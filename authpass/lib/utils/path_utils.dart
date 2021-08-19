import 'dart:async';
import 'dart:typed_data';

import 'package:authpass/env/_base.dart';
import 'package:authpass/utils/path_util.dart';
import 'package:authpass/utils/path_utils_path_provider.dart';
import 'package:authpass/utils/path_utils_portable.dart';
import 'package:authpass/utils/path_utils_web.dart';
import 'package:authpass/utils/platform.dart';
import 'package:file/file.dart';
import 'package:meta/meta.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

abstract class PathUtils implements PathUtil {
  factory PathUtils() => _instance;

  PathUtils.internal();

  static final PathUtils _instance = AuthPassPlatform.isPortable
      ? PathUtilsPortable.internal()
      : AuthPassPlatform.isWeb
          ? PathUtilsWeb.internal()
          : PathUtilsFromPathProvider.internal();
  static final Completer<bool> runAppFinished = Completer<bool>();

  static Future<bool> get waitForRunAppFinished => runAppFinished.future;

  String? get namespace => Env.value?.storageNamespace;

  Future<Directory> getAppDocDirectory({required bool ensureCreated});
  Future<Directory> getAppDataDirectory();
  Future<Directory> getLogDirectory();
  Future<File> saveToTempDirectory(
    Uint8List bytes, {
    @NonNls required String dirPrefix,
    @NonNls required String fileName,
  });

  Directory _namespaced(Directory base, {String? subNamespace}) {
    final namespace = Env.value?.storageNamespace;
    if (namespace == null && subNamespace == null) {
      return base;
    }
    return base
        .childDirectoryOrSelf(namespace)
        .childDirectoryOrSelf(subNamespace)
      ..createSync(recursive: true);
    // return Directory(
    //     path.joinAll([base.path, namespace, subNamespace].whereNotNull()))
    //   ..create(recursive: true);
  }
}

extension on Directory {
  Directory childDirectoryOrSelf(String? name) {
    if (name == null) {
      return this;
    }
    return childDirectory(name);
  }
}

abstract class PathUtilsDefault extends PathUtils {
  PathUtilsDefault.internal() : super.internal();

  final Map<String, Directory> directoryCache = {};

  @NonNls
  static String _cacheKey(String type, String? subNamespace) {
    return '$type$subNamespace';
  }

  @NonNls
  @override
  Future<Directory> getTemporaryDirectory({String? subNamespace}) async {
    return directoryCache[_cacheKey('temp', subNamespace)] ??= _namespaced(
      await retrieveTemporaryDirectory(),
      subNamespace: subNamespace,
    );
  }

  @protected
  @visibleForOverriding
  Future<Directory> retrieveTemporaryDirectory();
  @protected
  @visibleForOverriding
  Future<Directory> retrieveApplicationDocumentsDirectory();
  @protected
  @visibleForOverriding
  Future<Directory> retrieveAppDataDirectory();

  /// Document directory for "internal" kdbx files which should be accessible
  /// by the user. - this directory is NOT namespaced during development.
  @override
  Future<Directory> getAppDocDirectory({required bool ensureCreated}) async {
    final dir = _namespaced(await retrieveApplicationDocumentsDirectory());
    if (ensureCreated) {
      return await dir.create(recursive: true);
    }
    return dir;
  }

  /// Data directory meant for files which are NOT accessible by the user.
  /// (ie. json files, logs, etc).
  @override
  Future<Directory> getAppDataDirectory() async {
    return _namespaced(await retrieveAppDataDirectory());
  }

  @NonNls
  @override
  Future<Directory> getLogDirectory() async {
    return _namespaced(await retrieveTemporaryDirectory())
        .childDirectory('logs');
  }

  @override
  Future<File> saveToTempDirectory(
    Uint8List bytes, {
    required String dirPrefix,
    required String fileName,
  }) async {
    final tempDirectory = await getTemporaryDirectory();
    final dir = await tempDirectory.createTemp();
    final f = dir.childFile(fileName); //File(path.join(dir.path, fileName));
    await f.writeAsBytes(bytes);
    return f;
  }
}
