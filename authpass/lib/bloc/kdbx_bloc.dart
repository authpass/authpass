import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx/file_source_local.dart';
import 'package:authpass/bloc/kdbx_argon2_ffi.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/main.dart';
import 'package:authpass/theme.dart';
import 'package:authpass/utils/path_utils.dart';
import 'package:authpass/utils/platform.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';

final _logger = Logger('kdbx_bloc');

class FileExistsException extends KdbxException {
  FileExistsException({
    @required this.path,
  }) : assert(path != null);

  final String path;

  @override
  String toString() {
    return 'FileExistsException{path: $path}';
  }
}

class QuickUnlockStorage {
  QuickUnlockStorage({
    @required this.cloudStorageBloc,
    @required this.env,
    @required this.analytics,
  });

  CloudStorageBloc cloudStorageBloc;
  Env env;
  Analytics analytics;
  bool _supported;

  Future<bool> supportsBiometricKeyStore() async {
    if (_supported != null) {
      return _supported;
    }
    final canAuthenticate = await BiometricStorage().canAuthenticate();
    _logger.finer('supportBiometricKeyStore: $canAuthenticate');
    return _supported = (canAuthenticate == CanAuthenticateResponse.success);
  }

  Future<BiometricStorageFile> _storageFileCached;

  Future<BiometricStorageFile> _storageFile() => _storageFileCached ??=
      BiometricStorage().getStorage('${env.storageNamespace ?? ''}QuickUnlock');

  Future<void> updateQuickUnlockFile(
      Map<FileSource, Credentials> fileCredentials) async {
    if (!(await supportsBiometricKeyStore())) {
      _logger.severe(
          'updateQuickUnlockFile must not be called when biometric store is not supported.');
      return;
    }
    final quickUnlockCredentials = fileCredentials.map(
      (key, value) => MapEntry(key.uuid, base64.encode(value.getHash())),
    );
    _logger.fine('Getting storage file.');
    final storage = await _storageFile();
    _logger.fine('got storage, writing credentials.');
    try {
      await storage.write(json.encode(quickUnlockCredentials));
    } catch (e, stackTrace) {
      _logger.severe(
          'Error while writing quick unlock credentials.', e, stackTrace);
      rethrow;
    } finally {
      _logger.finer('all done.');
    }
  }

  Future<Map<FileSource, Credentials>> loadQuickUnlockFile(
      AppDataBloc appDataBloc) async {
    if (!(await supportsBiometricKeyStore())) {
      _logger.fine('Biometric store not supported. no quickunlock.');
      return {};
    }
    final storage = await _storageFile();
    final jsonContent = await storage.read();
    if (jsonContent == null) {
      _logger.finer('No quick unlock available.');
      return {};
    }
    final map = json.decode(jsonContent) as Map<String, dynamic>;
    final appData = await appDataBloc.store.load();
    return Map.fromEntries(map.entries.map((entry) {
      final file = appData.recentFileByUuid(entry.key);
      if (file == null) {
        return null;
      }
      return MapEntry(file.toFileSource(cloudStorageBloc),
          HashCredentials(base64.decode(entry.value as String)));
    }).where((e) => e != null));
  }
}

/// response to [KdbxBloc.readKdbxFile] will either be an exception OR a file.
class ReadFileResponse {
  ReadFileResponse(this.file, this.exception, this.exceptionType);
  final KdbxFile file;
  final dynamic exception;
  final String exceptionType;
}

class KdbxOpenedFile {
  KdbxOpenedFile({
    @required this.fileSource,
    @required this.openedFile,
    @required this.kdbxFile,
  })  : assert(fileSource != null),
        assert(openedFile != null),
        assert(kdbxFile != null);

  final FileSource fileSource;
  final OpenedFile openedFile;
  final KdbxFile kdbxFile;
}

class OpenedKdbxFiles {
  OpenedKdbxFiles(Map<FileSource, KdbxOpenedFile> files)
      : _files = Map.unmodifiable(files);
  final Map<FileSource, KdbxOpenedFile> _files;

  int get length => _files.length;

//  bool get isNotEmpty => _files.isNotEmpty;

  KdbxOpenedFile operator [](FileSource fileSource) => _files[fileSource];
  Iterable<MapEntry<FileSource, KdbxOpenedFile>> get entries => _files.entries;
  Iterable<KdbxOpenedFile> get values => _files.values;

