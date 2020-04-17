import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:kdbx/kdbx.dart';

// ignore_for_file: non_constant_identifier_names

typedef Argon2HashNative = Pointer<Utf8> Function(
  Pointer<Uint8> key,
  IntPtr keyLen,
  Pointer<Uint8> salt,
  Uint64 saltlen,
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

class Argon2Arguments {
  Argon2Arguments(this.key, this.salt, this.memory, this.iterations,
      this.length, this.parallelism, this.type, this.version);
  final Uint8List key;
  final Uint8List salt;
  final int memory;
  final int iterations;
  final int length;
  final int parallelism;
  final int type;
  final int version;
}

class FlutterArgon2 extends Argon2 {
  @override
  Argon2Hash argon2hash;

  @override
  Uint8List argon2(Uint8List key, Uint8List salt, int memory, int iterations,
      int length, int parallelism, int type, int version) {
    final args = Argon2Arguments(
        key, salt, memory, iterations, length, parallelism, type, version);
    return compute(FlutterArgon2.runArgon2, args);
  }

  static Uint8List runArgon2(Argon2Arguments) {}
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
