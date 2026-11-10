import 'dart:async';

import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/l10n-generated/app_localizations.dart';
import 'package:authpass/l10n-generated/app_localizations_en.dart';
import 'package:authpass/ui/widgets/duplicate_uuid_repair.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kdbx/kdbx.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

final loc = AppLocalizationsEn();

class _FakeFileSource extends Fake implements FileSource {
  _FakeFileSource(this.displayName);

  @override
  final String displayName;

  @override
  String toString() => 'FakeFileSource{$displayName}';
}

/// Only [findDuplicateUuidObjects] matters here - whether kdbx finds the right
/// duplicates, and what repairing them does to a database, is covered by
/// kdbx.dart's own tests.
class _FakeKdbxFile extends Fake implements KdbxFile {
  _FakeKdbxFile({this.duplicates = 1});

  int duplicates;

  @override
  Map<KdbxUuid, List<KdbxObject>> findDuplicateUuidObjects() => {
    for (var i = 0; i < duplicates; i++) ...{
      KdbxUuid.random(): <KdbxObject>[],
    },
  };
}

class _FakeOpenedFile extends Fake implements KdbxOpenedFile {
  _FakeOpenedFile(this.fileSource, this.kdbxFile);

  @override
  final FileSource fileSource;

  @override
  final KdbxFile kdbxFile;
}

class _FakeKdbxBloc extends Fake implements KdbxBloc {
  final _pending = <FileSource>[];
  final _answered = <FileSource>{};
  final _opened = <FileSource, KdbxOpenedFile>{};
  final _openedFiles = BehaviorSubject<OpenedKdbxFiles>();
  final _pendingChanged = StreamController<void>.broadcast();

  /// Stands in for the repair, which is otherwise a merge plus a save.
  Future<List<KdbxUuid>> Function(KdbxFile file)? onRepair;

  /// The files it was asked to repair, in order.
  final repairCalls = <KdbxFile>[];

  /// What [KdbxBloc] does by the end of opening a file: register it, announce
  /// it, and - last - queue it when it turned out to carry duplicates.
  ///
  /// The real bloc reports at the very end of `_openFileContent`, with the
  /// file registered and nothing left to await, and the queue has a notifier
  /// of its own so that the order of these two does not matter.
  void open(FileSource fileSource, KdbxFile file, {bool duplicates = true}) {
    _opened[fileSource] = _FakeOpenedFile(fileSource, file);
    _openedFiles.add(OpenedKdbxFiles(_opened));
    if (duplicates && !_answered.contains(fileSource)) {
      _pending.add(fileSource);
      _pendingChanged.add(null);
    }
  }

  /// Named for what it stands in for rather than after [KdbxBloc.close],
  /// which takes the `KdbxFile` and would be an override.
  void closeFile(FileSource fileSource) {
    _opened.remove(fileSource);
    _pending.remove(fileSource);
    _answered.remove(fileSource);
    _openedFiles.add(OpenedKdbxFiles(_opened));
  }

  @override
  Stream<void> get duplicateUuidsPendingChanged => _pendingChanged.stream;

  @override
  FileSource? takePendingDuplicateUuidReport() {
    if (_pending.isEmpty) {
      return null;
    }
    final fileSource = _pending.removeAt(0);
    _answered.add(fileSource);
    return fileSource;
  }

  @override
  void returnPendingDuplicateUuidReport(FileSource fileSource) {
    if (!_answered.remove(fileSource)) {
      return;
    }
    _pending.add(fileSource);
    _pendingChanged.add(null);
  }

  @override
  KdbxOpenedFile? fileForFileSource(FileSource fileSource) =>
      _opened[fileSource];

  @override
  FileSource? fileSourceForKdbxFile(KdbxFile file) {
    for (final opened in _opened.entries) {
      if (opened.value.kdbxFile == file) {
        return opened.key;
      }
    }
    return null;
  }

  @override
  ValueStream<OpenedKdbxFiles> get openedFilesChanged => _openedFiles.stream;

