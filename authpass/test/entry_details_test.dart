import 'dart:typed_data';

import 'package:authpass/l10n-generated/app_localizations.dart';
import 'package:authpass/l10n-generated/app_localizations_en.dart';
import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/screens/entry_details.dart';
import 'package:authpass/utils/otpauth.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
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
    _testTotp(
      'legacy OTPAuth field still generates codes',
      fields: {
        'OTPAuth':
            'otpauth://totp/test?secret=27zzsdziauhmftpf33sc5ksvmcn3crljhrusmxmmjt2tkht4huny5ozk&algorithm=SHA256&digits=6&period=30',
      },
      expectCode: '412013',
    );
    _testTotp(
      'entry with both otp and legacy OTPAuth: standard field is used',
      fields: {
        'OTPAuth':
            'otpauth://totp/legacy?secret=g33al2j6hqzvdjriwtwp4yhviu744ue4',
        'otp':
            'otpauth://totp/test?secret=27zzsdziauhmftpf33sc5ksvmcn3crljhrusmxmmjt2tkht4huny5ozk&algorithm=SHA256&digits=6&period=30',
      },
      totpFieldName: 'otp',
      expectCode: '412013',
    );
    _testTotp(
      'entry with both otp and legacy OTPAuth: legacy field still works',
      fields: {
        'OTPAuth':
            'otpauth://totp/test?secret=27zzsdziauhmftpf33sc5ksvmcn3crljhrusmxmmjt2tkht4huny5ozk&algorithm=SHA256&digits=6&period=30',
        'otp': 'otpauth://totp/other?secret=g33al2j6hqzvdjriwtwp4yhviu744ue4',
      },
      totpFieldName: 'OTPAuth',
      expectCode: '412013',
    );
  });

  group('TOTP field name', () {
    final commonFields = CommonFields(AppLocalizationsEn());

    test('standard field is otp, as used by KeePassXC', () {
      expect(commonFields.otp.key.key, 'otp');
      expect(commonFields.isCommon(commonFields.otp.key), isTrue);
      expect(commonFields.otp.protect, isTrue);
    });

    test('legacy and compatibility fields are still recognized as TOTP', () {
      expect(commonFields.isTotp(KdbxKey('otp')), isTrue);
      expect(commonFields.isTotp(KdbxKey('OTPAuth')), isTrue);
      expect(commonFields.isTotp(KdbxKey('TOTP Seed')), isTrue);
      expect(commonFields.isTotp(KdbxKey('Password')), isFalse);
    });

    test('standard field is listed before the legacy field', () {
      final keys = commonFields.fields.map((f) => f.key.key).toList();
      expect(keys.indexOf('otp'), lessThan(keys.indexOf('OTPAuth')));
    });

    test('toUri generates an otpauth url', () {
      final value = OtpAuth(
        secret: Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]),
      ).toUri().toString();
      expect(value, startsWith('otpauth://totp'));
    });

    test('setTotp stores otp and replaces the legacy field', () {
      final file = KdbxFormat().create(
        Credentials.composite(ProtectedValue.fromString('asdf'), null),
        'test',
      );
      final entry = KdbxEntry.create(file, file.body.rootGroup);
      _createFields(entry, {
        'OTPAuth': 'otpauth://totp/a?secret=OLDOLDOLDOLDOLDO',
      });
      const url = 'otpauth://totp/a?secret=NEWNEWNEWNEWNEWN';
      commonFields.setTotp(entry, url);
      expect(entry.getString(KdbxKey('otp'))?.getText(), url);
      expect(entry.getString(KdbxKey('OTPAuth')), isNull);
    });

    testWidgets('add field menu offers a single TOTP entry, stored as otp', (
      tester,
    ) async {
      KdbxKey? added;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales:
              const [Locale('en')] + AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Provider.value(
              value: commonFields,
              child: AddFieldButton(onAddField: (key) => added = key),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AddFieldButton));
      await tester.pumpAndSettle();
      final totp = find.text(AppLocalizationsEn().fieldTotp);
      expect(totp, findsOneWidget);
      await tester.tap(totp);
      await tester.pumpAndSettle();
      expect(added?.key, 'otp');
    });
  });
}
