import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/onedrive/onedrive_provider.dart';
import 'package:authpass/utils/uuid_util.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:test/test.dart';

import 'util/test_util.dart';

final _logger = Logger('onedrive_test');

// To run this test, you have to first execute
// `onedrive_auth.dart` from the command line:
// `dart run test/onedrive_auth.dart`

void main() {
  PrintAppender.setupLogging();
  final skip = Platform.environment['USER'] != 'herbert';
  _logger.finest('init tests.');

  final saveString1 = utf8.encode('Lorem Ipsum') as Uint8List;
  final saveString2 = utf8.encode('Lorem Ipsum New Content') as Uint8List;
  final saveString3 = utf8.encode('Lorem Ipsum Another Content') as Uint8List;

  group('test one drive', () {
    OneDriveProvider provider;
    final uuid = UuidUtil.createUuid();
    setUp(() async {
      final env = await TestUtil.createEnv();
      provider = OneDriveProvider(env: env, helper: CloudStorageHelperMock());
    });

    test('create and update', () async {
      final response = await provider.list();
      final docs =
          response.results.firstWhere((e) => e.path.contains('Documents'));
      final fileName = 'authpass_test_$uuid.txt';
      final fileSource = await provider.createEntity(
          CloudStorageSelectorSaveResult(docs, fileName), saveString1);

      final content1 = await fileSource.content().last;
      expect(content1.content, saveString1);

      // add a bit of delay, otherwise we get some weird conflicts.
      await Future<void>.delayed(const Duration(milliseconds: 200));
      await fileSource.contentWrite(saveString2);
      await Future<void>.delayed(const Duration(milliseconds: 200));
      await fileSource.contentWrite(saveString3);
    });

    test('create, load and conflict', () async {
      final response = await provider.list();
      final docs =
          response.results.firstWhere((e) => e.path.contains('Documents'));
      final fileName = 'authpass_test_$uuid.txt';
      final fileSource = await provider.createEntity(
          CloudStorageSelectorSaveResult(docs, fileName), saveString1);

      final content1 = await fileSource.content().last;
      expect(content1.content, saveString1);

      _logger.info('content metadata: ${content1.metadata}');

      await Future<void>.delayed(const Duration(milliseconds: 200));
      await fileSource.contentWrite(saveString2);

      expect(() async {
        // ignore: invalid_use_of_protected_member
        await fileSource.write(saveString2, content1.metadata);
      },
          throwsA(predicate<dynamic>((dynamic e) =>
              e is StorageException &&
              e.type == StorageExceptionType.conflict)));
    });
  }, skip: skip);
}
