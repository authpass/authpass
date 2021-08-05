part of 'analytics.dart';

// ignore_for_file: always_put_control_body_on_new_line,unnecessary_brace_in_string_interps, prefer_final_locals

// copied from usage plugin and adopted to include android and iOS version.
@NonNls
String _createUserAgent({String? platformVersion, String? deviceInfo}) {
  final locale = getPlatformLocale() ?? '';

  if (AuthPassPlatform.isAndroid) {
    return 'Mozilla/5.0 (Linux; Android $platformVersion; ${deviceInfo ?? 'Mobile'}; ${locale}) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/30.0.0.0 Mobile Safari/537.36';
  } else if (AuthPassPlatform.isIOS) {
    return 'Mozilla/5.0 (iPhone; CPU iPhone OS $platformVersion like Mac OS X; ${locale}) AppleWebKit/602.1.50 (KHTML, like Gecko) CriOS/56.0.2924.75 Mobile/14E5239e Safari/602.1';
  } else if (AuthPassPlatform.isMacOS) {
    return 'Mozilla/5.0 (Macintosh; Intel Mac OS X; Macintosh; ${locale})';
  } else if (AuthPassPlatform.isWindows) {
    return 'Mozilla/5.0 (Windows; Windows; Windows; ${locale})';
  } else if (AuthPassPlatform.isLinux) {
    return 'Mozilla/5.0 (Linux; Linux; Linux; ${locale})';
  } else {
    // Dart/1.8.0 (macos; macos; macos; en_US)
    final os = AuthPassPlatform.operatingSystem;
    return 'Dart/${getDartVersion()} (${os}; ${os}; ${os}; ${locale})';
  }
}

/// Return the string for the platform's locale; return's `null` if the locale
/// can't be determined.
@NonNls
String? getPlatformLocale() {
  var locale = AuthPassPlatform.localeName;
  if (locale == null) return null;

  final index = locale.indexOf('.');
  if (index != -1) locale = locale.substring(0, index);

  // Convert `en_US` to `en-us`.
  locale = locale.replaceAll('_', '-').toLowerCase();

  return locale;
}

@NonNls
String getDartVersion() {
  final ver = AuthPassPlatform.version;
  final index = ver.indexOf(' ');
  if (index != -1) return ver.substring(0, index);
  return ver;
}
