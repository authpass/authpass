import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:authpass/bloc/kdbx_argon2_ffi.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/env/test_driver.dart' as env;
import 'package:authpass/ui/screens/password_list.dart';
import 'package:authpass/ui/widgets/password_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kdbx/kdbx.dart';

const _password = 'asdf';
const _entryTitle = 'new entry';
const _databaseName = 'integration test';

/// Set when the future returned by [env.TestDriverEnv.start] fails.
///
/// Nothing awaits that future (see the test body), and `startApp` installs a
/// `PlatformDispatcher.instance.onError` handler which swallows errors, so a
/// failed startup would otherwise only show up as a step timing out with no
/// explanation. [_diagnostics] puts it into the failure message instead.
String? _startupFailure;

/// A kdbx database served over http on the loopback interface, so that the
/// app's url file source can download it without leaving the device.
class _ServedDatabase {
  _ServedDatabase(this._server, this.url);

  final HttpServer _server;

  /// What to type into the "load from url" dialog.
  final Uri url;

  /// How often the app asked for the database. Evidence that the download
  /// path really ran, rather than something having cached the file.
  int requestCount = 0;

  Future<void> close() => _server.close(force: true);
}

/// Creates a kdbx4 database holding a single entry titled [_entryTitle] and
/// serves it over http from the device itself.
///
/// The test used to download `kdbx4_keeweb.kdbx` from github.com over the real
/// network, which made a github outage or a slow runner look like a test
/// failure. What this test is for is the app's own path - url dialog ->
/// [FileSourceUrl] -> http -> kdbx parse -> password list - and a locally
/// served database exercises all of it. Reading a file written by another kdbx
/// implementation is covered by the kdbx package's own test suite.
Future<_ServedDatabase> _serveDatabase() async {
  final file = KdbxFormat(FlutterArgon2()).create(
    Credentials(ProtectedValue.fromString(_password)),
    _databaseName,
  );
  final entry = KdbxEntry.create(file, file.body.rootGroup);
  file.body.rootGroup.addEntry(entry);
  entry.setString(KdbxKeyCommon.TITLE, PlainValue(_entryTitle));
  final Uint8List bytes = await file.save();

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  final served = _ServedDatabase(
    server,
    Uri.http('${server.address.address}:${server.port}', '/test.kdbx'),
  );
  server.listen((request) async {
    served.requestCount++;
    request.response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = ContentType.binary
      ..add(bytes);
    await request.response.close();
  });
  return served;
}

