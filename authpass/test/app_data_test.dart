import 'package:authpass/bloc/app_data.dart';
import 'package:flutter_test/flutter_test.dart';

OpenedFile _openedFile([void Function(OpenedFileBuilder b)? updates]) =>
    OpenedFile(
      (b) => b
        ..uuid = 'uuid'
        ..sourceType = OpenedFilesSourceType.Local
        ..sourcePath = '/tmp/test.kdbx'
        ..name = 'test'
        ..update(updates ?? (_) {}),
    );

void main() {
  group('autofill opt out', () {
    test('a database nobody chose for is offered', () {
      expect(_openedFile().autofillEnabledOrDefault, isTrue);
    });

    test('switching it off is remembered', () {
      final file = _openedFile((b) => b..autofillEnabled = false);
      expect(file.autofillEnabledOrDefault, isFalse);
    });

    // The default flipped from off to on. Anyone who had already switched it
    // off stored `false` and has to keep it: only "never chose" may become on,
    // or the change would silently re-enable autofill for the people who
    // deliberately said no.
    test('surviving a round trip, so the default cannot undo the choice', () {
      final stored = serializers.serialize(
        _openedFile((b) => b..autofillEnabled = false),
      );
      final restored = serializers.deserialize(stored)! as OpenedFile;
      expect(restored.autofillEnabledOrDefault, isFalse);
    });

    test('an explicit yes round trips too', () {
      final stored = serializers.serialize(
        _openedFile((b) => b..autofillEnabled = true),
      );
      final restored = serializers.deserialize(stored)! as OpenedFile;
      expect(restored.autofillEnabledOrDefault, isTrue);
    });
  });
}
