// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '_base.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EnvSecrets {

 String? get analyticsAmplitudeApiKey; String? get analyticsGoogleAnalyticsId; ({String siteId, String url})? get analyticsMatomo; String? Function()? get googleClientId; String? get googleClientSecret; String? get dropboxKey; String? get dropboxSecret; String? get microsoftClientId; String? get microsoftClientSecret;
/// Create a copy of EnvSecrets
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnvSecretsCopyWith<EnvSecrets> get copyWith => _$EnvSecretsCopyWithImpl<EnvSecrets>(this as EnvSecrets, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnvSecrets&&(identical(other.analyticsAmplitudeApiKey, analyticsAmplitudeApiKey) || other.analyticsAmplitudeApiKey == analyticsAmplitudeApiKey)&&(identical(other.analyticsGoogleAnalyticsId, analyticsGoogleAnalyticsId) || other.analyticsGoogleAnalyticsId == analyticsGoogleAnalyticsId)&&(identical(other.analyticsMatomo, analyticsMatomo) || other.analyticsMatomo == analyticsMatomo)&&(identical(other.googleClientId, googleClientId) || other.googleClientId == googleClientId)&&(identical(other.googleClientSecret, googleClientSecret) || other.googleClientSecret == googleClientSecret)&&(identical(other.dropboxKey, dropboxKey) || other.dropboxKey == dropboxKey)&&(identical(other.dropboxSecret, dropboxSecret) || other.dropboxSecret == dropboxSecret)&&(identical(other.microsoftClientId, microsoftClientId) || other.microsoftClientId == microsoftClientId)&&(identical(other.microsoftClientSecret, microsoftClientSecret) || other.microsoftClientSecret == microsoftClientSecret));
}


@override
int get hashCode => Object.hash(runtimeType,analyticsAmplitudeApiKey,analyticsGoogleAnalyticsId,analyticsMatomo,googleClientId,googleClientSecret,dropboxKey,dropboxSecret,microsoftClientId,microsoftClientSecret);

@override
String toString() {
  return 'EnvSecrets(analyticsAmplitudeApiKey: $analyticsAmplitudeApiKey, analyticsGoogleAnalyticsId: $analyticsGoogleAnalyticsId, analyticsMatomo: $analyticsMatomo, googleClientId: $googleClientId, googleClientSecret: $googleClientSecret, dropboxKey: $dropboxKey, dropboxSecret: $dropboxSecret, microsoftClientId: $microsoftClientId, microsoftClientSecret: $microsoftClientSecret)';
}


}

