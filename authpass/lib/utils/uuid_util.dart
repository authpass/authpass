import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';
import 'package:uuid/data.dart';
import 'package:uuid/rng.dart';
import 'package:uuid/uuid.dart';

class UuidUtil {
  @NonNls
  static final _uuid = Uuid(goptions: GlobalOptions(CryptoRNG()));

  static String createUuid() => _uuid.v4();
}
