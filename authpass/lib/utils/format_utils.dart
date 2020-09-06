import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

final _logger = Logger('format_utils');

class FormatUtils {
  FormatUtils({
    @required String locale,
  }) : _dateFormatFull = DateFormat.yMd(locale).add_Hms() {
    _logger.finer('Initialized with locale $locale');
  }

  static const String NL = '\n'; // NLN-NLS
  static const String SP = ' '; // NON-NLS

  final DateFormat _dateFormatFull;

  String formatDateFull(DateTime dateTime) =>
      _dateFormatFull.format(dateTime.toLocal());

  /// To keep things secure, like URLs we just log the first few characters.
  static String maxLength(String string, int maxLength,
      {String ellipsis = '…'}) {
    if (string.length > maxLength) {
      return '${string.substring(0, maxLength)}$ellipsis';
    }
    return string;
  }

  static String anonymizeUrl(String potentialUrl) =>
      maxLength(potentialUrl, 15);
}
