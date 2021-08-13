import 'dart:typed_data';

import 'package:argon2_ffi_base/argon2_ffi_base.dart';
import 'package:authpass/utils/logging_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

final _logger = Logger('kdbx_argon2_ffi');

// ignore_for_file: non_constant_identifier_names

class FlutterArgon2 extends Argon2 {
  static final singleton = Argon2FfiFlutter();

  @override
  Uint8List argon2(Argon2Arguments args) {
    throw StateError('Use [argon2Async]');
  }

  @override
  Future<Uint8List> argon2Async(Argon2Arguments args) async {
    final started = Stopwatch()..start();
    try {
      _logger.finest('Starting argon2');
      return await compute(FlutterArgon2._runArgon2, args);
    } finally {
      _logger.fine('Finished argon2 in ${started.elapsedMilliseconds}ms');
    }
  }

  static Uint8List _runArgon2(Argon2Arguments args) {
    LoggingUtils().setupLogging(fromMainIsolate: false);
    return singleton.argon2(args);
  }

  @override
  bool get isFfi => singleton.isFfi;

  @override
  bool get isImplemented => singleton.isFfi;
}
