// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webdav_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserNamePasswordCredentials _$UserNamePasswordCredentialsFromJson(
        Map<String, dynamic> json) =>
    UserNamePasswordCredentials(
      baseUrl: json['baseUrl'] as String,
      username: json['username'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$UserNamePasswordCredentialsToJson(
        UserNamePasswordCredentials instance) =>
    <String, dynamic>{
      'baseUrl': instance.baseUrl,
      'username': instance.username,
      'password': instance.password,
    };

WebDavFileMetadata _$WebDavFileMetadataFromJson(Map<String, dynamic> json) =>
    WebDavFileMetadata(
      etag: json['etag'] as String?,
    );

Map<String, dynamic> _$WebDavFileMetadataToJson(WebDavFileMetadata instance) =>
    <String, dynamic>{
      'etag': instance.etag,
    };
