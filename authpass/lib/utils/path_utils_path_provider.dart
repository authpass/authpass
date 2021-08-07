import 'package:authpass/utils/path_utils.dart';
import 'package:authpass/utils/platform.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

class PathUtilsFromPathProvider extends PathUtilsDefault {
  PathUtilsFromPathProvider.internal() : super.internal();

  final FileSystem fileSystem = const LocalFileSystem();

  @override
  Future<Directory> retrieveTemporaryDirectory() async =>
      fileSystem.directory(await path_provider.getTemporaryDirectory());

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
    return await _getDesktopDirectory();
  }

  @NonNls
  Future<Directory> _getDesktopDirectory() async {
    // https://stackoverflow.com/a/32937974/109219
    final userHome = AuthPassPlatform.environment['HOME'] ??
        AuthPassPlatform.environment['USERPROFILE']!;
    final dataDir =
        fileSystem.directory(path.join(userHome, '.authpass', 'data'));
    await dataDir.create(recursive: true);
    return dataDir;
  }
}
