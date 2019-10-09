part of 'analytics.dart';

// ignore_for_file: unnecessary_brace_in_string_interps, prefer_final_locals

// copied from usage plugin and adopted to include android and iOS version.
String _createUserAgent({String platformVersion, String deviceInfo}) {
  final String locale = getPlatformLocale() ?? '';

  if (Platform.isAndroid) {
    return 'Mozilla/5.0 (Linux; Android $platformVersion; ${deviceInfo ?? 'Mobile'}; ${locale}) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/30.0.0.0 Mobile Safari/537.36';
  } else if (Platform.isIOS) {
    return 'Mozilla/5.0 (iPhone; CPU iPhone OS $platformVersion like Mac OS X; ${locale}) AppleWebKit/602.1.50 (KHTML, like Gecko) CriOS/56.0.2924.75 Mobile/14E5239e Safari/602.1';
  } else if (Platform.isMacOS) {
    return 'Mozilla/5.0 (Macintosh; Intel Mac OS X; Macintosh; ${locale})';
  } else if (Platform.isWindows) {
    return 'Mozilla/5.0 (Windows; Windows; Windows; ${locale})';
  } else if (Platform.isLinux) {
    return 'Mozilla/5.0 (Linux; Linux; Linux; ${locale})';
  } else {
    // Dart/1.8.0 (macos; macos; macos; en_US)
    String os = Platform.operatingSystem;
    return 'Dart/${getDartVersion()} (${os}; ${os}; ${os}; ${locale})';
  }
}

/// Return the string for the platform's locale; return's `null` if the locale
/// can't be determined.
String getPlatformLocale() {
  String locale = Platform.localeName;
  if (locale == null) return null;

  if (locale != null) {
    // Convert `en_US.UTF-8` to `en_US`.
    int index = locale.indexOf('.');
    if (index != -1) locale = locale.substring(0, index);

    // Convert `en_US` to `en-us`.
    locale = locale.replaceAll('_', '-').toLowerCase();
  }

  return locale;
}

String getDartVersion() {
  String ver = Platform.version;
  int index = ver.indexOf(' ');
  if (index != -1) ver = ver.substring(0, index);
  return ver;
}
