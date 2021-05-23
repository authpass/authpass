import 'dart:typed_data';

/// Wrapper around loaded file contents. This basically attaches
/// `metadata` to the retrieved byte content, e.g. for conflict detection
/// by having the revision loaded from e.g. dropbox we can assure there
/// are no conflicts on writing.
///
/// `metadata` must only be primitives and json serializable.
class FileContent {
  FileContent(
    this.content, [
    this.metadata = const <String, dynamic>{},
    this.source = FileContentSource.origin,
  ]);

  final Uint8List content;
  final Map<String, dynamic>? metadata;
  final FileContentSource source;
}

enum FileContentSource {
  origin,
  cache,
  memoryCache,
}
