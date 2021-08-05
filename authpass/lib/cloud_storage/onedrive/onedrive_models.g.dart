// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onedrive_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListChildrenResponse _$ListChildrenResponseFromJson(
        Map<String, dynamic> json) =>
    ListChildrenResponse(
      value: (json['value'] as List<dynamic>)
          .map((e) => OneDriveItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListChildrenResponseToJson(
        ListChildrenResponse instance) =>
    <String, dynamic>{
      'value': instance.value,
    };

OneDriveItem _$OneDriveItemFromJson(Map<String, dynamic> json) => OneDriveItem(
      id: json['id'] as String?,
      cTag: json['cTag'] as String?,
      eTag: json['eTag'] as String?,
      name: json['name'] as String?,
      parentReference: OneDriveItemParent.fromJson(
          json['parentReference'] as Map<String, dynamic>),
      folder: json['folder'] == null
          ? null
          : OneDriveFolder.fromJson(json['folder'] as Map<String, dynamic>),
      file: json['file'] == null
          ? null
          : OneDriveFile.fromJson(json['file'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OneDriveItemToJson(OneDriveItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cTag': instance.cTag,
      'eTag': instance.eTag,
      'name': instance.name,
      'parentReference': instance.parentReference,
      'folder': instance.folder,
      'file': instance.file,
    };

OneDriveItemParent _$OneDriveItemParentFromJson(Map<String, dynamic> json) =>
    OneDriveItemParent(
      path: json['path'] as String?,
    );

Map<String, dynamic> _$OneDriveItemParentToJson(OneDriveItemParent instance) =>
    <String, dynamic>{
      'path': instance.path,
    };

OneDriveFolder _$OneDriveFolderFromJson(Map<String, dynamic> json) =>
    OneDriveFolder(
      childCount: json['childCount'] as int?,
    );

Map<String, dynamic> _$OneDriveFolderToJson(OneDriveFolder instance) =>
    <String, dynamic>{
      'childCount': instance.childCount,
    };

OneDriveFile _$OneDriveFileFromJson(Map<String, dynamic> json) => OneDriveFile(
      mimeType: json['mimeType'] as String?,
    );

Map<String, dynamic> _$OneDriveFileToJson(OneDriveFile instance) =>
    <String, dynamic>{
      'mimeType': instance.mimeType,
    };
