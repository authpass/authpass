import 'package:authpass/cloud_storage/cloud_storage_helper.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/env/development.dart';
import 'package:authpass/utils/path_util.dart';

import 'package:logging/logging.dart';
import 'package:mockito/mockito.dart';

final _logger = Logger('test_util');

class TestUtil {
  static Env createEnv() {
    return Development();
  }
}

class EnvSecretsFake extends Fake implements EnvSecrets {
  @override
  String get microsoftClientId => '86bc71e4-c9f8-4724-ac92-e4e015b0b9b7';
}

class CloudStorageHelperMock implements CloudStorageHelper {
  CloudStorageHelperMock(this.env);
  @override
  final Env env;

  final Map<String, String> _storage = {};

  @override
  Future<String> loadCredentials(String cloudStorageId) async =>
      _storage[cloudStorageId];

  @override
  Future<void> saveCredentials(String cloudStorageId, String data) async {
    _logger.info('Saving for $cloudStorageId: $data');
    _storage[cloudStorageId] = data;
  }

  @override
  PathUtil get pathUtil => throw UnimplementedError();
}

class TestEnv extends Development {
  @override
  EnvSecrets get secrets => EnvSecretsFake();

  @override
  String get oauthRedirectUri => 'https://test.authpass.app/oauth';
}
