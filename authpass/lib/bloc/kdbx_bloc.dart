import 'dart:io';
import 'dart:typed_data';

import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/main.dart';
import 'package:flutter/foundation.dart';
import 'package:kdbx/kdbx.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

final _logger = Logger('kdbx_bloc');

abstract class FileSource {
  Uint8List _cached;

  @protected
  Future<Uint8List> load();

  Future<Uint8List> content() async => _cached ??= await load();
}

class FileSourceLocal extends FileSource {
  FileSourceLocal(this.file);

  final File file;

  @override
  Future<Uint8List> load() async {
    return await file.readAsBytes() as Uint8List;
  }
}

class FileSourceUrl extends FileSource {
  FileSourceUrl(this.url);

  final Uri url;

  @override
  Future<Uint8List> load() async {
    final response = await http.readBytes(url);
    return response;
  }
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
