import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:clock/clock.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:pedantic/pedantic.dart';

final _logger = Logger('file_source_cloud_storage');

class FileContentCached {
  FileContentCached({
    required this.metadata,
    required this.cacheDate,
    required this.cacheSize,
  }) : assert(cacheDate.isUtc);
  factory FileContentCached.fromJson(Map<String, dynamic> json) =>
      FileContentCached(
        metadata: json['metadata'] as Map<String, dynamic>?,
        cacheDate: DateTime.fromMillisecondsSinceEpoch(
          json['cacheDate'] as int,
          isUtc: true,
        ),
        cacheSize: json['cacheSize'] as int?,
      );

  final Map<String, dynamic>? metadata;
  final DateTime cacheDate;
  final int? cacheSize;

  Map<String, Object?> toJson() => {
        'metadata': metadata,
        'cacheDate': cacheDate.millisecond,
        'cacheSize': cacheSize,
      };

  @override
  String toString() => toJson().toString();
}

class FileSourceCloudStorage extends FileSource {
  FileSourceCloudStorage({
    required this.provider,
    required this.fileInfo,
    String? databaseName,
    required String uuid,
    FileContent? initialCachedContent,
  }) : super(
            databaseName: databaseName,
            uuid: uuid,
            initialCachedContent: initialCachedContent);

  static Directory? _cacheDir;

  Future<Directory> _getCacheDir() => provider.pathUtil
      .getTemporaryDirectory(subNamespace: 'cloud_storage_cache');

  final CloudStorageProvider provider;

  final Map<String, String?> fileInfo;

  @override
  String get typeDebug => '$runtimeType:${provider.id}';

  @override
  String get displayNameFromPath => provider.displayNameFromPath(fileInfo);

  @override
  String get displayPath => provider.displayPath(fileInfo);

  File _cacheMetadataFile(String cacheDirPath) =>
      File(path.join(cacheDirPath, '$uuid.kdbx.json'));
  File _cacheKdbxFile(String cacheDirPath) =>
      File(path.join(cacheDirPath, '$uuid.kdbx'));

  @override
  Stream<FileContent> load() async* {
    // first try to load from cache.
    _cacheDir ??= await _getCacheDir();
    final metadataFile = _cacheMetadataFile(_cacheDir!.path);
    final kdbxFile = _cacheKdbxFile(_cacheDir!.path);
    try {
      if (metadataFile.existsSync()) {
        final cacheInfo = FileContentCached.fromJson(json
            .decode(await metadataFile.readAsString()) as Map<String, dynamic>);
        final content = await kdbxFile.readAsBytes();
        if (content.length != cacheInfo.cacheSize) {
          throw StateError('Cached size does not match size in '
              'cache file. ${content.length} vs $cacheInfo');
        }
        yield FileContent(content, cacheInfo.metadata, FileContentSource.cache);
      }
    } catch (e, stackTrace) {
      _logger.severe('Error while loading cached kdbx file', e, stackTrace);
    }

    // after cache got loaded, download new version.
    _logger.finer('loading ${toString()}');
    final freshContent = await provider.loadFile(fileInfo);
    yield freshContent;
    unawaited(_writeCache(freshContent));
  }

  Future<void> _writeCache(FileContent freshContent) async {
    assert(freshContent.source == FileContentSource.origin);
    try {
      _cacheDir ??= await _getCacheDir();
      final metadataFile = _cacheMetadataFile(_cacheDir!.path);
      final kdbxFile = _cacheKdbxFile(_cacheDir!.path);
      final cacheInfo = FileContentCached(
        metadata: freshContent.metadata,
        cacheDate: clock.now().toUtc(),
        cacheSize: freshContent.content.length,
      );
      _logger.finer('Writing cache ${metadataFile.path}');
      await metadataFile.writeAsString(json.encode(cacheInfo.toJson()),
          flush: true);
      await kdbxFile.writeAsBytes(freshContent.content);
      _logger.finer('Done: Written cache ${metadataFile.path}');
    } catch (e, stackTrace) {
      _logger.severe('Error while writing cache for $uuid', e, stackTrace);
    }
  }

  @override
  bool get supportsWrite => true;

  @override
  Future<Map<String, dynamic>> write(
      Uint8List bytes, Map<String, dynamic>? previousMetadata) async {
    final metadata = await provider.saveFile(fileInfo, bytes, previousMetadata);
    await _writeCache(FileContent(bytes, metadata));
    return metadata;
  }

  @override
  FileSourceIcon get displayIcon => provider.displayIcon;

  @override
  FileSource copyWithDatabaseName(String databaseName) =>
      FileSourceCloudStorage(
        provider: provider,
        fileInfo: fileInfo,
        uuid: uuid,
        databaseName: databaseName,
        initialCachedContent: cached,
      );
}
