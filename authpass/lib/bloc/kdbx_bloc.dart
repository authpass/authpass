import 'dart:io';
import 'dart:typed_data';

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/main.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

final _logger = Logger('kdbx_bloc');

abstract class FileSource {
  FileSource({@required this.databaseName});

  Uint8List _cached;

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
}

class FileSourceLocal extends FileSource {
  FileSourceLocal(this.file, {String databaseName}) : super(databaseName: databaseName);

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
  FileSourceUrl(this.url, {String databaseName}) : super(databaseName: databaseName);

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

class FileExistsException extends KdbxException {}

class KdbxBloc with ChangeNotifier {
  KdbxBloc({
    @required this.appDataBloc,
    @required this.analytics,
  }) {
    _openedFiles.addListener(notifyListeners);
  }

  final AppDataBloc appDataBloc;
  final Analytics analytics;

  final _openedFiles = ValueNotifier<Map<FileSource, KdbxFile>>({});

  Iterable<MapEntry<FileSource, KdbxFile>> get openedFilesWithSources => _openedFiles.value.entries;
  List<KdbxFile> get openedFiles => _openedFiles.value.values.toList();

  @override
  void dispose() {
    _openedFiles.dispose();
    super.dispose();
  }

  Future<void> openFile(FileSource file, Credentials credentials) async {
    final kdbxFile = await compute(readKdbxFile, KdbxReadArgs(file, credentials), debugLabel: 'readKdbxFile');
    final appData = await appDataBloc.openedFile(file, name: kdbxFile.body.meta.databaseName.get());
    _openedFiles.value = {..._openedFiles.value, file: kdbxFile};
    analytics.events.trackOpenFile(type: appData.previousFiles.last.sourceType);
  }

  void closeAllFiles() {
    _openedFiles.value = {};
  }

  static Future<KdbxFile> readKdbxFile(KdbxReadArgs readArgs) async {
    initIsolate();
    _logger.finer('reading kdbx file ...');
    final fileContent = await readArgs.fileSource.content();
    final kdbxFile = KdbxFormat.read(fileContent, readArgs.credentials);
    _logger.finer('done reading');
    return kdbxFile;
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
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);
    final localSource = FileSourceLocal(File(path.join(appDir.path, fileName)), databaseName: databaseName);
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
  KdbxReadArgs(this.fileSource, this.credentials);

  final FileSource fileSource;
  final Credentials credentials;
}
