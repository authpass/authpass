// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authpass_cloud_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoredToken _$_StoredTokenFromJson(Map<String, dynamic> json) {
  return _StoredToken(
    authToken: json['authToken'] as String,
    isConfirmed: json['isConfirmed'] as bool,
  );
}

Map<String, dynamic> _$_StoredTokenToJson(_StoredToken instance) =>
    <String, dynamic>{
      'authToken': instance.authToken,
      'isConfirmed': instance.isConfirmed,
    };
