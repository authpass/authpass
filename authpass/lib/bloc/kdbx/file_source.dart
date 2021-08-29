import 'dart:typed_data';

import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/utils/platform.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('file_source');

enum FileSourceIcon {
  hdd,
  externalLink,
  dropbox,
  googleDrive,
  webDav,
  oneDrive,
  authPass,
}

abstract class FileSource {
  FileSource({
    required this.databaseName,
    required this.uuid,
    FileContent? initialCachedContent,
  }) : _cached = initialCachedContent;

  FileContent? _cached;

  @protected
  @visibleForTesting
  FileContent? get cached => _cached;

  /// the last read or written content.
  FileContent? get lastContent => cached;

  final String uuid;

  /// If known should return the name of the database, null otherwise.
  @protected
  final String? databaseName;

  /// Returns the database name, or if it is not know the bare file name.
  String get displayName => databaseName ?? displayNameFromPath;

  FileSourceIcon get displayIcon;

  /// The database name to display if [databaseName] is unknown.
  @protected
  String get displayNameFromPath;

  /// Exact path to the file source.
  String get displayPath;

  /// whether this file source supports saving of changes.
  bool get supportsWrite;

  /// The metadata which was fetched on the last call to [content].
  @protected
  Map<String, dynamic>? get previousMetadata => _cached!.metadata;

  String get typeDebug => runtimeType.toString();

  FileSource copyWithDatabaseName(String databaseName);

  @protected
  Stream<FileContent> load();

  /// Should write the given contents to the file. when there was a previous
  /// call to [load] which returned [FileContent.metadata], this will be passe
  /// into [previousMetadata]
  @protected
  Future<Map<String, dynamic>?> write(
      Uint8List bytes, Map<String, dynamic>? previousMetadata);

  Future<void> contentPreCache() async => await content().last;

  Stream<FileContent> content({bool updateCache = true}) async* {
    if (_cached != null) {
      //  memory cache is perfectly fine.
      yield _cached!;
    }
    await for (final content in load()) {
      yield content;
      if (updateCache) {
        _cached = FileContent(
            content.content, content.metadata, FileContentSource.memoryCache);
      }
    }
  }

  Future<FileContent> contentWrite(Uint8List bytes,
      {required Map<String, dynamic>? metadata}) async {
    _logger.finer('Writing content to $typeDebug ($runtimeType) $this');
    try {
      final newMetadata = await write(bytes, metadata ?? _cached?.metadata);
      return _cached =
          FileContent(bytes, newMetadata, FileContentSource.memoryCache);
    } catch (e, stackTrace) {
      _logger.severe('Error while writing into $typeDebug ($runtimeType) $this',
          e, stackTrace);
      rethrow;
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is FileSource) {
      return other.uuid == uuid;
    }
    return super == other;
  }

  @override
  int get hashCode => uuid.hashCode;

  @NonNls
  @protected
  Map<String, String?> toDebugMap() => {
        'type': runtimeType.toString(),
        'uuid': uuid,
        'databaseName': databaseName,
        'displayPath': displayPath
      };

  @override
  String toString() {
    return toDebugMap().toString();
  }

//  @override
//  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
//    return 'FileSource{type: $runtimeType, uuid: $uuid, '
//        'databaseName: $databaseName, displayPath: $displayPath}';
//  }
}

class FileSourceUrl extends FileSource {
  FileSourceUrl(this.url, {String? databaseName, required String uuid})
      : super(databaseName: databaseName, uuid: uuid);

  @NonNls
  static const _webCorsProxy = 'https://cors-anywhere.herokuapp.com/';

  final Uri? url;

  Uri? get _url =>
      AuthPassPlatform.isWeb && !url.toString().contains(_webCorsProxy)
          ? Uri.parse([_webCorsProxy, url].join())
          : url;

  @override
  Stream<FileContent> load() async* {
    final response = await http.readBytes(_url!);
    yield FileContent(response);
  }

  @override
  String get displayPath => Uri(
        scheme: url!.scheme,
        host: url!.host,
        path: url!.path,
      ).toString(); //url.replace(queryParameters: <String, dynamic>{}, fragment: '').toString();

  @override
  String get displayNameFromPath => path.basenameWithoutExtension(url!.path);

  @override
  Future<Map<String, dynamic>> write(
      Uint8List bytes, Map<String, dynamic>? previousMetadata) async {
    throw UnsupportedError('Cannot write to urls.');
  }

  @override
  bool get supportsWrite => false;

  @override
  FileSourceIcon get displayIcon => FileSourceIcon.externalLink;

  @override
  FileSource copyWithDatabaseName(String databaseName) => FileSourceUrl(
        url,
        uuid: uuid,
        databaseName: databaseName,
      );
}
