import 'package:analytics_event/analytics_event.dart';
import 'package:authpass/bloc/analytics_io.dart'
    if (dart.library.html) 'package:authpass/bloc/analytics_html.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/ui/screens/password_list.dart';
import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/platform.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';
import 'package:usage/usage.dart' as usage;

part 'analytics.g.dart';
part 'analytics_ua.dart';

final _logger = Logger('analytics');

/// user agent
const _sessionParamUa = 'ua'; // NON-NLS
/// application id
const _sessionParamAid = 'aid'; // NON-NLS
const _propertyMappingPlatform = 'platform'; // NON-NLS

class Analytics {
  Analytics({required this.env}) {
    _init();
  }

  static void trackError(@NonNls String description, bool fatal) {
    _errorGa?.sendException(description, fatal: fatal);
  }

  final Env env;
  final AnalyticsEvents events = _$AnalyticsEvents();

  usage.Analytics? _ga;
  final List<VoidCallback> _gaQ = [];
  String? _dbg;

  /// global analytics tracker we use for error reporting.
  static usage.Analytics? _errorGa;
  static const _gaPropertyMapping = <String, String>{
    _propertyMappingPlatform: 'cd1', // NON-NLS
    'userType': 'cd2', // NON-NLS
    'device': 'cd3', // NON-NLS
    'systemBrightness': 'cd4', // NON-NLS
  };

  Future<void> _init() async {
    if (env.secrets!.analyticsGoogleAnalyticsId != null) {
      if (AuthPassPlatform.isAndroid) {
        const miscChannel = MethodChannel('app.authpass/misc');
        final isFirebaseTestLab = await miscChannel
            .invokeMethod<bool>('isFirebaseTestLab'); // NON-NLS
        if (isFirebaseTestLab != null && isFirebaseTestLab) {
          _logger.info(
              'running in firebase test lab. not initializing analytics.');
          return;
        }
      }

      final info = await env.getAppInfo();

      String? platformVersion;
      String? deviceInfo;
      if (AuthPassPlatform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        platformVersion = androidInfo.version.release;
        deviceInfo = androidInfo.model;
      } else if (AuthPassPlatform.isIOS) {
        final iosInfo = await DeviceInfoPlugin().iosInfo;
        platformVersion = iosInfo.systemVersion;
      }
      final userAgent = _createUserAgent(
          platformVersion: platformVersion, deviceInfo: deviceInfo);
      _logger.fine(
          'Got PackageInfo: ${info.appName}, ${info.buildNumber}, ${info.packageName} - '
          'UserAgent: $userAgent');

      _dbg = '(ga)'; // NON-NLS
      _ga = await analyticsCreate(
        env.secrets!.analyticsGoogleAnalyticsId!,
        info.appName,
        [info.version, CharConstants.plus, info.buildNumber].join(),
        userAgent: userAgent,
      );
//      _ga.onSend.listen((event) {
//        _logger.finer('analytics send: $event');
//      });
      _ga!.setSessionValue(_sessionParamUa, userAgent);
      _errorGa = _ga;
      _ga!.setSessionValue(_gaPropertyMapping[_propertyMappingPlatform]!,
          AuthPassPlatform.operatingSystem);
      // set application id to package name.
      _ga!.setSessionValue(_sessionParamAid, info.packageName);
    } else {
      _logger.info('No analytics Id defined. Not tracking anything.');
      _errorGa = _ga = usage.AnalyticsMock();
      _dbg = '(noop)'; // NON-NLS
    }

    for (final cb in _gaQ) {
      cb();
    }
    _gaQ.clear();

    _logger.finest('$_dbg Registering analytics tracker. ${_ga!.clientId}');
    events.registerTracker(nonNls((final action, params) {
      final eventParams = <String, String?>{};
      int? value;
      String? category;
      String? actionOverride;

      final labelParams = <String>[];
      for (final entry in params.entries) {
        final customKey = _gaPropertyMapping[entry.key];
//        _logger.fine('entry.key: ${entry.key} = ${entry.value.runtimeType}');
        if (entry.key == 'value' && entry.value is int) {
          value = entry.value as int?;
        } else if (entry.key == 'category' && entry.value is String) {
          category = entry.value as String?;
        } else if (entry.key == 'action' && entry.value is String) {
          actionOverride = entry.value as String;
        } else if (customKey == null) {
          labelParams.add('${entry.key}=${entry.value}');
        } else {
          eventParams[customKey] = entry.value?.toString();
        }
      }
      labelParams.sort();

      if (actionOverride != null) {
        category = actionOverride;
      }

      final label = labelParams.join(',');
//      _amplitude?.logEvent(name: event, properties: params);
      _sendEvent(
        category ?? 'track',
        actionOverride ?? action,
        label: label,
        value: value,
        parameters: eventParams,
      );
    }));
  }