/// Pumps frames until [finder] matches at least one widget, and fails with a
/// message naming [what] if it never does.
///
/// Every step of this test drives a widget which only appears after work the
/// test itself did not await: the app's own startup, a route or menu
/// transition, an http download, argon2. `pumpAndSettle()` waits for none of
/// that - it runs frames only until nothing is animating any more, which on a
/// fast simulator happens before the widget exists. That is the race this test
/// kept losing in CI.
Future<void> _waitFor(
  WidgetTester tester,
  Finder finder,
  String what, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final waited = Stopwatch()..start();
  while (finder.evaluate().isEmpty) {
    if (waited.elapsed > timeout) {
      fail(
        'Timed out after ${timeout.inSeconds}s waiting for $what '
        '($finder).${_diagnostics()}',
      );
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
  await _settle(tester);
}

/// [_waitFor] and then tap it.
///
/// The wait matters even for a widget which is already there: a popup menu or
/// a dialog still growing into place rejects a hit test outside its current
/// (smaller) box, and the tap then lands on the barrier behind it and closes
/// the thing it meant to use.
Future<void> _tapWhenReady(
  WidgetTester tester,
  Finder finder,
  String what, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  await _waitFor(tester, finder, what, timeout: timeout);
  await tester.tap(finder);
  await _settle(tester);
}

/// [_waitFor] and then type [text] into it.
Future<void> _enterTextWhenReady(
  WidgetTester tester,
  Finder finder,
  String text,
  String what, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  await _waitFor(tester, finder, what, timeout: timeout);
  await tester.enterText(finder, text);
  await _settle(tester);
}

/// Runs frames until nothing is animating, so a transition cannot move a
/// widget out from under the next tap.
///
/// Gives up quietly when something animates forever - a progress indicator is
/// enough, and this test waits through two of them. A plain `pumpAndSettle()`
/// would instead keep pumping for ten minutes and then throw, turning a slow
/// download into a ten minute CI job. Nothing is lost by giving up: the widget
/// the caller is about to drive has already been waited for by [_waitFor].
Future<void> _settle(
  WidgetTester tester, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  try {
    await tester.pumpAndSettle(
      const Duration(milliseconds: 50),
      EnginePhase.sendSemanticsUpdate,
      timeout,
    );
  } on FlutterError catch (error) {
    if (!error.toString().contains('pumpAndSettle timed out')) {
      rethrow;
    }
  }
}

/// Everything the test knows about why a step might not have happened.
String _diagnostics() {
  final failure = _startupFailure;
  final dialog = _dialogText();
  return '${failure == null ? '' : '\nApp startup failed: $failure'}'
      '${dialog == null ? '' : '\nA dialog is on screen: $dialog'}';
}

/// The text of any dialog on screen, which is how the app reports a failed
/// download, a wrong password or a database it cannot parse.
String? _dialogText() {
  final dialogs = find.byType(AlertDialog);
  if (dialogs.evaluate().isEmpty) {
    return null;
  }
  return find
      .descendant(of: dialogs, matching: find.byType(Text))
      .evaluate()
      .map((element) => (element.widget as Text).data)
      .whereType<String>()
      .join(' / ');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('opens a kdbx database from a url and lists its entries', (
    WidgetTester tester,
  ) async {
    QuickUnlockStorage.debugForceNoBiometricSupport = true;

    final database = await _serveDatabase();
    addTearDown(database.close);

    // `start()` completes once `runApp` has been called, which is not the same
    // thing as the first screen being on screen - the app loads its AppData
    // first. So the future is only watched for errors, and each step below
    // waits for the widget it is about to drive.
    unawaited(
      env.TestDriverEnv().start().catchError((
        Object error,
        StackTrace stackTrace,
      ) {
        _startupFailure = '$error\n$stackTrace';
      }),
    );

    await _tapWhenReady(
      tester,
      find.byKey(const ValueKey('appBarOverflowMenu')),
      'the overflow menu of the file selection screen',
      // Startup includes the first frame of a cold app on a simulator.
      timeout: const Duration(seconds: 90),
    );

    await _tapWhenReady(
      tester,
      find.byKey(const ValueKey('downloadFromUrl')),
      'the "load from url" item of the overflow menu',
    );

    final urlDialog = find.byType(AlertDialog);
    await _enterTextWhenReady(
      tester,
      find.descendant(of: urlDialog, matching: find.byType(TextFormField)),
      database.url.toString(),
      'the url field of the "load from url" dialog',
    );
    await _tapWhenReady(
      tester,
      find.descendant(of: urlDialog, matching: find.text('OK')),
      'the OK button of the "load from url" dialog',
    );

    await _enterTextWhenReady(
      tester,
      find.byType(PasswordInputField),
      _password,
      'the master password field of the credentials screen',
    );
    await _tapWhenReady(
      tester,
      find.byKey(const ValueKey('continue')),
      'the continue button of the credentials screen',
    );

    final entryTitle = find.descendant(
      of: find.byType(PasswordListContent),
      matching: find.text(_entryTitle),
    );
    await _waitFor(
      tester,
      entryTitle,
      'the entry list of the opened database',
      // The download, argon2 and the first frame of the list.
      timeout: const Duration(seconds: 90),
    );

    expect(entryTitle.evaluate(), hasLength(1));
    expect(
      database.requestCount,
      greaterThanOrEqualTo(1),
      reason: 'the database should have been downloaded from the url',
    );
  });
}