/// @nodoc
abstract mixin class $EnvSecretsCopyWith<$Res>  {
  factory $EnvSecretsCopyWith(EnvSecrets value, $Res Function(EnvSecrets) _then) = _$EnvSecretsCopyWithImpl;
@useResult
$Res call({
 String? analyticsAmplitudeApiKey, String? analyticsGoogleAnalyticsId, ({String siteId, String url})? analyticsMatomo, String? Function()? googleClientId, String? googleClientSecret, String? dropboxKey, String? dropboxSecret, String? microsoftClientId, String? microsoftClientSecret
});




}
/// @nodoc
class _$EnvSecretsCopyWithImpl<$Res>
    implements $EnvSecretsCopyWith<$Res> {
  _$EnvSecretsCopyWithImpl(this._self, this._then);

  final EnvSecrets _self;
  final $Res Function(EnvSecrets) _then;

/// Create a copy of EnvSecrets
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? analyticsAmplitudeApiKey = freezed,Object? analyticsGoogleAnalyticsId = freezed,Object? analyticsMatomo = freezed,Object? googleClientId = freezed,Object? googleClientSecret = freezed,Object? dropboxKey = freezed,Object? dropboxSecret = freezed,Object? microsoftClientId = freezed,Object? microsoftClientSecret = freezed,}) {
  return _then(_self.copyWith(
analyticsAmplitudeApiKey: freezed == analyticsAmplitudeApiKey ? _self.analyticsAmplitudeApiKey : analyticsAmplitudeApiKey // ignore: cast_nullable_to_non_nullable
as String?,analyticsGoogleAnalyticsId: freezed == analyticsGoogleAnalyticsId ? _self.analyticsGoogleAnalyticsId : analyticsGoogleAnalyticsId // ignore: cast_nullable_to_non_nullable
as String?,analyticsMatomo: freezed == analyticsMatomo ? _self.analyticsMatomo : analyticsMatomo // ignore: cast_nullable_to_non_nullable
as ({String siteId, String url})?,googleClientId: freezed == googleClientId ? _self.googleClientId : googleClientId // ignore: cast_nullable_to_non_nullable
as String? Function()?,googleClientSecret: freezed == googleClientSecret ? _self.googleClientSecret : googleClientSecret // ignore: cast_nullable_to_non_nullable
as String?,dropboxKey: freezed == dropboxKey ? _self.dropboxKey : dropboxKey // ignore: cast_nullable_to_non_nullable
as String?,dropboxSecret: freezed == dropboxSecret ? _self.dropboxSecret : dropboxSecret // ignore: cast_nullable_to_non_nullable
as String?,microsoftClientId: freezed == microsoftClientId ? _self.microsoftClientId : microsoftClientId // ignore: cast_nullable_to_non_nullable
as String?,microsoftClientSecret: freezed == microsoftClientSecret ? _self.microsoftClientSecret : microsoftClientSecret // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EnvSecrets].
extension EnvSecretsPatterns on EnvSecrets {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnvSecrets value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnvSecrets() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnvSecrets value)  $default,){
final _that = this;
switch (_that) {
case _EnvSecrets():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnvSecrets value)?  $default,){
final _that = this;
switch (_that) {
case _EnvSecrets() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? analyticsAmplitudeApiKey,  String? analyticsGoogleAnalyticsId,  ({String siteId, String url})? analyticsMatomo,  String? Function()? googleClientId,  String? googleClientSecret,  String? dropboxKey,  String? dropboxSecret,  String? microsoftClientId,  String? microsoftClientSecret)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnvSecrets() when $default != null:
return $default(_that.analyticsAmplitudeApiKey,_that.analyticsGoogleAnalyticsId,_that.analyticsMatomo,_that.googleClientId,_that.googleClientSecret,_that.dropboxKey,_that.dropboxSecret,_that.microsoftClientId,_that.microsoftClientSecret);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? analyticsAmplitudeApiKey,  String? analyticsGoogleAnalyticsId,  ({String siteId, String url})? analyticsMatomo,  String? Function()? googleClientId,  String? googleClientSecret,  String? dropboxKey,  String? dropboxSecret,  String? microsoftClientId,  String? microsoftClientSecret)  $default,) {final _that = this;
switch (_that) {
case _EnvSecrets():
return $default(_that.analyticsAmplitudeApiKey,_that.analyticsGoogleAnalyticsId,_that.analyticsMatomo,_that.googleClientId,_that.googleClientSecret,_that.dropboxKey,_that.dropboxSecret,_that.microsoftClientId,_that.microsoftClientSecret);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? analyticsAmplitudeApiKey,  String? analyticsGoogleAnalyticsId,  ({String siteId, String url})? analyticsMatomo,  String? Function()? googleClientId,  String? googleClientSecret,  String? dropboxKey,  String? dropboxSecret,  String? microsoftClientId,  String? microsoftClientSecret)?  $default,) {final _that = this;
switch (_that) {
case _EnvSecrets() when $default != null:
return $default(_that.analyticsAmplitudeApiKey,_that.analyticsGoogleAnalyticsId,_that.analyticsMatomo,_that.googleClientId,_that.googleClientSecret,_that.dropboxKey,_that.dropboxSecret,_that.microsoftClientId,_that.microsoftClientSecret);case _:
  return null;

}
}

}

/// @nodoc


class _EnvSecrets implements EnvSecrets {
  const _EnvSecrets({required this.analyticsAmplitudeApiKey, required this.analyticsGoogleAnalyticsId, required this.analyticsMatomo, required this.googleClientId, required this.googleClientSecret, required this.dropboxKey, required this.dropboxSecret, required this.microsoftClientId, required this.microsoftClientSecret});
  

@override final  String? analyticsAmplitudeApiKey;
@override final  String? analyticsGoogleAnalyticsId;
@override final  ({String siteId, String url})? analyticsMatomo;
@override final  String? Function()? googleClientId;
@override final  String? googleClientSecret;
@override final  String? dropboxKey;
@override final  String? dropboxSecret;
@override final  String? microsoftClientId;
@override final  String? microsoftClientSecret;

/// Create a copy of EnvSecrets
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnvSecretsCopyWith<_EnvSecrets> get copyWith => __$EnvSecretsCopyWithImpl<_EnvSecrets>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnvSecrets&&(identical(other.analyticsAmplitudeApiKey, analyticsAmplitudeApiKey) || other.analyticsAmplitudeApiKey == analyticsAmplitudeApiKey)&&(identical(other.analyticsGoogleAnalyticsId, analyticsGoogleAnalyticsId) || other.analyticsGoogleAnalyticsId == analyticsGoogleAnalyticsId)&&(identical(other.analyticsMatomo, analyticsMatomo) || other.analyticsMatomo == analyticsMatomo)&&(identical(other.googleClientId, googleClientId) || other.googleClientId == googleClientId)&&(identical(other.googleClientSecret, googleClientSecret) || other.googleClientSecret == googleClientSecret)&&(identical(other.dropboxKey, dropboxKey) || other.dropboxKey == dropboxKey)&&(identical(other.dropboxSecret, dropboxSecret) || other.dropboxSecret == dropboxSecret)&&(identical(other.microsoftClientId, microsoftClientId) || other.microsoftClientId == microsoftClientId)&&(identical(other.microsoftClientSecret, microsoftClientSecret) || other.microsoftClientSecret == microsoftClientSecret));
}


