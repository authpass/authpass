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
/// It did, from 53c64505 until #432: every method funnels through
/// [AutofillMirror.container], and the call that reached the user was
/// `readManifest`, because `KdbxBloc._publishAutofillIdentities` is the one
/// autofill call in the open path with no try/catch around it. The sibling
/// throw out of `syncFile` was caught and logged, so opening a database failed
/// on the *second* throw, not the first.
///
/// This test has to run with `--platform chrome` to mean anything, and nothing
/// in CI does that yet.
void main() {
  group('AutofillMirror on web', () {
    late AutofillMirror mirror;

    setUp(() {
      mirror = AutofillMirror(appGroupIdentifier: 'group.test.authpass');
    });

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
