import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:ffi_helper/ffi_helper.dart';
import 'package:kdbx/kdbx.dart';

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

class FlutterArgon2 extends Argon2Base {
  FlutterArgon2() {
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
