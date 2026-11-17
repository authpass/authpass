import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/authpass_cloud_bloc.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/l10n-generated/app_localizations.dart';
import 'package:authpass/l10n-generated/app_localizations_en.dart';
import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/screens/entry_details.dart';
import 'package:authpass/ui/screens/password_list.dart';
import 'package:authpass/ui/widgets/keyboard_handler.dart';
import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

class _FakeFeatureFlags extends Fake implements FeatureFlags {
  @override
  bool? get authpassCloud => true;
}

class _FakeCloudBloc extends Fake implements AuthPassCloudBloc {
  @override
  FeatureFlags get featureFlags => _FakeFeatureFlags();

  @override
  TokenStatus get tokenStatus => TokenStatus.confirmed;

  @override
  Future<String?> createMailbox({
    String label = CharConstants.empty,
    String entryUuid = CharConstants.empty,
  }) async => 'mailbox@example.com';
}

class _FakeAnalyticsEvents extends Fake implements AnalyticsEvents {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeAnalytics extends Fake implements Analytics {
  @override
  final AnalyticsEvents events = _FakeAnalyticsEvents();
}

class _FakeEnv extends Fake implements Env {
  @override
  bool get featureFetchWebsiteIconEnabledByDefault => false;
}

class _FakeAppData extends Fake implements AppData {
  @override
  bool? get fetchWebsiteIcons => false;
}

class _FakeOpenedFile extends Fake implements OpenedFile {
  @override
  Color? get color => null;
}

class _FakeKdbxOpenedFile extends Fake implements KdbxOpenedFile {
  @override
  final OpenedFile openedFile = _FakeOpenedFile();
}

class _FakeKdbxBloc extends Fake implements KdbxBloc {
  @override
  KdbxOpenedFile fileForKdbxFile(KdbxFile file) => _FakeKdbxOpenedFile();
}

/// Hosts [EntryDetails] the way the entry details screen does: a new
/// [EntryViewModel] is created whenever the file reports a changed object.
class _ScreenHost extends StatefulWidget {
  const _ScreenHost({required this.entry, required this.kdbxBloc});

  final KdbxEntry entry;
  final KdbxBloc kdbxBloc;

  @override
  State<_ScreenHost> createState() => _ScreenHostState();
}

class _ScreenHostState extends State<_ScreenHost> {
  late EntryViewModel vm = EntryViewModel(widget.entry, widget.kdbxBloc);

  @override
  void initState() {
    super.initState();
    widget.entry.file.dirtyObjectsChanged.listen((event) {
      setState(() => vm = EntryViewModel(widget.entry, widget.kdbxBloc));
    });
  }

  @override
  Widget build(BuildContext context) =>
      EntryDetails(entry: vm, onSavedPressed: null);
}

/// Hosts one field like the entry details do: the field gets a new state when
/// its key changes, and the pending edits belong to the host.
class _FieldHost extends StatefulWidget {
  const _FieldHost({
    required this.entry,
    required this.commonFields,
    required this.pendingEdits,
  });

  final KdbxEntry entry;
  final CommonFields commonFields;
  final Map<KdbxKey, String> pendingEdits;

  @override
  State<_FieldHost> createState() => _FieldHostState();
}

class _FieldHostState extends State<_FieldHost> {
  final Map<KdbxKey, GlobalKey> _stateKeys = {};

  KdbxKey get _fieldKey => widget.entry.stringEntries
      .map((e) => e.key)
      .firstWhere((k) => k != KdbxKeyCommon.TITLE);

  @override
  Widget build(BuildContext context) {
    final key = _fieldKey;
    return Column(
      children: [
        EntryField(
          key: _stateKeys.putIfAbsent(key, GlobalKey.new),
          fieldType: FieldType.string,
          entry: widget.entry,
          fieldKey: key,
          commonField: widget.commonFields[key],
          pendingEdits: widget.pendingEdits,
          onChangedMetadata: () => setState(() {}),
        ),
        const TextField(key: ValueKey('other')),
      ],
    );
  }
}

void _createFields(KdbxEntry entry, Map<String, String> fields) {
  for (final e in fields.entries) {
    entry.setString(KdbxKey(e.key), ProtectedValue.fromString(e.value));
  }
}

@isTest
void _testTotp(
  String description, {
  required Map<String, String> fields,
  required String expectCode,
  String? totpFieldName,
}) {
  totpFieldName ??= fields.containsKey('TOTP Secret')
      ? 'TOTP Secret'
      : fields.keys.first;
  testWidgets(description, (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final file = KdbxFormat().create(
      Credentials.composite(ProtectedValue.fromString('asdf'), null),
      'test',
    );
    final entry = KdbxEntry.create(file, file.body.rootGroup);
    _createFields(entry, fields);
    await withClock(
      Clock(() => DateTime.utc(2020, 1, 1).subtract(const Duration(hours: 1))),
      () async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales:
                const [Locale('en')] + AppLocalizations.supportedLocales,
            home: Scaffold(
              body: MultiProvider(
                providers: [
                  Provider.value(value: CommonFields(AppLocalizationsEn())),
                ],
                child: EntryField(
                  fieldType: FieldType.otp,
                  entry: entry,
                  fieldKey: KdbxKey(totpFieldName!),
                  onChangedMetadata: () {},
                ),
              ),
            ),
          ),
        );
        final w = find
            .descendant(
              of: find.byType(EntryField),
              matching: find.byType(Text),
            )
            .first;
        expect(w, findsOneWidget);
        final otpCode = w.evaluate().single.widget as Text;
        expect(otpCode.data, expectCode);
      },
    );
  });
}

