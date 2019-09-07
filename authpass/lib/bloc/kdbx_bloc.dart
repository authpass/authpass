import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/main.dart';
import 'package:authpass/utils/path_utils.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:rxdart/rxdart.dart';

final _logger = Logger('kdbx_bloc');

abstract class FileSource {
  FileSource({@required this.databaseName, @required this.uuid});

  Uint8List _cached;

  final String uuid;

  /// If known should return the name of the database in the file. Otherwise the bare file name.
  @protected
  final String databaseName;

  String get displayName => databaseName ?? displayNameFromPath;

  /// The database name to display if [databaseName] is unknown.
  @protected
  String get displayNameFromPath;

  /// Exact path to the file source.
  String get displayPath;

  /// whether this file source supports saving of changes.
  bool get supportsWrite;

  @protected
  Future<Uint8List> load();

  Future<void> write(Uint8List bytes);

  Future<Uint8List> content() async => _cached ??= await load();

  @override
  bool operator ==(dynamic other) {
    if (other is FileSource) {
      assert(uuid != null);
      return other.uuid == uuid;
    }
    return super == other;
  }

  @override
  int get hashCode => uuid.hashCode;
}

class FileSourceLocal extends FileSource {
  FileSourceLocal(this.file, {String databaseName, @required String uuid})
      : super(databaseName: databaseName, uuid: uuid);

  final File file;

  @override
  Future<Uint8List> load() async {
    return await file.readAsBytes() as Uint8List;
  }

  @override
  String get displayPath => file.absolute.path;

  @override
  String get displayNameFromPath => path.basenameWithoutExtension(displayPath);

  @override
  Future<void> write(Uint8List bytes) => file.writeAsBytes(bytes);

  @override
  bool get supportsWrite => true;
}

class FileSourceUrl extends FileSource {
  FileSourceUrl(this.url, {String databaseName, @required String uuid}) : super(databaseName: databaseName, uuid: uuid);

  final Uri url;

  @override
  Future<Uint8List> load() async {
    final response = await http.readBytes(url);
    return response;
  }

  @override
  String get displayPath => Uri(
        scheme: url.scheme,
        host: url.host,
        path: url.path,
      ).toString(); //url.replace(queryParameters: <String, dynamic>{}, fragment: '').toString();

  @override
  String get displayNameFromPath => path.basenameWithoutExtension(url.path);

  @override
  Future<void> write(Uint8List bytes) => throw UnsupportedError('Cannot write to urls.');

  @override
  bool get supportsWrite => false;
}

class FileSourceCloudStorage extends FileSource {
  FileSourceCloudStorage({@required this.provider, @required this.fileInfo, String databaseName, @required String uuid})
      : super(databaseName: databaseName, uuid: uuid);

  final CloudStorageProvider provider;

  final Map<String, String> fileInfo;

  @override
  String get displayNameFromPath => provider.displayNameFromPath(fileInfo);

  @override
  String get displayPath => provider.displayPath(fileInfo);

  @override
  Future<Uint8List> load() {
    return provider.loadFile(fileInfo);
  }

  @override
  bool get supportsWrite => true;

  @override
  Future<void> write(Uint8List bytes) {
    return provider.saveFile(fileInfo, bytes);
  }
}

class FileExistsException extends KdbxException {}

class QuickUnlockStorage {
  QuickUnlockStorage({@required this.cloudStorageBloc});

  CloudStorageBloc cloudStorageBloc;
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

  Future<BiometricStorageFile> _storageFile() => _storageFileCached ??= BiometricStorage().getStorage('QuickUnlock');

  Future<void> updateQuickUnlockFile(Map<FileSource, Credentials> fileCredentials) async {
    if (!(await supportsBiometricKeyStore())) {
      _logger.severe('updateQuickUnlockFile must not be called when biometric store is not supported.');
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
      _logger.severe('Error while writing quick unlock credentials.', e, stackTrace);
      rethrow;
    } finally {
      _logger.finer('all done.');
    }
  }

  Future<Map<FileSource, Credentials>> loadQuickUnlockFile(AppDataBloc appDataBloc) async {
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
      return MapEntry(file.toFileSource(cloudStorageBloc), HashCredentials(base64.decode(entry.value as String)));
    }).where((e) => e != null));
  }
}

/// response to [KdbxBloc.readKdbxFile] will either bei an exception OR a file.
class ReadFileResponse {
  ReadFileResponse(this.file, this.exception);
  final KdbxFile file;
  final dynamic exception;
}

class KdbxBloc {
  KdbxBloc({
    @required this.appDataBloc,
    @required this.analytics,
    @required this.cloudStorageBloc,
  }) : quickUnlockStorage = QuickUnlockStorage(cloudStorageBloc: cloudStorageBloc);

  final AppDataBloc appDataBloc;
  final Analytics analytics;
  final CloudStorageBloc cloudStorageBloc;
  final QuickUnlockStorage quickUnlockStorage;

  final _openedFiles = BehaviorSubject<Map<FileSource, KdbxFile>>.seeded({});
  final _openedFilesQuickUnlock = <FileSource>{};

  Iterable<MapEntry<FileSource, KdbxFile>> get openedFilesWithSources => _openedFiles.value.entries;

  List<KdbxFile> get openedFiles => _openedFiles.value.values.toList();
  ValueObservable<Map<FileSource, KdbxFile>> get openedFilesChanged => _openedFiles.stream;