  bool containsKey(FileSource file) => _files.containsKey(file);

//  Map<K2, V2> map<K2, V2>(
//          MapEntry<K2, V2> Function(FileSource key, KdbxOpenedFile value) f) =>
//      _files.map(f);
}

/// Result information for [KdbxBloc.openFile] method calls.
class OpenFileResult {
  OpenFileResult({
    this.kdbxOpenedFile,
    this.fileContent,
    this.unlockStopwatch,
    this.loadStopwatch,
  });
  final KdbxOpenedFile kdbxOpenedFile;
  final FileContent fileContent;
  final Stopwatch unlockStopwatch;
  final Stopwatch loadStopwatch;
}

class KdbxBloc {
  KdbxBloc({
    @required this.env,
    @required this.appDataBloc,
    @required this.analytics,
    @required this.cloudStorageBloc,
  }) : quickUnlockStorage = QuickUnlockStorage(
            cloudStorageBloc: cloudStorageBloc,
            env: env,
            analytics: analytics) {
    if (AuthPassPlatform.isWeb) {
      KdbxFormat.dartWebWorkaround = true;
    }
    _openedFiles
        .map((value) => Map.fromEntries(value.entries
            .map((entry) => MapEntry(entry.value.kdbxFile, entry.value))))
        .listen((data) => _openedFilesByKdbxFile = data);
  }

  final Env env;
  final AppDataBloc appDataBloc;
  final Analytics analytics;
  final CloudStorageBloc cloudStorageBloc;
  final QuickUnlockStorage quickUnlockStorage;
  final KdbxFormat kdbxFormat = KdbxFormat(FlutterArgon2());

  final _openedFiles =
      BehaviorSubject<OpenedKdbxFiles>.seeded(OpenedKdbxFiles({}));
  Map<KdbxFile, KdbxOpenedFile> _openedFilesByKdbxFile;
  final _openedFilesQuickUnlock = <FileSource>{};

  Iterable<MapEntry<FileSource, KdbxFile>> get openedFilesWithSources =>
      _openedFiles.value.entries
          .map((entry) => MapEntry(entry.key, entry.value.kdbxFile));

  OpenedKdbxFiles get openedFiles => _openedFiles.value;
  List<KdbxFile> get openedFilesKdbx =>
      _openedFiles.value.values.map((value) => value.kdbxFile).toList();
  ValueStream<OpenedKdbxFiles> get openedFilesChanged => _openedFiles.stream;

  Future<int> _quickUnlockCheckRunning;

  void dispose() {
    _openedFiles.close();
//    super.dispose();
  }

  Future<KdbxOpenedFile> updateOpenedFile(
      KdbxOpenedFile file, void Function(OpenedFileBuilder b) updater) async {
    final updatedFile = (file.openedFile.toBuilder()..update(updater)).build();
    await appDataBloc.update((b, data) {
      b
        ..previousFiles.map((f) {
          if (!f.isSameFileAs(file.openedFile)) {
            return f;
          }
//          return (f.toBuilder()..update(updater)).build();
          return updatedFile;
        });
    });
    final newFile = KdbxOpenedFile(
      fileSource: file.fileSource,
      openedFile: updatedFile,
      kdbxFile: file.kdbxFile,
    );
    _openedFiles.value = OpenedKdbxFiles({
      ..._openedFiles.value._files,
      file.fileSource: newFile,
    });
    _logger.info('new values: ${_openedFiles.value}');
    return newFile;
  }

  Stream<OpenFileResult> openFile(FileSource file, Credentials credentials,
      {bool addToQuickUnlock = false}) async* {
    Uint8List previous;
    KdbxOpenedFile openedFile;
    await for (final fileContent in file.content()) {
      _logger.finer('$file got from ${fileContent.source}');
      final loadStopwatch = Stopwatch()..start();
      if (previous != null) {
        if (ByteUtils.eq(previous, fileContent.content)) {
          _logger.finer('$file: No changes detected. Nothing to do.');
          continue;
        } else {
          if (openedFile.kdbxFile.isDirty) {
            // ooooopsie.
            throw StateError('File was changed locally while '
                'loading new file from remote storage.');
          }
        }
      }
      previous = fileContent.content;
      loadStopwatch.stop();
      final unlockStopwatch = Stopwatch()..start();
      openedFile = await _openFileContent(
          file, credentials, fileContent, addToQuickUnlock);
      addToQuickUnlock = false;
      yield OpenFileResult(
        kdbxOpenedFile: openedFile,
        fileContent: fileContent,
        unlockStopwatch: unlockStopwatch..stop(),
        loadStopwatch: loadStopwatch,
      );
    }
    _logger.finer('$file: Done.');
  }