  @override
  Future<List<KdbxUuid>> repairDuplicateUuidEntries(KdbxFile file) {
    repairCalls.add(file);
    final onRepair = this.onRepair;
    if (onRepair != null) {
      return onRepair(file);
    }
    return Future.value([KdbxUuid.random()]);
  }

  @override
  Future<void> dispose() async {
    await _openedFiles.close();
    await _pendingChanged.close();
  }
}

/// The watcher, around a scaffold which says [label].
Widget _watched(_FakeKdbxBloc bloc, String label) => Provider<KdbxBloc>.value(
  value: bloc,
  child: DuplicateUuidWatcher(child: Scaffold(body: Text(label))),
);

/// Mounts the watcher the way unlocking a database does: the file is opened -
/// and queued - while the select-file screen is still up, and then the unlock
/// flow throws away the whole route stack. The dialog must still arrive, which
/// is what went wrong when the bloc pushed it itself.
///
/// Answers the navigator key, for the tests which have to navigate again
/// afterwards.
Future<GlobalKey<NavigatorState>> _unlockThenMainApp(
  WidgetTester tester,
  _FakeKdbxBloc bloc, {
  bool quickUnlock = false,
}) async {
  final navigatorKey = GlobalKey<NavigatorState>();
  await tester.pumpWidget(
    MaterialApp(
      navigatorKey: navigatorKey,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales:
          const [Locale('en')] + AppLocalizations.supportedLocales,
      home: const Scaffold(body: Text('select file')),
    ),
  );
  final mainApp = MaterialPageRoute<void>(
    builder: (context) => Provider<KdbxBloc>.value(
      value: bloc,
      child: const DuplicateUuidWatcher(
        child: Scaffold(body: Text('main app')),
      ),
    ),
  );
  // not awaited: a push only completes once its route is popped again.
  if (quickUnlock) {
    unawaited(navigatorKey.currentState!.pushReplacement(mainApp));
  } else {
    unawaited(
      navigatorKey.currentState!.pushAndRemoveUntil(mainApp, (route) => false),
    );
  }
  await tester.pumpAndSettle();
  return navigatorKey;
}

