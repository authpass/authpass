import 'package:file/file.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

/// A abstract version of [PathUtils] to make things mock able
/// and executable without `dart:ui` / flutter dependency.
abstract class PathUtil {
  /// Directory for temporary files which are typically cleared each app restart.
  Future<Directory> getTemporaryDirectory({@NonNls String? subNamespace});

  /// Directory for caches which survive application restart.
  Future<Directory> getCacheDirectory({@NonNls String? subNamespace});
}
