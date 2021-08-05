import 'dart:async';

import 'package:authpass/env/test_driver.dart' as env;
import 'package:authpass/ui/screens/password_list.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  // ignore: unused_local_variable
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  testWidgets('failing test example', (WidgetTester tester) async {
    unawaited(env.TestDriverEnv().start());
    await tester.pumpAndSettle();

    final menu = find.byKey(const ValueKey('appBarOverflowMenu'));
    await tester.tap(menu);
    await tester.pumpAndSettle();

    final button = find.byKey(const ValueKey('downloadFromUrl'));
    await tester.tap(button);
    await tester.pumpAndSettle();

    tester.testTextInput.enterText(
        'https://github.com/authpass/kdbx.dart/raw/master/test/kdbx4_keeweb.kdbx');
    await tester.pumpAndSettle();

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    tester.testTextInput.enterText('asdf');
    await tester.testTextInput.receiveAction(TextInputAction.go);
    await tester.pumpAndSettle();

    final entryTitle = find.descendant(
      of: find.byType(PasswordListContent),
      matching: find.text('new entry'),
    );

    expect(entryTitle.evaluate(), hasLength(1));

    // This is required prior to taking the screenshot.
    // await binding.convertFlutterSurfaceToImage();
    //
    // Trigger a frame.
    // await tester.pumpAndSettle();
    // await binding.takeScreenshot('screenshot-1');
  });
}
