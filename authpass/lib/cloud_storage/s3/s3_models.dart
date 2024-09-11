import 'package:json_annotation/json_annotation.dart';

part 's3_models.g.dart';

@JsonSerializable()
class S3Metadata {
  S3Metadata({
    required this.serviceUrl,
    required this.accessKey,
    required this.secretKey,
    required this.authRegion,
  });

  factory S3Metadata.fromJson(Map<String, dynamic> json) =>
      _$S3MetadataFromJson(json);
  Map<String, dynamic> toJson() => _$S3MetadataToJson(this);

  final String serviceUrl;
  final String accessKey;
  final String secretKey;
  final String authRegion;
}
