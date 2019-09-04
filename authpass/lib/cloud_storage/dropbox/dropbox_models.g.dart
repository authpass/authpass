// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dropbox_models.dart';

// **************************************************************************
// AnalyticsEventGenerator
// **************************************************************************

// ignore_for_file: unnecessary_statements, implicit_dynamic_parameter

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileSearchResponse _$FileSearchResponseFromJson(Map<String, dynamic> json) {
  return FileSearchResponse(
    matches: (json['matches'] as List).map((e) => FileSearchMatch.fromJson(e as Map<String, dynamic>)).toList(),
    hasMore: json['has_more'] as bool,
  );
}

Map<String, dynamic> _$FileSearchResponseToJson(FileSearchResponse instance) => <String, dynamic>{
      'matches': instance.matches,
      'has_more': instance.hasMore,
    };

FileSearchMatch _$FileSearchMatchFromJson(Map<String, dynamic> json) {
  return FileSearchMatch(
    metadata: FileMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$FileSearchMatchToJson(FileSearchMatch instance) => <String, dynamic>{
      'metadata': instance.metadata,
    };

FileMetadata _$FileMetadataFromJson(Map<String, dynamic> json) {
  return FileMetadata(
    id: json['id'] as String,
    name: json['name'] as String,
    pathDisplay: json['path_display'] as String,
  );
}

Map<String, dynamic> _$FileMetadataToJson(FileMetadata instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path_display': instance.pathDisplay,
    };
