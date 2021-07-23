import 'dart:io';

import 'platform_noop.dart' if (dart.library.html) 'platform_web.dart';

/// we do this ourselves so we do not have to depend on flutter for this file.
const bool _kIsWeb = authPassIsWeb;

class AuthPassPlatform {
  static final Map<String, String> environment =
      _kIsWeb ? const {} : Platform.environment;

  static String get version => _kIsWeb ? '0.0' : Platform.version;

  static bool get isWeb => _kIsWeb;
  static bool get isLinux => !_kIsWeb && Platform.isLinux;
  static bool get isWindows => !_kIsWeb && Platform.isWindows;
  static late final bool isWindowsWinAutoUpdate = isWindows &&
      const bool.fromEnvironment('AUTHPASS_WIN_AUTOUPDATE', defaultValue: true);

  /// Whether this is a "portable" build -
  /// ie. no files will be written outside the application directory.
  /// (application directory is in this case the
  /// parent directory of the executable)
  static bool get isPortable =>
      !_kIsWeb &&
      const bool.fromEnvironment('AUTHPASS_PORTABLE', defaultValue: false);
  static bool get isMacOS => !_kIsWeb && Platform.isMacOS;
  static bool get isIOS => !_kIsWeb && Platform.isIOS;
  static bool get isAndroid => !_kIsWeb && Platform.isAndroid;

  static String get operatingSystem =>
      _kIsWeb ? 'web' : Platform.operatingSystem;
  static String get operatingSystemVersion =>
      _kIsWeb ? 'web' : Platform.operatingSystemVersion;

  static String? get localeName => _kIsWeb ? null : Platform.localeName;
}
