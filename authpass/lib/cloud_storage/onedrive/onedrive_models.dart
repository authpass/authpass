import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

// TODO: remove the following when migrating to nnbd
//       (info: 'nullable' is deprecated and shouldn't be used. Has no effect.)
// ignore_for_file: deprecated_member_use

part 'onedrive_models.g.dart';

@JsonSerializable(nullable: false)
class ListChildrenResponse {
  ListChildrenResponse({
    required this.value,
  });
  factory ListChildrenResponse.fromJson(Map<String, dynamic> json) =>
      _$ListChildrenResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ListChildrenResponseToJson(this);

  final List<OneDriveItem> value;
}

@JsonSerializable(nullable: false)
class OneDriveItem {
  OneDriveItem({
    required this.id,
    required this.cTag,
    required this.eTag,
    required this.name,
    required this.parentReference,
    this.folder,
    this.file,
  });
  factory OneDriveItem.fromJson(Map<String, dynamic> json) =>
      _$OneDriveItemFromJson(json);
  Map<String, dynamic> toJson() => _$OneDriveItemToJson(this);

  final String? id;

  /// the "content" tag, only changes with content
  final String? cTag;

  /// etag changes with metadata+content.
  final String? eTag;
  final String? name;

  final OneDriveItemParent parentReference;

  @JsonKey(nullable: true)
  final OneDriveFolder? folder;
  @JsonKey(nullable: true)
  final OneDriveFile? file;

  CloudStorageEntity toCloudStorageEntity() => CloudStorageEntity(
        (b) => b
          ..name = name
          ..id = id
          ..type = (folder != null
              ? CloudStorageEntityType.directory
              : file != null
                  ? CloudStorageEntityType.file
                  : CloudStorageEntityType.unknown)
          ..path = [parentReference.path, CharConstants.slash, name].join(),
      );
}

@JsonSerializable(nullable: false)
class OneDriveItemParent {
  OneDriveItemParent({
    this.path,
  });
  factory OneDriveItemParent.fromJson(Map<String, dynamic> json) =>
      _$OneDriveItemParentFromJson(json);
  Map<String, dynamic> toJson() => _$OneDriveItemParentToJson(this);

  final String? path;
}

@JsonSerializable(nullable: false)
class OneDriveFolder {
  OneDriveFolder({
    this.childCount,
  });
  factory OneDriveFolder.fromJson(Map<String, dynamic> json) =>
      _$OneDriveFolderFromJson(json);
  Map<String, dynamic> toJson() => _$OneDriveFolderToJson(this);

  final int? childCount;
}

@JsonSerializable(nullable: false)
class OneDriveFile {
  OneDriveFile({
    this.mimeType,
  });
  factory OneDriveFile.fromJson(Map<String, dynamic> json) =>
      _$OneDriveFileFromJson(json);
  Map<String, dynamic> toJson() => _$OneDriveFileToJson(this);

  final String? mimeType;
}