void main() {
  late _FakeKdbxBloc bloc;
  late _FakeFileSource source;
  late _FakeKdbxFile file;

  setUp(() {
    bloc = _FakeKdbxBloc();
    source = _FakeFileSource('Test.kdbx');
    file = _FakeKdbxFile();
  });

  tearDown(() async {
    await bloc.dispose();
  });

  testWidgets('asks about a file which was queued before it was mounted', (
    tester,
  ) async {
    bloc.open(source, file);
    await _unlockThenMainApp(tester, bloc);

    expect(find.text('main app'), findsOneWidget);
    expect(find.text(loc.duplicateEntriesDialogTitle), findsOneWidget);
    expect(
      find.text(loc.duplicateEntriesDialogMessage('Test.kdbx', 1)),
      findsOneWidget,
    );
  });

  testWidgets('and after quick unlock, which replaces the route instead', (
    tester,
  ) async {
    bloc.open(source, file);
    await _unlockThenMainApp(tester, bloc, quickUnlock: true);

    expect(find.text(loc.duplicateEntriesDialogTitle), findsOneWidget);
  });

  testWidgets('repairs and reports when the user agrees', (tester) async {
    bloc.open(source, file);
    await _unlockThenMainApp(tester, bloc);

    await tester.tap(find.text(loc.duplicateEntriesRepairAction));
    await tester.pumpAndSettle();

    expect(bloc.repairCalls, [file]);
    expect(find.text(loc.duplicateEntriesRepairedMessage(1)), findsOneWidget);
  });

  testWidgets('repairs nothing when the user declines', (tester) async {
    bloc.open(source, file);
    await _unlockThenMainApp(tester, bloc);

    await tester.tap(find.text(loc.duplicateEntriesRepairLaterAction));
    await tester.pumpAndSettle();

    expect(bloc.repairCalls, isEmpty);
    expect(find.text(loc.duplicateEntriesDialogTitle), findsNothing);
  });

  testWidgets('says so when the repair went through but the save did not', (
    tester,
  ) async {
    bloc.onRepair = (file) async => throw DuplicateUuidRepairNotSavedException(
      [KdbxUuid.random()],
      'no connection',
      StackTrace.empty,
    );
    bloc.open(source, file);
    await _unlockThenMainApp(tester, bloc);

    await tester.tap(find.text(loc.duplicateEntriesRepairAction));
    await tester.pumpAndSettle();

    expect(
      find.text(loc.duplicateEntriesRepairNotSavedMessage),
      findsOneWidget,
      reason: 'the fold happened, so "could not be repaired" would be wrong',
    );
    expect(find.text(loc.duplicateEntriesRepairFailedMessage), findsNothing);
    await _dismiss(tester);
  });

  testWidgets('and tells them apart from a repair which did nothing', (
    tester,
  ) async {
    bloc.onRepair = (file) async => [];
    bloc.open(source, file);
    await _unlockThenMainApp(tester, bloc);

    await tester.tap(find.text(loc.duplicateEntriesRepairAction));
    await tester.pumpAndSettle();

    expect(find.text(loc.duplicateEntriesRepairFailedMessage), findsOneWidget);
    await _dismiss(tester);
  });

  testWidgets('reports a failed repair', (tester) async {
    bloc.onRepair = (file) async => throw Exception('broken');
    bloc.open(source, file);
    await _unlockThenMainApp(tester, bloc);

    await tester.tap(find.text(loc.duplicateEntriesRepairAction));
    await tester.pumpAndSettle();

    expect(find.text(loc.duplicateEntriesRepairFailedMessage), findsOneWidget);
    await _dismiss(tester);
  });

  testWidgets('says nothing about a file without duplicates', (tester) async {
    bloc.open(source, file, duplicates: false);
    await _unlockThenMainApp(tester, bloc);

    expect(find.text('main app'), findsOneWidget);
    expect(find.text(loc.duplicateEntriesDialogTitle), findsNothing);
  });

  testWidgets('asks about a file opened while it is already up', (
    tester,
  ) async {
    await _unlockThenMainApp(tester, bloc);
    expect(find.text(loc.duplicateEntriesDialogTitle), findsNothing);

    // a second database, or the remote content of a cloud file turning out to
    // have duplicates the cached content did not.
    bloc.open(source, file);
    await tester.pumpAndSettle();

    expect(find.text(loc.duplicateEntriesDialogTitle), findsOneWidget);
  });

  testWidgets('asks about several files one after another', (tester) async {
    final other = _FakeFileSource('Other.kdbx');
    bloc.open(source, file);
    bloc.open(other, _FakeKdbxFile(duplicates: 2));
    await _unlockThenMainApp(tester, bloc);

    expect(
      find.text(loc.duplicateEntriesDialogMessage('Test.kdbx', 1)),
      findsOneWidget,
    );
    expect(
      find.text(loc.duplicateEntriesDialogMessage('Other.kdbx', 2)),
      findsNothing,
      reason: 'one dialog at a time',
    );

    await tester.tap(find.text(loc.duplicateEntriesRepairLaterAction));
    await tester.pumpAndSettle();

    expect(
      find.text(loc.duplicateEntriesDialogMessage('Other.kdbx', 2)),
      findsOneWidget,
    );
  });

  testWidgets('does not repair a database which was closed while asking', (
    tester,
  ) async {
    bloc.open(source, file);
    await _unlockThenMainApp(tester, bloc);

    bloc.closeFile(source);
    await tester.tap(find.text(loc.duplicateEntriesRepairAction));
    await tester.pumpAndSettle();

    expect(
      bloc.repairCalls,
      isEmpty,
      reason: 'the file we were asking about is no longer open',
    );
  });

  testWidgets('leaves a second database to the watcher which stays', (
    tester,
  ) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    // database 1 is open, so a watcher is already mounted.
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales:
            const [Locale('en')] + AppLocalizations.supportedLocales,
        home: _watched(bloc, 'db1'),
      ),
    );
    // "Open another file" pushes the select file screen *over* the scaffold
    // rather than replacing it, so that first watcher stays mounted and keeps
    // its subscription.
    unawaited(
      navigatorKey.currentState!.push(
        MaterialPageRoute<void>(
          builder: (context) => const Scaffold(body: Text('select file')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // unlocking database 2: the open and the navigation are one turn, so both
    // watchers run their callback in the same frame, the doomed one first.
    bloc.open(source, file);
    unawaited(
      navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (context) => _watched(bloc, 'db2')),
        (route) => false,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('db2'), findsOneWidget);
    expect(find.text(loc.duplicateEntriesDialogTitle), findsOneWidget);

    await tester.tap(find.text(loc.duplicateEntriesRepairAction));
    await tester.pumpAndSettle();

    expect(
      bloc.repairCalls,
      [file],
      reason: 'the watcher being torn down must not be the one which asks',
    );
    expect(find.text(loc.duplicateEntriesRepairedMessage(1)), findsOneWidget);
  });

  testWidgets('and asks again if the unlock took the dialog with it', (
    tester,
  ) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales:
            const [Locale('en')] + AppLocalizations.supportedLocales,
        home: _watched(bloc, 'db1'),
      ),
    );
    unawaited(
      navigatorKey.currentState!.push(
        MaterialPageRoute<void>(
          builder: (context) => const Scaffold(body: Text('select file')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // The slow unlock path. Opening does real i/o after the file is queued -
    // quick unlock writes to the keystore, the autofill mirror reads files and
    // the keychain - so frames are produced before the unlock flow navigates,
    // and the watcher under the select file screen is still active when one
    // arrives. So it asks, and it is too early.
    bloc.open(source, file);
    await tester.pumpAndSettle();
    expect(find.text(loc.duplicateEntriesDialogTitle), findsOneWidget);

    unawaited(
      navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (context) => _watched(bloc, 'db2')),
        (route) => false,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(loc.duplicateEntriesDialogTitle),
      findsOneWidget,
      reason:
          'that dialog went with the route stack, so ask again rather '
          'than treating silence as "Not now"',
    );
    await tester.tap(find.text(loc.duplicateEntriesRepairAction));
    await tester.pumpAndSettle();

    expect(bloc.repairCalls, [file]);
  });

  testWidgets('but a question the user dismisses stays dismissed', (
    tester,
  ) async {
    bloc.open(source, file);
    await _unlockThenMainApp(tester, bloc);
    expect(find.text(loc.duplicateEntriesDialogTitle), findsOneWidget);

    // Tapping outside the dialog pops it with no result, exactly as the
    // Android back button and Escape do - and the other side of handing an
    // unanswered question back is that this must not count as one. It is the
    // user saying no.
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(
      find.text(loc.duplicateEntriesDialogTitle),
      findsNothing,
      reason:
          'handing this one back puts the same dialog straight back up, '
          'and then the only way out of it is a button',
    );
    expect(bloc.repairCalls, isEmpty);
  });

  testWidgets('repairs even when the screen it asked from is gone', (
    tester,
  ) async {
    bloc.open(source, file);
    var watcherMounted = true;
    late StateSetter rebuild;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales:
            const [Locale('en')] + AppLocalizations.supportedLocales,
        home: Provider<KdbxBloc>.value(
          value: bloc,
          child: StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return watcherMounted
                  ? const DuplicateUuidWatcher(
                      child: Scaffold(body: Text('main app')),
                    )
                  : const Scaffold(body: Text('main app'));
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(loc.duplicateEntriesDialogTitle), findsOneWidget);

    rebuild(() => watcherMounted = false);
    await tester.pumpAndSettle();
    expect(
      find.text(loc.duplicateEntriesDialogTitle),
      findsOneWidget,
      reason: 'the dialog is on the navigator, not inside the watcher',
    );

    await tester.tap(find.text(loc.duplicateEntriesRepairAction));
    await tester.pumpAndSettle();

    expect(
      bloc.repairCalls,
      [file],
      reason: 'the user said yes, and repairing needs nothing but the bloc',
    );
  });

  testWidgets('repairs the database which is open when the user agrees', (
    tester,
  ) async {
    bloc.open(source, file);
    await _unlockThenMainApp(tester, bloc);

    // the remote content of a cloud file replaces the cached content which was
    // asked about, while the dialog is still up.
    final remote = _FakeKdbxFile(duplicates: 3);
    bloc.open(source, remote);
    await tester.pumpAndSettle();

    await tester.tap(find.text(loc.duplicateEntriesRepairAction));
    await tester.pumpAndSettle();

    expect(
      bloc.repairCalls,
      [remote],
      reason: 'repairing the copy which is no longer open fixes nothing',
    );
  });

  testWidgets('says nothing when the duplicates are gone by then', (
    tester,
  ) async {
    bloc.open(source, file);
    await _unlockThenMainApp(tester, bloc);

    // same swap, except that the copy which arrived was already repaired on
    // another device.
    bloc.open(source, _FakeKdbxFile(duplicates: 0));
    await tester.pumpAndSettle();

    await tester.tap(find.text(loc.duplicateEntriesRepairAction));
    await tester.pumpAndSettle();

    expect(bloc.repairCalls, isEmpty);
    expect(
      find.text(loc.duplicateEntriesRepairFailedMessage),
      findsNothing,
      reason: 'there was nothing wrong with the database by the time we looked',
    );
    expect(find.text(loc.duplicateEntriesDialogTitle), findsNothing);
  });

  testWidgets('asks once while the file stays open', (tester) async {
    bloc.open(source, file);
    await _unlockThenMainApp(tester, bloc);
    await tester.tap(find.text(loc.duplicateEntriesRepairLaterAction));
    await tester.pumpAndSettle();

    // the remote content arrives and is reported a second time. Which set the
    // file lands in is [KdbxBloc]'s business; this is the watcher holding up
    // its end of it.
    bloc.open(source, file);
    await tester.pumpAndSettle();

    expect(find.text(loc.duplicateEntriesDialogTitle), findsNothing);
  });

  testWidgets('a snackbar undo offers nothing once its screen is gone', (
    tester,
  ) async {
    bloc.open(source, file, duplicates: false);
    late BuildContext snackbarContext;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales:
            const [Locale('en')] + AppLocalizations.supportedLocales,
        home: Provider<KdbxBloc>.value(
          value: bloc,
          child: Builder(
            builder: (context) {
              snackbarContext = context;
              return const Scaffold(body: Text('entry details'));
            },
          ),
        ),
      ),
    );
    // a snackbar outlives the screen which put it up, so by the time Undo is
    // tapped this element can be defunct.
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('somewhere else'))),
    );

    offerDuplicateUuidRepairForFile(snackbarContext, file);
    await tester.pumpAndSettle();

    expect(find.text(loc.duplicateEntriesDialogTitle), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('and offers nothing for a database which was closed', (
    tester,
  ) async {
    bloc.open(source, file, duplicates: false);
    late BuildContext screenContext;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales:
            const [Locale('en')] + AppLocalizations.supportedLocales,
        home: Provider<KdbxBloc>.value(
          value: bloc,
          child: Builder(
            builder: (context) {
              screenContext = context;
              return const Scaffold(body: Text('entry details'));
            },
          ),
        ),
      ),
    );

    bloc.closeFile(source);
    offerDuplicateUuidRepairForFile(screenContext, file);
    await tester.pumpAndSettle();

    expect(find.text(loc.duplicateEntriesDialogTitle), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

/// Error dialogs are guarded by a static "one at a time" flag which is only
/// cleared when the dialog closes, so leaving one up would leak into the next
/// test.
Future<void> _dismiss(WidgetTester tester) async {
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}
