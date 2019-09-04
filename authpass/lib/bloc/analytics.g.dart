// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// AnalyticsEventGenerator
// **************************************************************************

// ignore_for_file: unnecessary_statements

class _$AnalyticsEvents extends AnalyticsEvents with AnalyticsEventStubsImpl {
  _$AnalyticsEvents([TrackAnalytics tracker]) {
    tracker != null ? registerTracker(tracker) : null;
  }

  @override
  void trackLaunch() => trackEvent('launch', <String, dynamic>{});
  @override
  void trackOpenFile({OpenedFilesSourceType type}) => trackEvent(
      'openFile', <String, dynamic>{'type': type?.toString()?.substring(22)});
  @override
  void trackSelectEntry({EntrySelectionType type}) => trackEvent('selectEntry',
      <String, dynamic>{'type': type?.toString()?.substring(19)});
  @override
  void trackCopyField({String key}) =>
      trackEvent('copyField', <String, dynamic>{'key': key});
}

// **************************************************************************
// StaticTextGenerator
// **************************************************************************

// ignore_for_file: implicit_dynamic_parameter,strong_mode_implicit_dynamic_parameter,strong_mode_implicit_dynamic_variable,non_constant_identifier_names,unused_element
