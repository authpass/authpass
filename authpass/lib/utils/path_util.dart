import 'dart:io';

/// A abstract version of [PathUtils] to make things mock able
/// and executable without `dart:ui` / flutter dependency.
abstract class PathUtil {
  Future<Directory> getTemporaryDirectory({String? subNamespace});
}
