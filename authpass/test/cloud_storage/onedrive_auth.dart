import 'dart:io';

import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/onedrive/onedrive_provider.dart';
import 'package:logging_appenders/logging_appenders.dart';

import '../util/test_util.dart';

// small utility for `onedrive_test.dart`.

// ignore_for_file: avoid_print

Future<void> main() async {
  PrintAppender.setupLogging();

  final env = await TestUtil.createEnv();

  final provider = OneDriveProvider(env: env, helper: CloudStorageHelperMock());
  final result = await provider.startAuth((prompt) async {
    if (prompt is UserAuthenticationPrompt<OAuthTokenResult,
        OAuthTokenFlowPromptData>) {
      print('Open URL: ${prompt.data.openUri}');
      print('And enter code:');
      final code = stdin.readLineSync();
      print('got code: $code');
      prompt.result(OAuthTokenResult(code));
    } else {
      throw StateError('invalid prompt. $prompt');
    }
  });
  print('result: $result');
  await provider.logout();
  print('done.');
}
