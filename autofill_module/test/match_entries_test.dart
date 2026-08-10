import 'dart:io';

import 'package:authpass_autofill_module/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kdbx/kdbx.dart';

/// The lookup the credential provider actually performs.
///
/// Two vaults are opened at once and queried together, because the ordering
/// bug worth guarding against only shows up across files: a weak match in the
/// first vault must not outrank an exact one in the second.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tmp;
  late AutofillVaultService service;
  late List<Map<String, Object?>> vaultArgs;

  /// A vault written to disk, plus the arguments the native side would pass to
  /// open it — including the transformed key, exactly as the app caches it.
  Future<Map<String, Object?>> writeVault(
    String fileUuid,
    String name,
    Map<String, String> entries,
  ) async {
    final format = KdbxFormat();
    final file = format.create(
      Credentials.composite(ProtectedValue.fromString('pass-$fileUuid'), null),
      name,
    );
    for (final entry in entries.entries) {
      final kdbxEntry = KdbxEntry.create(file, file.body.rootGroup);
      file.body.rootGroup.addEntry(kdbxEntry);
      kdbxEntry.setString(KdbxKeyCommon.TITLE, PlainValue(entry.key));
      kdbxEntry.setString(KdbxKeyCommon.URL, PlainValue(entry.value));
      kdbxEntry.setString(
        KdbxKeyCommon.USER_NAME,
        PlainValue('user@${entry.key}'),
      );
      kdbxEntry.setString(
        KdbxKeyCommon.PASSWORD,
        ProtectedValue.fromString('secret-${entry.key}'),
      );
    }
    final bytes = await file.save();
    final path = '${tmp.path}/$fileUuid.kdbx';
    File(path).writeAsBytesSync(bytes);

    final credentials = file.transformedKeyCredentials!;
    return {
      'fileUuid': fileUuid,
      'name': name,
      'path': path,
      'transformedKey': Uint8List.fromList(credentials.transformedKey),
      'kdfFingerprint': credentials.kdfFingerprint,
    };
  }

  setUp(() async {
    tmp = Directory.systemTemp.createTempSync('autofill-match');
    service = AutofillVaultService();
    vaultArgs = [
      await writeVault('personal', 'Personal', {
        // a sibling host: matches accounts.google.com only by registrable domain
        'Google mail': 'https://mail.google.com/',
        'Unrelated': 'https://example.org/',
      }),
      await writeVault('work', 'Work', {
        // the exact host — must outrank the sibling above, despite coming second
        'Google account': 'https://accounts.google.com/signin',
        'Other': 'https://contoso.example/',
      }),
    ];
  });

  tearDown(() => tmp.deleteSync(recursive: true));

  Future<Object?> call(String method, [Map<String, Object?>? args]) {
    final handler = _handlerOf(service);
    return handler(MethodCall(method, args ?? const <String, Object?>{}));
  }

  test('opens several vaults and reports each one', () async {
    final result = await call('openVaults', {'vaults': vaultArgs});
    expect(result, isA<List<Object?>>());
    final statuses = (result! as List<Object?>)
        .cast<Map<Object?, Object?>>()
        .map((e) => '${e['fileUuid']}:${e['status']}')
        .toList();
    expect(statuses, ['personal:open', 'work:open']);
  });

  test('a broken vault does not sink the others', () async {
    final broken = Map<String, Object?>.from(vaultArgs.first)
      ..['path'] = '${tmp.path}/missing.kdbx';
    final result =
        (await call('openVaults', {
                  'vaults': [broken, vaultArgs.last],
                })
                as List<Object?>)
            .cast<Map<Object?, Object?>>();
    expect(result.first['status'], AutofillErrors.noVault);
    expect(result.last['status'], 'open');

    // and the surviving vault is still searchable
    final matches = await call('matchEntries', {
      'identifiers': ['https://accounts.google.com/'],
    });
    expect((matches! as List<Object?>), hasLength(1));
  });

  test('returns only what matches, best first, across vaults', () async {
    await call('openVaults', {'vaults': vaultArgs});
    final matches =
        (await call('matchEntries', {
                  'identifiers': ['https://accounts.google.com/signin'],
                })
                as List<Object?>)
            .cast<Map<Object?, Object?>>();

    // Neither `example.org` nor `contoso.example` may appear: filtering here
    // rather than natively is what keeps the channel cheap.
    expect(matches, hasLength(2));
    expect(matches.first['label'], 'Google account');
    expect(matches.first['fileUuid'], 'work');
    expect(matches.first['quality'], 'host');
    expect(matches.last['label'], 'Google mail');
    expect(matches.last['quality'], 'registrableDomain');
  });

  test('no password crosses the channel until one is chosen', () async {
    await call('openVaults', {'vaults': vaultArgs});
    final matches =
        (await call('matchEntries', {
                  'identifiers': ['https://accounts.google.com/'],
                })
                as List<Object?>)
            .cast<Map<Object?, Object?>>();
    for (final match in matches) {
      expect(match.keys, isNot(contains('password')));
    }

    final credential =
        (await call('credentialFor', {
              'fileUuid': 'work',
              'uuid': matches.first['uuid'],
            })
            as Map<Object?, Object?>);
    expect(credential['password'], 'secret-Google account');
    expect(credential['username'], 'user@Google account');
  });

  test('an unmatched request returns nothing rather than everything', () async {
    await call('openVaults', {'vaults': vaultArgs});
    final matches = await call('matchEntries', {
      'identifiers': ['https://nothing-stored-here.example/'],
    });
    expect(matches, isEmpty);
  });
}

/// Reaches the handler [AutofillVaultService.attach] installed, so the tests
/// exercise the same dispatch the native side reaches.
Future<Object?> Function(MethodCall) _handlerOf(AutofillVaultService service) {
  late Future<Object?> Function(MethodCall) captured;
  service.attach(_CapturingChannel((handler) => captured = handler));
  return captured;
}

class _CapturingChannel extends MethodChannel {
  _CapturingChannel(this.onHandler) : super('test');

  final void Function(Future<Object?> Function(MethodCall)) onHandler;

  @override
  void setMethodCallHandler(Future<Object?> Function(MethodCall)? handler) {
    onHandler(handler!);
  }
}
