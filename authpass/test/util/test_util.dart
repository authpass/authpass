import 'dart:convert';

import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/utils/path_util.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

final _logger = Logger('test_util');

const fs = LocalFileSystem();

@GenerateMocks([KdbxBloc])
class TestUtil {
  late final kdbxFormat = KdbxFormat();

  static Directory basePath() {
    final dir = fs.currentDirectory;
    if (dir.path.endsWith('test')) {
      return dir.parent;
    }
    return dir;
  }

  static File filePath(String relativePath) {
    return basePath().childFile(relativePath);
  }

  static Future<Env> createEnv() async {
    final secretsFile = filePath('test/_testSecrets.json');
    _logger.fine('Using ${secretsFile.absolute}');
    final secretJson =
        secretsFile.existsSync() ? await secretsFile.readAsString() : '{}';

    return TestEnv(EnvSecretsFake.fromJson(
        json.decode(secretJson) as Map<String, dynamic>));
  }

  KdbxFile createFile() {
    return kdbxFormat.create(
        Credentials(ProtectedValue.fromString('asdf')), 'asdf');
  }
}

class CloudStorageHelperMock implements CloudStorageHelperBase {
  CloudStorageHelperMock();
//  @override
//  final Env env;

  File get _file => TestUtil.filePath('test/_cloudStorageHelper.json');
  Map<String, String>? __storage;
  Future<Map<String, String>> _storage() async =>
      __storage ??= await (() async {
        final _storage = <String, String>{};
        if (_file.existsSync()) {
          _logger.fine('Loading from $_file');
          _storage.addAll((json.decode(await _file.readAsString()) as Map)
              .cast<String, String>());
        } else {
          _logger
              .severe('Unable to find cloud storage file at ${_file.absolute}');
        }
        return _storage;
      })();

  @override
  Future<String?> loadCredentials(String cloudStorageId) async {
    return (await _storage())[cloudStorageId];
  }

  @override
  Future<void> saveCredentials(String cloudStorageId, String data) async {
    _logger.info('Saving for $cloudStorageId: $data');
    final storage = await _storage();
    storage[cloudStorageId] = data;
    await _file.writeAsString(json.encode(storage));
  }

  @override
  final PathUtil pathUtil = TestPathUtil();
}

class TestPathUtil extends PathUtil {
  Directory? _tempDirector;

  @override
  Future<Directory> getTemporaryDirectory({String? subNamespace}) async {
    return _tempDirector ??= await fs.systemTempDirectory.createTemp();
  }
}

class EnvSecretsFake extends Fake implements EnvSecrets {
  EnvSecretsFake(this.microsoftClientId);
  EnvSecretsFake.fromJson(Map<String, dynamic> map)
      : microsoftClientId = map['microsoftClientId'] as String?;

  @override
  final String? microsoftClientId;
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
