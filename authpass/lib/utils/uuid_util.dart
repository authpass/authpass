import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart' as uuid_util;

class UuidUtil {
  @NonNls
  static const _uuid =
      Uuid(options: <String, dynamic>{'grng': uuid_util.UuidUtil.cryptoRNG});

  static String createUuid() => _uuid.v4();
}
