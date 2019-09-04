import 'dart:io';

import 'package:authpass/main.dart';
import 'package:built_value/built_value.dart';
import 'package:package_info/package_info.dart';

part '_base.g.dart';

enum EnvType { production, development }

const _DEFAULT_APP_NAME = 'AuthPass';
const _DEFAULT_VERSION = '1.0.0';
const _DEFAULT_BUILD_NUMBER = '1';
const _DEFAULT_PACKAGE_NAME = 'design.codeux.authpass';

abstract class AppInfo implements Built<AppInfo, AppInfoBuilder> {
  factory AppInfo([void updates(AppInfoBuilder b)]) = _$AppInfo;
  AppInfo._();

  String get appName;
  String get version;
  String get buildNumber;
  String get packageName;

  String get versionLabel => '$version+$buildNumber';
}

abstract class Env {
  Env(this.type) {
    value = this;
  }

  static Env value;

  final EnvType type;

  Future<void> start() async {
    await startApp(this);
  }

  String get name => runtimeType.toString();

  String get analyticsAmplitudeApiKey => null;
//  String get analyticsGoogleAnalyticsId => 'G-HNGCPDXTSW';
  String get analyticsGoogleAnalyticsId => 'UA-91100035-7';

  String get googleClientId => 'TODO';
  String get googleClientSecret => 'TODO';
  String get dropboxKey => 'TODO';
  String get dropboxSecret => 'TODO';
  Future<AppInfo> getAppInfo() async {
    final pi = await _getPackageInfo();
    return AppInfo((b) => b
      ..appName = pi?.appName ?? _DEFAULT_APP_NAME
      ..version = pi?.version ?? _DEFAULT_VERSION
      ..buildNumber = pi?.buildNumber ?? _DEFAULT_BUILD_NUMBER
      ..packageName = pi?.packageName ?? _DEFAULT_PACKAGE_NAME);
  }

  Future<PackageInfo> _getPackageInfo() async {
    if (Platform.isIOS || Platform.isAndroid) {
      return await PackageInfo.fromPlatform();
    }
    return null;
  }
}
