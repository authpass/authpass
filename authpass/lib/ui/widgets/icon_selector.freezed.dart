// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'icon_selector.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SelectedIcon implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SelectedIcon'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedIcon);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SelectedIcon()';
}


}

/// @nodoc
class $SelectedIconCopyWith<$Res>  {
$SelectedIconCopyWith(SelectedIcon _, $Res Function(SelectedIcon) __);
}


/// Adds pattern-matching-related methods to [SelectedIcon].
extension SelectedIconPatterns on SelectedIcon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _SelectedIconPredefined value)?  predefined,TResult Function( _SelectedIconCustom value)?  custom,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectedIconPredefined() when predefined != null:
return predefined(_that);case _SelectedIconCustom() when custom != null:
return custom(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _SelectedIconPredefined value)  predefined,required TResult Function( _SelectedIconCustom value)  custom,}){
final _that = this;
switch (_that) {
case _SelectedIconPredefined():
return predefined(_that);case _SelectedIconCustom():
return custom(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _SelectedIconPredefined value)?  predefined,TResult? Function( _SelectedIconCustom value)?  custom,}){
final _that = this;
switch (_that) {
case _SelectedIconPredefined() when predefined != null:
return predefined(_that);case _SelectedIconCustom() when custom != null:
return custom(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( KdbxIcon icon)?  predefined,TResult Function( KdbxCustomIcon custom)?  custom,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectedIconPredefined() when predefined != null:
return predefined(_that.icon);case _SelectedIconCustom() when custom != null:
return custom(_that.custom);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( KdbxIcon icon)  predefined,required TResult Function( KdbxCustomIcon custom)  custom,}) {final _that = this;
switch (_that) {
case _SelectedIconPredefined():
return predefined(_that.icon);case _SelectedIconCustom():
return custom(_that.custom);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( KdbxIcon icon)?  predefined,TResult? Function( KdbxCustomIcon custom)?  custom,}) {final _that = this;
switch (_that) {
case _SelectedIconPredefined() when predefined != null:
return predefined(_that.icon);case _SelectedIconCustom() when custom != null:
return custom(_that.custom);case _:
  return null;

}
}

}

/// @nodoc


class _SelectedIconPredefined with DiagnosticableTreeMixin implements SelectedIcon {
  const _SelectedIconPredefined(this.icon);
  

 final  KdbxIcon icon;

/// Create a copy of SelectedIcon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedIconPredefinedCopyWith<_SelectedIconPredefined> get copyWith => __$SelectedIconPredefinedCopyWithImpl<_SelectedIconPredefined>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SelectedIcon.predefined'))
    ..add(DiagnosticsProperty('icon', icon));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectedIconPredefined&&(identical(other.icon, icon) || other.icon == icon));
}


@override
int get hashCode => Object.hash(runtimeType,icon);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SelectedIcon.predefined(icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$SelectedIconPredefinedCopyWith<$Res> implements $SelectedIconCopyWith<$Res> {
  factory _$SelectedIconPredefinedCopyWith(_SelectedIconPredefined value, $Res Function(_SelectedIconPredefined) _then) = __$SelectedIconPredefinedCopyWithImpl;
@useResult
$Res call({
 KdbxIcon icon
});




}
/// @nodoc
class __$SelectedIconPredefinedCopyWithImpl<$Res>
    implements _$SelectedIconPredefinedCopyWith<$Res> {
  __$SelectedIconPredefinedCopyWithImpl(this._self, this._then);

  final _SelectedIconPredefined _self;
  final $Res Function(_SelectedIconPredefined) _then;

/// Create a copy of SelectedIcon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? icon = null,}) {
  return _then(_SelectedIconPredefined(
null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as KdbxIcon,
  ));
}


}

/// @nodoc


class _SelectedIconCustom with DiagnosticableTreeMixin implements SelectedIcon {
  const _SelectedIconCustom(this.custom);
  

 final  KdbxCustomIcon custom;

/// Create a copy of SelectedIcon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedIconCustomCopyWith<_SelectedIconCustom> get copyWith => __$SelectedIconCustomCopyWithImpl<_SelectedIconCustom>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SelectedIcon.custom'))
    ..add(DiagnosticsProperty('custom', custom));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectedIconCustom&&(identical(other.custom, custom) || other.custom == custom));
}


@override
int get hashCode => Object.hash(runtimeType,custom);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SelectedIcon.custom(custom: $custom)';
}


}

/// @nodoc
abstract mixin class _$SelectedIconCustomCopyWith<$Res> implements $SelectedIconCopyWith<$Res> {
  factory _$SelectedIconCustomCopyWith(_SelectedIconCustom value, $Res Function(_SelectedIconCustom) _then) = __$SelectedIconCustomCopyWithImpl;
@useResult
$Res call({
 KdbxCustomIcon custom
});




}
/// @nodoc
class __$SelectedIconCustomCopyWithImpl<$Res>
    implements _$SelectedIconCustomCopyWith<$Res> {
  __$SelectedIconCustomCopyWithImpl(this._self, this._then);

  final _SelectedIconCustom _self;
  final $Res Function(_SelectedIconCustom) _then;

/// Create a copy of SelectedIcon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? custom = null,}) {
  return _then(_SelectedIconCustom(
null == custom ? _self.custom : custom // ignore: cast_nullable_to_non_nullable
as KdbxCustomIcon,
  ));
}


}

// dart format on