  Future<int> _quickUnlockCheckRunning;

  void dispose() {
    _openedFiles.close();
//    super.dispose();
  }

  Future<void> openFile(FileSource file, Credentials credentials, {bool addToQuickUnlock = false}) async {
    final fileContent = await file.content();
    final kdbxReadFile =
        await compute(readKdbxFile, KdbxReadArgs(fileContent, credentials), debugLabel: 'readKdbxFile');
    if (kdbxReadFile.exception != null) {
      throw kdbxReadFile.exception;
    }
    final kdbxFile = kdbxReadFile.file;
    final openedFile = await appDataBloc.openedFile(file, name: kdbxFile.body.meta.databaseName.get());
    _openedFiles.value = {..._openedFiles.value, file: kdbxFile};
    analytics.events.trackOpenFile(type: openedFile.sourceType);

    if (addToQuickUnlock) {
      _openedFilesQuickUnlock.add(file);
      _logger.fine('adding file to quick unlock.');
      final openedFiles = _openedFiles.value;
      await quickUnlockStorage.updateQuickUnlockFile(Map.fromEntries(_openedFilesQuickUnlock.map((fileSource) {
        final openedFile = openedFiles[fileSource];
        if (openedFile == null) {
          _logger.warning('File was closed, but was still listed in quick unlock files.');
        }
        return MapEntry(fileSource, openedFile.credentials);
      })));
    }
  }

  bool _isOpen(FileSource file) => _openedFiles.value.containsKey(file);

  Future<int> reopenQuickUnlock() => _quickUnlockCheckRunning ??= (() async {
        try {
          _logger.finer('Checking quick unlock.');
          final unlockFiles = await quickUnlockStorage.loadQuickUnlockFile(appDataBloc);
          int filesOpened = 0;
          for (final file in unlockFiles.entries.where((entry) => !_isOpen(entry.key))) {
            await openFile(file.key, file.value);
            filesOpened++;
          }
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

  void closeAllFiles() {
    _logger.finer('Closing all files, clearing quick unlock.');
    analytics.events.trackCloseAllFiles(count: _openedFiles.value?.length);
    _openedFiles.value = {};
    // clear all quick unlock data.
    _openedFilesQuickUnlock.clear();
    quickUnlockStorage.updateQuickUnlockFile({});
  }

  static Future<ReadFileResponse> readKdbxFile(KdbxReadArgs readArgs) async {
    try {
      initIsolate();
      _logger.finer('reading kdbx file ...');
      final fileContent = readArgs.content;
      final kdbxFile = KdbxFormat.read(fileContent, readArgs.credentials);
      _logger.finer('done reading');
      return ReadFileResponse(kdbxFile, null);
    } catch (e, stackTrace) {
      _logger.warning('Error while reading kdbx file.', e, stackTrace);
      return ReadFileResponse(null, e.toString());
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
    assert(!(databaseName.endsWith('.kdbx')));
    final credentials = Credentials(ProtectedValue.fromString(password));
    final kdbxFile = KdbxFormat.create(
      credentials,
      databaseName,
    );
    final FileSourceLocal localSource = await _localFileSourceForDbName(databaseName);
    await localSource.file.writeAsBytes(kdbxFile.save(), flush: true);
    if (openAfterCreate) {
      await openFile(localSource, credentials);
    }
    return localSource;
  }

  Future<FileSourceLocal> _localFileSourceForDbName(String databaseName) async {
    final fileName = '$databaseName.kdbx';
    final appDir = await PathUtils().getAppDataDirectory();
    await appDir.create(recursive: true);
    final localSource = FileSourceLocal(File(path.join(appDir.path, fileName)),
        databaseName: databaseName, uuid: AppDataBloc.createUuid());
    if (localSource.file.existsSync()) {
      throw FileExistsException();
    }
    return localSource;
  }

  /// Creates a new password entry in the primary kdbx file, in the main root group.
  KdbxEntry createEntry() {
    if (openedFiles.isEmpty) {
      return null;
    }
    final file = openedFiles.first;
    final rootGroup = file.body.rootGroup;
    final entry = KdbxEntry.create(file, rootGroup);
    rootGroup.addEntry(entry);
    return entry;
  }

  Future<void> saveFile(KdbxFile file, {FileSource toFileSource}) async {
    final fileSource = toFileSource ?? fileSourceForFile(file);
    final bytes = file.save();
    await fileSource.write(bytes);
  }

  FileSource fileSourceForFile(KdbxFile file) => _openedFiles.value.entries
      .singleWhere((el) => el.value == file, orElse: () => throw StateError('File not opened?'))
      .key;

  Future<FileSource> saveLocally(FileSource source) async {
    final file = _openedFiles.value[source];
    if (file == null) {
      throw StateError('file for $source is not open.');
    }
    final databaseName = file.body.meta.databaseName.get();
    final localSource = await _localFileSourceForDbName(databaseName);
    await saveFile(file, toFileSource: localSource);
    _openedFiles.value = {
      ..._openedFiles.value,
      localSource: file,
    }..removeWhere((key, value) => key == source);
    await appDataBloc.openedFile(localSource, name: databaseName);
    return localSource;
  }
}

class KdbxReadArgs {
  KdbxReadArgs(this.content, this.credentials);

  final Uint8List content;
  final Credentials credentials;
}
