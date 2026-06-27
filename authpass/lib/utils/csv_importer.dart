import 'package:csv/csv.dart';
import 'package:kdbx/kdbx.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

/// The AuthPass entry fields that a CSV column can be mapped to.
enum CsvFieldType { title, username, password, url, notes }

extension CsvFieldTypeX on CsvFieldType {
  /// Returns the kdbx storage key for this field.
  ///
  /// [KdbxKeyCommon] only defines Title/URL/UserName/Password/OTP constants.
  /// Notes is a standard KeePass field but has no constant, so we construct
  /// the key directly.
  KdbxKey get kdbxKey {
    switch (this) {
      case CsvFieldType.title:
        return KdbxKeyCommon.TITLE;
      case CsvFieldType.username:
        return KdbxKeyCommon.USER_NAME;
      case CsvFieldType.password:
        return KdbxKeyCommon.PASSWORD;
      case CsvFieldType.url:
        return KdbxKeyCommon.URL;
      case CsvFieldType.notes:
        return KdbxKey(nonNls('Notes'));
    }
  }

  /// Whether the field value should be stored encrypted in memory.
  /// Only the password field uses [ProtectedValue]; everything else is plain.
  bool get isProtected => this == CsvFieldType.password;
}

// Exact match only — substring matching caused false positives, e.g.
// 'username'.contains('name') → wrongly matched as title.
bool _matches(String header, List<String> candidates) =>
    candidates.contains(header);

/// Infers the most likely [CsvFieldType] for a CSV column header, or returns
/// null if the header doesn't resemble any known AuthPass field.
///
/// The checks are ordered most-specific first so that headers like
/// 'username' resolve to [CsvFieldType.username] before the broader
/// 'name' candidate in [CsvFieldType.title] can match.
/// Bitwarden export columns (login_username, login_uri, login_password)
/// are included explicitly.
CsvFieldType? guessCsvField(String header) {
  final h = header.toLowerCase().trim();
  if (_matches(h, ['password', 'pass', 'passwd', 'secret', 'login_password'])) {
    return CsvFieldType.password;
  }
  if (_matches(h, [
    'username', 'user name', 'user', 'login', 'email',
    'userid', 'user id', 'account name', 'login_username',
  ])) {
    return CsvFieldType.username;
  }
  if (_matches(h, [
    'url', 'website', 'web', 'site', 'link', 'homepage', 'uri', 'login_uri',
  ])) {
    return CsvFieldType.url;
  }
  if (_matches(h, [
    'notes', 'note', 'comment', 'comments', 'remark',
    'remarks', 'description', 'extra',
  ])) {
    return CsvFieldType.notes;
  }
  if (_matches(h, ['title', 'name', 'account', 'entry', 'label', 'site name'])) {
    return CsvFieldType.title;
  }
  return null;
}

/// Parses [content] as CSV and returns all rows (including the header row at
/// index 0) with every cell coerced to a [String].
/// Returns an empty list if [content] is blank.
List<List<String>> parseCsvContent(String content) {
  if (content.trim().isEmpty) {
    return [];
  }
  return const CsvToListConverter(eol: '\n')
      .convert(content)
      .map((row) => row.map((cell) => cell?.toString() ?? '').toList())
      .toList();
}

/// Returns true if [file] already contains an entry whose title AND username
/// both match the values in [row] at the columns described by [mappings].
///
/// The comparison is case-insensitive and trims whitespace.
/// A row with neither title nor username mapped is never considered a
/// duplicate — there is not enough information to identify it.
bool isDuplicate(
  KdbxFile file,
  List<String> row,
  List<CsvFieldType?> mappings,
) {
  final newTitle = _getMappedValue(row, mappings, CsvFieldType.title);
  final newUsername = _getMappedValue(row, mappings, CsvFieldType.username);

  // Can't reliably identify a duplicate without at least one identifying field.
  if (newTitle == null && newUsername == null) {
    return false;
  }

  return file.body.rootGroup.getAllEntries().any((entry) {
    final existingTitle =
        entry.getString(KdbxKeyCommon.TITLE)?.getText()?.trim().toLowerCase();
    final existingUsername =
        entry.getString(KdbxKeyCommon.USER_NAME)?.getText()?.trim().toLowerCase();

    // Both fields must agree — a different username on the same site is a
    // separate account, not a duplicate.
    final titleMatches = newTitle == null ||
        newTitle.toLowerCase() == (existingTitle ?? '');
    final usernameMatches = newUsername == null ||
        newUsername.toLowerCase() == (existingUsername ?? '');
    return titleMatches && usernameMatches;
  });
}

/// Scans [row] for the first column mapped to [field] and returns its value,
/// or null if the column is absent, unmapped, or empty.
String? _getMappedValue(
  List<String> row,
  List<CsvFieldType?> mappings,
  CsvFieldType field,
) {
  for (var i = 0; i < mappings.length && i < row.length; i++) {
    if (mappings[i] == field) {
      final v = row[i].trim();
      return v.isEmpty ? null : v;
    }
  }
  return null;
}
