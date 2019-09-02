import 'package:amplitude_flutter/amplitude_flutter.dart';
import 'package:analytics_event_gen/analytics_event_gen.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/ui/screens/password_list.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

part 'analytics.g.dart';

final _logger = Logger('analytics');

class Analytics {
  Analytics({@required this.env}) {
    _init();
  }

  final Env env;
  final AnalyticsEvents events = _$AnalyticsEvents();

  AmplitudeFlutter _amplitude;

  Future<void> _init() async {
    if (env.analyticsAmplitudeApiKey != null) {
      _amplitude = AmplitudeFlutter(env.analyticsAmplitudeApiKey);
    }

    events.registerTracker((event, params) {
      _logger.finer('event($event, $params)');
      _amplitude?.logEvent(name: event, properties: params);
    });
  }
}

abstract class AnalyticsEvents implements AnalyticsEventStubs {
  void trackLaunch();
  void trackOpenFile({@required OpenedFilesSourceType type});
  void trackSelectEntry({EntrySelectionType type});
  void trackCopyField({@required String key});
}
