// Place fonts/AuthPassIcons.ttf in your fonts/ directory and
// add the following to your pubspec.yaml
// flutter:
//   fonts:
//    - family: AuthPassIcons
//      fonts:
//       - asset: fonts/AuthPassIcons.ttf
import 'package:flutter/widgets.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

class AuthPassIcons {
  AuthPassIcons._();

  @NonNls
  static const String _fontFamily = 'AuthPassIcons';

  static const IconData AuthPassLogo =
      IconData(0xe900, fontFamily: _fontFamily);
}
