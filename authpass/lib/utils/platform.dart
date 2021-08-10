import 'dart:io' show Platform;

import 'package:logging/logging.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

import 'platform_noop.dart' if (dart.library.html) 'platform_web.dart';

final _logger = Logger('platform');

/// we do this ourselves so we do not have to depend on flutter for this file.
const bool _kIsWeb = authPassIsWeb;

class AuthPassPlatform {
  static final Map<String, String> environment =
      _kIsWeb ? const {} : Platform.environment;

  @NonNls
  static String get version => _kIsWeb ? '0.0' : Platform.version;

  static bool get isWeb => _kIsWeb;
  static bool get isLinux => !_kIsWeb && Platform.isLinux;
  static bool get isWindows => !_kIsWeb && Platform.isWindows;
  @NonNls
  static late final bool isWindowsWinAutoUpdate = isWindows &&
      const bool.fromEnvironment('AUTHPASS_WIN_AUTOUPDATE', defaultValue: true);

  /// Whether this is a "portable" build -
  /// ie. no files will be written outside the application directory.
  /// (application directory is in this case the
  /// parent directory of the executable)
  @NonNls
  static bool get isPortable =>
      !_kIsWeb &&
      const bool.fromEnvironment('AUTHPASS_PORTABLE', defaultValue: false);
  static bool get isMacOS => !_kIsWeb && Platform.isMacOS;
  static bool get isIOS => !_kIsWeb && Platform.isIOS;
  static bool get isAndroid => !_kIsWeb && Platform.isAndroid;

  @NonNls
  static String get operatingSystem =>
      _kIsWeb ? 'web' : Platform.operatingSystem;
  @NonNls
  static String get operatingSystemVersion =>
      _kIsWeb ? 'web' : Platform.operatingSystemVersion;

  static String? get localeName => _kIsWeb ? null : Platform.localeName;

  static Map<String, String> debugInfo() {
    String handle(String Function() info) {
      try {
        return info();
      } catch (e) {
        // https://github.com/flutter/flutter/issues/83921
        _logger.finest('error fetching info. ');
        return 'throws: $e'; // NON-NLS
      }
    }

    return nonNls({
      'script': handle(() => Platform.script.toFilePath()),
      'executable': handle(() => Platform.executable),
      'resolvedExecutable': handle(() => Platform.resolvedExecutable),
      'executableArguments':
          handle(() => Platform.executableArguments.toString()),
    });
  }
}
