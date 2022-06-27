import 'package:authpass/utils/path_utils.dart';
import 'package:authpass/utils/platform.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';
import 'package:xdg_directories/xdg_directories.dart' as xdg;

class PathUtilsFromPathProvider extends PathUtilsDefault {
  PathUtilsFromPathProvider.internal() : super.internal();

  final FileSystem fileSystem = const LocalFileSystem();

  @NonNls
  final String _namespacePath = 'authpass';

  @override
  Future<Directory> retrieveTemporaryDirectory() async =>
      fileSystem.directory(await path_provider.getTemporaryDirectory());

  @override
  Future<Directory> retrieveCacheDirectory() async {
    if (AuthPassPlatform.isLinux) {
      return fileSystem
          .directory(path.join(xdg.cacheHome.path, _namespacePath));
    }
    return fileSystem.directory(await path_provider.getTemporaryDirectory());
  }

  @override
  Future<Directory> retrieveApplicationDocumentsDirectory() async => fileSystem
      .directory(await path_provider.getApplicationDocumentsDirectory());

  @override
  Future<Directory> retrieveAppDataDirectory() async {
    if (AuthPassPlatform.isWeb) {
      throw UnsupportedError('Not supported on web.');
    }
    if (AuthPassPlatform.isIOS || AuthPassPlatform.isMacOS) {
      return fileSystem
          .directory(await path_provider.getApplicationSupportDirectory());
    }
    if (AuthPassPlatform.isAndroid) {
      return fileSystem
          .directory(await path_provider.getApplicationDocumentsDirectory());
    }
    return await _getDesktopAppDataDirectory();
  }

  @NonNls
  Future<Directory> _getDesktopAppDataDirectory() async {
    // https://stackoverflow.com/a/32937974/109219
    final userHome = AuthPassPlatform.environment['HOME'] ??
        AuthPassPlatform.environment['USERPROFILE']!;
    final dataDir = (() {
      final inUserHome =
          fileSystem.directory(path.join(userHome, '.$_namespacePath', 'data'));
      if (AuthPassPlatform.isLinux && !inUserHome.existsSync()) {
        return fileSystem
            .directory(path.join(xdg.configHome.path, _namespacePath, 'data'));
      }
      return inUserHome;
    })();
    await dataDir.create(recursive: true);
    return dataDir;
  }
}
