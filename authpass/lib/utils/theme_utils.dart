import 'dart:ui';

import 'package:flutter/material.dart';

class ThemeUtil {
  static Color iconColor(ThemeData theme, Color? fileColor) {
    return fileColor ?? (theme.isDarkTheme ? Colors.white54 : Colors.black45);
  }
}

extension ThemeDataExt on ThemeData {
  bool get isDarkTheme => brightness == Brightness.dark;
  Color iconColor(Color? fileColor) => ThemeUtil.iconColor(this, fileColor);
}