  void trackScreen(@NonNls String screenName) {
    _requireGa((ga) {
      ga!.sendScreenView(screenName);
      _logger.finer('$_dbg screen($screenName)');
    });
  }

  void trackGenericEvent(
    @NonNls String category,
    @NonNls String action, {
    @NonNls String? label,
    int? value,
    @NonNls Map<String, String>? parameters,
  }) =>
      _sendEvent(
        category,
        action,
        label: label,
        value: value,
        parameters: parameters,
      );

  void trackTiming(
    @NonNls String variableName,
    int timeMs, {
    @NonNls String? category,
    @NonNls String? label,
  }) {
    _requireGa((ga) {
      ga!.sendTiming(variableName, timeMs, category: category, label: label);
      _logger.finest('$_dbg timing($variableName, $timeMs, '
          'category: $category, label: $label)');
    });
  }

  void _sendEvent(String? category, String? action,
      {String? label, int? value, Map<String, String?>? parameters}) {
    _requireGa((ga) {
      ga!.sendEvent(category!, action!,
          label: label,
          value: value,
          parameters: parameters?.map(
              (key, value) => MapEntry(key, value ?? CharConstants.empty)));
      _logger.finer(
          '$_dbg event($category, $action, $label, $value) - parameters: $parameters');
    });
  }

  void updateSizes({
    double? viewportSizeWidth,
    double? viewportSizeHeight,
    double? displaySizeWidth,
    double? displaySizeHeight,
    double? devicePixelRatio,
  }) {
    _requireGa(nonNls((ga) {
      ga!.setSessionValue(
          'vp', '${viewportSizeWidth!.round()}x${viewportSizeHeight!.round()}');
      final sr = [displaySizeWidth, displaySizeHeight]
          .map((e) => (e! / devicePixelRatio!).round())
          .join('x');
      ga.setSessionValue('sr', sr);
    }));
  }

  void _requireGa(void Function(usage.Analytics? ga) callback) {
    if (_ga == null) {
      _gaQ.add(() => callback(_ga));
    } else {
      callback(_ga);
    }
  }
}

const _unknown = 'unknown'; // NON-NLS

Future<String> deviceInfo() async {
  // get information about the current device.
  if (AuthPassPlatform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.model ?? _unknown;
  }
  if (AuthPassPlatform.isIOS) {
    final iosInfo = await DeviceInfoPlugin().iosInfo;
    return iosInfo.utsname.machine ?? _unknown;
  }
  return [
    _unknown,
    AuthPassPlatform.operatingSystemVersion,
    AuthPassPlatform.operatingSystem
  ].join(CharConstants.space);
}

abstract class AnalyticsEvents implements AnalyticsEventStubs {
  void trackLaunch({required Brightness systemBrightness});

  Future<void> trackInit(
          {required String? userType, required int value}) async =>
      _trackInit(userType: userType, device: await deviceInfo(), value: value);

  void _trackInit({
    required String? userType,
    required String device,
    required int value,
  });

  void trackOnboardingNew({
    @NonNls String category = 'onboarding', // NON-NLS
    @NonNls String action = 'click', // NON-NLS
    @NonNls String label = 'onboardingNewbie', // NON-NLS
  });

  void trackOnboardingExisting({
    @NonNls String category = 'onboarding', // NON-NLS
    @NonNls String action = 'click', // NON-NLS
    @NonNls String label = 'onboardingExisting', // NON-NLS
  });

  void trackActionPressed({@NonNls required String action});

  void trackCreateFileAt({
    required String cloudStorageId,
    @NonNls required String category,
  });

