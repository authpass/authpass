import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';

part '_base.g.dart';

enum EnvType { production, development }

abstract class AppInfo implements Built<AppInfo, AppInfoBuilder> {
  factory AppInfo([void Function(AppInfoBuilder b) updates]) = _$AppInfo;
  AppInfo._();

  String get appName;
  String get version;
  int get buildNumber;
  String get packageName;

  String get versionLabel => '$version+$buildNumber';

  String get shortString => '$appName ($versionLabel)';
}

class EnvSecrets {
  const EnvSecrets({
    @required this.analyticsAmplitudeApiKey,
    @required this.analyticsGoogleAnalyticsId,
    @required this.googleClientId,
    @required this.googleClientSecret,
    @required this.dropboxKey,
    @required this.dropboxSecret,
    @required this.microsoftClientId,
    @required this.microsoftClientSecret,
  });

  static const nullSecrets = EnvSecrets(
    analyticsAmplitudeApiKey: null,
    analyticsGoogleAnalyticsId: null,
    googleClientId: null,
    googleClientSecret: null,
    dropboxKey: null,
    dropboxSecret: null,
    microsoftClientId: null,
    microsoftClientSecret: null,
  );

  final String analyticsAmplitudeApiKey;
  final String analyticsGoogleAnalyticsId;
  final String googleClientId;
  final String googleClientSecret;
  final String dropboxKey;
  final String dropboxSecret;
  final String microsoftClientId;
  final String microsoftClientSecret;
}

abstract class FeatureFlags
    implements Built<FeatureFlags, FeatureFlagsBuilder> {
  factory FeatureFlags([void Function(FeatureFlagsBuilder b) updates]) =
      _$FeatureFlags;
  FeatureFlags._();

  bool get authpassCloud;
  String get authpassCloudUri;
}

abstract class Env {
  Env(this.type) {
    value = this;
  }

  /// app name ;) basically it's just here so I don't have to translate it.
  static const AuthPass = 'AuthPass'; // NON-NLS
  static const AuthPassCLoud = 'AuthPass Cloud'; // NON-NLS

  static Env value;

  final EnvType type;
  EnvSecrets get secrets;

  String get diacEndpoint => 'https://cloud.authpass.app/diac';

  bool get diacHidden => false;

  /// whether diac is disabled by default, and only enabled through opt-in.
  bool get diacDefaultDisabled => false;

  String get oauthRedirectUri;
  bool get oauthRedirectUriSupported;

  bool get isDebug => type == EnvType.development;

  String get name => runtimeType.toString();

  /// Allows having a "namespace" for different environments.
  /// e.g. for mac os to have a different configuration for
  /// debug build vs. production/app store build.
  String get storageNamespace => storageNamespaceFromEnvironment;

  /// Support for dropbox, google drive.
  bool get featureCloudStorageProprietary => true;

  /// Automatically fetch website icons.
  /// Right now this is only enabled during screenshots.
  bool get featureFetchWebsiteIconEnabledByDefault => false;

  /// Support for WebDAV
  bool get featureCloudStorageWebDav => true;

  @protected
  String get storageNamespaceFromEnvironment;

  final FeatureFlags featureFlags = FeatureFlags(
    (b) => b
      ..authpassCloud = true
      ..authpassCloudUri = 'https://cloud.authpass.app/',
  );

  Future<AppInfo> getAppInfo();
}
