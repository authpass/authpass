import 'dart:io';

import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:usage/usage_io.dart' as usage;
import 'package:analytics_event_gen/analytics_event_gen.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/ui/screens/password_list.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

part 'analytics.g.dart';

final _logger = Logger('analytics');

class Analytics {
  static const _APP_NAME = 'AuthPass';
  Analytics({@required this.env}) {
    _init();
  }

  static void trackError(String description, bool fatal) {
    _errorGa?.sendException(description, fatal: fatal);
  }

  final Env env;
  final AnalyticsEvents events = _$AnalyticsEvents();

  usage.Analytics _ga;

  /// global analytics tracker we use for error reporting.
  static usage.Analytics _errorGa;
  static const _gaPropertyMapping = <String, String>{
    'platform': 'cd1',
  };

  Future<void> _init() async {
    final info = await _getPackageInfo();
    _logger.fine('Got PackageInfo: ${info.appName}, ${info.buildNumber}, ${info.packageName}');
    if (env.analyticsGoogleAnalyticsId != null) {
      final docsDir = await getApplicationDocumentsDirectory();
      _ga = usage.AnalyticsIO(
        env.analyticsGoogleAnalyticsId,
        info.appName ?? _APP_NAME,
        '${info.version}+${info.buildNumber}',
        documentDirectory: docsDir,
      );
      _errorGa = _ga;
      _ga.setSessionValue(_gaPropertyMapping['platform'], Platform.operatingSystem);
    }

    events.registerTracker((event, params) {
      _logger.finer('event($event, $params)');
//      _amplitude?.logEvent(name: event, properties: params);
      _ga?.sendEvent(
        'track',
        event,
        parameters: Map.fromEntries(params.entries.map((entry) {
          final custom = _gaPropertyMapping[entry.key];
          if (custom == null) {
            return null;
          }
          return MapEntry(custom, entry.value?.toString());
        }).where((entry) => entry != null)),
      );
    });
  }

  void trackScreen(String screenName) {
    _logger.finer('trackScreen($screenName)');
    _ga?.sendScreenView(screenName);
  }

  Future<PackageInfo> _getPackageInfo() async {
    if (Platform.isIOS || Platform.isAndroid) {
      return await PackageInfo.fromPlatform();
    }
    return PackageInfo(
      appName: _APP_NAME,
      packageName: 'design.codeux.authpass',
      version: '0.0.0',
      buildNumber: '0',
    );
  }
}

abstract class AnalyticsEvents implements AnalyticsEventStubs {
  void trackLaunch();

  void trackOpenFile({@required OpenedFilesSourceType type});

  void trackSelectEntry({EntrySelectionType type});

  void trackCopyField({@required String key});
}
