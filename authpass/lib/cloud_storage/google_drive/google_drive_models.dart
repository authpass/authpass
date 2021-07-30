import 'package:googleapis/drive/v3.dart';
import 'package:json_annotation/json_annotation.dart';

part 'google_drive_models.g.dart';

@JsonSerializable()
class GoogleDriveMetadata {
  GoogleDriveMetadata({
    required this.modifiedTime,
    required this.version,
    required this.size,
  });
  factory GoogleDriveMetadata.fromJson(Map<String, dynamic> json) =>
      _$GoogleDriveMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleDriveMetadataToJson(this);

  static final fields = ['id', 'modifiedTime', 'version', 'size'].join(',');

  final DateTime? modifiedTime;
  final String? version;
  final int size;

  static GoogleDriveMetadata fromMetadata(File metadata) {
    return GoogleDriveMetadata(
      modifiedTime: metadata.modifiedTime,
      version: metadata.version,
      size: int.tryParse(metadata.size ?? '') ?? -1,
    );
  }
}
