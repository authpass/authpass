// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authpass_cloud_bloc.dart';

// **************************************************************************
// AnalyticsEventGenerator
// **************************************************************************

// ignore_for_file: unnecessary_statements

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoredToken _$_StoredTokenFromJson(Map<String, dynamic> json) {
  return _StoredToken(
    authToken: json['authToken'] as String,
    isConfirmed: json['isAuthenticated'] as bool,
  );
}

Map<String, dynamic> _$_StoredTokenToJson(_StoredToken instance) =>
    <String, dynamic>{
      'authToken': instance.authToken,
      'isAuthenticated': instance.isConfirmed,
    };

// **************************************************************************
// StaticTextGenerator
// **************************************************************************

// ignore_for_file: implicit_dynamic_parameter,strong_mode_implicit_dynamic_parameter,strong_mode_implicit_dynamic_variable,non_constant_identifier_names,unused_element
