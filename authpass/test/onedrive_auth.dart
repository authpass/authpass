import 'dart:io';

import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/onedrive/onedrive_provider.dart';

import 'util/test_util.dart';

Future<void> main() async {
  final env = TestEnv();
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
}
