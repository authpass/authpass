// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webdav_models.dart';

// **************************************************************************
// AnalyticsEventGenerator
// **************************************************************************

// ignore_for_file: unnecessary_statements

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserNamePasswordCredentials _$UserNamePasswordCredentialsFromJson(
    Map<String, dynamic> json) {
  return UserNamePasswordCredentials(
    baseUrl: json['baseUrl'] as String,
    username: json['username'] as String?,
    password: json['password'] as String?,
  );
}

Map<String, dynamic> _$UserNamePasswordCredentialsToJson(
        UserNamePasswordCredentials instance) =>
    <String, dynamic>{
      'baseUrl': instance.baseUrl,
      'username': instance.username,
      'password': instance.password,
    };

WebDavFileMetadata _$WebDavFileMetadataFromJson(Map<String, dynamic> json) {
  return WebDavFileMetadata(
    etag: json['etag'] as String?,
  );
}

Map<String, dynamic> _$WebDavFileMetadataToJson(WebDavFileMetadata instance) =>
    <String, dynamic>{
      'etag': instance.etag,
    };

// **************************************************************************
// StaticTextGenerator
// **************************************************************************

// ignore_for_file: implicit_dynamic_parameter,strong_mode_implicit_dynamic_parameter,strong_mode_implicit_dynamic_variable,non_constant_identifier_names,unused_element
