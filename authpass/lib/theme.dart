import 'package:authpass/utils/platform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('theme');

class AuthPassTheme {
  @NonNls
  static const monoFontFamily = 'JetBrainsMono';
//  static const Color linkColor = Colors.blueAccent;
  static const int _primaryColorValue = 0xFF626bc6;
  static const Color primaryColor = Color(_primaryColorValue);
  static const Color linkColor = primaryColor;
  static const MaterialColor primarySwatch =
      MaterialColor(_primaryColorValue, <int, Color>{
    50: Color(0xFFecedf8),
    100: Color(0xFFd0d3ee),
    200: Color(0xffb1b5e3),
    300: Color(0xFF9197d7),
    400: Color(0xFF7a81cf),
    500: Color(0xFF626bc6),
    600: Color(0xFF5a63c0),
    700: Color(0xFF5058b9),
    800: Color(0xFF464eb1),
    900: Color(0xFF343ca4),
  });

  static const defaultFileColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    primaryColor,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];
  static const defaultColorOrder = [
    Colors.teal,
    Colors.orange,
    Colors.blueGrey,
    Colors.deepPurple,
  ];
}

abstract class Breakpoints {
  static const TABLET_WIDTH = 720;
}

// during development use getters :-)
//ThemeData get authPassLightTheme => createTheme();
//ThemeData get authPassDarkTheme => createDarkTheme();
final authPassLightTheme = createTheme();
final authPassDarkTheme = createDarkTheme();

ThemeData _customize(ThemeData base) {
  final pageTransitionBuilders = {...const PageTransitionsTheme().builders};
  pageTransitionBuilders[TargetPlatform.macOS] =
      const FadeUpwardsPageTransitionsBuilder();
  return base.copyWith(
    androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
    pageTransitionsTheme:
        PageTransitionsTheme(builders: pageTransitionBuilders),
  );
}

bool _addedInterLicense = false;

Typography _getTypography() {
  if (defaultTargetPlatform == TargetPlatform.macOS &&
      // macos 10.15 -> darwin 19.0
      // https://en.wikipedia.org/wiki/MacOS_Mojave#Release_history
      // https://en.wikipedia.org/wiki/MacOS_Catalina#Release_history
      !_isDarwinVersion(minimumMajor: 19, minimumMinor: 0)) {
    if (!_addedInterLicense) {
      LicenseRegistry.addLicense(() async* {
        final license = await rootBundle
            .loadString(nonNls('assets/fonts/Inter-LICENSE.txt'));
        yield LicenseEntryWithLineBreaks([nonNls('fonts_inter')], license);
      });
      _addedInterLicense = true;
    }
    return Typography.material2018(
      platform: defaultTargetPlatform,
      black: Typography.blackCupertino.apply(fontFamily: nonNls('Inter')),
      white: Typography.whiteCupertino.apply(fontFamily: nonNls('Inter')),
    );
  } else {
    _logger.info(
        'using default theme $defaultTargetPlatform -- ${AuthPassPlatform.operatingSystemVersion}');
    return Typography.material2018(platform: defaultTargetPlatform);
  }
}

final macOsVersionPattern = RegExp(r'Darwin (\d+)\.(\d+)');

bool _isDarwinVersion({required int minimumMajor, required int minimumMinor}) {
  final match =
      macOsVersionPattern.firstMatch(AuthPassPlatform.operatingSystemVersion);
  if (match == null) {
    _logger.severe(
        'Unable to parse mac os version ${AuthPassPlatform.operatingSystemVersion}');
    return false;
  }
  final major = int.parse(match.group(1)!);
  final minor = int.parse(match.group(2)!);
  _logger.info(
      'Parsed ${AuthPassPlatform.operatingSystemVersion} as $major.$minor');
  _logger.finest(
      'Parsed ${AuthPassPlatform.operatingSystemVersion} as $major.$minor');
  return major > minimumMajor ||
      (major == minimumMajor && minor >= minimumMinor);
}

ThemeData createTheme() {
  return _customize(ThemeData(
    primarySwatch: AuthPassTheme.primarySwatch,
    typography: _getTypography(),
  ));
}

ThemeData createDarkTheme() {
  final colorScheme = ColorScheme.dark(
    primary: AuthPassTheme.primaryColor,
    onPrimary: Colors.white,
    secondary: AuthPassTheme.primarySwatch[300]!,
    secondaryVariant: AuthPassTheme.primarySwatch[500]!,
  );
  return _customize(ThemeData(
    typography: _getTypography(),
    primaryColor: colorScheme.primary,
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: AuthPassTheme.primarySwatch[800],
    ),
//    textSelectionColor: Colors.red,
    toggleableActiveColor: colorScheme.primary,
//    cursorColor: Colors.red,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    primarySwatch: AuthPassTheme.primarySwatch,
    selectedRowColor: colorScheme.surface,
  ));
}
