import 'dart:convert';

import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/utils/path_util.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

/// Common functionality shared across all cloud storages,
/// right now simply storing of oauth tokens.
class CloudStorageHelper implements CloudStorageHelperBase {
  CloudStorageHelper(this.env, this.pathUtil);

  final Env env;
  @override
  final PathUtil pathUtil;
  BiometricStorageFile? _storageFile;

  Future<BiometricStorageFile> _getStorageFile() async =>
      _storageFile ??= await BiometricStorage().getStorage(
        nonNls('${env.storageNamespace ?? ''}CloudProviderCreds'),
        options: StorageFileInitOptions(authenticationRequired: false),
      );

  Future<Map<String, dynamic>> _readDataMap() async {
    final file = await _getStorageFile();
    final data = await file.read();
    if (data != null) {
      return json.decode(data) as Map<String, dynamic>;
    }
    return <String, dynamic>{};
  }

  Future<void> _writeDataMap(Map<String, dynamic> dataMap) async {
    final file = await _getStorageFile();
    await file.write(json.encode(dataMap));
  }

  @override
  Future<String?> loadCredentials(String cloudStorageId) async {
    return (await _readDataMap())[cloudStorageId] as String?;
  }

  @override
  Future<void> saveCredentials(String cloudStorageId, String data) async {
    final dataMap = await _readDataMap();
    dataMap[cloudStorageId] = data;
    await _writeDataMap(dataMap);
  }
}
