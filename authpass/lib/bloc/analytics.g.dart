// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// AnalyticsEventGenerator
// **************************************************************************

// ignore_for_file: unnecessary_statements

// useNullSafetySyntax: true
class _$AnalyticsEvents extends AnalyticsEvents with AnalyticsEventStubsImpl {
  _$AnalyticsEvents([TrackAnalytics? tracker]) {
    tracker != null ? registerTracker(tracker) : null;
  }

  @override
  void trackLaunch({required Brightness systemBrightness}) =>
      trackEvent('launch', <String, dynamic>{
        'systemBrightness': systemBrightness.toString().substring(11)
      });
  @override
  void _trackInit(
          {required String? userType,
          required String device,
          required int value}) =>
      trackEvent('init', <String, dynamic>{
        'userType': userType,
        'device': device,
        'value': value
      });
  @override
  void trackOnboardingNew(
          {String category = 'onboarding',
          String action = 'click',
          String label = 'onboardingNewbie'}) =>
      trackEvent('onboardingNew', <String, dynamic>{
        'category': category,
        'action': action,
        'label': label
      });
  @override
  void trackOnboardingExisting(
          {String category = 'onboarding',
          String action = 'click',
          String label = 'onboardingExisting'}) =>
      trackEvent('onboardingExisting', <String, dynamic>{
        'category': category,
        'action': action,
        'label': label
      });
  @override
  void trackActionPressed({required String action}) =>
      trackEvent('actionPressed', <String, dynamic>{'action': action});
  @override
  void trackCreateFileAt(
          {required String cloudStorageId, required String category}) =>
      trackEvent('createFileAt', <String, dynamic>{
        'cloudStorageId': cloudStorageId,
        'category': category
      });
  @override
  void trackCreateFile() => trackEvent('createFile', <String, dynamic>{});
  @override
  void trackOpenFile({required String type}) =>
      trackEvent('openFile', <String, dynamic>{'type': type});
  @override
  void trackOpenFile2({required String generator, required String version}) =>
      trackEvent('openFile2',
          <String, dynamic>{'generator': generator, 'version': version});
  @override
  void trackSelectEntry({EntrySelectionType? type}) => trackEvent(
      'selectEntry', <String, dynamic>{'type': type?.toString().substring(19)});
  @override
  void trackCopyField({required String key}) =>
      trackEvent('copyField', <String, dynamic>{'key': key});
  @override
  void trackAddField({required String key}) =>
      trackEvent('addField', <String, dynamic>{'key': key});
  @override
  void trackCloseAllFiles({required int count}) =>
      trackEvent('closeAllFiles', <String, dynamic>{'count': count});
  @override
  void trackLockAllFiles({required int count}) =>
      trackEvent('lockAllFiles', <String, dynamic>{'count': count});
  @override
  void trackUserType({String? userType}) =>
      trackEvent('userType', <String, dynamic>{'userType': userType});
  @override
  void trackCloseFile() => trackEvent('closeFile', <String, dynamic>{});
  @override
  void trackPasswordListEmpty() =>
      trackEvent('passwordListEmpty', <String, dynamic>{});
  @override
  void trackQuickUnlock({int? value}) =>
      trackEvent('quickUnlock', <String, dynamic>{'value': value});
  @override
  void trackSave({required String type, int? value}) =>
      trackEvent('save', <String, dynamic>{'type': type, 'value': value});
  @override
  void trackSaveConflict(
          {required String type, int? value, required bool success}) =>
      trackEvent('saveConflict',
          <String, dynamic>{'type': type, 'value': value, 'success': success});
  @override
  void trackSaveCount({required String? generator, required int value}) =>
      trackEvent('saveCount',
          <String, dynamic>{'generator': generator, 'value': value});
  @override
  void trackDrawerOpen() => trackEvent('drawerOpen', <String, dynamic>{});
  @override
  void trackAttachmentAction(String action, {String category = 'attachment'}) =>
      trackEvent('attachmentAction',
          <String, dynamic>{'action': action, 'category': category});
  @override
  void trackAttachmentAdd(AttachmentAddType action, String ext, int value,
          {String category = 'attachmentAdd'}) =>
      trackEvent('attachmentAdd', <String, dynamic>{
        'action': action.toString().substring(18),
        'ext': ext,
        'value': value,
        'category': category
      });
  @override
  void trackCloudAuth(CloudAuthAction action,
          {String label = 'auth', String category = 'cloud'}) =>
      trackEvent('cloudAuth', <String, dynamic>{
        'action': action.toString().substring(16),
        'label': label,
        'category': category
      });
  @override
  void trackGroupDelete(GroupDeleteResult result,
          {String category = 'group'}) =>
      trackEvent('groupDelete', <String, dynamic>{
        'result': result.toString().substring(18),
        'category': category
      });
  @override
  void trackGroupCreate({String category = 'group'}) =>
      trackEvent('groupCreate', <String, dynamic>{'category': category});
  @override
  void trackPermanentlyDeleteEntry(
          {String category = 'entry',
          String action = 'perm-delete',
          String label = 'confirm'}) =>
      trackEvent('permanentlyDeleteEntry', <String, dynamic>{
        'category': category,
        'action': action,
        'label': label
      });
  @override
  void trackPermanentlyDeleteEntryCancel(
          {String category = 'entry',
          String action = 'perm-delete',
          String label = 'cancel'}) =>
      trackEvent('permanentlyDeleteEntryCancel', <String, dynamic>{
        'category': category,
        'action': action,
        'label': label
      });
  @override
  void trackPermanentlyDeleteGroup(
          {String category = 'group',
          String action = 'perm-delete',
          String label = 'confirm'}) =>
      trackEvent('permanentlyDeleteGroup', <String, dynamic>{
        'category': category,
        'action': action,
        'label': label
      });
  @override
  void trackPermanentlyDeleteGroupCancel(
          {String category = 'group',
          String action = 'perm-delete',
          String label = 'cancel'}) =>
      trackEvent('permanentlyDeleteGroupCancel', <String, dynamic>{
        'category': category,
        'action': action,
        'label': label
      });
  @override
  void _trackPreferences(
          {required String action, required String to, String? category}) =>
      trackEvent('preferences',
          <String, dynamic>{'action': action, 'to': to, 'category': category});
  @override
  void trackAutofillFilter(
          {required String filter,
          String category = 'autofill',
          String action = 'filter',
          required int value}) =>
      trackEvent('autofillFilter', <String, dynamic>{
        'filter': filter,
        'category': category,
        'action': action,
        'value': value
      });
  @override
  void trackAutofillSelect(
          {String category = 'autofill', String action = 'select'}) =>
      trackEvent('autofillSelect',
          <String, dynamic>{'category': category, 'action': action});
  @override
  void trackTryUnlock(
          {required TryUnlockResult action,
          required String ext,
          required String source,
          String category = 'tryUnlock'}) =>
      trackEvent('tryUnlock', <String, dynamic>{
        'action': action.toString().substring(16),
        'ext': ext,
        'source': source,
        'category': category
      });
  @override
  void trackCopyPassword(
          {String category = 'copyClipboard',
          String action = 'swipe',
          String label = 'password'}) =>
      trackEvent('copyPassword', <String, dynamic>{
        'category': category,
        'action': action,
        'label': label
      });
  @override
  void trackCopyUsername(
          {String category = 'copyClipboard',
          String action = 'swipe',
          String label = 'username'}) =>
      trackEvent('copyUsername', <String, dynamic>{
        'category': category,
        'action': action,
        'label': label
      });
  @override
  void trackEntryAction(EntryActionType label, {String action = 'entry'}) =>
      trackEvent('entryAction', <String, dynamic>{
        'label': label.toString().substring(16),
        'action': action
      });
  @override
  void trackBackupBanner(BannerAction action) => trackEvent('backupBanner',
      <String, dynamic>{'action': action.toString().substring(13)});
  @override
  void trackAutofillBanner(BannerAction action) => trackEvent('autofillBanner',
      <String, dynamic>{'action': action.toString().substring(13)});
}
