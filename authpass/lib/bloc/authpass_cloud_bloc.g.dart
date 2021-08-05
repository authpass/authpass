// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authpass_cloud_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoredToken _$StoredTokenFromJson(Map<String, dynamic> json) => _StoredToken(
      authToken: json['authToken'] as String,
      isConfirmed: json['isConfirmed'] as bool,
    );

Map<String, dynamic> _$StoredTokenToJson(_StoredToken instance) =>
    <String, dynamic>{
      'authToken': instance.authToken,
      'isConfirmed': instance.isConfirmed,
    };
