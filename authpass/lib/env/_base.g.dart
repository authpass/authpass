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
  final int buildNumber;
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

  int _buildNumber;
  int get buildNumber => _$this._buildNumber;
  set buildNumber(int buildNumber) => _$this._buildNumber = buildNumber;

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

class _$FeatureFlags extends FeatureFlags {
  @override
  final bool authpassCloud;
  @override
  final String authpassCloudUri;

  factory _$FeatureFlags([void Function(FeatureFlagsBuilder) updates]) =>
      (new FeatureFlagsBuilder()..update(updates)).build();

  _$FeatureFlags._({this.authpassCloud, this.authpassCloudUri}) : super._() {
    if (authpassCloud == null) {
      throw new BuiltValueNullFieldError('FeatureFlags', 'authpassCloud');
    }
    if (authpassCloudUri == null) {
      throw new BuiltValueNullFieldError('FeatureFlags', 'authpassCloudUri');
    }
  }

  @override
  FeatureFlags rebuild(void Function(FeatureFlagsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FeatureFlagsBuilder toBuilder() => new FeatureFlagsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FeatureFlags &&
        authpassCloud == other.authpassCloud &&
        authpassCloudUri == other.authpassCloudUri;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, authpassCloud.hashCode), authpassCloudUri.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FeatureFlags')
          ..add('authpassCloud', authpassCloud)
          ..add('authpassCloudUri', authpassCloudUri))
        .toString();
  }
}

class FeatureFlagsBuilder
    implements Builder<FeatureFlags, FeatureFlagsBuilder> {
  _$FeatureFlags _$v;

  bool _authpassCloud;
  bool get authpassCloud => _$this._authpassCloud;
  set authpassCloud(bool authpassCloud) =>
      _$this._authpassCloud = authpassCloud;

  String _authpassCloudUri;
  String get authpassCloudUri => _$this._authpassCloudUri;
  set authpassCloudUri(String authpassCloudUri) =>
      _$this._authpassCloudUri = authpassCloudUri;

  FeatureFlagsBuilder();

  FeatureFlagsBuilder get _$this {
    if (_$v != null) {
      _authpassCloud = _$v.authpassCloud;
      _authpassCloudUri = _$v.authpassCloudUri;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FeatureFlags other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FeatureFlags;
  }

  @override
  void update(void Function(FeatureFlagsBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FeatureFlags build() {
    final _$result = _$v ??
        new _$FeatureFlags._(
            authpassCloud: authpassCloud, authpassCloudUri: authpassCloudUri);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

// **************************************************************************
// StaticTextGenerator
// **************************************************************************

// ignore_for_file: implicit_dynamic_parameter,strong_mode_implicit_dynamic_parameter,strong_mode_implicit_dynamic_variable,non_constant_identifier_names,unused_element
