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
