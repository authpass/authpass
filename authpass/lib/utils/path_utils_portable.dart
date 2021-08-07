import 'dart:io' show Platform;

import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/path_utils.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:logging/logging.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('path_utils_portable');

@NonNls
const _dirNameData = 'data';
@NonNls
const _argumentData = '--data=';

class PathUtilsPortable extends PathUtilsDefault {
  PathUtilsPortable.internal() : super.internal();

  late final _dataDirectory = _getDataDirectory();

  final FileSystem fileSystem = const LocalFileSystem();

  Directory _getDataDirectory() {
    try {
      for (final arg in Platform.executableArguments) {
        if (arg.startsWith(_argumentData)) {
          final path = arg.split(CharConstants.equalSign)[1];
          _logger.finer('Use data path: $path');
          final directory = fileSystem.directory(path);
          directory.createSync(recursive: true);
          _logger.finer('Absolute Path: ${directory.absolute.path}');
          return directory;
        }
      }
    } catch (e, stackTrace) {
      _logger.warning(
          'Unable to get data directory from arguments.', e, stackTrace);
    }
    try {
      final directory = _getAppBaseDirectory();
      final base = directory.childDirectory(_dirNameData);
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
    // We assume we are 2 levels deep for portable apps. Like:
    // AuthPassPortable/App/AuthPass/AuthPass.exe
    try {
      return fileSystem.file(Platform.resolvedExecutable).parent.parent.parent;
    } catch (e, stackTrace) {
      _logger.warning('Unable to resolve Data directory through executable.', e,
          stackTrace);
    }
    try {
      return fileSystem.file(Platform.script.toFilePath()).parent.parent.parent;
    } catch (e, stackTrace) {
      _logger.warning('Unable to resolve Data directory through executable.', e,
          stackTrace);
    }
    return fileSystem.currentDirectory.parent;
  }

  Directory _subDir(@NonNls String name) {
    return _dataDirectory.childDirectory(name);
  }

  @override
  Future<Directory> retrieveAppDataDirectory() async => _subDir('AppData');

  @override
  Future<Directory> retrieveApplicationDocumentsDirectory() async =>
      _subDir('Documents');

  @override
  Future<Directory> retrieveTemporaryDirectory() async => _subDir('Temp');
}
