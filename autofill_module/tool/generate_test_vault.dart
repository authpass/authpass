// Builds a vault for the Phase 0 memory measurement, plus the transformed key
// that opens it.
//
//   dart run tool/generate_test_vault.dart [entryCount] [iconCount]
//
// Writes vault.kdbx and vault_key.json next to the extension sources, where
// the Xcode target picks them up as bundle resources.
//
// The point is a *realistic* vault. Decrypting is cheap; what costs memory in
// an extension is the XML DOM and, above all, custom icons, so both are
// adjustable. Defaults roughly match a heavy real world database.
//
// The key material written here is throwaway — it opens nothing but this
// generated file, which is why it can sit in a bundle.

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:kdbx/kdbx.dart';

const _password = 'spike';
const _outputDir = '../authpass/ios/AuthPassAutofill/Fixtures';

Future<void> main(List<String> args) async {
  final entryCount = args.isNotEmpty ? int.parse(args[0]) : 2000;
  final iconCount = args.length > 1 ? int.parse(args[1]) : 30;

  final format = KdbxFormat();
  final file = format.create(
    Credentials(ProtectedValue.fromString(_password)),
    'AutoFill spike',
  );

  final random = Random(42);
  final icons = <KdbxCustomIcon>[];
  for (var i = 0; i < iconCount; i++) {
    // ~24kb each, which is what a png favicon of any ambition costs.
    final icon = KdbxCustomIcon(
      uuid: KdbxUuid.random(),
      data: _randomBytes(random, 24 * 1024),
    );
    file.body.meta.addCustomIcon(icon);
    icons.add(icon);
  }

  final group = file.body.rootGroup;
  for (var i = 0; i < entryCount; i++) {
    final entry = KdbxEntry.create(file, group);
    group.addEntry(entry);
    entry.setString(KdbxKeyCommon.TITLE, PlainValue('Account $i'));
    entry.setString(KdbxKeyCommon.USER_NAME, PlainValue('user$i@example.com'));
    entry.setString(
      KdbxKeyCommon.PASSWORD,
      ProtectedValue.fromString('correct horse battery staple $i'),
    );
    entry.setString(
      KdbxKeyCommon.URL,
      PlainValue('https://site$i.example.com'),
    );
    entry.setString(KdbxKey('Notes'), PlainValue('notes for account $i\n' * 4));
    if (icons.isNotEmpty) {
      entry.customIcon = icons[i % icons.length];
    }
  }

  stdout.writeln('deriving key (argon2 in pure dart, this takes a while)...');
  final bytes = await file.save();

  final credentials = file.transformedKeyCredentials;
  if (credentials == null) {
    stderr.writeln('kdbx did not hand out a transformed key.');
    exit(1);
  }

  final directory = Directory(_outputDir);
  directory.createSync(recursive: true);

  final vault = File('${directory.path}/vault.kdbx');
  vault.writeAsBytesSync(bytes);

  File('${directory.path}/vault_key.json').writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert({
      'transformedKey': base64.encode(credentials.transformedKey),
      'kdfFingerprint': credentials.kdfFingerprint,
      'entryCount': entryCount,
      'note':
          'throwaway key for the autofill spike, see tool/'
          'generate_test_vault.dart',
    }),
  );

  stdout.writeln(
    'wrote ${vault.path} '
    '(${(bytes.length / 1024 / 1024).toStringAsFixed(1)} MB, '
    '$entryCount entries, $iconCount icons)',
  );
}

Uint8List _randomBytes(Random random, int length) =>
    Uint8List.fromList(List.generate(length, (_) => random.nextInt(256)));
