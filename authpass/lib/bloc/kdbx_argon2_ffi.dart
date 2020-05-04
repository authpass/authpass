import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';

final _logger = Logger('kdbx_argon2_ffi');

// ignore_for_file: non_constant_identifier_names

typedef Argon2HashNative = Pointer<Utf8> Function(
  Pointer<Uint8> key,
  Uint32 keyLen,
  Pointer<Uint8> salt,
  Uint32 saltlen,
  Uint32 m_cost, // memory cost
  Uint32 t_cost, // time cost (number iterations)
  Uint32 parallelism,
  IntPtr hashlen,
  Uint8 type,
  Uint32 version,
);

typedef Argon2Hash = Pointer<Utf8> Function(
  Pointer<Uint8> key,
  int keyLen,
  Pointer<Uint8> salt,
  int saltlen,
  int m_cost, // memory cost
  int t_cost, // time cost (number iterations)
  int parallelism,
  int hashlen,
  int type,
  int version,
);

class FlutterArgon2 extends Argon2 {
  static final singleton = FlutterArgon2Native();

  @override
  Uint8List argon2(Argon2Arguments args) {
    throw StateError('Use [argon2Async]');
  }

  @override
  Future<Uint8List> argon2Async(Argon2Arguments args) async {
    final started = Stopwatch()..start();
    try {
      _logger.finest('Starting argon2');
      return await compute(FlutterArgon2.runArgon2, args);
    } finally {
      _logger.fine('Finished argon2 in ${started.elapsedMilliseconds}ms');
    }
  }

  static Uint8List runArgon2(Argon2Arguments args) {
    return singleton.argon2(args);
  }
}

class FlutterArgon2Native extends Argon2Base {
  FlutterArgon2Native() {
    final argon2lib = Platform.isAndroid
        ? DynamicLibrary.open('libargon2_ffi.so')
        : DynamicLibrary.executable();
    argon2hash = argon2lib
        .lookup<NativeFunction<Argon2HashNative>>('hp_argon2_hash')
        .asFunction();
  }
  @override
  Argon2Hash argon2hash;
}
