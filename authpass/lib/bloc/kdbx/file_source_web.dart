import 'dart:convert';
import 'dart:typed_data';

import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/utils/constants.dart';
import 'package:web/web.dart' as web;

class FileSourceWeb extends FileSource {
  FileSourceWeb({
    required String super.databaseName,
    required super.uuid,
    super.initialCachedContent,
  });

  @override
  FileSource copyWithDatabaseName(String databaseName) => FileSourceWeb(
    databaseName: databaseName,
    uuid: uuid,
    initialCachedContent: cached,
  );

  @override
  FileSourceIcon get displayIcon => FileSourceIcon.hdd;

  @override
  String get displayNameFromPath => databaseName ?? CharConstants.empty;

  @override
  String get displayPath => displayNameFromPath;

  @override
  Stream<FileContent> load() async* {
    final bytes = await _SimpleKeyValueStore.instance.read(_keyBytes);
    yield FileContent(bytes);
  }

  @override
  bool get supportsWrite => true;

  @override
  Future<Map<String, dynamic>?> write(
    Uint8List bytes,
    Map<String, dynamic>? previousMetadata,
  ) async {
    await _SimpleKeyValueStore.instance.write(_keyBytes, bytes);
    return <String, dynamic>{};
  }

  String get _keyBytes => uuid;
}

class _SimpleKeyValueStore {
  _SimpleKeyValueStore._() {
    _init();
  }

  static final instance = _SimpleKeyValueStore._();

  void _init() {}

  Future<void> write(String key, Uint8List bytes) async {
    web.window.localStorage.setItem(key, base64.encode(bytes));
  }

  Future<Uint8List> read(String key) async {
    final value = web.window.localStorage.getItem(key);
    if (value == null) {
      throw LoadFileNotFoundException('not found.');
    }
    return base64.decode(value);
  }
}
