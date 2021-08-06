import 'dart:typed_data';

import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/extension_methods.dart';
import 'package:base32/base32.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:logging/logging.dart';
import 'package:otp/otp.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('otpauth');

/// loosely based on format from
/// https://github.com/google/google-authenticator/wiki/Key-Uri-Format
class OtpAuth {
  const OtpAuth({
    required this.secret,
    this.algorithm = DEFAULT_ALGORITHM,
    this.digits = DEFAULT_DIGITS,
    this.period = DEFAULT_PERIOD,
    this.label = CharConstants.empty,
  });

  factory OtpAuth.fromUri(Uri uri) {
    final p = uri.queryParameters;

    return OtpAuth(
      label: uri.pathSegments
          .firstWhere((element) => true, orElse: () => CharConstants.empty),
      secret: base32.decode(p[PARAM_SECRET]!),
      algorithm: algorithmForString(p[PARAM_ALGORITHM]) ?? DEFAULT_ALGORITHM,
      digits: p[PARAM_DIGITS]?.toInt() ?? DEFAULT_DIGITS,
      period: p[PARAM_PERIOD]?.toInt() ?? DEFAULT_PERIOD,
    );
  }

  @NonNls
  static OtpAuth? fromQueryString(String value) {
    if (value.contains('key=')) {
      _logger.finer('value contains "key=": $value');
      // KeeOTP format:key={base32Key}&size=12&step=33&type=Totp&counter=3
      final data = Uri.splitQueryString(value);
      try {
        return OtpAuth(
          secret: base32.decode(_addBase32Padding(data['key'])!),
          period: data['step']?.toInt() ?? OtpAuth.DEFAULT_PERIOD,
          digits: data['size']?.toInt() ?? OtpAuth.DEFAULT_DIGITS,
        );
      } on FormatException catch (e, stackTrace) {
        _logger.fine('Error parsing $data', e, stackTrace);
        rethrow;
      }
    }
  }

  static String? _addBase32Padding(String? base32data) {
    if (base32data == null) {
      return null;
    }
    final padding = (8 - (base32data.length % 8)) % 8;
    if (padding == 0) {
      return base32data;
    }
    return base32data + ('=' * padding); // NON-NLS
  }

  @NonNls
  static const SCHEME = 'otpauth';
  @NonNls
  static const URI_PREFIX = '$SCHEME:';

  /// we only support time based tokens anyway.
  static const TYPE_TOTP = 'totp'; // NON-NLS
  static const PARAM_SECRET = 'secret'; // NON-NLS
  static const PARAM_ALGORITHM = 'algorithm'; // NON-NLS
  static const PARAM_DIGITS = 'digits'; // NON-NLS
  static const PARAM_PERIOD = 'period'; // NON-NLS

  static const QUERY_PARAM_KEY = 'key'; // NON-NLS
  static const QUERY_PARAM_STEP = 'step'; // NON-NLS
  static const QUERY_PARAM_SIZE = 'size'; // NON-NLS

  static const DEFAULT_ALGORITHM = Algorithm.SHA1;
  static const DEFAULT_DIGITS = 6;
  static const DEFAULT_PERIOD = 30;

  @NonNls
  static Map<Algorithm, String> algorithms = {
    Algorithm.SHA1: 'SHA1',
    Algorithm.SHA256: 'SHA256',
    Algorithm.SHA512: 'SHA512',
  };

  static Algorithm? algorithmForString(String? key) =>
      algorithms.entries.firstWhereOrNull((entry) => entry.value == key)?.key;

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

  @NonNls
  @override
  String toString() {
    return 'OtpAuth{label: $label, algorithm: $algorithm, digits: $digits, period: $period}';
  }
}
