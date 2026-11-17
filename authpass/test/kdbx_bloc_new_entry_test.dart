import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kdbx/kdbx.dart';

import 'util/test_util.dart';

class _FakeAppDataBloc extends Fake implements AppDataBloc {}

class _FakeEvents implements AnalyticsEvents {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeAnalytics extends Fake implements Analytics {
  @override
  final AnalyticsEvents events = _FakeEvents();
}

class _FakeCloudStorageBloc extends Fake implements CloudStorageBloc {}

void main() {
  final format = KdbxFormat();
  late KdbxBloc bloc;
  late KdbxFile file;

  setUp(() async {
    bloc = KdbxBloc(
      env: await TestUtil.createEnv(),
      appDataBloc: _FakeAppDataBloc(),
      analytics: _FakeAnalytics(),
      cloudStorageBloc: _FakeCloudStorageBloc(),
      kdbxFormat: format,
    );
    file = format.create(
      Credentials(ProtectedValue.fromString('asdf')),
      'test',
    );
    final existing = KdbxEntry.create(file, file.body.rootGroup);
    existing.setString(KdbxKeyCommon.TITLE, PlainValue('existing'));
    file.body.rootGroup.addEntry(existing);
    // save, so that the file has no unsaved changes.
    await file.save();
    expect(file.isDirty, false);
  });

  tearDown(() {
    bloc.dispose();
  });

  group('discardUntouchedNewEntry', () {
    test('removes an untouched new entry and leaves the file clean', () {
      final entry = bloc.createEntry(file: file);
      expect(file.body.rootGroup.entries, hasLength(2));
      expect(file.isDirty, true);

      expect(bloc.discardUntouchedNewEntry(entry), true);

      expect(file.body.rootGroup.entries, hasLength(1));
      expect(file.isDirty, false);
    });

    test('keeps an entry which was edited', () {
      final entry = bloc.createEntry(file: file);
      entry.setString(KdbxKeyCommon.TITLE, PlainValue('my new entry'));

      expect(bloc.discardUntouchedNewEntry(entry), false);

      expect(file.body.rootGroup.entries, contains(entry));
      expect(file.isDirty, true);
    });

    test('keeps an entry which only got a password', () {
      final entry = bloc.createEntry(file: file);
      entry.setString(
        KdbxKeyCommon.PASSWORD,
        ProtectedValue.fromString('secret'),
      );

      expect(bloc.discardUntouchedNewEntry(entry), false);
      expect(file.body.rootGroup.entries, contains(entry));
    });

    test('keeps an entry which was saved', () async {
      final entry = bloc.createEntry(file: file);
      await file.save();

      expect(bloc.discardUntouchedNewEntry(entry), false);
      expect(file.body.rootGroup.entries, contains(entry));
    });

    test('never removes an entry it did not create', () {
      final existing = file.body.rootGroup.entries.single;
      expect(bloc.discardUntouchedNewEntry(existing), false);
      expect(file.body.rootGroup.entries, contains(existing));

      // not even when it looks blank.
      final blank = KdbxEntry.create(file, file.body.rootGroup);
      file.body.rootGroup.addEntry(blank);
      expect(bloc.discardUntouchedNewEntry(blank), false);
      expect(file.body.rootGroup.entries, contains(blank));
    });

    test('only removes the entry once', () {
      final entry = bloc.createEntry(file: file);
      expect(bloc.discardUntouchedNewEntry(entry), true);
      expect(bloc.discardUntouchedNewEntry(entry), false);
    });

    test('stays dirty if there were other unsaved changes', () {
      final existing = file.body.rootGroup.entries.single;
      existing.setString(KdbxKeyCommon.TITLE, PlainValue('changed'));
      final entry = bloc.createEntry(file: file);

      expect(bloc.discardUntouchedNewEntry(entry), true);

      expect(file.body.rootGroup.entries, [existing]);
      expect(file.isDirty, true);
      expect(existing.isDirty, true);
    });

    test('stays dirty if the group was renamed meanwhile', () async {
      final sub = KdbxGroup.create(
        ctx: file.ctx,
        parent: file.body.rootGroup,
        name: 'Sub',
      );
      file.body.rootGroup.addGroup(sub);
      await file.save();
      expect(file.isDirty, false);
      final entry = bloc.createEntry(file: file, group: sub);
      sub.name.set('Renamed');

      expect(bloc.discardUntouchedNewEntry(entry), true);

      expect(sub.entries, isEmpty);
      expect(sub.name.get(), 'Renamed');
      expect(file.isDirty, true);
      expect(sub.isDirty, true);
    });

    test('stays dirty if the group got another icon meanwhile', () async {
      final sub = KdbxGroup.create(
        ctx: file.ctx,
        parent: file.body.rootGroup,
        name: 'Sub',
      );
      file.body.rootGroup.addGroup(sub);
      await file.save();
      final entry = bloc.createEntry(file: file, group: sub);
      sub.icon.set(KdbxIcon.Star);

      expect(bloc.discardUntouchedNewEntry(entry), true);

      expect(file.isDirty, true);
    });

    test('forgets entries when the files are closed', () async {
      final entry = bloc.createEntry(file: file);
      expect(bloc.newEntryCount, 1);

      await bloc.closeAllFiles(clearQuickUnlock: false);

      expect(bloc.newEntryCount, 0);
      expect(bloc.discardUntouchedNewEntry(entry), false);
    });

    test('forgetNewEntry leaves the entry alone', () {
      final entry = bloc.createEntry(file: file);
      bloc.forgetNewEntry(entry);

      expect(bloc.newEntryCount, 0);
      expect(bloc.discardUntouchedNewEntry(entry), false);
      expect(file.body.rootGroup.entries, contains(entry));
    });
  });
}
