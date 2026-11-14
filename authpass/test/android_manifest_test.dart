import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Android destroys and recreates an activity on every configuration change
/// that it is not declared to handle itself. For this app that means a new
/// Flutter engine and a fresh Dart isolate, so every opened database is gone
/// and the user is back at the locked screen.
///
/// Entering split screen, or switching to a floating window, resizes the
/// window and with it `smallestScreenSize`. Only `screenSize` was declared,
/// which covers rotation but not these window changes (#401).
void main() {
  test('MainActivity handles window resizes itself', () {
    final manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    final activity = RegExp(
      r'<activity\b[^>]*android:name="\.MainActivity"[^>]*>',
    ).firstMatch(manifest);
    expect(activity, isNotNull, reason: 'MainActivity not found in manifest');
    final configChanges = RegExp(
      r'android:configChanges="([^"]*)"',
    ).firstMatch(activity!.group(0)!);
    expect(configChanges, isNotNull);
    final handled = configChanges!.group(1)!.split('|').toSet();
    expect(
      handled,
      containsAll(<String>[
        'orientation',
        'screenSize',
        'smallestScreenSize',
        'screenLayout',
        'density',
        'keyboard',
        'keyboardHidden',
        'uiMode',
      ]),
    );
  });
}
