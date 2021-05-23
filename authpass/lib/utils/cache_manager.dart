// ignore_for_file: implementation_imports

import 'package:authpass/utils/path_utils.dart';
import 'package:clock/clock.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cache_manager/src/storage/cache_object.dart';
import 'package:meta/meta.dart';

class AuthPassCacheManager extends CacheManager {
  factory AuthPassCacheManager({required PathUtils pathUtils}) {
    final key = getKey(pathUtils);
    final config = Config(
      getKey(pathUtils),
      maxNrOfCacheObjects: 200,
      stalePeriod: const Duration(days: 30),
      repo: JsonCacheInfoRepository(databaseName: key),
    );
    final cacheManager = AuthPassCacheManager._(
      pathUtils: pathUtils,
      config: config,
    );
    return cacheManager;
  }

  AuthPassCacheManager._({required this.pathUtils, required Config config})
      : key = getKey(pathUtils),
        super(config);

  static const _keyBase = 'authpassCachedImageData';
  static String getKey(PathUtils pathUtils) => pathUtils.namespace == null
      ? _keyBase
      : '${_keyBase}__${pathUtils.namespace}';
  final String key;

  PathUtils pathUtils;
}

class MemoryCacheObject {
  MemoryCacheObject(this.cacheObject) : touched = clock.now();

  final CacheObject cacheObject;
  final DateTime touched;
}
