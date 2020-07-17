import 'dart:ffi';
import 'dart:io';

import 'package:authpass/env/_base.dart';
import 'package:ffi/ffi.dart';

import 'package:logging/logging.dart';
import 'package:winsparkle_flutter/winsparkle_flutter.dart';

final _logger = Logger('winsparkle_init');

Future<void> initWinSparkle(Env env) async {
  assert(Platform.isWindows);
  _logger.fine('Initializing winsparkle.');
  final freePointers = <Pointer<NativeType>>[];
  try {
    final url =
        Utf8.toUtf8('https://data.authpass.app/data/artifacts/appcast.xml');
    win_sparkle_set_appcast_url(url);

    final appInfo = await env.getAppInfo();
    final companyName = Utf8.toUtf8('CodeUX.design');
    final name = Utf16.toUtf16(appInfo.appName);
    final appVersion = Utf16.toUtf16(appInfo.versionLabel);
    freePointers.addAll([companyName, name, appVersion]);
//    final
    win_sparkle_set_app_details(companyName, name, appVersion);

    final buildVersion = Utf16.toUtf16(appInfo.buildNumber.toString());
    win_sparkle_set_app_build_version(buildVersion);

    win_sparkle_init();
  } catch (e, stackTrace) {
    _logger.severe('Error while interacting with winsparkle.', e, stackTrace);
    try {
      freePointers.forEach(free);
    } catch (e, stackTrace) {
      _logger.warning('Error while freeing pointer.', e, stackTrace);
    }
  }
}

void cleanupWinSparkle() {
  try {
    win_sparkle_cleanup();
  } catch (e, stackTrace) {
    _logger.warning(
        'Error while calling cleanup for WinSparkle', e, stackTrace);
  }
}

void winSparkleCheckUpdate() {
  win_sparkle_check_update_with_ui();
}
