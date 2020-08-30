import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart' as uuid_util;

class UuidUtil {
  static final _uuid =
      Uuid(options: <String, dynamic>{'grng': uuid_util.UuidUtil.cryptoRNG});

  static String createUuid() => _uuid.v4();
}
