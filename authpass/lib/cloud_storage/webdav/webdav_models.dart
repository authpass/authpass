import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'webdav_models.g.dart';

@JsonSerializable(nullable: false)
class UserNamePasswordCredentials {
  UserNamePasswordCredentials({
    @required String baseUrl,
    @required this.username,
    @required this.password,
  }) : baseUrl = _ensureEndsWithSlash(baseUrl);
  factory UserNamePasswordCredentials.fromJson(Map<String, dynamic> json) =>
      _$UserNamePasswordCredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$UserNamePasswordCredentialsToJson(this);

  final String baseUrl;
  final String username;
  final String password;

  static String _ensureEndsWithSlash(String baseUrl) {
    if (baseUrl.endsWith('/')) {
      return baseUrl;
    }
    return '$baseUrl/';
  }
}

@JsonSerializable(nullable: false)
class WebDavFileMetadata {
  WebDavFileMetadata({
    @required this.etag,
  });
  factory WebDavFileMetadata.fromJson(Map<String, dynamic> json) =>
      _$WebDavFileMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$WebDavFileMetadataToJson(this);

  final String etag;
}
