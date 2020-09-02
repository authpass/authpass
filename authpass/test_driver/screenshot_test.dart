import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:screenshots/screenshots.dart';
import 'package:test/test.dart';

void main() {
  group('Simple KDBX Open', () {
    final downloadButton = find.byValueKey('downloadFromUrl');

    FlutterDriver driver;
    StreamSubscription streamSubscription;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      streamSubscription = driver.serviceClient.onIsolateRunnable
          .asBroadcastStream()
          .listen((isolateRef) {
        print(
            'Resuming isolate: ${isolateRef.numberAsString}:${isolateRef.name}');
        isolateRef.resume();
      });
    });
    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
      await streamSubscription?.cancel();
    });
    test('open kdbx 3 file', () async {
      final config = Config();

      await screenshot(driver, config, 'launchscreen');

      await driver.tap(downloadButton);

      await driver.waitUntilNoTransientCallbacks();

      await driver.enterText(
          'https://github.com/authpass/kdbx.dart/raw/master/test/kdbx4_keeweb.kdbx');
      await driver.tap(find.text('Ok'));

      await driver.waitUntilNoTransientCallbacks();
      await driver.enterText('asdf');
      await driver.tap(find.byType('CheckboxListTile'));
      await driver.tap(find.text('Continue'));

      await screenshot(driver, config, 'openedfile');
    });
  });
}
