import 'dart:io';

import 'package:authpass/utils/path_utils.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;

final _logger = Logger('path_utils_portable');

class PathUtilsPortable extends PathUtilsDefault {
  PathUtilsPortable.internal() : super.internal();

  late final _dataDirectory = _getDataDirectory();

  Directory _getDataDirectory() {
    try {
      final directory = _getAppBaseDirectory();
      final base = Directory(path.join(directory.path, 'Data'));
      base.createSync(recursive: true);
      return base;
    } catch (e, stackTrace) {
      _logger.warning(
          'Unable to resolve Data directory through executable. using current directory.',
          e,
          stackTrace);
      throw StateError('Unable to get data directory. $e');
    }
  }

  Directory _getAppBaseDirectory() {
    try {
      return File(Platform.resolvedExecutable).parent.parent;
    } catch (e, stackTrace) {
      _logger.warning('Unable to resolve Data directory through executable.', e,
          stackTrace);
    }
    try {
      return File(Platform.script.toFilePath()).parent.parent;
    } catch (e, stackTrace) {
      _logger.warning('Unable to resolve Data directory through executable.', e,
          stackTrace);
    }
    return Directory.current.parent;
  }

  Directory _subDir(String name) {
    return Directory(path.join(_dataDirectory.path, name));
  }

  @override
  Future<Directory> retrieveAppDataDirectory() async => _subDir('AppData');

  @override
  Future<Directory> retrieveApplicationDocumentsDirectory() async =>
      _subDir('Documents');

  @override
  Future<Directory> retrieveTemporaryDirectory() async => _subDir('Temp');
}
