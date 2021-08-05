// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dropbox_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileListResponse _$FileListResponseFromJson(Map<String, dynamic> json) =>
    FileListResponse(
      entries: (json['entries'] as List<dynamic>?)
          ?.map((e) => FileMetadata.fromJson(e as Map<String, dynamic>))
          .toList(),
      cursor: json['cursor'] as String?,
      hasMore: json['has_more'] as bool?,
    );

Map<String, dynamic> _$FileListResponseToJson(FileListResponse instance) =>
    <String, dynamic>{
      'entries': instance.entries,
      'cursor': instance.cursor,
      'has_more': instance.hasMore,
    };

FileSearchResponse _$FileSearchResponseFromJson(Map<String, dynamic> json) =>
    FileSearchResponse(
      matches: (json['matches'] as List<dynamic>?)
          ?.map((e) => FileSearchMatch.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['has_more'] as bool?,
    );

Map<String, dynamic> _$FileSearchResponseToJson(FileSearchResponse instance) =>
    <String, dynamic>{
      'matches': instance.matches,
      'has_more': instance.hasMore,
    };

FileSearchMatch _$FileSearchMatchFromJson(Map<String, dynamic> json) =>
    FileSearchMatch(
      metadata: json['metadata'] == null
          ? null
          : FileMetadataV2.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FileSearchMatchToJson(FileSearchMatch instance) =>
    <String, dynamic>{
      'metadata': instance.metadata,
    };

FileMetadataV2 _$FileMetadataV2FromJson(Map<String, dynamic> json) =>
    FileMetadataV2(
      metadata: json['metadata'] == null
          ? null
          : FileMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FileMetadataV2ToJson(FileMetadataV2 instance) =>
    <String, dynamic>{
      'metadata': instance.metadata,
    };

FileMetadata _$FileMetadataFromJson(Map<String, dynamic> json) => FileMetadata(
      id: json['id'] as String?,
      tag: json['.tag'] as String?,
      name: json['name'] as String?,
      pathDisplay: json['path_display'] as String?,
      rev: json['rev'] as String?,
    );

Map<String, dynamic> _$FileMetadataToJson(FileMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      '.tag': instance.tag,
      'name': instance.name,
      'path_display': instance.pathDisplay,
      'rev': instance.rev,
    };
