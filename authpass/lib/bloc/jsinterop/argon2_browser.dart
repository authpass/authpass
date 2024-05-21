@JS('argon2')
import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

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
  result.then(
      ((Argon2Result result) {
        _logger.info('got some result ${result.runtimeType}');
        _logger.info('got some result ${result.hash.runtimeType}');
        final hash = result.hash.toDart.asUint8List();
        // if (hash is Uint8List) {
        //   _logger.info('great, uint8list');
        //   completer.complete(hash);
        // } else if (hash is List) {
        //   final intList = hash.cast<int>();
        //
        //   completer.complete(Uint8List.fromList(intList));
        // }
        completer.complete(hash);
      }).toJS,
      ((JSObject error) {
        _logger.info('got some error.', error);
        completer.completeError(error as Object);
      }).toJS);
  return completer.future;
}

extension type Argon2BrowserOptions._(JSObject o) implements JSObject {
  external factory Argon2BrowserOptions({
    required JSUint8Array pass,
    required JSUint8Array salt,
    int time,
    int mem,
    int hashLen,
    int parallelism,
    int type,
  });

  external JSUint8Array get pass;
  external JSUint8Array get salt;
  external int get time;
  external int get mem;
  external int get hashLen;
  external int get parallelism;
  external int get type;
}

extension type Argon2Result._(JSObject o) implements JSObject {
  external JSArrayBuffer get hash;
  external JSArrayBuffer get encoded;
}

@JS('Promise')
extension type PromiseJsImpl<T>._(JSObject _) implements JSObject {
  external PromiseJsImpl(JSExportedDartFunction resolver);

  external PromiseJsImpl<dynamic> then([
    JSExportedDartFunction onResolve,
    JSExportedDartFunction onReject,
  ]);
}
