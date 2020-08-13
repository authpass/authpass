// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'icon_selector.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$SelectedIconTearOff {
  const _$SelectedIconTearOff();

// ignore: unused_element
  _SelectedIconPredefined predefined(KdbxIcon icon) {
    return _SelectedIconPredefined(
      icon,
    );
  }

// ignore: unused_element
  _SelectedIconCustom custom(KdbxCustomIcon custom) {
    return _SelectedIconCustom(
      custom,
    );
  }
}

// ignore: unused_element
const $SelectedIcon = _$SelectedIconTearOff();

mixin _$SelectedIcon {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result predefined(KdbxIcon icon),
    @required Result custom(KdbxCustomIcon custom),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result predefined(KdbxIcon icon),
    Result custom(KdbxCustomIcon custom),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result predefined(_SelectedIconPredefined value),
    @required Result custom(_SelectedIconCustom value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result predefined(_SelectedIconPredefined value),
    Result custom(_SelectedIconCustom value),
    @required Result orElse(),
  });
}

abstract class $SelectedIconCopyWith<$Res> {
  factory $SelectedIconCopyWith(
          SelectedIcon value, $Res Function(SelectedIcon) then) =
      _$SelectedIconCopyWithImpl<$Res>;
}

class _$SelectedIconCopyWithImpl<$Res> implements $SelectedIconCopyWith<$Res> {
  _$SelectedIconCopyWithImpl(this._value, this._then);

  final SelectedIcon _value;
  // ignore: unused_field
  final $Res Function(SelectedIcon) _then;
}

abstract class _$SelectedIconPredefinedCopyWith<$Res> {
  factory _$SelectedIconPredefinedCopyWith(_SelectedIconPredefined value,
          $Res Function(_SelectedIconPredefined) then) =
      __$SelectedIconPredefinedCopyWithImpl<$Res>;
  $Res call({KdbxIcon icon});
}

class __$SelectedIconPredefinedCopyWithImpl<$Res>
    extends _$SelectedIconCopyWithImpl<$Res>
    implements _$SelectedIconPredefinedCopyWith<$Res> {
  __$SelectedIconPredefinedCopyWithImpl(_SelectedIconPredefined _value,
      $Res Function(_SelectedIconPredefined) _then)
      : super(_value, (v) => _then(v as _SelectedIconPredefined));

  @override
  _SelectedIconPredefined get _value => super._value as _SelectedIconPredefined;

  @override
  $Res call({
    Object icon = freezed,
  }) {
    return _then(_SelectedIconPredefined(
      icon == freezed ? _value.icon : icon as KdbxIcon,
    ));
  }
}

class _$_SelectedIconPredefined
    with DiagnosticableTreeMixin
    implements _SelectedIconPredefined {
  const _$_SelectedIconPredefined(this.icon) : assert(icon != null);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SelectedIconPredefined &&
            (identical(other.icon, icon) ||
                const DeepCollectionEquality().equals(other.icon, icon)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(icon);

  @override
  _$SelectedIconPredefinedCopyWith<_SelectedIconPredefined> get copyWith =>
      __$SelectedIconPredefinedCopyWithImpl<_SelectedIconPredefined>(
          this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result predefined(KdbxIcon icon),
    @required Result custom(KdbxCustomIcon custom),
  }) {
    assert(predefined != null);
    assert(custom != null);
    return predefined(icon);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result predefined(KdbxIcon icon),
    Result custom(KdbxCustomIcon custom),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (predefined != null) {
      return predefined(icon);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result predefined(_SelectedIconPredefined value),
    @required Result custom(_SelectedIconCustom value),
  }) {
    assert(predefined != null);
    assert(custom != null);
    return predefined(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result predefined(_SelectedIconPredefined value),
    Result custom(_SelectedIconCustom value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (predefined != null) {
      return predefined(this);
    }
    return orElse();
  }
}

abstract class _SelectedIconPredefined implements SelectedIcon {
  const factory _SelectedIconPredefined(KdbxIcon icon) =
      _$_SelectedIconPredefined;

  KdbxIcon get icon;
  _$SelectedIconPredefinedCopyWith<_SelectedIconPredefined> get copyWith;
}

abstract class _$SelectedIconCustomCopyWith<$Res> {
  factory _$SelectedIconCustomCopyWith(
          _SelectedIconCustom value, $Res Function(_SelectedIconCustom) then) =
      __$SelectedIconCustomCopyWithImpl<$Res>;
  $Res call({KdbxCustomIcon custom});
}

class __$SelectedIconCustomCopyWithImpl<$Res>
    extends _$SelectedIconCopyWithImpl<$Res>
    implements _$SelectedIconCustomCopyWith<$Res> {
  __$SelectedIconCustomCopyWithImpl(
      _SelectedIconCustom _value, $Res Function(_SelectedIconCustom) _then)
      : super(_value, (v) => _then(v as _SelectedIconCustom));

  @override
  _SelectedIconCustom get _value => super._value as _SelectedIconCustom;

  @override
  $Res call({
    Object custom = freezed,
  }) {
    return _then(_SelectedIconCustom(
      custom == freezed ? _value.custom : custom as KdbxCustomIcon,
    ));
  }
}

class _$_SelectedIconCustom
    with DiagnosticableTreeMixin
    implements _SelectedIconCustom {
  const _$_SelectedIconCustom(this.custom) : assert(custom != null);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SelectedIconCustom &&
            (identical(other.custom, custom) ||
                const DeepCollectionEquality().equals(other.custom, custom)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(custom);

  @override
  _$SelectedIconCustomCopyWith<_SelectedIconCustom> get copyWith =>
      __$SelectedIconCustomCopyWithImpl<_SelectedIconCustom>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result predefined(KdbxIcon icon),
    @required Result custom(KdbxCustomIcon custom),
  }) {
    assert(predefined != null);
    assert(custom != null);
    return custom(this.custom);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result predefined(KdbxIcon icon),
    Result custom(KdbxCustomIcon custom),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (custom != null) {
      return custom(this.custom);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result predefined(_SelectedIconPredefined value),
    @required Result custom(_SelectedIconCustom value),
  }) {
    assert(predefined != null);
    assert(custom != null);
    return custom(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result predefined(_SelectedIconPredefined value),
    Result custom(_SelectedIconCustom value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (custom != null) {
      return custom(this);
    }
    return orElse();
  }
}

abstract class _SelectedIconCustom implements SelectedIcon {
  const factory _SelectedIconCustom(KdbxCustomIcon custom) =
      _$_SelectedIconCustom;

  KdbxCustomIcon get custom;
  _$SelectedIconCustomCopyWith<_SelectedIconCustom> get copyWith;
}
