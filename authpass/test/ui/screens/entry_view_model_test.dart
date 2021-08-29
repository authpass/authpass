import 'dart:typed_data';

import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/ui/screens/password_list.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:mockito/mockito.dart';

import '../../util/test_util.dart';
import '../../util/test_util.mocks.dart';

void main() {
  PrintAppender.setupLogging();
  final testUtil = TestUtil();
  group('entry view model', () {
    late KdbxEntry entry;
    late MockKdbxBloc kdbxBloc;

    setUp(() {
      final file = testUtil.createFile();
      final rootGroup = file.body.rootGroup;
      entry = KdbxEntry.create(file, rootGroup);
      rootGroup.addEntry(entry);

      kdbxBloc = MockKdbxBloc();
      final fakeFile = OpenedFile(
        (b) => b
          ..lastOpenedAt = clock.now().toUtc()
          ..uuid = AppDataBloc.createUuid()
          ..sourceType = OpenedFilesSourceType.Url
          ..sourcePath = 'foo'
          ..name = 'bar',
      );
      final fakeKdbxOpenedFile = KdbxOpenedFile(
        fileSource: FileSourceUrl(Uri.parse('https://authpass.app/'),
            uuid: AppDataBloc.createUuid()),
        openedFile: fakeFile,
        kdbxFile: file,
        kdbxFileContent: FileContent(Uint8List(0)),
      );
      when(kdbxBloc.fileForKdbxFile(any)).thenReturn(fakeKdbxOpenedFile);
    });
    String? _website(String value) {
      entry.setString(EntryViewModel.websiteKey, PlainValue(value));
      final vm = EntryViewModel(entry, kdbxBloc);
      return vm.website;
    }

    test('url transforms', () {
      // bloc.fileForFileSource()

      expect(_website('authpass.app'), 'http://authpass.app/');
      // TODO we should probably fix this somehow.
      expect(_website('authpass.app\nloremipsum'), 'http://authpass.app/');
      expect(_website('\n\nauthpass.app\r\n'), 'http://authpass.app/');
      expect(_website('\n\nauthpass.app//blubb\r\n'), 'http://authpass.app/');
      expect(_website('   \n'), isNull);
    });
  });
}
