import 'package:authpass/bloc/deps.dart';
import 'package:authpass/env/production.dart';
import 'package:authpass/main.dart';
import 'package:authpass/ui/screens/password_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
//import 'package:flutter_test/flutter_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Simple KDBX Open', () {
    // FlutterDriver driver;
    // StreamSubscription streamSubscription;
    //
    // var screenshotCount = 0;
    //
    // Future<void> takeScreenshot() async {
    //   const basedir = 'build/screenshots';
    //   await Directory(basedir).create(recursive: true);
    //   await File(path.join(basedir, 'test${screenshotCount++}.png'))
    //       .writeAsBytes(await driver.screenshot());
    // }
    //
    // // Connect to the Flutter driver before running any tests.
    // setUpAll(() async {
    //   driver = await FlutterDriver.connect();
    //   await driver.waitUntilFirstFrameRasterized();
    // });

    // // Close the connection to the driver after the tests have completed.
    // tearDownAll(() async {
    //   if (driver != null) {
    //     await driver.close();
    //   }
    //   await streamSubscription?.cancel();
    // });
    final env = Production();
    final deps = Deps(env: env);

    testWidgets('open kdbx 3 file', (tester) async {
      await tester.pumpWidget(
        AuthPassApp(env: env, deps: deps, isFirstRun: false),
      );

      await tester.tap(find.byKey(const ValueKey('appBarOverflowMenu')));
      await tester.pumpAndSettle();

      final downloadButton = find.byKey(const ValueKey('downloadFromUrl'));
      await tester.tap(downloadButton);

      await tester.pumpAndSettle();

      await tester.enterText(find.byTooltip('Enter URL'),
          'https://github.com/authpass/kdbx.dart/raw/master/test/kdbx4_keeweb.kdbx');
      // await takeScreenshot();
      //await find.ancestor(of: find.text('Ok'), matching: find.byType('FlatButton'));
      await tester.tap(find.text('Ok'));
      // await takeScreenshot();
//      await driver.waitUntilNoTransientCallbacks(
//          timeout: const Duration(seconds: 10));
//       await takeScreenshot();

      await tester.pumpAndSettle();

      await tester.enterText(null, 'asdf');
      // await driver.tap(find.byType('CheckboxListTile'));
      await tester.tap(find.text('Continue'));
      expect(
          find.descendant(
              of: find.byType(PasswordListContent),
              matching: find.text('new entry')),
          findsOneWidget);
      // final newEntryTitle = await driver.getWidgetDiagnostics(find.descendant(
      //     of: find.byType('PasswordListContent'),
      //     matching: find.text('new entry')));
      // expect(newEntryTitle, isNotNull);
      // await takeScreenshot();
    });
  });
}
