import 'dart:convert';
import 'dart:typed_data';

import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:clock/clock.dart';
import 'package:file/file.dart';
import 'package:logging/logging.dart';
import 'package:pedantic/pedantic.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('file_source_cloud_storage');

@NonNls
const _jsonMetadata = 'metadata';
@NonNls
const _jsonCacheDate = 'cacheDate';
@NonNls
const _jsonCacheSize = 'cacheSize';

class FileContentCached {
  FileContentCached({
    required this.metadata,
    required this.cacheDate,
    required this.cacheSize,
  }) : assert(cacheDate.isUtc);
  factory FileContentCached.fromJson(Map<String, dynamic> json) =>
      FileContentCached(
        metadata: json[_jsonMetadata] as Map<String, dynamic>?,
        cacheDate: DateTime.fromMillisecondsSinceEpoch(
          json[_jsonCacheDate] as int,
          isUtc: true,
        ),
        cacheSize: json[_jsonCacheSize] as int?,
      );

  final Map<String, dynamic>? metadata;
  final DateTime cacheDate;
  final int? cacheSize;

  Map<String, Object?> toJson() => {
        _jsonMetadata: metadata,
        _jsonCacheDate: cacheDate.millisecond,
        _jsonCacheSize: cacheSize,
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

  @NonNls
  @override
  String get typeDebug => '$runtimeType:${provider.id}';

  @override
  String get displayNameFromPath => provider.displayNameFromPath(fileInfo);

  @override
  String get displayPath => provider.displayPath(fileInfo);

  @NonNls
  File _cacheMetadataFile(Directory cacheDir) =>
      cacheDir.childFile('$uuid.kdbx.json');
  @NonNls
  File _cacheKdbxFile(Directory cacheDir) => cacheDir.childFile('$uuid.kdbx');

  @override
  Stream<FileContent> load() async* {
    // first try to load from cache.
    final cacheDir = _cacheDir ??= await _getCacheDir();
    final metadataFile = _cacheMetadataFile(cacheDir);
    final kdbxFile = _cacheKdbxFile(cacheDir);
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
    try {
      final freshContent = await provider.loadFile(fileInfo);
      yield freshContent;
      unawaited(_writeCache(freshContent));
    } catch (e, stackTrace) {
      _logger.severe('Error while loading file from provider ${toString()}', e,
          stackTrace);
      rethrow;
    }
  }

  Future<void> _writeCache(FileContent freshContent) async {
    assert(freshContent.source == FileContentSource.origin);
    try {
      final cacheDir = _cacheDir ??= await _getCacheDir();
      final metadataFile = _cacheMetadataFile(cacheDir);
      final kdbxFile = _cacheKdbxFile(cacheDir);
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
