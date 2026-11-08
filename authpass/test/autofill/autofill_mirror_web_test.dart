@TestOn('browser')
library;

import 'package:authpass/autofill/autofill_mirror.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the one platform check in [AutofillMirror] that has to be answered
/// without `dart:io`.
///
/// `dart:io` compiles for the web and throws at *runtime* —
/// `Unsupported operation: Platform._operatingSystem` — so a plain
/// `Platform.isIOS` here is invisible to `flutter analyze` and to every test
/// that runs on the VM, and only fails once a real browser reaches the line.
/// It did: `container()` is called before the try block in both `syncFile` and
/// `readManifest`, so one unguarded check broke opening any database on
/// web.authpass.app (issue in PR #428).
///
/// This test has to run with `--platform chrome` to mean anything.
void main() {
  group('AutofillMirror on web', () {
    final mirror = AutofillMirror(appGroupIdentifier: 'group.test.authpass');

    test('container() answers null instead of throwing', () async {
      expect(await mirror.container(), isNull);
    });

    test('isAvailable is false', () async {
      expect(await mirror.isAvailable, isFalse);
    });

    test('readManifest() answers an empty manifest', () async {
      expect((await mirror.readManifest()).entries, isEmpty);
    });
  });
}
