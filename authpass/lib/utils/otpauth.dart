import 'dart:typed_data';

import 'package:authpass/utils/extension_methods.dart';
import 'package:base32/base32.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:meta/meta.dart';
import 'package:otp/otp.dart';

/// losely based on format from
/// https://github.com/google/google-authenticator/wiki/Key-Uri-Format
class OtpAuth {
  const OtpAuth({
    required this.secret,
    this.algorithm = DEFAULT_ALGORITHM,
    this.digits = DEFAULT_DIGITS,
    this.period = DEFAULT_PERIOD,
    this.label = '',
  })  : assert(secret != null),
        assert(algorithm != null),
        assert(digits != null),
        assert(period != null);

  factory OtpAuth.fromUri(Uri uri) {
    final p = uri.queryParameters;

    return OtpAuth(
      label: uri.pathSegments.firstWhere((element) => true, orElse: () => ''),
      secret: base32.decode(p[PARAM_SECRET]!),
      algorithm: algorithmForString(p[PARAM_ALGORITHM]) ?? DEFAULT_ALGORITHM,
      digits: p[PARAM_DIGITS]?.toInt() ?? DEFAULT_DIGITS,
      period: p[PARAM_PERIOD]?.toInt() ?? DEFAULT_PERIOD,
    );
  }

  static const SCHEME = 'otpauth';

  /// we only support time based tokens anyway.
  static const TYPE_TOTP = 'totp';
  static const PARAM_SECRET = 'secret';
  static const PARAM_ALGORITHM = 'algorithm';
  static const PARAM_DIGITS = 'digits';
  static const PARAM_PERIOD = 'period';

  static const DEFAULT_ALGORITHM = Algorithm.SHA1;
  static const DEFAULT_DIGITS = 6;
  static const DEFAULT_PERIOD = 30;

  static Map<Algorithm, String> algorithms = {
    Algorithm.SHA1: 'SHA1',
    Algorithm.SHA256: 'SHA256',
    Algorithm.SHA512: 'SHA512',
  };

  static Algorithm? algorithmForString(String? key) => algorithms.entries
      .firstWhereOrNull((entry) => entry.value == key)
      ?.key;

  final String label;
  final Algorithm algorithm;
  final Uint8List secret;
  final int digits;
  final int period;

  Uri toUri() => Uri(
        scheme: SCHEME,
        host: TYPE_TOTP,
        pathSegments: [label],
        queryParameters: <String, String?>{
          PARAM_SECRET: base32.encode(secret),
          PARAM_ALGORITHM: algorithms[algorithm],
          PARAM_DIGITS: digits.toString(),
          PARAM_PERIOD: period.toString(),
        },
      );

  @override
  String toString() {
    return 'OtpAuth{label: $label, algorithm: $algorithm, digits: $digits, period: $period}';
  }
}
