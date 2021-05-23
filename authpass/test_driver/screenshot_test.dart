@Timeout(Duration(minutes: 10))

// example run command:
// flutter_dev drive -d iPhone --target=test_driver/app.dart --driver=test_driver/screenshot_test.dart

import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'util/_screenshots_util.dart';

void main() {
  group('Simple KDBX Open', () {
    FlutterDriver? driver;
    StreamSubscription? streamSubscription;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      // TODO port this?
      // streamSubscription = driver.serviceClient.onIsolateRunnable
      //     .asBroadcastStream()
      //     .listen((isolateRef) {
      //   print(
      //       'Resuming isolate: ${isolateRef.numberAsString}:${isolateRef.name}');
      //   isolateRef.resume();
      // });
      /*
      maybe something like:
      driver.serviceClient.onIsolateEvent.asBroadcastStream().listen((event) {
        if (event.kind == 'IsolateRunnable') {
          // event.isolate.
        }
      });
       */
    });
    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        await driver!.close();
      }
      await streamSubscription?.cancel();
    });
    test('open kdbx 3 file', () async {
      await Future<void>.delayed(const Duration(seconds: 1));
      await driver!.waitUntilNoTransientCallbacks();

      final config = Config();
      while (!(await driver!.requestData('nextTheme')).contains('light')) {}

      await screenshot(driver, config, 'launchscreen');

      await _downloadFileAndOpen(driver!,
          'https://github.com/authpass/authpass/raw/master/_docs/screenshot_example.kdbx');

      await screenshot(driver, config, 'openedfile1');

      await driver!.tap(find.byValueKey('appBarOverflowMenu'));
      await driver!.tap(find.byValueKey('openAnotherFile'));
      await _downloadFileAndOpen(driver!,
          'https://github.com/authpass/authpass/raw/master/_docs/screenshot_example_company.kdbx');
      await screenshot(driver, config, 'openfile2');

      // entry details

      await driver!.tap(find.text('slack'));
      await screenshot(driver, config, 'entry_details');

      await driver!.tap(find.descendant(
          of: find.byType('AppBar'),
          matching: find.byType('IconButton'),
          firstMatchOnly: true));

      // Password generator

      await driver!.tap(find.byValueKey('appBarOverflowMenu'));
      await driver!.tap(find.byValueKey('openPasswordGenerator'));
      await screenshot(driver, config, 'password_generator');

      await driver!.tap(find.descendant(
          of: find.byType('AppBar'),
          matching: find.byType('IconButton'),
          firstMatchOnly: true));

      // switch to dark theme
      while (!(await driver!.requestData('nextTheme')).contains('dark')) {}
      await driver!.waitUntilNoTransientCallbacks();
      await screenshot(driver, config, 'theme1');

      // dark screenshot of overflow menu
      await driver!.tap(find.byValueKey('appBarOverflowMenu'));
      await screenshot(driver, config, 'appbar_menu');
      await driver!.tap(find.byValueKey('openPasswordGenerator'));

      // back to password list
      await driver!.tap(find.descendant(
          of: find.byType('AppBar'),
          matching: find.byType('IconButton'),
          firstMatchOnly: true));

      // open drawer
      await driver!.tap(find.descendant(
          of: find.byType('AppBar'),
          matching: find.byType('IconButton'),
          firstMatchOnly: true));
      await screenshot(driver, config, 'drawer');
      await driver!.waitUntilNoTransientCallbacks();
      await screenshot(driver, config, 'drawer2');
    });
  }, timeout: const Timeout.factor(8));
}

Future<void> _downloadFileAndOpen(FlutterDriver driver, String url) async {
  await driver.tap(find.byValueKey('appBarOverflowMenu'));
  final downloadButton = find.byValueKey('downloadFromUrl');
  await driver.tap(downloadButton);
  await driver.waitUntilNoTransientCallbacks();
  await driver.enterText(url);
  await driver.tap(find.text('Ok'));
  await driver.waitUntilNoTransientCallbacks();
  await driver.enterText('asdf');
  // await driver.tap(find.byType('CheckboxListTile'));
  await driver.tap(find.byValueKey('continue'));
}
