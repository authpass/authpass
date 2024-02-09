import 'package:file/file.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

/// A abstract version of [PathUtils] to make things mock able
/// and executable without `dart:ui` / flutter dependency.
abstract class PathUtil {
  /// Directory for temporary files which are typically cleared each app restart.
  Future<Directory> getTemporaryDirectory({@NonNls String? subNamespace});

  /// Directory for caches which survive application restart but is not permanent.
  /// Files in this directory may be cleared at any time
  Future<Directory> getCacheDirectory({@NonNls String? subNamespace});

  /// Directory for caches which survive application restart and is not cleared.
  Future<Directory> getApplicationSupportDirectory({@NonNls String? subNamespace});
}
