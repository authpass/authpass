import 'dart:typed_data';

import 'package:authpass/utils/constants.dart';
import 'package:base32/base32.dart';

final _spaces = RegExp(r'\s+');

Uint8List base32Decode(String code) {
  return base32
      .decode(code.replaceAll(_spaces, CharConstants.empty).toUpperCase());
}

String base32Encode(Uint8List data) => base32.encode(data);
