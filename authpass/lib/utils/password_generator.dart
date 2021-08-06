import 'dart:math';

import 'package:charcode/ascii.dart';
import 'package:charcode/html_entity.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

class PasswordGenerator {
  factory PasswordGenerator.singleton() => _instance;
  PasswordGenerator._();

  static final _instance = PasswordGenerator._();
  final _random = Random.secure();

  String generatePassword(CharacterSet characterSet, int length) {
    final max = characterSet.length;
    return String.fromCharCodes(
        List.generate(length, (i) => characterSet[_random.nextInt(max)]));
  }
}

abstract class CharacterSet {
  const CharacterSet();

  static const alphabetAsciiLowerCase = CharacterRange($a, $z);
  static const alphabetAsciiUpperCase = CharacterRange($A, $Z);
  static const numeric = CharacterRange($0, $9);
  static const alphabetUmlauts = CharacterRange($Agrave, $yuml);
  // CharacterString('äüößÄÜÖ');
  @NonNls
  static const specialCharacters =
      CharacterString(r'''@%+\/$'!#$^?:,.(){}[]~-_''');

  /// keys used for persisting user selection for default password generator.
  @NonNls
  static const selectableCharacterSets = {
    'alphabetAsciiLowerCase': alphabetAsciiLowerCase,
    'alphabetAsciiUpperCase': alphabetAsciiUpperCase,
    'numeric': numeric,
    'alphabetUmlauts': alphabetUmlauts,
    'specialCharacters': specialCharacters,
  };

  static const alphaNumeric = CharacterSetCollection([
    alphabetAsciiLowerCase,
    alphabetAsciiUpperCase,
    numeric,
  ]);

  int operator [](int pos);

  int get length;

  CharacterSet operator +(CharacterSet other) =>
      CharacterSetCollection([this, other]);

  static String characterSetIdFor(CharacterSet? set) =>
      selectableCharacterSets.entries
          .firstWhere((entry) => entry.value == set)
          .key;

  static Set<CharacterSet?> characterSetFromIds(Iterable<String> ids) =>
      ids.map((setId) => CharacterSet.selectableCharacterSets[setId]).toSet();
}

class CharacterSetCollection extends CharacterSet {
  const CharacterSetCollection(this.sets);

  final List<CharacterSet?> sets;

  @override
  int operator [](int pos) {
    var i = pos;
    for (final set in sets) {
      if (i < set!.length) {
        return set[i];
      }
      i -= set.length;
    }
    throw RangeError('Unable to find $pos ($i items after last index).');
  }

  @override
  int get length => sets.fold(0, (prev, set) => prev + set!.length);
}

class CharacterRange extends CharacterSet {
  const CharacterRange(this.charCodeStart, this.charCodeEnd);

  final int charCodeStart;
  final int charCodeEnd;

  @override
  int operator [](int pos) {
    final ret = charCodeStart + pos;
    if (ret > charCodeEnd) {
      throw RangeError(
          'Out of range. $pos (vs. $charCodeStart to $charCodeEnd)');
    }
    return ret;
  }

  @override
  int get length => charCodeEnd - charCodeStart;
}

class CharacterString extends CharacterSet {
  const CharacterString(this._string);

  final String _string;

  @override
  int operator [](int pos) => _string.codeUnitAt(pos);

  @override
  int get length => _string.length;
}
