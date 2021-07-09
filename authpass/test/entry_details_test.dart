import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/screens/entry_details.dart';
import 'package:clock/clock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

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
  totpFieldName ??=
      fields.containsKey('TOTP Secret') ? 'TOTP Secret' : fields.keys.first;
  testWidgets(description, (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final file = KdbxFormat().create(
        Credentials.composite(ProtectedValue.fromString('asdf'), null), 'test');
    final entry = KdbxEntry.create(file, file.body.rootGroup);
    _createFields(entry, fields);
    await withClock(
        Clock(
            () => DateTime.utc(2020, 1, 1).subtract(const Duration(hours: 1))),
        () async {
      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales:
            const [Locale('en')] + AppLocalizations.supportedLocales,
        home: Scaffold(
          body: MultiProvider(
            providers: [
              Provider.value(value: CommonFields(AppLocalizationsEn()))
            ],
            child: EntryField(
                fieldType: FieldType.otp,
                entry: entry,
                fieldKey: KdbxKey(totpFieldName!),
                onChangedMetadata: () {}),
          ),
        ),
      ));
      final w = find
          .descendant(
            of: find.byType(EntryField),
            matching: find.byType(Text),
          )
          .first;
      expect(w, findsOneWidget);
      final otpCode = w.evaluate().single.widget as Text;
      expect(otpCode.data, expectCode);
    });
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
}
