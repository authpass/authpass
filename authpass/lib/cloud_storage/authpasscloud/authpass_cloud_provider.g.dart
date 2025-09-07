// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authpass_cloud_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FileMetadata _$FileMetadataFromJson(Map<String, dynamic> json) =>
    _FileMetadata(
      name: json['name'] as String,
      fileToken: json['fileToken'] as String,
      versionToken: json['versionToken'] as String,
    );

Map<String, dynamic> _$FileMetadataToJson(_FileMetadata instance) =>
    <String, dynamic>{
      'name': instance.name,
      'fileToken': instance.fileToken,
      'versionToken': instance.versionToken,
    };

AuthPassExternalAttachment _$AuthPassExternalAttachmentFromJson(
  Map<String, dynamic> json,
) => AuthPassExternalAttachment(
  attachmentId: json['id'] as String,
  secret: json['secret'] as String,
  format: $enumDecode(_$AttachmentFormatEnumMap, json['format']),
  size: json['size'] as int,
);

Map<String, dynamic> _$AuthPassExternalAttachmentToJson(
  AuthPassExternalAttachment instance,
) => <String, dynamic>{
  'id': instance.attachmentId,
  'secret': instance.secret,
  'format': _$AttachmentFormatEnumMap[instance.format]!,
  'size': instance.size,
};

const _$AttachmentFormatEnumMap = {
  AttachmentFormat.gzipChaCha7539: 'gzipChaCha7539',
  AttachmentFormat.unsupported: 'unsupported',
};
