import 'package:authpass/utils/platform.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('secure_window');

/// Keeps the app's contents out of the picture iOS takes for the app switcher.
///
/// Android gets the same protection from `FLAG_SECURE`, which the window
/// manager applies by itself. iOS has no such flag, so the native side covers
/// the window while the system takes its picture and this only carries the
/// preference across — both platforms read the one `secureWindow` setting.
///
/// A no-op everywhere else, so callers do not have to check the platform.
class SecureWindow {
  SecureWindow({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(_channelName);

  @NonNls
  static const _channelName = 'design.codeux.authpass/secure_window';

  final MethodChannel _channel;

  Future<void> setSecure(bool secure) async {
    if (!AuthPassPlatform.isIOS) {
      return;
    }
    try {
      await _channel.invokeMethod<void>(nonNls('setSecure'), secure);
    } on PlatformException catch (e, stackTrace) {
      // Not worth bothering the user about: the consequence is a screenshot in
      // the app switcher, and there is nothing they could do here anyway.
      _logger.warning(
        'Unable to change the secure window flag.',
        e,
        stackTrace,
      );
    } on MissingPluginException catch (e, stackTrace) {
      _logger.warning(
        'Secure window channel is not registered.',
        e,
        stackTrace,
      );
    }
  }
}
