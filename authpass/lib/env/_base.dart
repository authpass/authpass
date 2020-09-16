import 'package:built_value/built_value.dart' hide nullable;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part '_base.g.dart';
part '_base.freezed.dart';

enum EnvType { production, development }

abstract class AppInfo implements Built<AppInfo, AppInfoBuilder> {
  factory AppInfo([void Function(AppInfoBuilder b) updates]) = _$AppInfo;
  AppInfo._();

  String get appName;
  String get version;
  int get buildNumber;
  String get packageName;

  String get versionLabel => '$version+$buildNumber'; // NON-NLS

  String get shortString => '$appName ($versionLabel)'; // NON-NLS
}

@freezed
abstract class EnvSecrets with _$EnvSecrets {
  const factory EnvSecrets({
    @required @nullable String analyticsAmplitudeApiKey,
    @required @nullable String analyticsGoogleAnalyticsId,
    @required @nullable String googleClientId,
    @required @nullable String googleClientSecret,
    @required @nullable String dropboxKey,
    @required @nullable String dropboxSecret,
    @required @nullable String microsoftClientId,
    @required @nullable String microsoftClientSecret,
  }) = _EnvSecrets;

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
  static const AuthPassCloud = 'AuthPass Cloud'; // NON-NLS
  static const KeePassExtension = 'kdbx'; // NON-NLS

  static Env value;

  final EnvType type;
  EnvSecrets get secrets;

  String get diacEndpoint => 'https://cloud.authpass.app/diac'; // NON-NLS

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

  /// allow disabling of "onboarding".
  bool get featureOnboarding => true;

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
      ..authpassCloudUri = 'https://cloud.authpass.app/', // NON-NLS
  );

  Future<AppInfo> getAppInfo();
}
