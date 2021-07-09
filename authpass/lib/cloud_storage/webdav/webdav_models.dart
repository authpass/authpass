import 'package:authpass/utils/format_utils.dart';
import 'package:json_annotation/json_annotation.dart';

// TODO: remove the following when migrating to nnbd
//       (info: 'nullable' is deprecated and shouldn't be used. Has no effect.)
// ignore_for_file: deprecated_member_use

part 'webdav_models.g.dart';

@JsonSerializable(nullable: false)
class UserNamePasswordCredentials {
  UserNamePasswordCredentials({
    required String baseUrl,
    required this.username,
    required this.password,
  }) : baseUrl = _ensureEndsWithSlash(baseUrl);
  factory UserNamePasswordCredentials.fromJson(Map<String, dynamic> json) =>
      _$UserNamePasswordCredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$UserNamePasswordCredentialsToJson(this);

  final String baseUrl;
  final String? username;
  final String? password;

  static String _ensureEndsWithSlash(String baseUrl) {
    if (baseUrl.endsWith(Nls.SLASH)) {
      return baseUrl;
    }
    return baseUrl + Nls.SLASH;
  }
}

@JsonSerializable(nullable: false)
class WebDavFileMetadata {
  WebDavFileMetadata({
    required this.etag,
  });
  factory WebDavFileMetadata.fromJson(Map<String, dynamic> json) =>
      _$WebDavFileMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$WebDavFileMetadataToJson(this);

  final String? etag;
}
