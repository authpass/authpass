import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class PathUtils {
  factory PathUtils() => _instance;

  PathUtils._();

  static final PathUtils _instance = PathUtils._();
  static final Completer<bool> runAppFinished = Completer<bool>();
  static Future<bool> get waitForRunAppFinished => runAppFinished.future;

  Future<Directory> getAppDataDirectory() async {
    return Platform.isIOS || Platform.isAndroid ? getApplicationDocumentsDirectory() : _getDesktopDirectory();
  }

  Future<Directory> getLogDirectory() async {
    return Directory(path.join((await getAppDataDirectory()).path, 'logs'));
  }

  Future<Directory> _getDesktopDirectory() async {
    // https://stackoverflow.com/a/32937974/109219
    final userHome = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    final dataDir = Directory(path.join(userHome, '.authpass', 'data'));
    await dataDir.create(recursive: true);
    return dataDir;
  }
}
