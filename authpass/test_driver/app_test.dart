import 'dart:async';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
//import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Simple KDBX Open', () {
    final downloadButton = find.byValueKey('downloadFromUrl');

    FlutterDriver? driver;
    StreamSubscription? streamSubscription;

    var screenshotCount = 0;

    Future<void> takeScreenshot() async {
      const basedir = 'build/screenshots';
      await Directory(basedir).create(recursive: true);
      await File(path.join(basedir, 'test${screenshotCount++}.png'))
          .writeAsBytes(await driver!.screenshot());
    }

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver!.waitUntilFirstFrameRasterized();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        await driver!.close();
      }
      await streamSubscription?.cancel();
    });

    test('open kdbx 3 file', () async {
      await driver!.tap(find.byValueKey('appBarOverflowMenu'));
      await driver!.tap(downloadButton);

      await driver!.waitUntilNoTransientCallbacks();

      await driver!.enterText(
          'https://github.com/authpass/kdbx.dart/raw/master/test/kdbx4_keeweb.kdbx');
      await takeScreenshot();
      //await find.ancestor(of: find.text('Ok'), matching: find.byType('FlatButton'));
      await driver!.tap(find.text('OK'));
      await takeScreenshot();
//      await driver.waitUntilNoTransientCallbacks(
//          timeout: const Duration(seconds: 10));
      await takeScreenshot();

      await driver!.waitUntilNoTransientCallbacks();

      await driver!.enterText('asdf');
      // await driver.tap(find.byType('CheckboxListTile'));
      await driver!.tap(find.text('Continue'));
      final newEntryTitle = await driver!.getWidgetDiagnostics(find.descendant(
          of: find.byType('PasswordListContent'),
          matching: find.text('new entry')));
      expect(newEntryTitle, isNotNull);
      await takeScreenshot();
    });
  });
}