  Future<KdbxOpenedFile> _openFileContent(
      FileSource file,
      Credentials credentials,
      FileContent fileContent,
      bool addToQuickUnlock) async {
    final readArgs = KdbxReadArgs(fileContent.content, credentials);
//    final kdbxReadFile = await compute(
//        staticReadKdbxFile, readArgs,
//        debugLabel: 'readKdbxFile');
    final kdbxReadFile = await readKdbxFile(kdbxFormat, readArgs);
    if (kdbxReadFile.exception != null) {
      final mapping = <Type, Exception Function()>{
        KdbxInvalidKeyException: () => KdbxInvalidKeyException(),
        KdbxCorruptedFileException: () => KdbxCorruptedFileException(''),
      }.map((key, value) => MapEntry(key.toString(), value));
      final exception = mapping[kdbxReadFile.exceptionType];
      if (exception != null) {
        throw exception();
      }
      throw kdbxReadFile.exception;
    }
    final kdbxFile = kdbxReadFile.file;
    final openedFile = await appDataBloc.openedFile(
      file,
      name: kdbxFile.body.meta.databaseName.get(),
      defaultColor: _defaultNextColor(),
    );
    final kdbxOpenedFile = KdbxOpenedFile(
      fileSource: file,
      openedFile: openedFile,
      kdbxFile: kdbxFile,
    );
    _openedFiles.value = OpenedKdbxFiles({
      ..._openedFiles.value._files,
      file: kdbxOpenedFile,
    });
    analytics.events.trackOpenFile(type: file.typeDebug);
    analytics.events.trackOpenFile2(
      generator: kdbxFile.body.meta.generator.get() ?? 'NULL',
      version: '${kdbxFile.header.version}',
    );

    if (addToQuickUnlock) {
      _openedFilesQuickUnlock.add(file);
      _logger.fine('adding file to quick unlock.');
      await _updateQuickUnlockStore();
    }
    return kdbxOpenedFile;
  }

  Color _defaultNextColor() {
    for (final color in AuthPassTheme.defaultColorOrder) {
      if (!openedFiles.values
          .any((file) => file.openedFile.colorCode == color.value)) {
        return color;
      }
    }
    return null;
  }

  /// writes all opened files into secure storage.
  Future<void> _updateQuickUnlockStore() async {
    final openedFiles = _openedFiles.value;
    await quickUnlockStorage.updateQuickUnlockFile(
        Map.fromEntries(_openedFilesQuickUnlock.map((fileSource) {
      final openedFile = openedFiles[fileSource];
      if (openedFile == null) {
        _logger.warning(
            'File was closed, but was still listed in quick unlock files.');
        return null;
      }
      return MapEntry(fileSource, openedFile.kdbxFile.credentials);
    }).where((entry) => entry != null)));
  }

  bool _isOpen(FileSource file) => _openedFiles.value.containsKey(file);

  Future<void> continueLoadInBackground(
    StreamIterator<OpenFileResult> openIt, {
    @required String debugName,
  }) async {
    try {
      while (await openIt.moveNext()) {
        final r = openIt.current;
        _logger.fine('load:$debugName new data from ${r.fileContent.source}');
      }
    } catch (e, stackTrace) {
      _logger.severe('load:$debugName error while loading subsequent data.', e,
          stackTrace);
      rethrow;
    }
    _logger.fine('load:$debugName finished.');
  }

  Future<int> reopenQuickUnlock([TaskProgress progress]) =>
      _quickUnlockCheckRunning ??= (() async {
        try {
          _logger.finer('Checking quick unlock.');
          final unlockFiles =
              await quickUnlockStorage.loadQuickUnlockFile(appDataBloc);
          var filesOpened = 0;
          for (final file
              in unlockFiles.entries.where((entry) => !_isOpen(entry.key))) {
            try {
              final fileLabel =
                  '${file.key.displayName} … (${filesOpened + 1} / ${unlockFiles.length})';
//              progress.progressLabel = 'Loading $fileLabel';
//              await file.key.contentPreCache();
              progress.progressLabel = 'Opening $fileLabel';
              final open = StreamIterator(openFile(file.key, file.value));
              await open.moveNext();
              filesOpened++;
              unawaited(
                  continueLoadInBackground(open, debugName: '$fileLabel'));
            } catch (e, stackTrace) {
              _logger.severe(
                  'Panic, error while trying to open file from '
                  'quick unlock. ignoring file for now. ${file.key}',
                  e,
                  stackTrace);
            }
          }
          analytics.events.trackQuickUnlock(value: filesOpened);
          _openedFilesQuickUnlock.clear();
          _openedFilesQuickUnlock.addAll(unlockFiles.keys);
          return filesOpened;
        } on AuthException catch (e, stackTrace) {
          if (e.code == AuthExceptionCode.userCanceled) {
            _logger.info('User canceled quick unlock.');
            return 0;
          }
          _logger.severe('Error during quick unlock.', e, stackTrace);
          return 0;
        }
      })()
          .whenComplete(() => _quickUnlockCheckRunning = null);

