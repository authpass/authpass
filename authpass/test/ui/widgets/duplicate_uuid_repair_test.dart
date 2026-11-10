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
  final _opened = <FileSource, KdbxOpenedFile>{};
  final _openedFiles = BehaviorSubject<OpenedKdbxFiles>();

  /// Stands in for the repair, which is otherwise a merge plus a save.
  Future<List<KdbxUuid>> Function(KdbxFile file)? onRepair;

  /// The files it was asked to repair, in order.
  final repairCalls = <KdbxFile>[];

  /// What [KdbxBloc] does while opening a file: register it, and queue it when
  /// it turned out to carry duplicates.
  void open(FileSource fileSource, KdbxFile file, {bool duplicates = true}) {
    _opened[fileSource] = _FakeOpenedFile(fileSource, file);
    if (duplicates) {
      _pending.add(fileSource);
    }
    _openedFiles.add(OpenedKdbxFiles(_opened));
  }

  /// Named for what it stands in for rather than after [KdbxBloc.close],
  /// which takes the `KdbxFile` and would be an override.
  void closeFile(FileSource fileSource) {
    _opened.remove(fileSource);
    _openedFiles.add(OpenedKdbxFiles(_opened));
  }

  @override
  FileSource? takePendingDuplicateUuidReport() =>
      _pending.isEmpty ? null : _pending.removeAt(0);

  @override
  KdbxOpenedFile? fileForFileSource(FileSource fileSource) =>
      _opened[fileSource];

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
  Future<void> dispose() => _openedFiles.close();
}

/// Mounts the watcher the way unlocking a database does: the file is opened -
/// and queued - while the select-file screen is still up, and then the unlock
/// flow throws away the whole route stack. The dialog must still arrive, which
/// is what went wrong when the bloc pushed it itself.
Future<void> _unlockThenMainApp(
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
}

/// Error dialogs are guarded by a static "one at a time" flag which is only
/// cleared when the dialog closes, so leaving one up would leak into the next
/// test.
Future<void> _dismiss(WidgetTester tester) async {
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}
