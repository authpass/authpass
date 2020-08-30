import 'dart:convert';
import 'dart:io';

import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/utils/path_util.dart';
import 'package:logging/logging.dart';
import 'package:mockito/mockito.dart';

final _logger = Logger('test_util');

class TestUtil {
  static Future<Env> createEnv() async {
    final secretJson = await File('test/_testSecrets.json').readAsString();

    return TestEnv(EnvSecretsFake.fromJson(
        json.decode(secretJson) as Map<String, Object>));
  }
}

class CloudStorageHelperMock implements CloudStorageHelperBase {
  CloudStorageHelperMock();
//  @override
//  final Env env;

  final Map<String, String> _storage = {};

  File get _file => File('test/_cloudStorageHelper.json');

  @override
  Future<String> loadCredentials(String cloudStorageId) async {
    if (_file.existsSync()) {
      _storage.addAll((json.decode(await _file.readAsString()) as Map)
          .cast<String, String>());
    }
    return _storage[cloudStorageId];
  }

  @override
  Future<void> saveCredentials(String cloudStorageId, String data) async {
    _logger.info('Saving for $cloudStorageId: $data');
    _storage[cloudStorageId] = data;
    await _file.writeAsString(json.encode(_storage));
  }

  @override
  final pathUtil = TestPathUtil();
}

class TestPathUtil extends PathUtil {
  Directory _tempDirector;

  @override
  Future<Directory> getTemporaryDirectory({String subNamespace}) async {
    return _tempDirector ??= await Directory.systemTemp.createTemp();
  }
}

class EnvSecretsFake extends Fake implements EnvSecrets {
  EnvSecretsFake(this.microsoftClientId);
  EnvSecretsFake.fromJson(Map<String, Object> map)
      : microsoftClientId = map['microsoftClientId'] as String;

  @override
  final String microsoftClientId;
}

class TestEnv extends Env {
  TestEnv(this.secrets) : super(EnvType.development);

  @override
  Future<AppInfo> getAppInfo() {
    throw UnimplementedError();
  }

  @override
  String get oauthRedirectUri => 'https://test.authpass.app/oauth';

  @override
  bool get oauthRedirectUriSupported => true;

  @override
  final EnvSecrets secrets;

  @override
  String get storageNamespaceFromEnvironment => '';
}
