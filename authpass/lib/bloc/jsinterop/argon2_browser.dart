@JS('argon2')
import 'dart:async';
import 'dart:typed_data';

import 'package:js/js.dart';

import 'package:logging/logging.dart';

final _logger = Logger('argon2_browser');

@JS('argon2.hash')
external PromiseJsImpl<Argon2Result> argon2BrowserHashInternal(
    Argon2BrowserOptions options);

Future<Uint8List> argon2BrowserHash(Argon2BrowserOptions options) {
  final completer = Completer<Uint8List>();
  _logger.info('calling argon2.');
  final result = argon2BrowserHashInternal(options);
  _logger.info('called.');
  result.then(allowInterop((Argon2Result result) {
    _logger.info('got some result ${result.runtimeType}');
    _logger.info('got some result ${result.hash.runtimeType}');
    final dynamic hash = result.hash;
    if (hash is Uint8List) {
      _logger.info('great, uint8list');
      completer.complete(hash);
    } else if (hash is List) {
      final intList = hash.cast<int>();

      completer.complete(Uint8List.fromList(intList));
    }
  }), allowInterop((dynamic error) {
    _logger.info('got some error.', error);
    completer.completeError(error as Object);
  }));
  return completer.future;
}

@JS()
@anonymous
class Argon2BrowserOptions {
  external factory Argon2BrowserOptions({
    required List<int> pass,
    required List<int> salt,
    int time,
    int mem,
    int hashLen,
    int parallelism,
    int type,
  });

  external List<int> get pass;
  external List<int> get salt;
  external int get time;
  external int get mem;
  external int get hashLen;
  external int get parallelism;
  external int get type;
}

@JS()
@anonymous
class Argon2Result {
  external dynamic get hash;
  external dynamic get encoded;
}

@JS('Promise')
class PromiseJsImpl<T> {
  external PromiseJsImpl(Function resolver);

  external PromiseJsImpl then([
    void Function(T result) onResolve,
    void Function(dynamic) onReject,
  ]);
}
