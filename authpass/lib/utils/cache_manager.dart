// ignore_for_file: implementation_imports

import 'dart:async';

import 'package:authpass/utils/path_utils.dart';
import 'package:authpass/utils/platform.dart';
import 'package:clock/clock.dart';
import 'package:file/file.dart' as f;
import 'package:file/local.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cache_manager/src/cache_store.dart';
import 'package:flutter_cache_manager/src/storage/cache_info_repository.dart';
import 'package:flutter_cache_manager/src/storage/cache_object.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

bool _isSqfliteSupported() =>
    AuthPassPlatform.isAndroid ||
    AuthPassPlatform.isIOS ||
    AuthPassPlatform.isMacOS;

class AuthPassCacheManager extends BaseCacheManager {
  factory AuthPassCacheManager({PathUtils pathUtils}) {
    final path = Completer<f.Directory>();
    final cacheManager = AuthPassCacheManager._(
      pathUtils: pathUtils,
      cacheStore: _isSqfliteSupported() || AuthPassPlatform.isWeb
          ? null
          : CacheStore(
              path.future,
              getKey(pathUtils),
              200,
              const Duration(days: 30),
              cacheRepoProvider: Future.value(MemoryCacheInfoRepository()),
            ),
    );
    cacheManager
        .getFilePath()
        .then((value) async {
          const fs = LocalFileSystem();
          final directory = fs.directory(value);
          await directory.create(recursive: true);
          return directory;
        })
        .then(path.complete)
        .catchError(path.completeError);
    return cacheManager;
  }

  AuthPassCacheManager._({@required this.pathUtils, CacheStore cacheStore})
      : key = getKey(pathUtils),
        super(getKey(pathUtils), cacheStore: cacheStore);

  static const _keyBase = 'authpassCachedImageData';
  static String getKey(PathUtils pathUtils) => pathUtils.namespace == null
      ? _keyBase
      : '${_keyBase}__${pathUtils.namespace}';
  final String key;

  PathUtils pathUtils;

  @override
  Future<String> getFilePath() async {
    final directory = await pathUtils.getAppDataDirectory();
    return path.join(directory.path, key);
  }
}

class MemoryCacheObject {
  MemoryCacheObject(this.cacheObject) : touched = clock.now();

  final CacheObject cacheObject;
  final DateTime touched;
}

class MemoryCacheInfoRepository extends CacheInfoRepository {
  final Map<String, MemoryCacheObject> cacheObjects = {};

  @override
  Future close() async {
    cacheObjects.clear();
  }

  @override
  Future<int> delete(int id) async {
    final before = cacheObjects.length;
    cacheObjects.removeWhere((key, value) => value.cacheObject.id == id);
    return before - cacheObjects.length;
  }

  @override
  Future deleteAll(Iterable<int> ids) async {
    cacheObjects.clear();
  }

  @override
  Future<CacheObject> get(String url) =>
      Future.value(cacheObjects[url]?.cacheObject);

  @override
  Future<List<CacheObject>> getAllObjects() =>
      Future.value(cacheObjects.values?.map((e) => e.cacheObject)?.toList());

  @override
  Future<List<CacheObject>> getObjectsOverCapacity(int capacity) async {
    final values = List.of(cacheObjects.values);
    values.sort((a, b) => a.touched.compareTo(b.touched));
    if (values.length <= capacity) {
      return [];
    }
    return values.sublist(capacity).map((e) => e.cacheObject).toList();
  }

  @override
  Future<List<CacheObject>> getOldObjects(Duration maxAge) async {
    final maxDate = clock.now().subtract(maxAge);
    return cacheObjects.values
        .where((element) => element.touched.isBefore(maxDate))
        .map((e) => e.cacheObject)
        .toList();
  }

  @override
  Future<CacheObject> insert(CacheObject cacheObject) async {
    cacheObjects[cacheObject.url] = MemoryCacheObject(cacheObject);
    return cacheObject;
  }

  @override
  Future open() async {}

  @override
  Future<int> update(CacheObject cacheObject) async {
    cacheObjects[cacheObject.url] = MemoryCacheObject(cacheObject);
    return 1;
  }

  @override
  Future updateOrInsert(CacheObject cacheObject) async {
    await update(cacheObject);
  }
}
