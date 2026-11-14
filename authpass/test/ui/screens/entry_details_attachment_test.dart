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
import 'package:authpass/ui/screens/password_list.dart';
import 'package:authpass/ui/widgets/keyboard_handler.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:clock/clock.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../util/test_util.dart';
import '../../util/test_util.mocks.dart';

class _FakeAnalyticsEvents implements AnalyticsEvents {
  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

class _FakeAnalytics extends MockAnalytics {
  final _events = _FakeAnalyticsEvents();

  @override
  AnalyticsEvents get events => _events;
}

class _FakeFileSelector extends FileSelectorPlatform {
  _FakeFileSelector(this.file);

  final XFile file;

  @override
  Future<XFile?> openFile({
    List<XTypeGroup>? acceptedTypeGroups,
    String? initialDirectory,
    String? confirmButtonText,
  }) async => file;
}

void main() {
  PrintAppender.setupLogging();
  final testUtil = TestUtil();

  setUpAll(() => initializeDateFormatting('en'));

  late KdbxEntry entry;
  late MockKdbxBloc kdbxBloc;

  setUp(() {
    final file = testUtil.createFile();
    final rootGroup = file.body.rootGroup;
    // A new entry is dirty from the start (it sets its icon on creation),
    // so changes to it do not emit change events.
    entry = KdbxEntry.create(file, rootGroup);
    rootGroup.addEntry(entry);
    kdbxBloc = MockKdbxBloc();
    when(kdbxBloc.fileForKdbxFile(any)).thenReturn(
      KdbxOpenedFile(
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
      ),
    );
    when(kdbxBloc.attachmentInfo(any)).thenReturn(null);
    when(
      kdbxBloc.attachmentProviderForFileSource(any),
    ).thenAnswer((_) async => AttachmentProviderLocal());
  });

  Future<void> pumpDetails(WidgetTester tester) async {
    final env = await TestUtil.createEnv();
    // The providers sit above the `MaterialApp`, so that they are also
    // available to the bottom sheet and dialogs (routes of the navigator).
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<Env>.value(value: env),
          Provider<AppData>.value(value: AppData()),
          Provider<KdbxBloc>.value(value: kdbxBloc),
          Provider<Analytics>.value(value: _FakeAnalytics()),
          Provider.value(value: CommonFields(AppLocalizationsEn())),
          Provider.value(value: KeyboardShortcutEvents()),
          Provider.value(value: FormatUtils(locale: 'en')),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales:
              const [Locale('en')] + AppLocalizations.supportedLocales,
          home: Scaffold(
            body: EntryDetails(
              entry: EntryViewModel(entry, kdbxBloc),
              onSavedPressed: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('removed attachment disappears from the list', (tester) async {
    tester.view.physicalSize = const Size(1000, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    entry.createBinary(
      isProtected: false,
      name: 'a.txt',
      bytes: Uint8List.fromList([1, 2, 3]),
    );
    await pumpDetails(tester);
    expect(find.text('a.txt'), findsOneWidget);

    await tester.tap(find.text('a.txt'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'OK'));
    await tester.pumpAndSettle();

    expect(find.text('a.txt'), findsNothing);
  });

  testWidgets('attached file appears in the list', (tester) async {
    tester.view.physicalSize = const Size(1000, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final previous = FileSelectorPlatform.instance;
    FileSelectorPlatform.instance = _FakeFileSelector(
      XFile.fromData(Uint8List.fromList([104, 105]), path: '/tmp/b.txt'),
    );
    addTearDown(() => FileSelectorPlatform.instance = previous);
    await pumpDetails(tester);
    expect(find.text('b.txt'), findsNothing);

    await tester.tap(find.text('Add Attachment'));
    await tester.pumpAndSettle();

    expect(find.text('b.txt'), findsOneWidget);
  });
}
