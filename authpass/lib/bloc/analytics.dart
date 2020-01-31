import 'dart:io';

import 'package:analytics_event_gen/analytics_event_gen.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/ui/screens/password_list.dart';
import 'package:authpass/utils/path_utils.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:usage/usage_io.dart' as usage;

part 'analytics.g.dart';
part 'analytics_ua.dart';

final _logger = Logger('analytics');

class Analytics {
  Analytics({@required this.env}) {
    _init();
  }

  static void trackError(String description, bool fatal) {
    _errorGa?.sendException(description, fatal: fatal);
  }

  final Env env;
  final AnalyticsEvents events = _$AnalyticsEvents();

  usage.Analytics _ga;
  final List<VoidCallback> _gaQ = [];

  /// global analytics tracker we use for error reporting.
  static usage.Analytics _errorGa;
  static const _gaPropertyMapping = <String, String>{
    'platform': 'cd1',
    'userType': 'cd2',
  };

  Future<void> _init() async {
    if (env.secrets.analyticsGoogleAnalyticsId != null) {
      if (Platform.isAndroid) {
        const miscChannel = MethodChannel('app.authpass/misc');
        final isFirebaseTestLab =
            await miscChannel.invokeMethod<bool>('isFirebaseTestLab');
        if (isFirebaseTestLab) {
          _logger.info(
              'running in firebase test lab. not initializing analytics.');
          return;
        }
      }

      final info = await env.getAppInfo();

      String platformVersion;
      String deviceInfo;
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        platformVersion = androidInfo.version.release;
        deviceInfo = androidInfo.model;
      } else if (Platform.isIOS) {
        final iosInfo = await DeviceInfoPlugin().iosInfo;
        platformVersion = iosInfo.systemVersion;
      }
      final userAgent = _createUserAgent(
          platformVersion: platformVersion, deviceInfo: deviceInfo);
      _logger.fine(
          'Got PackageInfo: ${info.appName}, ${info.buildNumber}, ${info.packageName} - '
          'UserAgent: $userAgent');

      final docsDir = await PathUtils().getAppDataDirectory();
      _ga = usage.AnalyticsIO(
        env.secrets.analyticsGoogleAnalyticsId,
        info.appName,
        '${info.version}+${info.buildNumber}',
        documentDirectory: docsDir,
        userAgent: userAgent,
      );
      _ga.setSessionValue('ua', userAgent);
      _errorGa = _ga;
      _ga.setSessionValue(
          _gaPropertyMapping['platform'], Platform.operatingSystem);
      // set application id to package name.
      _ga.setSessionValue('aid', info.packageName);

      for (final cb in _gaQ) {
        cb();
      }
      _gaQ.clear();
    } else {
      _logger.info('No analyics Id defined. Not tracking anyting.');
    }

    events.registerTracker((event, params) {
      final eventParams = <String, String>{};
      int value;

      final labelParams = <String>[];
      for (final entry in params.entries) {
        final custom = _gaPropertyMapping[entry.key];
        if (entry.key == 'value' && entry.value is int) {
          value = entry.value as int;
        }
        if (custom == null) {
          labelParams.add('${entry.key}=${entry.value}');
        } else {
          eventParams[entry.key] = entry.value?.toString();
        }
      }
      labelParams.sort();

      final label = labelParams.join(',');
      _logger.finer('event($event, $params, value=$value) - label: $label');
//      _amplitude?.logEvent(name: event, properties: params);
      _sendEvent(
        'track',
        event,
        label: label,
        value: value,
        parameters: eventParams,
      );
    });
  }

  void trackScreen(String screenName) {
    if (_ga == null) {
      _gaQ.add(() {
        trackScreen(screenName);
      });
      return;
    }
    _logger.finer('trackScreen($screenName)');
    _ga?.sendScreenView(screenName);
  }

  void _sendEvent(String category, String action,
      {String label, int value, Map<String, String> parameters}) {
    if (_ga == null) {
      _gaQ.add(() {
        _sendEvent(category, action,
            label: label, value: value, parameters: parameters);
      });
      return;
    }
    _ga.sendEvent(category, action,
        label: label, value: value, parameters: parameters);
  }
}

abstract class AnalyticsEvents implements AnalyticsEventStubs {
  void trackLaunch();

  void trackCreateFile();

  void trackOpenFile({@required String type});

  void trackSelectEntry({EntrySelectionType type});

  void trackCopyField({@required String key});

  void trackAddField({@required String key});

  void trackCloseAllFiles({int count});

  void trackUserType({String userType});

  void trackCloseFile();

  /// weird case of empty password list.
  void trackPasswordListEmpty();

  void trackQuickUnlock({int value});

  void trackSave({@required String type, int value});
}
