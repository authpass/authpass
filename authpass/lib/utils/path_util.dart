import 'package:file/file.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

/// A abstract version of [PathUtils] to make things mock able
/// and executable without `dart:ui` / flutter dependency.
abstract class PathUtil {
  Future<Directory> getTemporaryDirectory({@NonNls String? subNamespace});
}
