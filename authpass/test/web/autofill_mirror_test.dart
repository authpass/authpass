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
/// `readManifest`, because `KdbxBloc._publishAutofillIdentities` was then the
/// one autofill call in the open path with no try/catch around it — it has one
/// now. The sibling throw out of `syncFile` was already caught and logged, so
/// opening a database failed on the *second* throw, not the first.
///
/// Lives under `test/web/` because that whole directory is what
/// `_tools/test-coverage.sh` hands to `--platform chrome`, so a second web
/// test joins that run by being put here. A tag would not do: `--tags` selects
/// *tests*, and the runner still has to load every file to find them — pointed
/// at `test/`, the chrome run tries to compile `onedrive_test.dart` and
/// `webdav_test.dart` for the browser and dies before reaching anything of
/// ours.
///
/// `@TestOn` is the other half, and keeps this file off the VM run — where
/// every assertion below would pass for the wrong reason, `Platform.isIOS`
/// being merely false there, so nothing ever reaches the line that threw.
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
