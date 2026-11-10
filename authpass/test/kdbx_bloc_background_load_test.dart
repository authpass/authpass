import 'dart:async';
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

/// A cloud-ish file source: [content] hands out the cached bytes at once and
/// only then starts a "remote" fetch, exactly as [FileSource.content] does for
/// a real provider.
///
/// [load] snapshots [remote] when it *starts*, not when it completes, because
/// that is what an HTTP GET does — a response that arrives after a later PUT
/// still carries the content the file had when the request went out. The whole
/// hazard under test lives in that gap, so the fake has to reproduce it.
class _GatedFileSource extends FileSource {
  _GatedFileSource({required Uint8List cached, required this.remote})
    : super(
        databaseName: 'test',
        uuid: 'gated-file-source',
        initialCachedContent: FileContent(
          cached,
          const <String, dynamic>{},
          FileContentSource.cache,
        ),
      );

  /// What the file holds at the origin. Writes land here; [load] reads it.
  Uint8List remote;

  /// Completes once [load] has snapshotted [remote] — i.e. the GET is in
  /// flight.
  final loadStarted = Completer<void>();

  /// The test opens this to let the in-flight GET return.
  final gate = Completer<void>();

  final writtenBytes = <Uint8List>[];

  @override
  Stream<FileContent> load() async* {
    final snapshot = remote;
    if (!loadStarted.isCompleted) {
      loadStarted.complete();
    }
    await gate.future;
    yield FileContent(
      snapshot,
      const <String, dynamic>{},
      FileContentSource.origin,
    );
  }

  @override
  Future<Map<String, dynamic>?> write(
    Uint8List bytes,
    Map<String, dynamic>? previousMetadata,
  ) async {
    writtenBytes.add(bytes);
    remote = bytes;
    return <String, dynamic>{};
  }

  @override
  bool get supportsWrite => true;

  @override
  FileSourceIcon get displayIcon => FileSourceIcon.webDav;

  @override
  String get displayNameFromPath => 'gated';

  @override
  String get displayPath => 'gated://test.kdbx';

  /// A rename goes through `saveAs(file, copyWithDatabaseName(name))`, so the
  /// write lands on a *different instance* that is `==` to this one. The copy
  /// shares [remote] and [writtenBytes], being the same file at the origin.
  @override
  FileSource copyWithDatabaseName(String databaseName) =>
      _RenamedFileSource(this);
}

class _RenamedFileSource extends FileSource {
  _RenamedFileSource(this.original)
    : super(
        databaseName: 'renamed',
        uuid: original.uuid,
        initialCachedContent: original.lastContent,
      );

  final _GatedFileSource original;

  @override
  Stream<FileContent> load() => original.load();

  @override
  Future<Map<String, dynamic>?> write(
    Uint8List bytes,
    Map<String, dynamic>? previousMetadata,
  ) => original.write(bytes, previousMetadata);

  @override
  bool get supportsWrite => true;

  @override
  FileSourceIcon get displayIcon => FileSourceIcon.webDav;

  @override
  String get displayNameFromPath => 'renamed';

  @override
  String get displayPath => original.displayPath;

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
      // keeps the autofill mirror out of a unit test; it has its own.
      ..autofillEnabled = false,
  );
}

/// Holds the second and later `openedFile()` calls open, which is where
/// `_openFileContent` sits between "the content from the origin is decrypted"
/// and "the open file is replaced with it". In the app that gap is argon2, long
/// enough on a phone for the user to save in the middle of it.
class _GatedAppDataBloc extends _FakeAppDataBloc {
  var calls = 0;
  final reopenStarted = Completer<void>();
  final gate = Completer<void>();

