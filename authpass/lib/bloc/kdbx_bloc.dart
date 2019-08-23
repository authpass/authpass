import 'dart:io';
import 'dart:typed_data';

import 'package:authpass/bloc/app_data.dart';
import 'package:flutter/foundation.dart';
import 'package:kdbx/kdbx.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

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
    final kdbxFile = await KdbxFormat.read(await file.content(), credentials);
    await appDataBloc.openedFile(file, name: kdbxFile.body.meta.databaseName);
    _openedFiles.value = _openedFiles.value + [kdbxFile];
  }
}
