// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_base.dart';

// **************************************************************************
// AnalyticsEventGenerator
// **************************************************************************

// ignore_for_file: unnecessary_statements

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppInfo extends AppInfo {
  @override
  final String appName;
  @override
  final String version;
  @override
  final String buildNumber;
  @override
  final String packageName;

  factory _$AppInfo([void Function(AppInfoBuilder) updates]) =>
      (new AppInfoBuilder()..update(updates)).build();

  _$AppInfo._({this.appName, this.version, this.buildNumber, this.packageName})
      : super._() {
    if (appName == null) {
      throw new BuiltValueNullFieldError('AppInfo', 'appName');
    }
    if (version == null) {
      throw new BuiltValueNullFieldError('AppInfo', 'version');
    }
    if (buildNumber == null) {
      throw new BuiltValueNullFieldError('AppInfo', 'buildNumber');
    }
    if (packageName == null) {
      throw new BuiltValueNullFieldError('AppInfo', 'packageName');
    }
  }

  @override
  AppInfo rebuild(void Function(AppInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppInfoBuilder toBuilder() => new AppInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppInfo &&
        appName == other.appName &&
        version == other.version &&
        buildNumber == other.buildNumber &&
        packageName == other.packageName;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, appName.hashCode), version.hashCode),
            buildNumber.hashCode),
        packageName.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AppInfo')
          ..add('appName', appName)
          ..add('version', version)
          ..add('buildNumber', buildNumber)
          ..add('packageName', packageName))
        .toString();
  }
}

class AppInfoBuilder implements Builder<AppInfo, AppInfoBuilder> {
  _$AppInfo _$v;

  String _appName;
  String get appName => _$this._appName;
  set appName(String appName) => _$this._appName = appName;

  String _version;
  String get version => _$this._version;
  set version(String version) => _$this._version = version;

  String _buildNumber;
  String get buildNumber => _$this._buildNumber;
  set buildNumber(String buildNumber) => _$this._buildNumber = buildNumber;

  String _packageName;
  String get packageName => _$this._packageName;
  set packageName(String packageName) => _$this._packageName = packageName;

  AppInfoBuilder();

  AppInfoBuilder get _$this {
    if (_$v != null) {
      _appName = _$v.appName;
      _version = _$v.version;
      _buildNumber = _$v.buildNumber;
      _packageName = _$v.packageName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppInfo other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AppInfo;
  }

  @override
  void update(void Function(AppInfoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AppInfo build() {
    final _$result = _$v ??
        new _$AppInfo._(
            appName: appName,
            version: version,
            buildNumber: buildNumber,
            packageName: packageName);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