void main() {
  PrintAppender.setupLogging();
  group('TOTP Codes', () {
    _testTotp(
      'base32 code',
      fields: {
        'TOTP Seed': '3TBQAZ2XLJ54LTUMVVLJTPAST5TZANMF',
        'TOTP Settings': '30;6',
      },
      expectCode: '059989',
    );
    _testTotp(
      'base32 with spaces',
      fields: {
        'TOTP Seed': 'g33a l2j6 hqzv djri wtwp 4yhv iu74 4ue4',
        'TOTP Settings': '30;6',
      },
      expectCode: '872187',
    );
    _testTotp(
      'base32 with empty settings',
      fields: {
        'TOTP Seed': 'g33a l2j6 hqzv djri wtwp 4yhv iu74 4ue4',
        'TOTP Settings': '',
      },
      expectCode: '872187',
    );
    _testTotp(
      'otpauth url',
      fields: {
        'otp':
            'otpauth://totp/test?secret=27zzsdziauhmftpf33sc5ksvmcn3crljhrusmxmmjt2tkht4huny5ozk&algorithm=SHA256&digits=6&period=30',
      },
      expectCode: '412013',
    );
  });

  group('Protected field editing', () {
    final formKey = GlobalKey<FormState>();

    // the fake cloud bloc is a Listenable, which Provider would reject.
    final defaultValueCheck = Provider.debugCheckInvalidValueType;
    setUp(() => Provider.debugCheckInvalidValueType = null);
    tearDown(() => Provider.debugCheckInvalidValueType = defaultValueCheck);

    Future<KdbxEntry> pumpPasswordField(WidgetTester tester) async {
      final file = KdbxFormat().create(
        Credentials.composite(ProtectedValue.fromString('asdf'), null),
        'test',
      );
      final entry = KdbxEntry.create(file, file.body.rootGroup);
      entry.setString(
        KdbxKeyCommon.PASSWORD,
        ProtectedValue.fromString('original'),
      );
      entry.setString(KdbxKeyCommon.TITLE, PlainValue('title'));
      file.body.rootGroup.addEntry(entry);
      final commonFields = CommonFields(AppLocalizationsEn());
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales:
              const [Locale('en')] + AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MultiProvider(
              providers: [
                Provider.value(value: commonFields),
                Provider.value(value: KeyboardShortcutEvents()),
                Provider<AuthPassCloudBloc>.value(value: _FakeCloudBloc()),
                Provider<Analytics>.value(value: _FakeAnalytics()),
              ],
              child: Form(
                key: formKey,
                child: _FieldHost(
                  entry: entry,
                  commonFields: commonFields,
                  pendingEdits: {},
                ),
              ),
            ),
          ),
        ),
      );
      // reveal the protected field and start editing.
      await tester.tap(find.byType(ObscuredEntryFieldEditor));
      await tester.pump();
      await tester.pump();
      return entry;
    }

    testWidgets('edited password is not written before saving', (
      tester,
    ) async {
      final entry = await pumpPasswordField(tester);
      await tester.enterText(find.byType(TextFormField), 'clobbered');
      // moving the focus to another field hides the password again.
      await tester.tap(find.byKey(const ValueKey('other')));
      await tester.pump();
      expect(find.byType(ObscuredEntryFieldEditor), findsOneWidget);
      // discarding the form: the entry must still have the saved password.
      expect(
        entry.getString(KdbxKeyCommon.PASSWORD)!.getText(),
        'original',
      );
    });

    testWidgets('edited password is written when saving', (tester) async {
      final entry = await pumpPasswordField(tester);
      await tester.enterText(find.byType(TextFormField), 'changed');
      await tester.tap(find.byKey(const ValueKey('other')));
      await tester.pump();
      expect(find.byType(ObscuredEntryFieldEditor), findsOneWidget);
      formKey.currentState!.save();
      expect(entry.getString(KdbxKeyCommon.PASSWORD)!.getText(), 'changed');
      expect(entry.getString(KdbxKeyCommon.PASSWORD), isA<ProtectedValue>());
    });

    testWidgets('unprotecting a field does not write a pending edit', (
      tester,
    ) async {
      final entry = await pumpPasswordField(tester);
      await tester.enterText(find.byType(TextFormField), 'clobbered');
      await tester.tap(find.byKey(const ValueKey('other')));
      await tester.pump();
      expect(find.byType(ObscuredEntryFieldEditor), findsOneWidget);
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppLocalizationsEn().fieldUnprotect));
      await tester.pumpAndSettle();
      // the entry still has the saved text, and was only unprotected.
      expect(
        entry.getString(KdbxKeyCommon.PASSWORD)!.getText(),
        'original',
      );
      expect(entry.getString(KdbxKeyCommon.PASSWORD), isA<PlainValue>());
      formKey.currentState!.save();
      expect(entry.getString(KdbxKeyCommon.PASSWORD)!.getText(), 'clobbered');
      expect(entry.getString(KdbxKeyCommon.PASSWORD), isA<PlainValue>());
    });

    testWidgets('a newer edit after unprotecting is not replaced', (
      tester,
    ) async {
      final entry = await pumpPasswordField(tester);
      await tester.enterText(find.byType(TextFormField), 'P');
      await tester.tap(find.byKey(const ValueKey('other')));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppLocalizationsEn().fieldUnprotect));
      await tester.pumpAndSettle();
      // reveal again and replace the text with a newer edit.
      await tester.tap(find.byType(ObscuredEntryFieldEditor));
      await tester.pump();
      await tester.pump();
      await tester.enterText(find.byType(TextFormField), 'Q');
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppLocalizationsEn().fieldProtect));
      await tester.pumpAndSettle();
      formKey.currentState!.save();
      expect(entry.getString(KdbxKeyCommon.PASSWORD)!.getText(), 'Q');
    });

    Future<void> menu(WidgetTester tester, String label) async {
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }

    Future<void> editAndHide(WidgetTester tester, String text) async {
      await tester.enterText(find.byType(TextFormField), text);
      await tester.tap(find.byKey(const ValueKey('other')));
      await tester.pump();
      expect(find.byType(ObscuredEntryFieldEditor), findsOneWidget);
    }

    Future<void> rename(WidgetTester tester, String name) async {
      await menu(tester, AppLocalizationsEn().fieldRename);
      await tester.enterText(
        find.descendant(
          of: find.byType(SimplePromptDialog),
          matching: find.byType(TextField),
        ),
        name,
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
    }

    testWidgets('renaming a field does not write its pending edit', (
      tester,
    ) async {
      final entry = await pumpPasswordField(tester);
      await editAndHide(tester, 'changed');
      await rename(tester, 'Renamed');
      // only the key changed; the edit stays out of the entry until saved.
      expect(entry.getString(KdbxKey('Renamed'))!.getText(), 'original');
      expect(entry.getString(KdbxKey('Renamed')), isA<ProtectedValue>());
    });

    testWidgets('a renamed field saves its pending edit under the new key', (
      tester,
    ) async {
      final entry = await pumpPasswordField(tester);
      await editAndHide(tester, 'changed');
      await rename(tester, 'Renamed');
      expect(find.byType(ObscuredEntryFieldEditor), findsOneWidget);
      formKey.currentState!.save();
      expect(entry.getString(KdbxKey('Renamed'))!.getText(), 'changed');
      expect(entry.getString(KdbxKey('Renamed')), isA<ProtectedValue>());
      expect(entry.getString(KdbxKeyCommon.PASSWORD), isNull);
    });

    testWidgets('protecting a field does not write an unsaved edit', (
      tester,
    ) async {
      final entry = await pumpPasswordField(tester);
      // make the field a plain one first, with its text field showing.
      await menu(tester, AppLocalizationsEn().fieldUnprotect);
      await tester.tap(find.byType(ObscuredEntryFieldEditor));
      await tester.pump();
      await tester.pump();
      await tester.enterText(find.byType(TextFormField), 'clobbered');
      await menu(tester, AppLocalizationsEn().fieldProtect);
      // discarding the form here leaves the stored text alone.
      expect(entry.getString(KdbxKeyCommon.PASSWORD)!.getText(), 'original');
      expect(entry.getString(KdbxKeyCommon.PASSWORD), isA<ProtectedValue>());
      formKey.currentState!.save();
      expect(entry.getString(KdbxKeyCommon.PASSWORD)!.getText(), 'clobbered');
      expect(entry.getString(KdbxKeyCommon.PASSWORD), isA<ProtectedValue>());
    });

    testWidgets('a generated email address does not bring back an old edit', (
      tester,
    ) async {
      final entry = await pumpPasswordField(tester);
      await editAndHide(tester, 'stale');
      await menu(tester, AppLocalizationsEn().fieldGenerateEmail);
      expect(
        entry.getString(KdbxKeyCommon.PASSWORD)!.getText(),
        'mailbox@example.com',
      );
      await menu(tester, AppLocalizationsEn().fieldProtect);
      formKey.currentState!.save();
      expect(
        entry.getString(KdbxKeyCommon.PASSWORD)!.getText(),
        'mailbox@example.com',
      );
    });
  });

  group('Protected field editing on the entry details', () {
    final formKey = GlobalKey<FormState>();
    final passwordField = find.byWidgetPredicate(
      (w) => w is EntryField && w.fieldKey == KdbxKeyCommon.PASSWORD,
    );
    final renamedField = find.byWidgetPredicate(
      (w) => w is EntryField && w.fieldKey == KdbxKey('Renamed'),
    );

    final defaultValueCheck = Provider.debugCheckInvalidValueType;
    setUpAll(() => initializeDateFormatting('en'));
    setUp(() => Provider.debugCheckInvalidValueType = null);
    tearDown(() => Provider.debugCheckInvalidValueType = defaultValueCheck);

    Future<KdbxEntry> pumpDetails(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1000, 3000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final file = KdbxFormat().create(
        Credentials.composite(ProtectedValue.fromString('asdf'), null),
        'test',
      );
      final entry = KdbxEntry.create(file, file.body.rootGroup);
      entry.setString(
        KdbxKeyCommon.PASSWORD,
        ProtectedValue.fromString('original'),
      );
      entry.setString(KdbxKeyCommon.TITLE, PlainValue('title'));
      file.body.rootGroup.addEntry(entry);
      final kdbxBloc = _FakeKdbxBloc();
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales:
              const [Locale('en')] + AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MultiProvider(
              providers: [
                Provider.value(value: CommonFields(AppLocalizationsEn())),
                Provider.value(value: KeyboardShortcutEvents()),
                Provider.value(value: FormatUtils(locale: 'en')),
                Provider<KdbxBloc>.value(value: kdbxBloc),
                Provider<Env>.value(value: _FakeEnv()),
                Provider<AppData>.value(value: _FakeAppData()),
                Provider<AuthPassCloudBloc>.value(value: _FakeCloudBloc()),
                Provider<Analytics>.value(value: _FakeAnalytics()),
              ],
              child: Form(
                key: formKey,
                child: _ScreenHost(entry: entry, kdbxBloc: kdbxBloc),
              ),
            ),
          ),
        ),
      );
      // reveal the protected field and edit it, then hide it again.
      await tester.tap(
        find.descendant(
          of: passwordField,
          matching: find.byType(ObscuredEntryFieldEditor),
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.enterText(
        find.descendant(
          of: passwordField,
          matching: find.byType(TextFormField),
        ),
        'changed',
      );
      await tester.tap(find.widgetWithText(TextFormField, 'title'));
      await tester.pump();
      expect(
        find.descendant(
          of: passwordField,
          matching: find.byType(ObscuredEntryFieldEditor),
        ),
        findsOneWidget,
      );
      return entry;
    }

    Future<void> menu(WidgetTester tester, Finder field, String label) async {
      await tester.tap(
        find.descendant(of: field, matching: find.byIcon(Icons.more_vert)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }

    Future<void> rename(WidgetTester tester) async {
      await menu(tester, passwordField, AppLocalizationsEn().fieldRename);
      await tester.enterText(
        find.descendant(
          of: find.byType(SimplePromptDialog),
          matching: find.byType(TextField),
        ),
        'Renamed',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
    }

    testWidgets('a pending edit survives renaming and is saved', (
      tester,
    ) async {
      final entry = await pumpDetails(tester);
      await rename(tester);
      formKey.currentState!.save();
      expect(entry.getString(KdbxKey('Renamed'))!.getText(), 'changed');
      expect(entry.getString(KdbxKey('Renamed')), isA<ProtectedValue>());
    });

    testWidgets('a pending edit survives toggling protection and is saved', (
      tester,
    ) async {
      final entry = await pumpDetails(tester);
      await menu(tester, passwordField, AppLocalizationsEn().fieldUnprotect);
      await menu(tester, passwordField, AppLocalizationsEn().fieldProtect);
      formKey.currentState!.save();
      expect(entry.getString(KdbxKeyCommon.PASSWORD)!.getText(), 'changed');
      expect(entry.getString(KdbxKeyCommon.PASSWORD), isA<ProtectedValue>());
    });

    testWidgets('discarding after renaming keeps the stored value', (
      tester,
    ) async {
      final entry = await pumpDetails(tester);
      await rename(tester);
      expect(renamedField, findsOneWidget);
      expect(entry.getString(KdbxKey('Renamed'))!.getText(), 'original');
    });
  });
}