  Future<void> close(KdbxFile file) async {
    _logger.fine('Close file.');
    analytics.events.trackCloseFile();
    final fileSource = fileForKdbxFile(file).fileSource;
    _openedFiles.value = OpenedKdbxFiles(
        Map.from(_openedFiles.value._files)..remove(fileSource));
    if (_openedFilesQuickUnlock.remove(fileSource)) {
      _logger.fine('file was in quick unlock. need to persist it.');
      await _updateQuickUnlockStore();
    } else {
      _logger.fine('file was not in quick unlock.');
    }
  }

  void closeAllFiles() {
    _logger.finer('Closing all files, clearing quick unlock.');
    analytics.events.trackCloseAllFiles(count: _openedFiles.value?.length);
    _openedFiles.value = OpenedKdbxFiles({});
    if (_openedFilesQuickUnlock.isNotEmpty) {
      // clear all quick unlock data.
      _openedFilesQuickUnlock.clear();
      quickUnlockStorage.updateQuickUnlockFile({});
    }
  }

  static Future<ReadFileResponse> staticReadKdbxFile(
      KdbxReadArgs readArgs) async {
    initIsolate();
    final kdbxFormat = KdbxFormat(FlutterArgon2());
    return readKdbxFile(kdbxFormat, readArgs);
  }

  static Future<ReadFileResponse> readKdbxFile(
      KdbxFormat kdbxFormat, KdbxReadArgs readArgs) async {
    try {
      _logger.finer('reading kdbx file ...');
      final fileContent = readArgs.content;
      final kdbxFile = await kdbxFormat.read(fileContent, readArgs.credentials);
      _logger.finer('done reading');
      return ReadFileResponse(kdbxFile, null, null);
    } catch (e, stackTrace) {
      _logger.warning('Error while reading kdbx file.', e, stackTrace);
      return ReadFileResponse(null, e.toString(), e.runtimeType.toString());
    }
  }

  /// Creates a new file in the application document directory by the given name.
  /// Throws a [FileExistsException] if a file of the same name already exists.
  Future<FileSourceLocal> createFile({
    @required String password,
    @required String databaseName,
    bool openAfterCreate = false,
  }) async {
    assert(password != null);
    analytics.events.trackCreateFile();
    assert(!(databaseName.endsWith('.kdbx')));
    final credentials = Credentials(ProtectedValue.fromString(password));
    final kdbxFile = kdbxFormat.create(
      credentials,
      databaseName,
      generator: 'AuthPass',
    );
    final localSource = await _localFileSourceForDbName(databaseName);
    await localSource.file
        .writeAsBytes(await _saveFileToBytes(kdbxFile), flush: true);
    if (openAfterCreate) {
      await openFile(localSource, credentials).last;
    }
    return localSource;
  }

  Future<FileSourceLocal> _localFileSourceForDbName(String databaseName) async {
    final fileName = '$databaseName.kdbx';
    final appDir = await PathUtils().getAppDocDirectory(ensureCreated: true);
    final localSource = FileSourceLocal(File(path.join(appDir.path, fileName)),
        databaseName: databaseName, uuid: AppDataBloc.createUuid());
    if (localSource.file.existsSync()) {
      throw FileExistsException(path: localSource.file.path);
    }
    return localSource;
  }

  /// Creates a new password entry in [file] (default: the primary kdbx file),
  /// and adds it to [group] (default: main root group).
  KdbxEntry createEntry({
    KdbxFile file,
    KdbxGroup group,
  }) {
    file ??= group?.file;
    if (file == null) {
      if (openedFilesKdbx.isEmpty) {
        return null;
      }
      file = openedFilesKdbx.first;
    }
    final rootGroup = group ?? file.body.rootGroup;
    final entry = KdbxEntry.create(file, rootGroup);
    rootGroup.addEntry(entry);
    return entry;
  }

