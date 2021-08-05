import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

// TODO: remove the following when migrating to nnbd
//       (info: 'nullable' is deprecated and shouldn't be used. Has no effect.)
// ignore_for_file: deprecated_member_use

part 'dropbox_models.g.dart';

@JsonSerializable(nullable: false)
class FileListResponse {
  FileListResponse({
    this.entries,
    this.cursor,
    this.hasMore,
  });
  factory FileListResponse.fromJson(Map<String, dynamic> json) =>
      _$FileListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FileListResponseToJson(this);

  final List<FileMetadata>? entries;
  final String? cursor;
  @JsonKey(name: 'has_more')
  final bool? hasMore;
}

@JsonSerializable(nullable: false)
class FileSearchResponse {
  FileSearchResponse({
    this.matches,
    this.hasMore,
  });

  factory FileSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$FileSearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FileSearchResponseToJson(this);

  final List<FileSearchMatch>? matches;
  @JsonKey(name: 'has_more')
  final bool? hasMore;

  @NonNls
  @override
  String toString() {
    return 'FileSearchResponse{matches: $matches, hasMore: $hasMore}';
  }
}

@JsonSerializable(nullable: false)
class FileSearchMatch {
  FileSearchMatch({
    this.metadata,
  });

  factory FileSearchMatch.fromJson(Map<String, dynamic> json) =>
      _$FileSearchMatchFromJson(json);

  Map<String, dynamic> toJson() => _$FileSearchMatchToJson(this);

  @JsonKey(name: 'metadata')
  final FileMetadataV2? metadata;

  @NonNls
  @override
  String toString() {
    return 'FileSearchMatch{metadata: $metadata}';
  }
}

@JsonSerializable(nullable: false)
class FileMetadataV2 {
  FileMetadataV2({
    this.metadata,
  });

  factory FileMetadataV2.fromJson(Map<String, dynamic> json) =>
      _$FileMetadataV2FromJson(json);

  Map<String, dynamic> toJson() => _$FileMetadataV2ToJson(this);

  final FileMetadata? metadata;
}

@JsonSerializable(nullable: false)
class FileMetadata {
  FileMetadata({
    this.id,
    this.tag,
    this.name,
    this.pathDisplay,
    this.rev,
  });

  factory FileMetadata.fromJson(Map<String, dynamic> json) =>
      _$FileMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$FileMetadataToJson(this);

  final String? id;

  /// one of: 'folder' or 'file' or 'deleted'
  @JsonKey(name: '.tag')
  final String? tag;

  @NonNls
  CloudStorageEntityType get tagType => tag == 'folder'
      ? CloudStorageEntityType.directory
      : CloudStorageEntityType.file;
  final String? name;
  @JsonKey(name: 'path_display')
  final String? pathDisplay;
  final String? rev;

  @NonNls
  @override
  String toString() {
    return 'FileMetadata{id: $id, name: $name, pathDisplay: $pathDisplay}';
  }

  CloudStorageEntity toCloudStorageEntity() => CloudStorageEntity(
        (b) => b
          ..name = name
          ..id = id
          ..type = tagType
          ..path = pathDisplay,
      );
}
