import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:logging/logging.dart';

final _logger = Logger('ios_autofill_service');

class IosAutoFillService with StreamSubscriberBase {
  IosAutoFillService(this.kdbxBloc) {
    handle(kdbxBloc.openedFilesChanged.listen((event) {}));
  }

  static const platform = MethodChannel('design.codeux.authpass.ios/as');
  final KdbxBloc kdbxBloc;

  Future<bool> _invokeBool(String methodName) async {
    final ret = await platform.invokeMethod<int>('isAvailable');
    _logger.finer('$methodName:$ret');
    return ret == 1;
  }

  Future<bool> isAvailable() => _invokeBool('isAvailable');
  Future<bool> isEnabled() => _invokeBool('isEnabled');

  void dispose() {
    cancelSubscriptions();
  }
}
