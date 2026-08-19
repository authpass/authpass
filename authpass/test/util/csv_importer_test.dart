import 'package:authpass/utils/csv_importer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kdbx/kdbx.dart';

/// Creates a fresh in-memory kdbx file for each test that needs one.
KdbxFile _emptyFile() => KdbxFormat().create(
      Credentials(ProtectedValue.fromString('test')),
      'test',
    );

void main() {
  // ─── guessCsvField ────────────────────────────────────────────────────────

  group('guessCsvField', () {
    test('detects title variants', () {
      for (final h in ['name', 'title', 'account', 'entry', 'label']) {
        expect(guessCsvField(h), CsvFieldType.title, reason: 'header: $h');
      }
    });

    test('detects username variants', () {
      for (final h in ['username', 'user', 'login', 'email', 'userid']) {
        expect(guessCsvField(h), CsvFieldType.username, reason: 'header: $h');
      }
    });

    test('detects password variants', () {
      for (final h in ['password', 'pass', 'passwd', 'secret']) {
        expect(guessCsvField(h), CsvFieldType.password, reason: 'header: $h');
      }
    });

    test('detects url variants', () {
      for (final h in ['url', 'website', 'link', 'homepage', 'uri']) {
        expect(guessCsvField(h), CsvFieldType.url, reason: 'header: $h');
      }
    });

    test('detects notes variants', () {
      for (final h in ['notes', 'note', 'comment', 'extra', 'description']) {
        expect(guessCsvField(h), CsvFieldType.notes, reason: 'header: $h');
      }
    });

    test('returns null for unrecognised headers', () {
      for (final h in ['group', 'folder', 'totp', 'favourite', 'type']) {
        expect(guessCsvField(h), isNull, reason: 'header: $h');
      }
    });

    test('is case-insensitive', () {
      expect(guessCsvField('Password'), CsvFieldType.password);
      expect(guessCsvField('USERNAME'), CsvFieldType.username);
      expect(guessCsvField('Title'), CsvFieldType.title);
    });

    test('trims surrounding whitespace', () {
      expect(guessCsvField('  url  '), CsvFieldType.url);
    });
  });

  // ─── parseCsvContent ──────────────────────────────────────────────────────

  group('parseCsvContent', () {
    test('parses a simple two-row CSV', () {
      const csv = 'name,url,username,password\n'
          'GitHub,https://github.com,devuser,s3cr3t';
      final rows = parseCsvContent(csv);
      expect(rows.length, 2);
      expect(rows[0], ['name', 'url', 'username', 'password']);
      expect(rows[1], ['GitHub', 'https://github.com', 'devuser', 's3cr3t']);
    });

    test('handles quoted values containing commas', () {
      const csv = 'name,notes\nGoogle,"Has comma, inside"';
      final rows = parseCsvContent(csv);
      expect(rows[1][1], 'Has comma, inside');
    });

    test('returns empty list for empty content', () {
      expect(parseCsvContent(''), isEmpty);
      expect(parseCsvContent('   '), isEmpty);
    });

    test('treats cells as strings regardless of their apparent type', () {
      const csv = 'count,flag\n42,true';
      final rows = parseCsvContent(csv);
      expect(rows[1][0], '42');
      expect(rows[1][1], 'true');
    });
  });

  // ─── isDuplicate ──────────────────────────────────────────────────────────

  group('isDuplicate', () {
    late KdbxFile file;

    // Shared mappings matching the test CSV column order:
    // col 0 = title, col 1 = url, col 2 = username, col 3 = password
    const mappings = [
      CsvFieldType.title,
      CsvFieldType.url,
      CsvFieldType.username,
      CsvFieldType.password,
    ];

    setUp(() => file = _emptyFile());

    /// Convenience helper to add an entry directly to the root group.
    void addEntry(String title, String username) {
      final entry = KdbxEntry.create(file, file.body.rootGroup);
      entry.setString(KdbxKeyCommon.TITLE, PlainValue(title));
      entry.setString(KdbxKeyCommon.USER_NAME, PlainValue(username));
      file.body.rootGroup.addEntry(entry);
    }

    test('detects exact title + username match', () {
      addEntry('GitHub', 'devuser');
      final row = ['GitHub', 'https://github.com', 'devuser', 'pass'];
      expect(isDuplicate(file, row, mappings), isTrue);
    });

    test('does not flag same title but different username', () {
      addEntry('GitHub', 'otheruser');
      final row = ['GitHub', 'https://github.com', 'devuser', 'pass'];
      expect(isDuplicate(file, row, mappings), isFalse);
    });

    test('does not flag same username but different title', () {
      addEntry('GitLab', 'devuser');
      final row = ['GitHub', 'https://github.com', 'devuser', 'pass'];
      expect(isDuplicate(file, row, mappings), isFalse);
    });

    test('duplicate check is case-insensitive', () {
      addEntry('GitHub', 'DevUser');
      final row = ['github', 'https://github.com', 'devuser', 'pass'];
      expect(isDuplicate(file, row, mappings), isTrue);
    });

    test('returns false when file has no entries', () {
      final row = ['GitHub', 'https://github.com', 'devuser', 'pass'];
      expect(isDuplicate(file, row, mappings), isFalse);
    });

    test('returns false when row has no title or username mapped', () {
      // A row with only a URL mapped cannot be uniquely identified —
      // multiple entries can share the same URL (e.g. two accounts on GitHub).
      addEntry('GitHub', 'devuser');
      const urlOnlyMappings = [CsvFieldType.url];
      final row = ['https://github.com'];
      expect(isDuplicate(file, row, urlOnlyMappings), isFalse);
    });
  });
}