  @override
  Future<OpenedFile> openedFile(
    FileSource file, {
    required String? name,
    OpenedFile? oldFile,
    Color? defaultColor,
  }) async {
    calls++;
    if (calls == 2) {
      reopenStarted.complete();
      await gate.future;
    }
    return super.openedFile(
      file,
      name: name,
      oldFile: oldFile,
      defaultColor: defaultColor,
    );
  }
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

/// Pure-dart argon2; the default kdf parameters (1 MiB, 2 iterations) are
/// cheap enough for a unit test.
final _format = KdbxFormat();
final _credentials = Credentials(ProtectedValue.fromString('asdf'));

String? _titleOf(KdbxFile file) =>
    file.body.rootGroup.getAllEntries().single.getString(_title)?.getText();

void main() {
  late KdbxBloc bloc;

  Future<void> newBloc([AppDataBloc? appDataBloc]) async {
    bloc = KdbxBloc(
      env: await TestUtil.createEnv(),
      appDataBloc: appDataBloc ?? _FakeAppDataBloc(),
      analytics: _FakeAnalytics(),
      cloudStorageBloc: _FakeCloudStorageBloc(),
      kdbxFormat: _format,
    );
  }

  setUp(() async {
    await newBloc();
  });

  tearDown(() {
    bloc.dispose();
  });

  /// Builds the two byte versions the hazard needs: what the local cache holds
  /// (`cached`) and what the origin holds at the moment the file is opened
  /// (`remote`), differing in the single entry's title.
  Future<({Uint8List cached, Uint8List remote})> twoVersions() async {
    final file = _format.create(_credentials, 'test');
    final entry = KdbxEntry.create(file, file.body.rootGroup);
    file.body.rootGroup.addEntry(entry);
    entry.setString(_title, PlainValue('cached'));
    final cached = await file.save();
    entry.setString(_title, PlainValue('remote'));
    final remote = await file.save();
    return (cached: cached, remote: remote);
  }

  group('a save racing the background remote load', () {
    test('survives the remote content that was already in flight', () async {
      final versions = await twoVersions();
      final source = _GatedFileSource(
        cached: versions.cached,
        remote: versions.remote,
      );

      // Open the way select_file_screen does: take the first (cached) result
      // and leave the rest to the background.
      final openIt = StreamIterator(bloc.openFile(source, _credentials));
      expect(await openIt.moveNext(), isTrue);
      final opened = openIt.current.kdbxOpenedFile!;
      expect(_titleOf(opened.kdbxFile), 'cached');

      final background = bloc.continueLoadInBackground(
        openIt,
        debugName: 'test',
        fileSource: source,
      );

      // The GET is out, carrying the pre-save content.
      await source.loadStarted.future;

      // This is the repair dialog: mutate and save, seconds after the open.
      opened.kdbxFile.body.rootGroup.getAllEntries().single.setString(
        _title,
        PlainValue('repaired'),
      );
      await bloc.saveFile(opened.kdbxFile);
      expect(opened.kdbxFile.isDirty, isFalse);
      expect(source.writtenBytes, hasLength(1));

      // Now the in-flight GET comes back with the content from before the
      // save.
      source.gate.complete();
      await background;

      expect(
        _titleOf(bloc.openedFiles[source]!.kdbxFile),
        'repaired',
        reason:
            'the background load replaced the saved file with the stale '
            'remote content it had fetched before the save',
      );
      expect(
        bloc.openedFiles[source]!.kdbxFile,
        same(opened.kdbxFile),
        reason:
            'the object the UI is holding was swapped out from under it for '
            'one built from older bytes',
      );
    });

    test('does not throw when the file still has unsaved changes', () async {
      final versions = await twoVersions();
      final source = _GatedFileSource(
        cached: versions.cached,
        remote: versions.remote,
      );

      final openIt = StreamIterator(bloc.openFile(source, _credentials));
      expect(await openIt.moveNext(), isTrue);
      final opened = openIt.current.kdbxOpenedFile!;

      final background = bloc.continueLoadInBackground(
        openIt,
        debugName: 'test',
        fileSource: source,
      );
      await source.loadStarted.future;

      opened.kdbxFile.body.rootGroup.getAllEntries().single.setString(
        _title,
        PlainValue('edited, not yet saved'),
      );
      expect(opened.kdbxFile.isDirty, isTrue);

      source.gate.complete();
      // Both call sites run this unawaited, so anything thrown here lands in
      // `PlatformDispatcher.instance.onError` and shows the user an
      // "Unexpected error" dialog for something they cannot act on.
      await expectLater(background, completes);

      expect(
        _titleOf(bloc.openedFiles[source]!.kdbxFile),
        'edited, not yet saved',
      );
      expect(bloc.openedFiles[source]!.kdbxFile, same(opened.kdbxFile));
    });

    test(
      'still picks up remote changes when nothing happened locally',
      () async {
        final versions = await twoVersions();
        final source = _GatedFileSource(
          cached: versions.cached,
          remote: versions.remote,
        );

        final openIt = StreamIterator(bloc.openFile(source, _credentials));
        expect(await openIt.moveNext(), isTrue);
        expect(_titleOf(openIt.current.kdbxOpenedFile!.kdbxFile), 'cached');

        final background = bloc.continueLoadInBackground(
          openIt,
          debugName: 'test',
          fileSource: source,
        );
        await source.loadStarted.future;
        source.gate.complete();
        await background;

        expect(_titleOf(bloc.openedFiles[source]!.kdbxFile), 'remote');
      },
    );

    // The common case, and the one that has to be guarded before the
    // byte-equality shortcut rather than after it: the open file is kept
    // either way, but `content()` resuming past its yield would roll the
    // memory cache — and, for a cloud source, the cache on disk — back to the
    // bytes from the origin, which predate the save. The next save would then
    // send a stale revision and conflict with itself, and the next cold start
    // would open the content from before the save.
    test(
      'does not roll the cache back when the bytes happen to match',
      () async {
        final versions = await twoVersions();
        final source = _GatedFileSource(
          cached: versions.cached,
          remote: versions.cached,
        );

        final openIt = StreamIterator(bloc.openFile(source, _credentials));
        expect(await openIt.moveNext(), isTrue);
        final opened = openIt.current.kdbxOpenedFile!;

        final background = bloc.continueLoadInBackground(
          openIt,
          debugName: 'test',
          fileSource: source,
        );
        await source.loadStarted.future;

        opened.kdbxFile.body.rootGroup.getAllEntries().single.setString(
          _title,
          PlainValue('repaired'),
        );
        final saved = await bloc.saveFile(opened.kdbxFile);

        source.gate.complete();
        await background;

        expect(_titleOf(bloc.openedFiles[source]!.kdbxFile), 'repaired');
        expect(
          source.lastContent!.content,
          same(saved.content),
          reason: 'the cache was rolled back to the content from the origin',
        );
      },
    );

    // The guard has to be asked again at the swap, not only before the
    // decrypting: on a phone argon2 takes long enough for the user to save in
    // the middle of it, and the swap is what takes their file away.
    test('survives a save made while the remote copy is decrypting', () async {
      final appData = _GatedAppDataBloc();
      await newBloc(appData);
      final versions = await twoVersions();
      final source = _GatedFileSource(
        cached: versions.cached,
        remote: versions.remote,
      );

      final openIt = StreamIterator(bloc.openFile(source, _credentials));
      expect(await openIt.moveNext(), isTrue);
      final opened = openIt.current.kdbxOpenedFile!;

      final background = bloc.continueLoadInBackground(
        openIt,
        debugName: 'test',
        fileSource: source,
      );
      await source.loadStarted.future;
      // Let the content from the origin arrive and start being opened, then
      // hold it just short of the swap.
      source.gate.complete();
      await appData.reopenStarted.future;

      opened.kdbxFile.body.rootGroup.getAllEntries().single.setString(
        _title,
        PlainValue('repaired'),
      );
      await bloc.saveFile(opened.kdbxFile);

      appData.gate.complete();
      await background;

      expect(_titleOf(bloc.openedFiles[source]!.kdbxFile), 'repaired');
      expect(bloc.openedFiles[source]!.kdbxFile, same(opened.kdbxFile));
    });

    test(
      'keeps an unsaved edit made while the remote copy is decrypting',
      () async {
        final appData = _GatedAppDataBloc();
        await newBloc(appData);
        final versions = await twoVersions();
        final source = _GatedFileSource(
          cached: versions.cached,
          remote: versions.remote,
        );

        final openIt = StreamIterator(bloc.openFile(source, _credentials));
        expect(await openIt.moveNext(), isTrue);
        final opened = openIt.current.kdbxOpenedFile!;

        final background = bloc.continueLoadInBackground(
          openIt,
          debugName: 'test',
          fileSource: source,
        );
        await source.loadStarted.future;
        source.gate.complete();
        await appData.reopenStarted.future;

        opened.kdbxFile.body.rootGroup.getAllEntries().single.setString(
          _title,
          PlainValue('edited, not yet saved'),
        );

        appData.gate.complete();
        await expectLater(background, completes);

        // Not merely "the edit is still there": the file has to be the same
        // object, or `fileForKdbxFile` throws when the user saves it.
        expect(bloc.openedFiles[source]!.kdbxFile, same(opened.kdbxFile));
        expect(
          _titleOf(bloc.openedFiles[source]!.kdbxFile),
          'edited, not yet saved',
        );
      },
    );

    test('does not reopen a database that was locked meanwhile', () async {
      final versions = await twoVersions();
      final source = _GatedFileSource(
        cached: versions.cached,
        remote: versions.remote,
      );

      final openIt = StreamIterator(bloc.openFile(source, _credentials));
      expect(await openIt.moveNext(), isTrue);

      final background = bloc.continueLoadInBackground(
        openIt,
        debugName: 'test',
        fileSource: source,
      );
      await source.loadStarted.future;

      await bloc.closeAllFiles(clearQuickUnlock: false);
      expect(bloc.openedFiles.length, 0);

      source.gate.complete();
      await expectLater(background, completes);

      expect(
        bloc.openedFiles.length,
        0,
        reason: 'the background load put the locked database back',
      );
    });

    // A rename is `saveAs(file, fileSource.copyWithDatabaseName(name))`, so
    // the write lands on a different FileSource instance that is `==` to this
    // one. Identity of the installed state is what catches it; a counter kept
    // on the instance does not.
    test('survives a rename made while the load was in flight', () async {
      final versions = await twoVersions();
      final source = _GatedFileSource(
        cached: versions.cached,
        remote: versions.remote,
      );

      final openIt = StreamIterator(bloc.openFile(source, _credentials));
      expect(await openIt.moveNext(), isTrue);
      final opened = openIt.current.kdbxOpenedFile!;

      final background = bloc.continueLoadInBackground(
        openIt,
        debugName: 'test',
        fileSource: source,
      );
      await source.loadStarted.future;

      opened.kdbxFile.body.rootGroup.getAllEntries().single.setString(
        _title,
        PlainValue('repaired'),
      );
      await bloc.saveAs(opened, source.copyWithDatabaseName('renamed'));

      source.gate.complete();
      await expectLater(background, completes);

      expect(_titleOf(bloc.openedFiles[source]!.kdbxFile), 'repaired');
      expect(bloc.openedFiles[source]!.kdbxFile, same(opened.kdbxFile));
    });
  });
}
