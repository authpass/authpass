import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';

abstract class FileSourceWeb extends FileSource {
  factory FileSourceWeb({
    // ignore: avoid_unused_constructor_parameters
    required String databaseName,
    // ignore: avoid_unused_constructor_parameters
    required String uuid,
    // ignore: avoid_unused_constructor_parameters
    FileContent? initialCachedContent,
  }) {
    throw UnimplementedError();
  }
}
