import 'dart:io';

import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/onedrive/onedrive_provider.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:test/test.dart';

import 'util/test_util.dart';

final _logger = Logger('onedrive_test');

void main() {
  PrintAppender.setupLogging();
  final skip = Platform.environment['USER'] != 'herbert';
  final env = TestEnv();
  _logger.finest('init tests.');
  group('test one drive', () {
    test('create auth token', () async {
      final provider =
          OneDriveProvider(env: env, helper: CloudStorageHelperMock(env));
      await provider.startAuth((prompt) async {
        if (prompt is UserAuthenticationPrompt<OAuthTokenResult,
            OAuthTokenFlowPromptData>) {
          print('Open URL: ${prompt.data.openUri}');
          print('And enter code:');
          final code = stdin.readLineSync();
          prompt.result(OAuthTokenResult(code));
        } else {
          throw StateError('invalid prompt. $prompt');
        }
      });
    });
  }, skip: skip);
}
