import 'dart:async';
import 'dart:typed_data';

import 'package:argon2_ffi_base/argon2_ffi_base.dart';
import 'package:authpass/bloc/jsinterop/argon2_browser.dart';

class FlutterArgon2 extends Argon2 {
  @override
  Uint8List argon2(Argon2Arguments args) {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> argon2Async(Argon2Arguments args) {
    return argon2BrowserHash(Argon2BrowserOptions(
      pass: args.key,
      salt: args.salt,
      time: args.iterations,
      mem: args.memory,
      hashLen: args.length,
      parallelism: args.parallelism,
      type: args.type,
    ));
  }

  @override
  bool get isFfi => false;

  @override
  bool get isImplemented => true;
}
