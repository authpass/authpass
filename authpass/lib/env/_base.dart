import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/platform.dart';
import 'package:built_value/built_value.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

part '_base.g.dart';
part '_base.freezed.dart';

enum EnvType { production, development }

abstract class AppInfo implements Built<AppInfo, AppInfoBuilder> {
  factory AppInfo([void Function(AppInfoBuilder b)? updates]) = _$AppInfo;
  AppInfo._();

  String get appName;
  String get version;
  int get buildNumber;
  String get packageName;

  String get versionLabel => '$version+$buildNumber'; // NON-NLS

  String get shortString => '$appName ($versionLabel)'; // NON-NLS

  String get longString => '$shortString [$packageName]'; // NON-NLS
}

@freezed
abstract class EnvSecrets with _$EnvSecrets {
  const factory EnvSecrets({
    required String? analyticsAmplitudeApiKey,
    required String? analyticsGoogleAnalyticsId,
    required ({String siteId, String url})? analyticsMatomo,
    required String? Function()? googleClientId,
    required String? googleClientSecret,
    required String? dropboxKey,
    required String? dropboxSecret,
    required String? microsoftClientId,
    required String? microsoftClientSecret,
  }) = _EnvSecrets;

  static const nullSecrets = EnvSecrets(
    analyticsAmplitudeApiKey: null,
    analyticsGoogleAnalyticsId: null,
    analyticsMatomo: null,
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
  factory FeatureFlags([void Function(FeatureFlagsBuilder b)? updates]) =
      _$FeatureFlags;
  FeatureFlags._();

  bool? get authpassCloud;
  String? get authpassCloudUri;
}

abstract class Env {
  Env(this.type) {
    value = this;
  }

  /// app name ;) basically it's just here so I don't have to translate it.
  static const AuthPass = 'AuthPass'; // NON-NLS
  static const AuthPassCloud = 'AuthPass Cloud'; // NON-NLS
  static const KeePassExtension = 'kdbx'; // NON-NLS

  static const _authPassCloudUrl = 'https://cloud.authpass.app'; // NON-NLS

  static Env? value;

  final EnvType type;
  EnvSecrets? get secrets;

  final overrideFlutterOnError = true;

  String get diacEndpoint => '$_authPassCloudUrl/diac'; // NON-NLS

  bool get diacHidden => false;

  /// whether diac is disabled by default, and only enabled through opt-in.
  bool get diacDefaultDisabled => false;

  String? get oauthRedirectUri;
  bool get oauthRedirectUriSupported;

  bool get isDebug => type == EnvType.development;

  String get name => runtimeType.toString();

  String get forumUrl => UrlConstants.forumUrl;

  String forumUrlNewTopic({
    String title = CharConstants.empty,
    String body = CharConstants.empty,
    int category = 5,
    List<String> tags = const <String>[],
  }) => nonNls(
    Uri.parse('${forumUrl}new-topic')
        .replace(
          queryParameters: <String, String>{
            'title': title,
            'body': body,
            'category_id': category.toString(),
            'tags': tags.join(','),
          }..removeWhere((key, value) => value.isEmpty),
        )
        .toString(),
  );

  /// Allows having a "namespace" for different environments.
  /// e.g. for mac os to have a different configuration for
  /// debug build vs. production/app store build.
  String? get storageNamespace => storageNamespaceFromEnvironment;

  /// App group shared between the app and the credential provider extension,
  /// and the keychain access group the cached vault keys live in — an app
  /// group identifier doubles as a `kSecAttrAccessGroup`.
  ///
  /// Must match `com.apple.security.application-groups` in the entitlements of
  /// both targets. Not namespaced per environment: debug and release builds
  /// have distinct bundle ids but share this container, which is fine because
  /// only one of them is ever installed with autofill enabled.
  ///
  /// The `group.` prefix is required on iOS, where Apple adds the team id
  /// behind the scenes. **macOS differs**: a sandboxed app needs the group
  /// either prefixed with the team id, authorized by an embedded provisioning
  /// profile, or distributed through the Mac App Store. AuthPass ships both MAS
  /// and Developer ID builds, so the macOS extension (phase 5) may need
  /// `$(AppIdentifierPrefix)group.design.codeux.authpass` here — which is the
  /// style macos/Runner already uses for `keychain-access-groups`.
  String get autofillAppGroupIdentifier => 'group.design.codeux.authpass';

  /// The numeric App Store id of the iOS app, as in
  /// `apps.apple.com/app/authpass-password-manager/id1479297675`.
  ///
  /// Configuration rather than something discoverable: flutter_store_listing
  /// 2.0 deleted the iTunes `/lookup` call that used to find this at launch,
  /// so an id that is wrong or unset means the store listing and the review
  /// form do not open at all, on a release build without an error.
  String get appStoreId => '1479297675'; // NON-NLS

  /// The Mac App Store id, which is a **different app** from [appStoreId] —
  /// `id1478552452`, the `mt=12` link in README.md.
  ///
  /// flutter_store_listing defaults this to [appStoreId] when it is not given,
  /// which would send Mac users to the iOS listing, so it is always passed
  /// separately. It stays correct for the Developer ID builds too: they are
  /// not sold there, but the Mac App Store is still where a Mac user reviews
  /// AuthPass.
  String get macAppStoreId => '1478552452'; // NON-NLS

  /// Where an explicit "review AuthPass" action goes on the platforms
  /// flutter_store_listing reports as `unsupportedPlatform`.
  ///
  /// The package knows the three app stores, so on Linux and Windows it opens
  /// nothing at all — but those builds do come from stores of their own that
  /// take reviews. Without this the button is simply dead there; on 1.x it
  /// opened a Google Play page for a package name that is not on Play, which
  /// is where the dedicated `StorePlatform.unsupported` came from.
  ///
  /// Null on web, where there is genuinely nowhere to leave a review.
  ///
  /// Each platform gets its primary channel, because nothing at runtime says
  /// which one this build was installed from: a flatpak or portable-zip user
  /// reaches a listing they did not install from, which still beats a button
  /// that does nothing.
  Uri? get reviewFallbackUri {
    if (AuthPassPlatform.isLinux) {
      return Uri.parse(UrlConstants.snapStoreUrl);
    }
    if (AuthPassPlatform.isWindows) {
      return Uri.parse(UrlConstants.microsoftStoreUrl);
    }
    return null;
  }

  /// allow disabling of "onboarding".
  bool get featureOnboarding => true;

  /// Support for dropbox, google drive.
  bool get featureCloudStorageProprietary => true;

  /// Automatically fetch website icons.
  /// Right now this is only disabled for fdroid.
  bool get featureFetchWebsiteIconEnabledByDefault => true;

  /// Support for WebDAV
  bool get featureCloudStorageWebDav => true;

  @protected
  String? get storageNamespaceFromEnvironment;

  final FeatureFlags featureFlags = FeatureFlags(
    (b) => b
      ..authpassCloud = true
      ..authpassCloudUri = '$_authPassCloudUrl/', // NON-NLS
  );

  Future<AppInfo> getAppInfo();
}