  /// Wrapper around [file.save()], which adds a bit of meta data
  /// before storing it.
  Future<Uint8List> _saveFileToBytes(KdbxFile file) async {
    final generator = file.body.meta.generator.get();
    if (generator == null || generator.isEmpty) {
      file.body.meta.generator.set('AuthPass (save)');
    }
    final saveCounter =
        file.body.meta.customData['codeux.design.authpass.save'] ?? '0';
    final newCounter = (int.tryParse(saveCounter) ?? 0) + 1;
    file.body.meta.customData['codeux.design.authpass.save'] = '$newCounter';
    analytics.events.trackSaveCount(generator: generator, value: newCounter);
    return await file.save();
  }

  Future<void> saveFile(KdbxFile file, {FileSource toFileSource}) async {
    final fileSource = toFileSource ?? fileForKdbxFile(file).fileSource;
    final bytes = await _saveFileToBytes(file);
    await fileSource.contentWrite(bytes);
    analytics.events.trackSave(type: fileSource.typeDebug, value: bytes.length);
    analytics.trackTiming('saveFileSize', bytes.length,
        category: 'fileSize', label: 'save');
  }

  KdbxOpenedFile fileForKdbxFile(KdbxFile file) =>
      _openedFilesByKdbxFile[file] ??
      (() {
        throw StateError('Missing file source for kdbxFile.');
      })();

  KdbxOpenedFile fileForFileSource(FileSource fileSource) =>
      _openedFiles.value[fileSource];

  Future<KdbxOpenedFile> saveAs(
      KdbxOpenedFile oldFile, FileSource output) async {
    await saveFile(oldFile.kdbxFile, toFileSource: output);
    return await _savedAs(oldFile, output);
  }

  Future<KdbxOpenedFile> _savedAs(
      KdbxOpenedFile oldFile, FileSource output) async {
    final oldSource = oldFile.fileSource;
    final databaseName = oldFile.kdbxFile.body.meta.databaseName.get();
    final newOpenedFile = await appDataBloc.openedFile(
      output,
      name: databaseName,
      oldFile: oldFile.openedFile,
    );
    final newFile = KdbxOpenedFile(
      fileSource: output,
      openedFile: newOpenedFile,
      kdbxFile: oldFile.kdbxFile,
    );
    _openedFiles.value = OpenedKdbxFiles({
      ...Map.fromEntries(_openedFiles.value._files.entries
          .where((entry) => entry.key != oldSource)),
      newFile.fileSource: newFile,
    });
    // TODO also do not update quick unlock if this file is not in quick unlock.
    if (_openedFilesQuickUnlock.isNotEmpty) {
      try {
        await _updateQuickUnlockStore();
      } on AuthException catch (e, stackTrace) {
        if (e.code == AuthExceptionCode.userCanceled) {
          _logger.warning(
              'User cancelled saving quick unlock. ignoring for now.',
              e,
              stackTrace);
        } else {
          rethrow;
        }
      }
    }
    return newFile;
  }

  Future<KdbxOpenedFile> saveAsNewFile(
      KdbxOpenedFile oldFile,
      CloudStorageSelectorSaveResult createFileInfo,
      CloudStorageProvider cs) async {
    final bytes = await _saveFileToBytes(oldFile.kdbxFile);
    final entity = await cs.createEntity(createFileInfo, bytes);
    return await _savedAs(oldFile, entity);
  }

  Future<FileSource> saveLocally(FileSource source) async {
    final file = _openedFiles.value[source];
    if (file == null) {
      throw StateError('file for $source is not open.');
    }
    final databaseName = file.kdbxFile.body.meta.databaseName.get();
    final localSource = await _localFileSourceForDbName(databaseName);
    return (await saveAs(file, localSource)).fileSource;
  }

  Map<String, KdbxEntry> _entryUuidLookup;

  KdbxEntry findEntryByUuid(String uuid) {
    _entryUuidLookup ??= Map.fromEntries(openedFilesKdbx.expand((file) => file
        .body.rootGroup
        .getAllEntries()
        .map((e) => MapEntry(e.uuid.uuid, e))));

    return _entryUuidLookup[uuid];
  }

  void clearEntryByUuidLookup() => _entryUuidLookup = null;
}

class KdbxReadArgs {
  KdbxReadArgs(this.content, this.credentials);

  final Uint8List content;
  final Credentials credentials;
}
