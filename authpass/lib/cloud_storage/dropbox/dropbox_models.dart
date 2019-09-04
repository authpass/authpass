import 'package:json_annotation/json_annotation.dart';

part 'dropbox_models.g.dart';

@JsonSerializable(nullable: false)
class FileSearchResponse {
  FileSearchResponse({
    this.matches,
    this.hasMore,
  });
  factory FileSearchResponse.fromJson(Map<String, dynamic> json) => _$FileSearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FileSearchResponseToJson(this);

  final List<FileSearchMatch> matches;
  @JsonKey(name: 'has_more')
  final bool hasMore;
}

@JsonSerializable(nullable: false)
class FileSearchMatch {
  FileSearchMatch({
    this.metadata,
  });
  factory FileSearchMatch.fromJson(Map<String, dynamic> json) => _$FileSearchMatchFromJson(json);
  Map<String, dynamic> toJson() => _$FileSearchMatchToJson(this);

  final FileMetadata metadata;
}

@JsonSerializable(nullable: false)
class FileMetadata {
  FileMetadata({
    this.id,
    this.name,
    this.pathDisplay,
  });
  factory FileMetadata.fromJson(Map<String, dynamic> json) => _$FileMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$FileMetadataToJson(this);

  final String id;
  final String name;
  @JsonKey(name: 'path_display')
  final String pathDisplay;
}
