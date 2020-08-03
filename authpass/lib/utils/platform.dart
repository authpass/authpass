import 'dart:io';

import 'package:flutter/foundation.dart';

class AuthPassPlatform {
  static final Map<String, String> environment =
      kIsWeb ? const {} : Platform.environment;

  static String get version => kIsWeb ? '0.0' : Platform.version;

  static bool get isWeb => kIsWeb;
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  static String get operatingSystem =>
      kIsWeb ? 'web' : Platform.operatingSystem;
  static String get operatingSystemVersion =>
      kIsWeb ? 'web' : Platform.operatingSystemVersion;

  static String get localeName => kIsWeb ? null : Platform.localeName;
}
