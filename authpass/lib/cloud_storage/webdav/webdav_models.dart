import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'webdav_models.g.dart';

@JsonSerializable(nullable: false)
class UserNamePasswordCredentials {
  UserNamePasswordCredentials({
    @required this.baseUrl,
    @required this.username,
    @required this.password,
  });
  factory UserNamePasswordCredentials.fromJson(Map<String, dynamic> json) =>
      _$UserNamePasswordCredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$UserNamePasswordCredentialsToJson(this);

  final String baseUrl;
  final String username;
  final String password;
}

@JsonSerializable(nullable: false)
class WebDavFileMetadata {
  WebDavFileMetadata({
    @required this.etag,
  });
  factory WebDavFileMetadata.fromJson(Map<String, dynamic> json) => _$WebDavFileMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$WebDavFileMetadataToJson(this);

  final String etag;
}
