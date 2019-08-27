import 'dart:io';
import 'dart:typed_data';

import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/main.dart';
import 'package:flutter/foundation.dart';
import 'package:kdbx/kdbx.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

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

  @protected
  Future<Uint8List> load();

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
  String get displayPath => url.replace(queryParameters: <String, dynamic>{}, fragment: '').toString();

  @override
  String get displayNameFromPath => path.basenameWithoutExtension(url.path);
}

class KdbxBloc with ChangeNotifier {
  KdbxBloc({
    @required this.appDataBloc,
  }) {
    _openedFiles.addListener(notifyListeners);
  }

  final AppDataBloc appDataBloc;

  final _openedFiles = ValueNotifier<List<KdbxFile>>([]);

  List<KdbxFile> get openedFiles => _openedFiles.value;

  @override
  void dispose() {
    _openedFiles.dispose();
    super.dispose();
  }

  Future<void> openFile(FileSource file, Credentials credentials) async {
    final kdbxFile = await compute(readKdbxFile, KdbxReadArgs(file, credentials), debugLabel: 'readKdbxFile');
    await appDataBloc.openedFile(file, name: kdbxFile.body.meta.databaseName.get());
    _openedFiles.value = _openedFiles.value + [kdbxFile];
  }

  void closeAllFiles() {
    _openedFiles.value = [];
  }

  static Future<KdbxFile> readKdbxFile(KdbxReadArgs readArgs) async {
    initIsolate();
    _logger.finer('reading kdbx file ...');
    final fileContent = await readArgs.fileSource.content();
    final kdbxFile = KdbxFormat.read(fileContent, readArgs.credentials);
    _logger.finer('done reading');
    return kdbxFile;
  }
}

class KdbxReadArgs {
  KdbxReadArgs(this.fileSource, this.credentials);

  final FileSource fileSource;
  final Credentials credentials;
}
