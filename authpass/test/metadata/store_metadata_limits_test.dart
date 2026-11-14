import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

/// `metadata/misc/<locale>/store_metadata.csv` carries a length limit per row.
/// The `playstore_title` row said 50 for years while Google Play enforces 30,
/// and nothing noticed because nothing publishes the listing (#418).
///
/// `en-US` is the Crowdin source file, so its limit column is the one that is
/// edited by hand. The other locales are overwritten by Crowdin and must not
/// be edited here, which is why the limits are read from `en-US` only and
/// applied to every locale.
void main() {
  final root = Directory(p.join('..', 'metadata', 'misc'));

  /// Limits the stores themselves enforce. If a limit column asks for more
  /// than the store accepts, translators write text that cannot be published.
  const storeLimits = {
    'playstore_title': 30,
    'playstore_short_description': 80,
    'playstore_full_description': 4000,
    'apple-appstore-title': 30,
    'apple-appstore-subtitle': 30,
    'apple-appstore-description': 4000,
    'apple-appstore-keywords': 100,
  };

  /// Locales whose `playstore_title` is still over the limit and waits for
  /// translators on Crowdin. Never add one. An entry that has become stale
  /// (Crowdin synced a short enough translation) only prints a warning, so an
  /// automated Crowdin update never turns CI red; delete it when you see it.
  const waitingForTranslators = <String, Set<String>>{
    'playstore_title': {
      'de-DE',
      'es-ES',
      'fi-FI',
      'fr-FR',
      'he-IL',
      'id-ID',
      'it-IT',
      'nl-NL',
      'pl-PL',
      'pt-BR',
      'ru-RU',
      'si-LK',
      'sk-SK',
      'tr-TR',
      'uk-UA',
      'zh-TW',
    },
  };

  Map<String, ({String value, int? limit})> load(String locale) {
    final file = File(p.join(root.path, locale, 'store_metadata.csv'));
    final rows = parseCsv(file.readAsStringSync());
    return {
      for (final row in rows)
        if (row.length >= 4)
          row[0]: (value: row[1], limit: int.tryParse(row[3])),
    };
  }

  final locales =
      root
          .listSync()
          .whereType<Directory>()
          .map((d) => p.basename(d.path))
          .toList()
        ..sort();

  test('parseCsv handles quotes, commas and line breaks in fields', () {
    expect(
      parseCsv('"a","b ""q"", x\r\ny","c"\n"d","","1"\n'),
      [
        ['a', 'b "q", x\r\ny', 'c'],
        ['d', '', '1'],
      ],
    );
  });

  test('locales are found', () {
    expect(locales, contains('en-US'));
  });

  test('en-US limits do not exceed what the stores accept', () {
    final source = load('en-US');
    for (final entry in storeLimits.entries) {
      final limit = source[entry.key]?.limit;
      expect(limit, isNotNull, reason: '${entry.key} has no limit');
      expect(
        limit,
        lessThanOrEqualTo(entry.value),
        reason:
            '${entry.key} limit column is $limit, store allows '
            '${entry.value}',
      );
    }
  });

  group('values stay within the en-US limit', () {
    final source = load('en-US');
    for (final locale in locales) {
      test(locale, () {
        final rows = load(locale);
        final pending = <String>[];
        for (final key in source.keys) {
          final limit = source[key]!.limit;
          final value = rows[key]?.value;
          if (limit == null || value == null) {
            continue;
          }
          final length = value.runes.length;
          final waiting = waitingForTranslators[key]?.contains(locale) ?? false;
          if (waiting && length <= limit) {
            // ignore: avoid_print
            print(
              'stale waitingForTranslators entry: $locale $key is $length '
              'characters, within $limit; remove it from the list',
            );
          } else if (!waiting) {
            expect(
              length,
              lessThanOrEqualTo(limit),
              reason: '$locale $key is $length characters, limit is $limit',
            );
          }
          pending.add(key);
        }
        expect(pending, isNotEmpty);
      });
    }
  });
}

/// Minimal RFC 4180 parser: quoted fields, doubled quotes, line breaks inside
/// quotes. Enough for the Crowdin export; avoids a dependency for one test.
List<List<String>> parseCsv(String input) {
  final rows = <List<String>>[];
  var row = <String>[];
  final field = StringBuffer();
  var inQuotes = false;
  var hasData = false;
  final text = input.startsWith('﻿') ? input.substring(1) : input;
  for (var i = 0; i < text.length; i++) {
    final c = text[i];
    if (inQuotes) {
      if (c == '"') {
        if (i + 1 < text.length && text[i + 1] == '"') {
          field.write('"');
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        field.write(c);
      }
    } else if (c == '"') {
      inQuotes = true;
      hasData = true;
    } else if (c == ',') {
      row.add(field.toString());
      field.clear();
      hasData = true;
    } else if (c == '\n' || c == '\r') {
      if (c == '\r' && i + 1 < text.length && text[i + 1] == '\n') {
        i++;
      }
      if (hasData) {
        row.add(field.toString());
        rows.add(row);
      }
      row = <String>[];
      field.clear();
      hasData = false;
    } else {
      field.write(c);
      hasData = true;
    }
  }
  if (hasData) {
    row.add(field.toString());
    rows.add(row);
  }
  return rows;
}
