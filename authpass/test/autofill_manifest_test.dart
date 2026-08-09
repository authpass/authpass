import 'package:authpass/autofill/autofill_manifest.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AutofillManifestEntry entry(String uuid, {String name = 'Vault'}) =>
      AutofillManifestEntry(
        fileUuid: uuid,
        name: name,
        fileName: 'vaults/$uuid.kdbx',
        updatedAt: DateTime.utc(2026, 8, 9, 10, 30),
        kdfFingerprint: 'fingerprint-$uuid',
      );

  group('round trip', () {
    test('survives encode and parse', () {
      final manifest = AutofillManifest(entries: [entry('a'), entry('b')]);
      final parsed = AutofillManifest.parse(manifest.encode());

      expect(parsed.entries, hasLength(2));
      final first = parsed.byFileUuid('a')!;
      expect(first.name, 'Vault');
      expect(first.fileName, 'vaults/a.kdbx');
      expect(first.kdfFingerprint, 'fingerprint-a');
      expect(first.updatedAt, DateTime.utc(2026, 8, 9, 10, 30));
    });

    test('keeps updatedAt in utc across the wire', () {
      final local = AutofillManifestEntry(
        fileUuid: 'a',
        name: 'Vault',
        fileName: 'vaults/a.kdbx',
        updatedAt: DateTime(2026, 8, 9, 10, 30),
        kdfFingerprint: 'f',
      );
      final parsed = AutofillManifest.parse(
        AutofillManifest(entries: [local]).encode(),
      ).entries.single;

      expect(parsed.updatedAt.isUtc, isTrue);
      expect(
        parsed.updatedAt.millisecondsSinceEpoch,
        local.updatedAt.millisecondsSinceEpoch,
      );
    });

    test('an empty manifest is valid', () {
      expect(
        AutofillManifest.parse(AutofillManifest(entries: []).encode()).entries,
        isEmpty,
      );
    });
  });

  group('editing', () {
    test('withEntry appends a new file', () {
      final manifest = AutofillManifest(entries: [entry('a')]);
      expect(manifest.withEntry(entry('b')).entries, hasLength(2));
    });

    test('withEntry replaces rather than duplicates', () {
      final manifest = AutofillManifest(
        entries: [
          entry('a', name: 'Old'),
          entry('b'),
        ],
      );
      final updated = manifest.withEntry(entry('a', name: 'New'));

      expect(updated.entries, hasLength(2));
      expect(updated.byFileUuid('a')!.name, 'New');
    });

    test('withoutFileUuid drops just the one', () {
      final manifest = AutofillManifest(entries: [entry('a'), entry('b')]);
      final updated = manifest.withoutFileUuid('a');

      expect(updated.byFileUuid('a'), isNull);
      expect(updated.byFileUuid('b'), isNotNull);
    });

    test('withoutFileUuid on an unknown uuid changes nothing', () {
      final manifest = AutofillManifest(entries: [entry('a')]);
      expect(manifest.withoutFileUuid('zzz').entries, hasLength(1));
    });

    test('byFileUuid is null when absent', () {
      expect(AutofillManifest(entries: []).byFileUuid('a'), isNull);
    });
  });

  group('versioning', () {
    test('refuses a manifest from a newer app', () {
      // the extension ships with the app, but a stale container can outlive an
      // upgrade — better to read nothing than to guess at the shape.
      expect(
        () => AutofillManifest.parse('{"version": 999, "entries": []}'),
        throwsFormatException,
      );
    });

    test('accepts the current version', () {
      expect(
        AutofillManifest.parse(
          '{"version": ${AutofillManifest.currentVersion}, "entries": []}',
        ).entries,
        isEmpty,
      );
    });

    test('tolerates a missing entries list', () {
      expect(AutofillManifest.parse('{"version": 1}').entries, isEmpty);
    });
  });
}