  void trackCreateFile();

  void trackOpenFile({@NonNls required String type});

  void trackOpenFile2(
      {@NonNls required String generator, @NonNls required String version});

  void trackSelectEntry({EntrySelectionType? type});

  void trackCopyField({@NonNls required String key});

  void trackAddField({@NonNls required String key});

  void trackCloseAllFiles({required int count});

  void trackLockAllFiles({required int count});

  void trackUserType({@NonNls String? userType});

  void trackCloseFile();

  /// weird case of empty password list.
  void trackPasswordListEmpty();

  void trackQuickUnlock({int? value});

  void trackSave({required String type, int? value});
  void trackSaveConflict({
    required String type,
    int? value,
    required bool success,
  });
  void trackSaveCount({required String? generator, required int value});

  void trackDrawerOpen();

  @NonNls
  void trackAttachmentAction(
    @NonNls String action, {
    @NonNls String category = 'attachment',
  });

  @NonNls
  void trackAttachmentAdd(
    AttachmentAddType action,
    String ext,
    int value, {
    @NonNls String category = 'attachmentAdd',
  });

  @NonNls
  void trackCloudAuth(
    CloudAuthAction action, {
    String label = 'auth',
    String category = 'cloud',
  });

  @NonNls
  void trackGroupDelete(GroupDeleteResult result, {String category = 'group'});
  @NonNls
  void trackGroupCreate({String category = 'group'});

  @NonNls
  void trackPermanentlyDeleteEntry({
    String category = 'entry',
    String action = 'perm-delete',
    String label = 'confirm',
  });
  @NonNls
  void trackPermanentlyDeleteEntryCancel({
    String category = 'entry',
    String action = 'perm-delete',
    String label = 'cancel',
  });
  @NonNls
  void trackPermanentlyDeleteGroup({
    String category = 'group',
    String action = 'perm-delete',
    String label = 'confirm',
  });
  @NonNls
  void trackPermanentlyDeleteGroupCancel({
    String category = 'group',
    String action = 'perm-delete',
    String label = 'cancel',
  });

  @NonNls
  void trackPreferences({
    @NonNls required String setting,
    @NonNls required String to,
  }) =>
      _trackPreferences(action: setting, to: to, category: 'preferences');
  void _trackPreferences({
    required String action,
    required String to,
    String? category,
  });

  @NonNls
  void trackAutofillFilter({
    @NonNls required String filter,
    String category = 'autofill',
    String action = 'filter',
    required int value,
  });
  @NonNls
  void trackAutofillSelect({
    String category = 'autofill',
    String action = 'select',
  });

  @NonNls
  void trackTryUnlock({
    required TryUnlockResult action,
    required String ext,
    required String source,
    String category = 'tryUnlock',
  });

  @NonNls
  void trackCopyPassword({
    String category = 'copyClipboard',
    String action = 'swipe',
    String label = 'password',
  });

  @NonNls
  void trackCopyUsername({
    String category = 'copyClipboard',
    String action = 'swipe',
    String label = 'username',
  });

  @NonNls
  void trackEntryAction(EntryActionType label, {String action = 'entry'});

  void trackBackupBanner(BannerAction action);

  void trackAutofillBanner(BannerAction action);
}

enum BannerAction {
  shown,
  dismissed,
  saved,
}

enum EntryActionType {
  generateEmail,
  generatePassword,
  openUrl,
}

enum TryUnlockResult {
  success,
  invalidCredential,
  alreadyOpen,
  failure,
  invalidFileStructure,
}

extension TryUnlockResultExt on TryUnlockResult {
  static const DOT_POS = 16;
  String get name {
    assert(runtimeType.toString().length == DOT_POS - 1);
    return toString().substring(DOT_POS);
  }
}

enum GroupDeleteResult {
  hasSubgroups,
  hasEntries,
  deleted,
  undo,
}

enum CloudAuthAction {
  authSend,
  authResend,
  authSuccess,
  authCanceled,
}

enum AttachmentAddType {
  success,
  canceled,
}

extension ContextEvents on BuildContext {
  AnalyticsEvents get events =>
      Provider.of<Analytics>(this, listen: false).events;
}
