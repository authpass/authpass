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
  void trackInit({String userType, int value}) => trackEvent(
      'init', <String, dynamic>{'userType': userType, 'value': value});
  @override
  void trackCreateFile() => trackEvent('createFile', <String, dynamic>{});
  @override
  void trackOpenFile({String type}) =>
      trackEvent('openFile', <String, dynamic>{'type': type});
  @override
  void trackOpenFile2({String generator}) =>
      trackEvent('openFile2', <String, dynamic>{'generator': generator});
  @override
  void trackSelectEntry({EntrySelectionType type}) => trackEvent('selectEntry',
      <String, dynamic>{'type': type?.toString()?.substring(19)});
  @override
  void trackCopyField({String key}) =>
      trackEvent('copyField', <String, dynamic>{'key': key});
  @override
  void trackAddField({String key}) =>
      trackEvent('addField', <String, dynamic>{'key': key});
  @override
  void trackCloseAllFiles({int count}) =>
      trackEvent('closeAllFiles', <String, dynamic>{'count': count});
  @override
  void trackUserType({String userType}) =>
      trackEvent('userType', <String, dynamic>{'userType': userType});
  @override
  void trackCloseFile() => trackEvent('closeFile', <String, dynamic>{});
  @override
  void trackPasswordListEmpty() =>
      trackEvent('passwordListEmpty', <String, dynamic>{});
  @override
  void trackQuickUnlock({int value}) =>
      trackEvent('quickUnlock', <String, dynamic>{'value': value});
  @override
  void trackSave({String type, int value}) =>
      trackEvent('save', <String, dynamic>{'type': type, 'value': value});
  @override
  void trackSaveCount({String generator, int value}) => trackEvent(
      'saveCount', <String, dynamic>{'generator': generator, 'value': value});
}

// **************************************************************************
// StaticTextGenerator
// **************************************************************************

// ignore_for_file: implicit_dynamic_parameter,strong_mode_implicit_dynamic_parameter,strong_mode_implicit_dynamic_variable,non_constant_identifier_names,unused_element
