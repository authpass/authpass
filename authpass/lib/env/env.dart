import 'package:authpass/env/_base.dart';
import 'package:authpass/main.dart';
import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/extension_methods.dart';
import 'package:authpass/utils/platform.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('env');

const _DEFAULT_APP_NAME = AppConstants.authPass;
@NonNls
const _DEFAULT_VERSION =
    String.fromEnvironment('AUTHPASS_VERSION', defaultValue: '1.0.0');
@NonNls
const _DEFAULT_BUILD_NUMBER =
    int.fromEnvironment('AUTHPASS_BUILD_NUMBER', defaultValue: 1);
@NonNls
const _DEFAULT_PACKAGE_NAME = String.fromEnvironment('AUTHPASS_PACKAGE_NAME',
    defaultValue: 'design.codeux.authpass.dev');

abstract class EnvAppBase extends Env {
  EnvAppBase(EnvType type) : super(type);

  @NonNls
  static const _ENV_STORAGE_NAMESPACE = 'AUTHPASS_STORAGE_NAMESPACE';

  @override
  EnvSecrets? get secrets;

//  String get oauthRedirectUri => 'authpass://oauth/code';
  @NonNls
  @override
  String? get oauthRedirectUri => oauthRedirectUriSupported
      // for clients not supporting https:// handling, it will redirect
      // to authpass://
      ? 'https://links.authpass.app/app/oauth/code'
      : null;
  @override
  bool get oauthRedirectUriSupported =>
      AuthPassPlatform.isIOS ||
      AuthPassPlatform.isAndroid ||
      AuthPassPlatform.isMacOS;

  @override
  String? get storageNamespaceFromEnvironment =>
      AuthPassPlatform.environment[_ENV_STORAGE_NAMESPACE];

  Future<void> start() async {
    await startApp(this);
  }

  @override
  Future<AppInfo> getAppInfo() async {
    final pi = await _getPackageInfo();
    return AppInfo((b) => b
      ..appName = pi?.appName.nullIfBlank() ?? _DEFAULT_APP_NAME
      ..version = pi?.version.nullIfBlank() ?? _DEFAULT_VERSION
      ..buildNumber = int.tryParse(pi?.buildNumber.nullIfBlank() ??
              _DEFAULT_BUILD_NUMBER.toString()) ??
          _DEFAULT_BUILD_NUMBER
      ..packageName = pi?.packageName.nullIfBlank() ?? _DEFAULT_PACKAGE_NAME);
  }

  Future<PackageInfo?> _getPackageInfo() async {
    try {
      // linux and windows don't support this right now.
      if (AuthPassPlatform.isWeb ||
          AuthPassPlatform.isLinux ||
          AuthPassPlatform.isWindows) {
        return null;
      }
      return await PackageInfo.fromPlatform();
    } on PlatformException catch (e, stackTrace) {
      _logger.severe('Error getting package info', e, stackTrace);
      return null;
    }
  }
}
