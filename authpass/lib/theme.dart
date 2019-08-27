import 'package:flutter/material.dart';

class AuthPassTheme {
  static const Color linkColor = Colors.blueAccent;
  static const MaterialColor primarySwatch = MaterialColor(0xFF626bc6, <int, Color>{
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
}

ThemeData createTheme() {
  return ThemeData(
    primarySwatch: AuthPassTheme.primarySwatch,
  );
}
