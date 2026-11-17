import 'dart:typed_data';

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:authpass/l10n-generated/app_localizations.dart';
import 'package:authpass/ui/widgets/password_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kdbx/kdbx.dart';

import 'util/test_util.dart';

/// A database which only exists as bytes in memory.
class _MemoryFileSource extends FileSource {
  _MemoryFileSource(this.bytes)
    : super(databaseName: 'test', uuid: 'memory-source');

  final Uint8List bytes;

  @override
  Stream<FileContent> load() async* {
    yield FileContent(bytes, const <String, dynamic>{});
  }

  @override
  Future<Map<String, dynamic>?> write(
    Uint8List bytes,
    Map<String, dynamic>? previousMetadata,
  ) async => <String, dynamic>{};

  @override
  bool get supportsWrite => false;

  @override
  FileSourceIcon get displayIcon => FileSourceIcon.hdd;

  @override
  String get displayNameFromPath => 'test';

  @override
  String get displayPath => 'memory://test.kdbx';

  @override
  FileSource copyWithDatabaseName(String databaseName) => this;
}

class _FakeAppDataBloc extends Fake implements AppDataBloc {
  @override
  Future<OpenedFile> openedFile(
    FileSource file, {
    required String? name,
    OpenedFile? oldFile,
    Color? defaultColor,
  }) async => OpenedFile(
    (b) => b
      ..uuid = file.uuid
      ..sourceType = OpenedFilesSourceType.Url
      ..sourcePath = file.displayPath
      ..name = name
      ..autofillEnabled = false,
  );
}

class _FakeCloudStorageBloc extends Fake implements CloudStorageBloc {}

class _FakeAnalyticsEvents extends Fake implements AnalyticsEvents {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeAnalytics extends Fake implements Analytics {
  @override
  final AnalyticsEvents events = _FakeAnalyticsEvents();
}

final _format = KdbxFormat();
final _keyFile = Uint8List.fromList(List.generate(32, (i) => i * 7));

ProtectedValue _pw(String password) => ProtectedValue.fromString(password);

Future<Uint8List> _database(Credentials credentials) =>
    _format.create(credentials, 'test').save();

String? _name(OpenFileResult result) =>
    result.kdbxOpenedFile!.kdbxFile.body.meta.databaseName.get();

void main() {
  late KdbxBloc bloc;

  setUp(() async {
    bloc = KdbxBloc(
      env: await TestUtil.createEnv(),
      appDataBloc: _FakeAppDataBloc(),
      analytics: _FakeAnalytics(),
      cloudStorageBloc: _FakeCloudStorageBloc(),
      kdbxFormat: _format,
    );
  });

  tearDown(() {
    bloc.dispose();
  });

  Future<OpenFileResult> open(
    Uint8List database,
    String password, {
    Uint8List? keyFile,
  }) => bloc
      .openFileWithPassword(
        _MemoryFileSource(database),
        password: password,
        keyFile: keyFile,
      )
      .first;

  group('opening a database with a password field', () {
    test('an empty password is not "no password"', () async {
      // The root cause of #294: the composite key of an empty password differs
      // from the one of no password, so the latter cannot open the former.
      final db = await _database(Credentials.composite(_pw(''), null));
      await expectLater(
        bloc
            .openFile(_MemoryFileSource(db), Credentials.composite(null, null))
            .first,
        throwsA(isA<KdbxInvalidKeyException>()),
      );
    });

    test('opens a database locked with an empty password', () async {
      final db = await _database(Credentials.composite(_pw(''), null));
      expect(_name(await open(db, '')), 'test');
    });

    test('opens a database locked with no password', () async {
      final db = await _database(Credentials.composite(null, null));
      expect(_name(await open(db, '')), 'test');
    });

    test('opens a database locked with a normal password', () async {
      final db = await _database(Credentials.composite(_pw('asdf'), null));
      expect(_name(await open(db, 'asdf')), 'test');
    });

    test(
      'opens a database locked with an empty password and a key file',
      () async {
        final db = await _database(Credentials.composite(_pw(''), _keyFile));
        expect(_name(await open(db, '', keyFile: _keyFile)), 'test');
      },
    );

    test('opens a database locked with a key file only', () async {
      final db = await _database(Credentials.composite(null, _keyFile));
      expect(_name(await open(db, '', keyFile: _keyFile)), 'test');
    });

    test(
      'keeps working credentials for the opened empty password file',
      () async {
        final db = await _database(Credentials.composite(_pw(''), null));
        final result = await open(db, '');
        // what quick unlock stores and what a later save uses.
        final credentials = result.kdbxOpenedFile!.kdbxFile.credentials;
        final reread = await _format.read(db, credentials);
        expect(reread.body.meta.databaseName.get(), 'test');
      },
    );

    test('a wrong password is reported, not swallowed', () async {
      final db = await _database(Credentials.composite(_pw('asdf'), null));
      await expectLater(
        open(db, 'wrong'),
        throwsA(isA<KdbxInvalidKeyException>()),
      );
    });

    test('an empty password on a normal database is reported', () async {
      final db = await _database(Credentials.composite(_pw('asdf'), null));
      await expectLater(open(db, ''), throwsA(isA<KdbxInvalidKeyException>()));
    });

    test('a non-empty password is not retried as something else', () async {
      final db = await _database(Credentials.composite(_pw(''), null));
      await expectLater(open(db, 'x'), throwsA(isA<KdbxInvalidKeyException>()));
    });
  });

  group('invalid password message', () {
    String? invalid;
    const message = 'wrong password';
    final validator = invalidPasswordValidator(
      invalidValue: () => invalid,
      message: message,
    );

    test('nothing is rejected yet', () {
      invalid = null;
      expect(validator(''), isNull);
      expect(validator('abc'), isNull);
    });

    test('a rejected non-empty password shows the message', () {
      invalid = 'abc';
      expect(validator('abc'), message);
      expect(validator('abd'), isNull);
    });

    test('a rejected empty password shows the message', () {
      invalid = '';
      expect(validator(''), message);
      expect(validator('abc'), isNull);
    });

    testWidgets('the form fails validation on a rejected empty password', (
      tester,
    ) async {
      invalid = '';
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Form(
              key: formKey,
              child: PasswordInputField(
                labelText: 'pw',
                validator: validator,
                autovalidateMode: AutovalidateMode.always,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text(message), findsOneWidget);
    });
  });
}
