// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'icon_selector.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SelectedIcon {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(KdbxIcon icon) predefined,
    required TResult Function(KdbxCustomIcon custom) custom,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(KdbxIcon icon)? predefined,
    TResult? Function(KdbxCustomIcon custom)? custom,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(KdbxIcon icon)? predefined,
    TResult Function(KdbxCustomIcon custom)? custom,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SelectedIconPredefined value) predefined,
    required TResult Function(_SelectedIconCustom value) custom,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SelectedIconPredefined value)? predefined,
    TResult? Function(_SelectedIconCustom value)? custom,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SelectedIconPredefined value)? predefined,
    TResult Function(_SelectedIconCustom value)? custom,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectedIconCopyWith<$Res> {
  factory $SelectedIconCopyWith(
          SelectedIcon value, $Res Function(SelectedIcon) then) =
      _$SelectedIconCopyWithImpl<$Res, SelectedIcon>;
}

/// @nodoc
class _$SelectedIconCopyWithImpl<$Res, $Val extends SelectedIcon>
    implements $SelectedIconCopyWith<$Res> {
  _$SelectedIconCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SelectedIconPredefinedImplCopyWith<$Res> {
  factory _$$SelectedIconPredefinedImplCopyWith(
          _$SelectedIconPredefinedImpl value,
          $Res Function(_$SelectedIconPredefinedImpl) then) =
      __$$SelectedIconPredefinedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({KdbxIcon icon});
}

/// @nodoc
class __$$SelectedIconPredefinedImplCopyWithImpl<$Res>
    extends _$SelectedIconCopyWithImpl<$Res, _$SelectedIconPredefinedImpl>
    implements _$$SelectedIconPredefinedImplCopyWith<$Res> {
  __$$SelectedIconPredefinedImplCopyWithImpl(
      _$SelectedIconPredefinedImpl _value,
      $Res Function(_$SelectedIconPredefinedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = null,
  }) {
    return _then(_$SelectedIconPredefinedImpl(
      null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as KdbxIcon,
    ));
  }
}

/// @nodoc

class _$SelectedIconPredefinedImpl
    with DiagnosticableTreeMixin
    implements _SelectedIconPredefined {
  const _$SelectedIconPredefinedImpl(this.icon);

  @override
  final KdbxIcon icon;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SelectedIcon.predefined(icon: $icon)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SelectedIcon.predefined'))
      ..add(DiagnosticsProperty('icon', icon));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectedIconPredefinedImpl &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @override
  int get hashCode => Object.hash(runtimeType, icon);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectedIconPredefinedImplCopyWith<_$SelectedIconPredefinedImpl>
      get copyWith => __$$SelectedIconPredefinedImplCopyWithImpl<
          _$SelectedIconPredefinedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(KdbxIcon icon) predefined,
    required TResult Function(KdbxCustomIcon custom) custom,
  }) {
    return predefined(icon);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(KdbxIcon icon)? predefined,
    TResult? Function(KdbxCustomIcon custom)? custom,
  }) {
    return predefined?.call(icon);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(KdbxIcon icon)? predefined,
    TResult Function(KdbxCustomIcon custom)? custom,
    required TResult orElse(),
  }) {
    if (predefined != null) {
      return predefined(icon);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SelectedIconPredefined value) predefined,
    required TResult Function(_SelectedIconCustom value) custom,
  }) {
    return predefined(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SelectedIconPredefined value)? predefined,
    TResult? Function(_SelectedIconCustom value)? custom,
  }) {
    return predefined?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SelectedIconPredefined value)? predefined,
    TResult Function(_SelectedIconCustom value)? custom,
    required TResult orElse(),
  }) {
    if (predefined != null) {
      return predefined(this);
    }
    return orElse();
  }
}

abstract class _SelectedIconPredefined implements SelectedIcon {
  const factory _SelectedIconPredefined(final KdbxIcon icon) =
      _$SelectedIconPredefinedImpl;

  KdbxIcon get icon;
  @JsonKey(ignore: true)
  _$$SelectedIconPredefinedImplCopyWith<_$SelectedIconPredefinedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SelectedIconCustomImplCopyWith<$Res> {
  factory _$$SelectedIconCustomImplCopyWith(_$SelectedIconCustomImpl value,
          $Res Function(_$SelectedIconCustomImpl) then) =
      __$$SelectedIconCustomImplCopyWithImpl<$Res>;
  @useResult
  $Res call({KdbxCustomIcon custom});
}

/// @nodoc
class __$$SelectedIconCustomImplCopyWithImpl<$Res>
    extends _$SelectedIconCopyWithImpl<$Res, _$SelectedIconCustomImpl>
    implements _$$SelectedIconCustomImplCopyWith<$Res> {
  __$$SelectedIconCustomImplCopyWithImpl(_$SelectedIconCustomImpl _value,
      $Res Function(_$SelectedIconCustomImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? custom = null,
  }) {
    return _then(_$SelectedIconCustomImpl(
      null == custom
          ? _value.custom
          : custom // ignore: cast_nullable_to_non_nullable
              as KdbxCustomIcon,
    ));
  }
}

/// @nodoc

class _$SelectedIconCustomImpl
    with DiagnosticableTreeMixin
    implements _SelectedIconCustom {
  const _$SelectedIconCustomImpl(this.custom);

  @override
  final KdbxCustomIcon custom;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SelectedIcon.custom(custom: $custom)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SelectedIcon.custom'))
      ..add(DiagnosticsProperty('custom', custom));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectedIconCustomImpl &&
            (identical(other.custom, custom) || other.custom == custom));
  }

  @override
  int get hashCode => Object.hash(runtimeType, custom);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectedIconCustomImplCopyWith<_$SelectedIconCustomImpl> get copyWith =>
      __$$SelectedIconCustomImplCopyWithImpl<_$SelectedIconCustomImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(KdbxIcon icon) predefined,
    required TResult Function(KdbxCustomIcon custom) custom,
  }) {
    return custom(this.custom);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(KdbxIcon icon)? predefined,
    TResult? Function(KdbxCustomIcon custom)? custom,
  }) {
    return custom?.call(this.custom);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(KdbxIcon icon)? predefined,
    TResult Function(KdbxCustomIcon custom)? custom,
    required TResult orElse(),
  }) {
    if (custom != null) {
      return custom(this.custom);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SelectedIconPredefined value) predefined,
    required TResult Function(_SelectedIconCustom value) custom,
  }) {
    return custom(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SelectedIconPredefined value)? predefined,
    TResult? Function(_SelectedIconCustom value)? custom,
  }) {
    return custom?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SelectedIconPredefined value)? predefined,
    TResult Function(_SelectedIconCustom value)? custom,
    required TResult orElse(),
  }) {
    if (custom != null) {
      return custom(this);
    }
    return orElse();
  }
}

abstract class _SelectedIconCustom implements SelectedIcon {
  const factory _SelectedIconCustom(final KdbxCustomIcon custom) =
      _$SelectedIconCustomImpl;

  KdbxCustomIcon get custom;
  @JsonKey(ignore: true)
  _$$SelectedIconCustomImplCopyWith<_$SelectedIconCustomImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
