// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_base.dart';

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

  factory _$AppInfo([void Function(AppInfoBuilder)? updates]) =>
      (new AppInfoBuilder()..update(updates)).build();

  _$AppInfo._(
      {required this.appName,
      required this.version,
      required this.buildNumber,
      required this.packageName})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(appName, 'AppInfo', 'appName');
    BuiltValueNullFieldError.checkNotNull(version, 'AppInfo', 'version');
    BuiltValueNullFieldError.checkNotNull(
        buildNumber, 'AppInfo', 'buildNumber');
    BuiltValueNullFieldError.checkNotNull(
        packageName, 'AppInfo', 'packageName');
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
  _$AppInfo? _$v;

  String? _appName;
  String? get appName => _$this._appName;
  set appName(String? appName) => _$this._appName = appName;

  String? _version;
  String? get version => _$this._version;
  set version(String? version) => _$this._version = version;

  int? _buildNumber;
  int? get buildNumber => _$this._buildNumber;
  set buildNumber(int? buildNumber) => _$this._buildNumber = buildNumber;

  String? _packageName;
  String? get packageName => _$this._packageName;
  set packageName(String? packageName) => _$this._packageName = packageName;

  AppInfoBuilder();

  AppInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _appName = $v.appName;
      _version = $v.version;
      _buildNumber = $v.buildNumber;
      _packageName = $v.packageName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppInfo other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AppInfo;
  }

  @override
  void update(void Function(AppInfoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AppInfo build() {
    final _$result = _$v ??
        new _$AppInfo._(
            appName: BuiltValueNullFieldError.checkNotNull(
                appName, 'AppInfo', 'appName'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, 'AppInfo', 'version'),
            buildNumber: BuiltValueNullFieldError.checkNotNull(
                buildNumber, 'AppInfo', 'buildNumber'),
            packageName: BuiltValueNullFieldError.checkNotNull(
                packageName, 'AppInfo', 'packageName'));
    replace(_$result);
    return _$result;
  }
}

class _$FeatureFlags extends FeatureFlags {
  @override
  final bool? authpassCloud;
  @override
  final String? authpassCloudUri;

  factory _$FeatureFlags([void Function(FeatureFlagsBuilder)? updates]) =>
      (new FeatureFlagsBuilder()..update(updates)).build();

  _$FeatureFlags._({this.authpassCloud, this.authpassCloudUri}) : super._();

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
  _$FeatureFlags? _$v;

  bool? _authpassCloud;
  bool? get authpassCloud => _$this._authpassCloud;
  set authpassCloud(bool? authpassCloud) =>
      _$this._authpassCloud = authpassCloud;

  String? _authpassCloudUri;
  String? get authpassCloudUri => _$this._authpassCloudUri;
  set authpassCloudUri(String? authpassCloudUri) =>
      _$this._authpassCloudUri = authpassCloudUri;

  FeatureFlagsBuilder();

  FeatureFlagsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _authpassCloud = $v.authpassCloud;
      _authpassCloudUri = $v.authpassCloudUri;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FeatureFlags other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FeatureFlags;
  }

  @override
  void update(void Function(FeatureFlagsBuilder)? updates) {
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

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
