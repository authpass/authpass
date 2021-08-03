import 'dart:convert';
import 'dart:typed_data';

import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source_cloud_storage.dart';
import 'package:authpass/bloc/kdbx/storage_exception.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/utils/uuid_util.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

final _logger = Logger('generic_cloud_storage');

void simpleCloudStorageTestSuite({
  required CloudStorageProvider Function() providerCb,
  Future<CloudStorageEntity?>? Function(CloudStorageProvider? provider)?
      selectParent,
}) {
  late String uuid;
  late CloudStorageProvider provider;

  final saveString1 = utf8.encode('Lorem Ipsum') as Uint8List;
  final saveString2 = utf8.encode('Lorem Ipsum New Content') as Uint8List;
  final saveString3 = utf8.encode('Lorem Ipsum Another Content') as Uint8List;
  final saveStrings = [saveString1, saveString2, saveString3];

  int _findString(Uint8List bytes) {
    return saveStrings.indexWhere((element) => ByteUtils.eq(element, bytes));
  }

  setUp(() async {
    uuid = UuidUtil.createUuid();
    provider = providerCb();
  });

  selectParent ??= (provider) => null;
  test('create and update', () async {
    final parent = await selectParent!(provider);
    final fileName = 'authpass_test_$uuid.txt';
    final fileSource = await provider.createEntity(
        CloudStorageSelectorSaveResult(parent, fileName), saveString1);

    final content1 = await fileSource.content().last;
    expect(content1.content, saveString1);

    // add a bit of delay, otherwise we get some weird conflicts.
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await fileSource.contentWrite(saveString2, metadata: null);
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await fileSource.contentWrite(saveString3, metadata: null);
    } on StorageConflictException catch (e, stackTrace) {
      _logger.severe('storage conflict', e, stackTrace);
      await for (final c in fileSource.content()) {
        _logger
            .info('${c.source}: ${c.metadata} --- ${_findString(c.content)}');
      }
      _logger.info('Done loading.');
      fail('detected a conflict!');
    }
  });

  test('create, load and conflict', () async {
    final parent = await selectParent!(provider);
    final fileName = 'authpass_test_$uuid.txt';
    final fileSource = await provider.createEntity(
        CloudStorageSelectorSaveResult(parent, fileName), saveString1);

    final content1 = await fileSource.content().last;
    expect(content1.content, saveString1);

    _logger.info('content metadata: ${content1.metadata}');

    await Future<void>.delayed(const Duration(milliseconds: 200));
    await fileSource.contentWrite(saveString2, metadata: null);

    expect(() async {
      // ignore: invalid_use_of_protected_member
      await fileSource.write(saveString2, content1.metadata);
    },
        throwsA(predicate<dynamic>((dynamic e) =>
            e is StorageException && e.type == StorageExceptionType.conflict)));
  });

  test('create, conflict', () async {
    final parent = await selectParent!(provider);
    final fileName = 'authpass_test_$uuid.txt';
    final fileSource = await provider.createEntity(
        CloudStorageSelectorSaveResult(parent, fileName), saveString1);
    final content1 = fileSource.cached;
    await fileSource.contentWrite(saveString2, metadata: null);
    expect(() async {
      // ignore: invalid_use_of_protected_member
      await fileSource.write(saveString3, content1!.metadata);
    }, throwsA(isA<StorageConflictException>()));
  });

  test('create, load from cache', () async {
    final parent = await selectParent!(provider);
    final fileName = 'authpass_test_$uuid.txt';
    final fileSource = await provider.createEntity(
        CloudStorageSelectorSaveResult(parent, fileName), saveString1);
    if (fileSource is FileSourceCloudStorage) {
      final fileInfo = fileSource.fileInfo;
      {
        final loadedFile = provider.toFileSourceFromFileInfo(fileInfo,
            uuid: fileSource.uuid, initialCachedContent: null);
        await loadedFile.content().last;
      }
      final loadedFile = provider.toFileSourceFromFileInfo(fileInfo,
          uuid: fileSource.uuid, initialCachedContent: null);
      expect(await loadedFile.content().map((event) => event.source).toList(),
          [FileContentSource.cache, FileContentSource.origin]);
    }
  });
}
