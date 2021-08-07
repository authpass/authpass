import 'package:authpass/utils/path_utils.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

class PathUtilsWeb extends PathUtilsDefault {
  PathUtilsWeb.internal() : super.internal();

  final FileSystem fileSystem = MemoryFileSystem();

  @NonNls
  @override
  Future<Directory> retrieveAppDataDirectory() async {
    return fileSystem.directory('/app');
  }

  @NonNls
  @override
  Future<Directory> retrieveApplicationDocumentsDirectory() async {
    return fileSystem.directory('/doc');
  }

  @NonNls
  @override
  Future<Directory> retrieveTemporaryDirectory() async {
    return fileSystem.directory('/temp');
  }
}