@override
int get hashCode => Object.hash(runtimeType,analyticsAmplitudeApiKey,analyticsGoogleAnalyticsId,analyticsMatomo,googleClientId,googleClientSecret,dropboxKey,dropboxSecret,microsoftClientId,microsoftClientSecret);

@override
String toString() {
  return 'EnvSecrets(analyticsAmplitudeApiKey: $analyticsAmplitudeApiKey, analyticsGoogleAnalyticsId: $analyticsGoogleAnalyticsId, analyticsMatomo: $analyticsMatomo, googleClientId: $googleClientId, googleClientSecret: $googleClientSecret, dropboxKey: $dropboxKey, dropboxSecret: $dropboxSecret, microsoftClientId: $microsoftClientId, microsoftClientSecret: $microsoftClientSecret)';
}


}

/// @nodoc
abstract mixin class _$EnvSecretsCopyWith<$Res> implements $EnvSecretsCopyWith<$Res> {
  factory _$EnvSecretsCopyWith(_EnvSecrets value, $Res Function(_EnvSecrets) _then) = __$EnvSecretsCopyWithImpl;
@override @useResult
$Res call({
 String? analyticsAmplitudeApiKey, String? analyticsGoogleAnalyticsId, ({String siteId, String url})? analyticsMatomo, String? Function()? googleClientId, String? googleClientSecret, String? dropboxKey, String? dropboxSecret, String? microsoftClientId, String? microsoftClientSecret
});




}
/// @nodoc
class __$EnvSecretsCopyWithImpl<$Res>
    implements _$EnvSecretsCopyWith<$Res> {
  __$EnvSecretsCopyWithImpl(this._self, this._then);

  final _EnvSecrets _self;
  final $Res Function(_EnvSecrets) _then;

/// Create a copy of EnvSecrets
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? analyticsAmplitudeApiKey = freezed,Object? analyticsGoogleAnalyticsId = freezed,Object? analyticsMatomo = freezed,Object? googleClientId = freezed,Object? googleClientSecret = freezed,Object? dropboxKey = freezed,Object? dropboxSecret = freezed,Object? microsoftClientId = freezed,Object? microsoftClientSecret = freezed,}) {
  return _then(_EnvSecrets(
analyticsAmplitudeApiKey: freezed == analyticsAmplitudeApiKey ? _self.analyticsAmplitudeApiKey : analyticsAmplitudeApiKey // ignore: cast_nullable_to_non_nullable
as String?,analyticsGoogleAnalyticsId: freezed == analyticsGoogleAnalyticsId ? _self.analyticsGoogleAnalyticsId : analyticsGoogleAnalyticsId // ignore: cast_nullable_to_non_nullable
as String?,analyticsMatomo: freezed == analyticsMatomo ? _self.analyticsMatomo : analyticsMatomo // ignore: cast_nullable_to_non_nullable
as ({String siteId, String url})?,googleClientId: freezed == googleClientId ? _self.googleClientId : googleClientId // ignore: cast_nullable_to_non_nullable
as String? Function()?,googleClientSecret: freezed == googleClientSecret ? _self.googleClientSecret : googleClientSecret // ignore: cast_nullable_to_non_nullable
as String?,dropboxKey: freezed == dropboxKey ? _self.dropboxKey : dropboxKey // ignore: cast_nullable_to_non_nullable
as String?,dropboxSecret: freezed == dropboxSecret ? _self.dropboxSecret : dropboxSecret // ignore: cast_nullable_to_non_nullable
as String?,microsoftClientId: freezed == microsoftClientId ? _self.microsoftClientId : microsoftClientId // ignore: cast_nullable_to_non_nullable
as String?,microsoftClientSecret: freezed == microsoftClientSecret ? _self.microsoftClientSecret : microsoftClientSecret // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
