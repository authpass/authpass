import 'dart:ffi';

import 'package:authpass/env/_base.dart';
import 'package:authpass/utils/platform.dart';
import 'package:ffi/ffi.dart';
import 'package:logging/logging.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';
import 'package:winsparkle_flutter/winsparkle_flutter.dart';

final _logger = Logger('winsparkle_init');

@NonNls
const _appCastUrl = 'https://data.authpass.app/data/artifacts/appcast.xml';
@NonNls
const _herbertCompany = 'CodeUX.design';

Future<void> initWinSparkle(Env env) async {
  assert(AuthPassPlatform.isWindows);
  _logger.fine('Initializing winsparkle.');
  final freePointers = <Pointer<NativeType>>[];
  try {
    final url = _appCastUrl.toNativeUtf8();
    win_sparkle_set_appcast_url(url);

    final appInfo = await env.getAppInfo();
    final companyName = _herbertCompany.toNativeUtf16();
    final name = appInfo.appName.toNativeUtf16();
    final appVersion = appInfo.versionLabel.toNativeUtf16();
    freePointers.addAll([companyName, name, appVersion]);
//    final
    win_sparkle_set_app_details(companyName, name, appVersion);

    final buildVersion = appInfo.buildNumber.toString().toNativeUtf16();
    win_sparkle_set_app_build_version(buildVersion);

    win_sparkle_init();
  } catch (e, stackTrace) {
    _logger.severe('Error while interacting with winsparkle.', e, stackTrace);
    try {
      freePointers.forEach(calloc.free);
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
