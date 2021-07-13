@Tags(['webdav'])
import 'dart:io';

import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/webdav/webdav_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';

import '../util/test_util.dart';
import 'generic_cloud_storage.dart';

final _logger = Logger('webdav_test');

/// Requires a webdav server.
/// see `docker-compose.yaml`.
void main() {
  PrintAppender.setupLogging();

  final webDavUrl =
      Platform.environment['WEBDAV_URL'] ?? 'http://localhost:10280';
  // final webDavUrl =
  //     Platform.environment['WEBDAV_URL'] ?? 'http://localhost:10283';
  final webDavUsername = Platform.environment['WEBDAV_USERNAME'] ?? 'authpass';
  final webDavPassword = Platform.environment['WEBDAV_PASSWORD'] ?? 'authpa55';

  _logger.fine('Starting webdav test for URL: $webDavUrl');

  group('simple webdav test', () {
    late WebDavProvider provider;
    setUp(() async {
      // final env = await TestUtil.createEnv();
      provider = WebDavProvider(helper: CloudStorageHelperMock());
      // authenticate
      final result = await provider.startAuth((prompt) async {
        if (prompt is UserAuthenticationPrompt<UrlUsernamePasswordResult,
            UrlUsernamePasswordPromptData>) {
          prompt.result(UrlUsernamePasswordResult(
              webDavUrl, webDavUsername, webDavPassword));
        } else {
          throw StateError('wrong prompt type.');
        }
        return;
      });
      expect(result, true);
    });
    simpleCloudStorageTestSuite(providerCb: () => provider);
  });
}
