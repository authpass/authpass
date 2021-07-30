// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_source_local.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileSourceLocalMetadata _$FileSourceLocalMetadataFromJson(
    Map<String, dynamic> json) {
  return FileSourceLocalMetadata(
    lastModifiedAt: DateTime.parse(json['lastModifiedAt'] as String),
    length: json['length'] as int,
  );
}

Map<String, dynamic> _$FileSourceLocalMetadataToJson(
        FileSourceLocalMetadata instance) =>
    <String, dynamic>{
      'lastModifiedAt': instance.lastModifiedAt.toIso8601String(),
      'length': instance.length,
    };
