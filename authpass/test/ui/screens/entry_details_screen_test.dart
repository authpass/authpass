import 'dart:typed_data';

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/l10n-generated/app_localizations.dart';
import 'package:authpass/l10n-generated/app_localizations_en.dart';
import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/screens/entry_details.dart';
import 'package:authpass/ui/widgets/keyboard_handler.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kdbx/kdbx.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../util/test_util.dart';
import '../../util/test_util.mocks.dart';

class _FakeAnalyticsEvents extends Fake implements AnalyticsEvents {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeAnalytics extends Fake implements Analytics {
  @override
  final AnalyticsEvents events = _FakeAnalyticsEvents();
}

class _RecordingKdbxBloc extends MockKdbxBloc {
  final discarded = <KdbxEntry>[];

  @override
  bool discardUntouchedNewEntry(KdbxEntry entry) {
    discarded.add(entry);
    return true;
  }
}

void main() {
  /// The provider tree the screen needs, as a value so a test can pump it
  /// twice and so hand the screen a new widget instance - which is what an
  /// ancestor rebuild does in the app.
  Widget app({
    required KdbxEntry entry,
    required KdbxBloc kdbxBloc,
    required KdbxOpenedFile openedFile,
    required Env env,
  }) => MultiProvider(
    providers: [
      Provider<Env>.value(value: env),
      Provider<KdbxBloc>.value(value: kdbxBloc),
      Provider.value(value: AppData()),
      Provider.value(
        value: OpenedKdbxFiles({openedFile.fileSource: openedFile}),
      ),
      Provider<Analytics>.value(value: _FakeAnalytics()),
      Provider.value(value: CommonFields(AppLocalizationsEn())),
      Provider.value(value: FormatUtils(locale: 'en')),
      Provider.value(value: KeyboardShortcutEvents()),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.of(
            context,
          ).push(EntryDetailsScreen.route(entry: entry)),
          child: const Text('open'),
        ),
      ),
    ),
  );

  // Issue #199: the screen rebuilds from `KdbxFile.dirtyObjectsChanged`, but
  // that subscription used to live in the bag `KdbxObjectSavableStateMixin`
  // empties on every `didUpdateWidget`, and nothing re-registered it. One
  // ancestor rebuild and the screen stopped reacting to the file for good -
  // an attachment added, the header, an entry a sync brought in.
  testWidgets('the attachment list still follows the file after a rebuild', (
    tester,
  ) async {
    await initializeDateFormatting('en');
    // Tall enough that the attachment rows are laid out rather than left
    // below the fold, where `find.text` would not see them.
    tester.view.physicalSize = const Size(1000, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final file = TestUtil().createFile();
    final entry = KdbxEntry.create(file, file.body.rootGroup);
    file.body.rootGroup.addEntry(entry);
    entry.createBinary(
      isProtected: false,
      name: 'a.txt',
      bytes: Uint8List.fromList([1]),
    );

    final kdbxBloc = _RecordingKdbxBloc();
    final openedFile = KdbxOpenedFile(
      fileSource: FileSourceUrl(
        Uri.parse('https://authpass.app/'),
        uuid: AppDataBloc.createUuid(),
      ),
      openedFile: OpenedFile(
        (b) => b
          ..lastOpenedAt = clock.now().toUtc()
          ..uuid = AppDataBloc.createUuid()
          ..sourceType = OpenedFilesSourceType.Url
          ..sourcePath = 'foo'
          ..name = 'bar',
      ),
      kdbxFile: file,
      kdbxFileContent: FileContent(Uint8List(0)),
    );
    when(kdbxBloc.fileForKdbxFile(any)).thenReturn(openedFile);
    when(kdbxBloc.openedFilesKdbx).thenReturn([file]);
    // Null is what a plain, non-cloud attachment gets; the mock is strict, so
    // leaving it unstubbed throws while building the row.
    when(kdbxBloc.attachmentInfo(any)).thenReturn(null);

    final env = await TestUtil.createEnv();
    final widget = app(
      entry: entry,
      kdbxBloc: kdbxBloc,
      openedFile: openedFile,
      env: env,
    );
    await tester.pumpWidget(widget);
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('a.txt'), findsOneWidget);

    // The rebuild has to come first: it is what used to cancel the
    // subscription, so a change made afterwards is the one that goes unseen.
    await tester.pumpWidget(
      app(
        entry: entry,
        kdbxBloc: kdbxBloc,
        openedFile: openedFile,
        env: env,
      ),
    );
    await tester.pumpAndSettle();

    entry.createBinary(
      isProtected: false,
      name: 'b.txt',
      bytes: Uint8List.fromList([2]),
    );
    await tester.pumpAndSettle();

    expect(find.text('b.txt'), findsOneWidget);
    expect(find.text('a.txt'), findsOneWidget);
  });

  testWidgets('leaving the entry details hands the entry to the bloc', (
    tester,
  ) async {
    await initializeDateFormatting('en');
    final file = TestUtil().createFile();
    final entry = KdbxEntry.create(file, file.body.rootGroup);
    file.body.rootGroup.addEntry(entry);

    final kdbxBloc = _RecordingKdbxBloc();
    final openedFile = KdbxOpenedFile(
      fileSource: FileSourceUrl(
        Uri.parse('https://authpass.app/'),
        uuid: AppDataBloc.createUuid(),
      ),
      openedFile: OpenedFile(
        (b) => b
          ..lastOpenedAt = clock.now().toUtc()
          ..uuid = AppDataBloc.createUuid()
          ..sourceType = OpenedFilesSourceType.Url
          ..sourcePath = 'foo'
          ..name = 'bar',
      ),
      kdbxFile: file,
      kdbxFileContent: FileContent(Uint8List(0)),
    );
    when(kdbxBloc.fileForKdbxFile(any)).thenReturn(openedFile);
    when(kdbxBloc.openedFilesKdbx).thenReturn([file]);

    final env = await TestUtil.createEnv();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<Env>.value(value: env),
          Provider<KdbxBloc>.value(value: kdbxBloc),
          Provider.value(value: AppData()),
          Provider.value(
            value: OpenedKdbxFiles({openedFile.fileSource: openedFile}),
          ),
          Provider<Analytics>.value(value: _FakeAnalytics()),
          Provider.value(value: CommonFields(AppLocalizationsEn())),
          Provider.value(value: FormatUtils(locale: 'en')),
          Provider.value(value: KeyboardShortcutEvents()),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(
                context,
              ).push(EntryDetailsScreen.route(entry: entry)),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(EntryDetailsScreen), findsOneWidget);
    expect(kdbxBloc.discarded, isEmpty);

    // The form was not changed, so going back does not ask for confirmation.
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byType(EntryDetailsScreen), findsNothing);
    expect(kdbxBloc.discarded, [entry]);
  });
}
