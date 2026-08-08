@Tags(['fixture'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kdbx/kdbx.dart';

/// Checks the generated spike fixture the same way the extension opens it:
/// with the exported transformed key and no argon2 anywhere.
///
/// Tagged, because it needs `dart run tool/generate_test_vault.dart` first.
/// Run with `flutter test --tags=fixture`.
void main() {
  const fixtures = '../authpass/ios/AuthPassAutofill/Fixtures';

  test('the fixture opens with its transformed key', () async {
    final vault = File('$fixtures/vault.kdbx');
    final keyFile = File('$fixtures/vault_key.json');
    if (!vault.existsSync() || !keyFile.existsSync()) {
      fail('run: dart run tool/generate_test_vault.dart');
    }

    final key = json.decode(keyFile.readAsStringSync()) as Map<String, Object?>;
    final credentials = TransformedKeyCredentials(
      transformedKey: base64.decode(key['transformedKey']! as String),
      kdfFingerprint: key['kdfFingerprint']! as String,
    );

    final file = await KdbxFormat().read(vault.readAsBytesSync(), credentials);
    final entries = file.body.rootGroup.getAllEntries();
    expect(entries, hasLength(key['entryCount']));
    expect(
      entries.first.getString(KdbxKeyCommon.PASSWORD)!.getText(),
      startsWith('correct horse battery staple'),
    );
  });
}
