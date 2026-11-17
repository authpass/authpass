import 'dart:typed_data';

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:flutter/material.dart' show Color;
import 'package:flutter_test/flutter_test.dart';
import 'package:kdbx/kdbx.dart';

import 'util/test_util.dart';

/// A file source whose origin holds [remote].
class _OriginFileSource extends FileSource {
  _OriginFileSource(this.remote)
    : super(databaseName: 'test', uuid: 'reload-file-source');

  Uint8List remote;

  @override
  Stream<FileContent> load() async* {
    yield FileContent(
      remote,
      const <String, dynamic>{},
      FileContentSource.origin,
    );
  }

  @override
  Future<Map<String, dynamic>?> write(
    Uint8List bytes,
    Map<String, dynamic>? previousMetadata,
  ) async {
    remote = bytes;
    return <String, dynamic>{};
  }

  @override
  bool get supportsWrite => true;

  @override
  FileSourceIcon get displayIcon => FileSourceIcon.webDav;

  @override
  String get displayNameFromPath => 'origin';

  @override
  String get displayPath => 'origin://test.kdbx';

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

  @override
  void trackTiming(
    String variableName,
    int timeMs, {
    String? category,
    String? label,
  }) {}
}

const _title = KdbxKeyCommon.TITLE;

final _format = KdbxFormat();
final _credentials = Credentials(ProtectedValue.fromString('asdf'));

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

  /// Opens a database holding one entry titled `original`.
  Future<(_OriginFileSource, KdbxOpenedFile, Uint8List)> open() async {
    final file = _format.create(_credentials, 'test');
    final entry = KdbxEntry.create(file, file.body.rootGroup);
    file.body.rootGroup.addEntry(entry);
    entry.setString(_title, PlainValue('original'));
    final bytes = await file.save();
    final source = _OriginFileSource(bytes);
    final opened =
        (await bloc.openFile(source, _credentials).last).kdbxOpenedFile!;
    return (source, opened, bytes);
  }

  group('reload', () {
    test('keeps unsaved edits dirty when the origin did not change', () async {
      final (_, opened, _) = await open();
      opened.kdbxFile.body.rootGroup.getAllEntries().single.setString(
        _title,
        PlainValue('edited, not yet saved'),
      );
      expect(opened.kdbxFile.isDirty, isTrue);

      final statuses = await bloc.reload(opened).toList();

      expect(statuses, contains(ReloadStatus.didNotChange));
      expect(opened.kdbxFile.isDirty, isTrue);
    });

    test('keeps unsaved edits dirty when it merges new content', () async {
      final (source, opened, _) = await open();
      // Another device adds an entry and saves it to the origin.
      final other = await _format.read(source.remote, _credentials);
      final added = KdbxEntry.create(other, other.body.rootGroup);
      other.body.rootGroup.addEntry(added);
      added.setString(_title, PlainValue('from elsewhere'));
      source.remote = await other.save();

      opened.kdbxFile.body.rootGroup.getAllEntries().single.setString(
        _title,
        PlainValue('edited, not yet saved'),
      );
      expect(opened.kdbxFile.isDirty, isTrue);

      final statuses = await bloc.reload(opened).toList();

      expect(statuses, contains(ReloadStatus.merged));
      expect(opened.kdbxFile.body.rootGroup.getAllEntries(), hasLength(2));
      expect(opened.kdbxFile.isDirty, isTrue);
    });

    test('keeps an unsaved edit of an entry the origin changed', () async {
      final (source, opened, _) = await open();
      // Modification times have a resolution of one second.
      await Future<void>.delayed(const Duration(seconds: 2));
      final entry = opened.kdbxFile.body.rootGroup.getAllEntries().single;
      entry.setString(_title, PlainValue('local unsaved'));
      // Another device edits the same entry later and saves it to the origin.
      await Future<void>.delayed(const Duration(seconds: 2));
      final other = await _format.read(source.remote, _credentials);
      other.body.rootGroup.getAllEntries().single.setString(
        _title,
        PlainValue('remote'),
      );
      source.remote = await other.save();

      await bloc.reload(opened).toList();

      final merged = opened.kdbxFile.body.rootGroup.getAllEntries().single;
      final titles = [
        merged,
        ...merged.history,
      ].map((e) => e.getString(_title)?.getText()).toList();
      expect(titles.first, 'remote');
      expect(titles, contains('local unsaved'));
      expect(opened.kdbxFile.isDirty, isTrue);
    });

    test(
      'does not duplicate a revision for an entry that was only moved',
      () async {
        final (source, opened, _) = await open();
        final file = opened.kdbxFile;
        file.body.meta.historyMaxItems.set(2);
        final entry = file.body.rootGroup.getAllEntries().single;
        final sub = file.createGroup(parent: file.body.rootGroup, name: 'sub');
        // Modification times have a resolution of one second.
        await Future<void>.delayed(const Duration(seconds: 2));
        entry.setString(_title, PlainValue('e1'));
        await file.save();
        await Future<void>.delayed(const Duration(seconds: 2));
        entry.setString(_title, PlainValue('e2'));
        source.remote = await file.save();
        // History is now [original, e1]. Move the entry, without saving.
        file.move(entry, sub);
        expect(file.isDirty, isTrue);
        // Another device edits the title and saves it to the origin.
        await Future<void>.delayed(const Duration(seconds: 2));
        final other = await _format.read(source.remote, _credentials);
        other.body.rootGroup.getAllEntries().single.setString(
          _title,
          PlainValue('remote'),
        );
        source.remote = await other.save();

        await bloc.reload(opened).toList();

        final merged = file.body.rootGroup.getAllEntries().single;
        expect(merged.getString(_title)?.getText(), 'remote');
        expect(merged.history.map((e) => e.getString(_title)?.getText()), [
          'e1',
          'e2',
        ]);
      },
    );

    test('leaves a clean file clean', () async {
      final (_, opened, _) = await open();
      expect(opened.kdbxFile.isDirty, isFalse);

      await bloc.reload(opened).toList();

      expect(opened.kdbxFile.isDirty, isFalse);
    });

    test('a save after the reload still makes the file clean', () async {
      final (_, opened, _) = await open();
      opened.kdbxFile.body.rootGroup.getAllEntries().single.setString(
        _title,
        PlainValue('edited, not yet saved'),
      );
      await bloc.reload(opened).toList();

      await opened.kdbxFile.save();

      expect(opened.kdbxFile.isDirty, isFalse);
    });
  });
}
