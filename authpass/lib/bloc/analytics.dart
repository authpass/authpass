import 'dart:io';
import 'dart:ui';

import 'package:analytics_event/analytics_event.dart';
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
    'device': 'cd3',
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
//      _ga.onSend.listen((event) {
//        _logger.finer('analytics send: $event');
//      });
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

    _logger.finest('Registering analytics tracker.');
    events.registerTracker((event, params) {
      final eventParams = <String, String>{};
      int value;
      var category = 'track';

      final labelParams = <String>[];
      for (final entry in params.entries) {
        final customKey = _gaPropertyMapping[entry.key];
        _logger.fine('entry.key: ${entry.key} = ${entry.value.runtimeType}');
        if (entry.key == 'value' && entry.value is int) {
          value = entry.value as int;
        } else if (entry.key == 'category' && entry.value is String) {
          category = entry.value as String;
        } else if (customKey == null) {
          labelParams.add('${entry.key}=${entry.value}');
        } else {
          eventParams[customKey] = entry.value?.toString();
        }
      }
      labelParams.sort();

      final label = labelParams.join(',');
      _logger
          .finer('event($event, $eventParams, value=$value) - label: $label');
//      _amplitude?.logEvent(name: event, properties: params);
      _sendEvent(
        category,
        event,
        label: label,
        value: value,
        parameters: eventParams,
      );
    });
  }

  void trackScreen(String screenName) {
    _requireGa((ga) {
      _logger.finer('trackScreen($screenName)');
      ga.sendScreenView(screenName);
    });
  }

  void _sendEvent(String category, String action,
      {String label, int value, Map<String, String> parameters}) {
    _requireGa((ga) {
      ga.sendEvent(category, action,
          label: label, value: value, parameters: parameters);
    });
  }

  void updateSizes({
    Size viewportSize,
    Size displaySize,
    double devicePixelRatio,
  }) {
    _requireGa((ga) {
      ga.setSessionValue(
          'vp', '${viewportSize.width.round()}x${viewportSize.height.round()}');
      final sr = [displaySize.width, displaySize.height]
          .map((e) => (e / devicePixelRatio).round())
          .join('x');
      ga.setSessionValue('sr', sr);
    });
  }

  void _requireGa(void Function(usage.Analytics ga) callback) {
    if (_ga == null) {
      _gaQ.add(() => callback(_ga));
    } else {
      callback(_ga);
    }
  }
}

Future<String> deviceInfo() async {
  // get information about the current device.
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.model;
  }
  if (Platform.isIOS) {
    final iosInfo = await DeviceInfoPlugin().iosInfo;
    return iosInfo.utsname.machine;
  }
  return 'unknown (${Platform.operatingSystem})';
}

abstract class AnalyticsEvents implements AnalyticsEventStubs {
  void trackLaunch();

  Future<void> trackInit(
          {@required String userType, @required int value}) async =>
      _trackInit(userType: userType, device: await deviceInfo(), value: value);

  void _trackInit({
    @required String userType,
    @required String device,
    @required int value,
  });

  void trackActionPressed({@required String action});

  void trackCreateFile();

  void trackOpenFile({@required String type});

  void trackOpenFile2({@required String generator, @required String version});

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
  void trackSaveCount({@required String generator, @required int value});

  void trackAttachmentAction(String action, {String category = 'attachment'});
}
