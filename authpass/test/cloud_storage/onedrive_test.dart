import 'dart:io';

import 'package:authpass/cloud_storage/onedrive/onedrive_provider.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:test/test.dart';

import '../util/test_util.dart';
import 'generic_cloud_storage.dart';

final _logger = Logger('onedrive_test');

// To run this test, you have to first execute
// `onedrive_auth.dart` from the command line:
// `dart run test/onedrive_auth.dart`

void main() {
  PrintAppender.setupLogging();
  final skip = Platform.environment['USER'] != 'herbert';
  _logger.finest('init tests.');

  group('test one drive', () {
    late OneDriveProvider provider;
    setUp(() async {
      final env = await TestUtil.createEnv();
      provider = OneDriveProvider(env: env, helper: CloudStorageHelperMock());
    });

    simpleCloudStorageTestSuite(
        providerCb: () => provider,
        selectParent: (provider) async {
          final response = await provider!.list();
          final parent = response.results
              .firstWhere((e) => e!.path!.contains('Documents'));
          return parent;
        });
  }, skip: skip);
}
