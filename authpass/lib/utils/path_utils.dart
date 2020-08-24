import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:authpass/env/_base.dart';
import 'package:authpass/utils/platform.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

class PathUtils {
  factory PathUtils() => _instance;

  PathUtils._();

  static final PathUtils _instance = PathUtils._();
  static final Completer<bool> runAppFinished = Completer<bool>();
  static Future<bool> get waitForRunAppFinished => runAppFinished.future;

  Future<Directory> getTemporaryDirectory() async {
    return _namespaced(await path_provider.getTemporaryDirectory());
  }

  /// Document directory for "internal" kdbx files which should be accessible
  /// by the user. - this directory is NOT namespaced during development.
  Future<Directory> getAppDocDirectory({@required bool ensureCreated}) async {
    assert(ensureCreated != null);
    final dir = await path_provider.getApplicationDocumentsDirectory();
    if (ensureCreated) {
      return await dir.create(recursive: true);
    }
    return dir;
  }

  /// Data directory meant for files which are NOT accessible by the user.
  /// (ie. json files, logs, etc).
  Future<Directory> getAppDataDirectory() async {
    if (AuthPassPlatform.isWeb) {
      throw UnsupportedError('Not supported on web.');
    }
    if (AuthPassPlatform.isIOS || AuthPassPlatform.isMacOS) {
      return _namespaced(await path_provider.getApplicationSupportDirectory());
    }
    if (AuthPassPlatform.isAndroid) {
      return _namespaced(
          await path_provider.getApplicationDocumentsDirectory());
    }
    return _namespaced(await _getDesktopDirectory());
  }

  Directory _namespaced(Directory base) {
    final namespace = Env.value?.storageNamespace;
    if (namespace == null) {
      return base;
    }
    return Directory(path.join(base.path, namespace));
  }

  String get namespace => Env.value?.storageNamespace;

  Future<Directory> getLogDirectory() async {
    return Directory(
        path.join((_namespaced(await getTemporaryDirectory())).path, 'logs'));
  }

  Future<Directory> _getDesktopDirectory() async {
    // https://stackoverflow.com/a/32937974/109219
    final userHome = AuthPassPlatform.environment['HOME'] ??
        Platform.environment['USERPROFILE'];
    final dataDir = Directory(path.join(userHome, '.authpass', 'data'));
    await dataDir.create(recursive: true);
    return dataDir;
  }

  Future<File> saveToTempDirectory(Uint8List bytes,
      {@required String dirPrefix, @required String fileName}) async {
    assert(fileName != null);
    final tempDirectory = await getTemporaryDirectory();
    final dir = await tempDirectory.createTemp();
    final f = File(path.join(dir.path, fileName));
    await f.writeAsBytes(bytes);
    return f;
  }
}
