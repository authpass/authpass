// ignore_for_file: omit_local_variable_types,unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class AppLocalizationsSi extends AppLocalizations {
  AppLocalizationsSi([String locale = 'si']) : super(locale);

  @override
  String get fieldUserName => 'පරිශීලක';

  @override
  String get fieldPassword => 'මුරපදය';

  @override
  String get fieldWebsite => 'වියමන අඩවිය';

  @override
  String get fieldTitle => 'මාතෘකාව';

  @override
  String get fieldTotp => 'One Time Password (Time Based)';

  @override
  String get english => 'ඉංග්‍රීසි';

  @override
  String get german => 'ජර්මානු';

  @override
  String get russian => 'රුසියානු';

  @override
  String get ukrainian => 'Ukrainian';

  @override
  String get lithuanian => 'Lithuanian';

  @override
  String get french => 'ප්‍රංශ';

  @override
  String get spanish => 'ස්පාඤ්ඤ';

  @override
  String get indonesian => 'ඉන්දුනීසියානු';

  @override
  String get turkish => 'තුර්කි';

  @override
  String get hebrew => 'Hebrew';

  @override
  String get italian => 'ඉතාලි';

  @override
  String get chineseSimplified => 'සරල චීන';

  @override
  String get chineseTraditional => 'සාම්ප්‍රදායික චීන';

  @override
  String get portugueseBrazilian => 'Portuguese, Brazilian';

  @override
  String get slovak => 'Slovak';

  @override
  String get dutch => 'Dutch';

  @override
  String get selectItem => 'තෝරන්න';

  @override
  String get selectKeepassFile => 'AuthPass - Select KeePass File';

  @override
  String get selectKeepassFileLabel => 'Please select a KeePass (.kdbx) file.';

  @override
  String get createNewFile => 'නව ගොනුවක් සාදන්න';

  @override
  String get openLocalFile => 'ස්ථානීය ගොනුවක් \nවිවෘත කරන්න';

  @override
  String get openFile => 'ගොනුව විවෘත කරන්න';

  @override
  String get loadFromDropdownMenu => 'Load from …';

  @override
  String get quickUnlockingFiles => 'Quick unlocking files …';

  @override
  String openFileProgress(Object fileName, Object current, Object totalCount) {
    return 'Opening $fileName … ($current / $totalCount)';
  }

  @override
  String loadFrom(String cloudStorageName) {
    return '$cloudStorageName වෙතින් පුරන්න';
  }

  @override
  String get loadFromRemoteUrl => 'Open kdbx from URL';

  @override
  String get createNewKeepass =>
      'New to KeePass?\nCreate New Password Database';

  @override
  String get labelLastOpenFiles => 'අවසන්වරට විවෘත කළ ගොනු:';

  @override
  String get noFilesHaveBeenOpenYet => 'No files have been opened yet.';

  @override
  String get preferenceSelectLanguage => 'භාෂාව තෝරන්න';

  @override
  String get preferenceLanguage => 'භාෂාව';

  @override
  String get preferenceTextScaleFactor => 'Text Scale Factor';

  @override
  String get preferenceVisualDensity => 'Visual Density';

  @override
  String get preferenceTheme => 'තේමාව';

  @override
  String get preferenceThemeLight => 'දීප්ත';

  @override
  String get preferenceThemeDark => 'අඳුරු';

  @override
  String get preferenceSystemDefault => 'පද්ධතියේ පෙරනිමි';

  @override
  String get preferenceDefault => 'පෙරනිමි';

  @override
  String get lockAllFiles => 'සියලුම විවෘත ගොනු අගුලුලන්න';

  @override
  String get preferenceAllowScreenshots => 'Allow Screenshots of the App';

  @override
  String get preferenceEnableAutoFill => 'Enable autofill';

  @override
  String get enableAutofillSuggestionBanner =>
      'You can you can fill field of other application by enabling autofill!';

  @override
  String get dismissAutofillSuggestionBannerButton => 'DISMISS';

  @override
  String get enableAutofillSuggestionBannerButton => 'ENABLE!';

  @override
  String get preferenceAutoFillDescription =>
      'Only supported on Android Oreo (8.0) or later.';

  @override
  String get preferenceTitle => 'අභිප්‍රේත';

  @override
  String get preferenceEnableSystemWideShortcuts =>
      'Enable system wide shortcuts';

  @override
  String get preferenceEnableSystemWideShortcutsHelp =>
      'Registers ctrl+alt+f as system wide shortcut to open search.';

  @override
  String get preferencesSearchFields => 'Customize Search fields';

  @override
  String get preferencesSearchFieldPromptTitle => 'Search fields';

  @override
  String get preferencesSearchFieldPromptLabel =>
      'Comma separated list of fields to use in the password list search.';

  @override
  String preferencesSearchFieldPromptHelp(
    Object wildCardCharacter,
    Object defaultSearchFields,
  ) {
    return 'Use $wildCardCharacter for all, leave empty for default ($defaultSearchFields)';
  }

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback => 'We welcome any kind of feedback!';

  @override
  String get aboutLinkVisitWebsite => 'Also make sure to visit our website';

  @override
  String get aboutLinkGitHub => 'සහ විවෘත මූලාශ්‍ර ව්‍යාපෘතියකි';

  @override
  String aboutLogFile(String logFilePath) {
    return 'Log File: $logFilePath';
  }

  @override
  String get aboutLinkContributors => 'Show Contributors';

  @override
  String get unableToLaunchUrlTitle => 'Unable to open Url';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'Unable to launch $url: $openError';
  }

  @override
  String get unableToLaunchUrlNoHandler => 'No application available for url.';

  @override
  String launchedUrl(Object url) {
    return 'විවෘත කළ ඒ.ස.නි.: $url';
  }

  @override
  String get menuItemGeneratePassword => 'Generate Password';

  @override
  String get menuItemPreferences => 'අභිප්‍රේත';

  @override
  String get menuItemOpenAnotherFile => 'Open another File';

  @override
  String get menuItemCheckForUpdates => 'Check for updates';

  @override
  String get menuItemSupport => 'සටහන් යවන්න';

  @override
  String get menuItemSupportSubtitle => 'Send logs by email';

  @override
  String get menuItemForum => 'සහාය සංසදය';

  @override
  String get menuItemForumSubtitle => 'Report Problems and get help';

  @override
  String get menuItemHelp => 'උදව්';

  @override
  String get menuItemHelpSubtitle => 'Show documentation';

  @override
  String get menuItemAbout => 'පිළිබඳව';

  @override
  String get actionOpenUrl => 'Open URL';

  @override
  String get passwordPlainText => 'Reveal password';

  @override
  String get generatorPassword => 'මුරපදය';

  @override
  String get generatePassword => 'Generate Password';

  @override
  String get doneButtonLabel => 'අවසන්';

  @override
  String get useAsDefault => 'Use as Default';

  @override
  String get characterSetLowerCase => 'Lowercase (a-z)';

  @override
  String get characterSetUpperCase => 'Uppercase (A-Z)';

  @override
  String get characterSetNumeric => 'Numeric (0-9)';

  @override
  String get characterSetUmlauts => 'Umlauts (ä)';

  @override
  String get characterSetSpecial => 'විශේෂ (@%+)';

  @override
  String get length => 'Length';

  @override
  String get customLength => 'Custom Length';

  @override
  String customLengthHelperText(Object customMinLength) {
    return 'Only used for length > $customMinLength';
  }

  @override
  String savedFiles(int numFiles, Object files) {
    final intl.NumberFormat numFilesNumberFormat =
        intl.NumberFormat.compactLong(
          locale: localeName,
        );
    final String numFilesString = numFilesNumberFormat.format(numFiles);

    String _temp0 = intl.Intl.pluralLogic(
      numFiles,
      locale: localeName,
      other: '$numFilesString files saved: $files',
      one: 'One file saved: $files',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => 'Manage Groups';

  @override
  String get lockFiles => 'Lock Files';

  @override
  String get searchHint => 'සොයන්න';

  @override
  String get searchButtonLabel => 'සොයන්න';

  @override
  String get filterButtonLabel => 'සමූහය අනුව පෙරන්න';

  @override
  String get clear => 'හිස් කරන්න';

  @override
  String get autofillFilterPrefix => 'පෙරහන:';

  @override
  String get autofillMatchPrefix => 'Matching entries for:';

  @override
  String get autofillPrompt => 'Select password entry for autofill.';

  @override
  String get copiedToClipboard => 'Copied to clipboard.';

  @override
  String get noTitle => '(මාතෘකාවක් නැත)';

  @override
  String get noUsername => '(පරිශීලක නාමයක් නැත)';

  @override
  String get filterCustomize => 'රිසිකරණය …';

  @override
  String get swipeCopyPassword => 'මුරපදය පිටපත්';

  @override
  String get swipeCopyUsername => 'පරිශීලක නාමය පිටපත්';

  @override
  String get copyUsernameNotExists => 'Entry has no username defined.';

  @override
  String get copyPasswordNotExists => 'Entry has no password defined.';

  @override
  String get doneCopiedPassword => 'Copied password to clipboard.';

  @override
  String get doneCopiedUsername => 'Copied username to clipboard.';

  @override
  String get doneCopiedField => 'Copied.';

  @override
  String copiedFieldToClipboard(Object fieldName) {
    return '$fieldName copied.';
  }

  @override
  String copiedFieldEmpty(Object fieldName) {
    return '$fieldName is empty.';
  }

  @override
  String get emptyPasswordVaultPlaceholder =>
      'You do not have any password in your database yet.';

  @override
  String get emptyPasswordVaultButtonLabel => 'ඔබගේ පළමු මුරපදය සාදන්න';

  @override
  String get loading => 'පූරණය වෙමින්';

  @override
  String get loadingFile => 'ගොනුව පූරණය වෙමින්…';

  @override
  String get internalFile => 'අභ්‍යන්තර ගොනුව';

  @override
  String get internalFileSubtitle =>
      'Database previously created with AuthPass';

  @override
  String get filePicker => 'File Picker';

  @override
  String get filePickerSubtitle => 'Open file from the device.';

  @override
  String get credentialsAppBarTitle => 'අක්තපත්‍ර';

  @override
  String get credentialLabel => 'Enter the password for:';

  @override
  String get masterPasswordInputLabel => 'මුරපදය';

  @override
  String get masterPasswordEmptyValidator => 'ඔබගේ මුරපදය ඇතුළත් කරන්න.';

  @override
  String get masterPasswordIncorrectValidator => 'වලංගු නොවන මුරපදයකි';

  @override
  String get useKeyFile => 'යතුරු ගොනුව භාවිතා කරන්න';

  @override
  String get saveMasterPasswordBiometric =>
      'Save Password with biometric key store?';

  @override
  String get close => 'වසන්න';

  @override
  String get addNewPassword => 'නව මුරපදයක් එකතු කරන්න';

  @override
  String get errorOpenFileInvalidFileStructureTitle =>
      'Tried to open invalid file type';

  @override
  String errorOpenFileInvalidFileStructureBody(Object fileName) {
    return 'The file ($fileName) does not appear to be a valid KDBX file. Please either choose a valid KDBX file or create a new password database.';
  }

  @override
  String get errorOpenFileAlreadyOpenTitle => 'ගොනුව දැනටමත් විවෘතයි';

  @override
  String errorOpenFileAlreadyOpenBody(
    Object databaseName,
    Object openFileSource,
    Object newFileSource,
  ) {
    return 'The selected database $databaseName is already open from $openFileSource (Tried to open from $newFileSource)';
  }

  @override
  String get loadFromUrl => 'ඒ.ස.නි. වෙතින් බාගන්න';

  @override
  String get loadFromUrlEnterUrl => 'ඒ.ස.නි. යොදන්න';

  @override
  String get loadFromUrlErrorEnterFullUrl =>
      'Please enter full url starting with http:// or https://';

  @override
  String get loadFromUrlErrorInvalidUrl => 'Please enter a valid url.';

  @override
  String get linuxAppArmorWarning =>
      'AuthPass requires permission to communicate with Secret Service to store credentials for cloud storage.\nPlease run the following command:';

  @override
  String get cancel => 'Cancel';

  @override
  String get errorLoadFileFromSourceTitle => 'Error while opening file.';

  @override
  String errorLoadFileFromSourceBody(Object source, Object error) {
    return 'Unable to open $source.\n$error';
  }

  @override
  String get errorUnlockFileTitle => 'Unable to open File';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Unknown error while trying to open file. $error';
  }

  @override
  String get dialogContinue => 'ඉදිරියට';

  @override
  String get dialogSendErrorReport => 'Send Error Report';

  @override
  String get dialogReportErrorForum => 'Report Error in Forum/Help';

  @override
  String get groupFilterDescription =>
      'Select which Groups to show (recursively)';

  @override
  String get groupFilterSelectAll => 'සියල්ල තෝරන්න';

  @override
  String get groupFilterDeselectAll => 'සියල්ල නොතෝරන්න';

  @override
  String get createSubgroup => 'Create Subgroup';

  @override
  String get editAction => 'සංස්කරණය';

  @override
  String get mailboxEnableLabel => '(re)enable';

  @override
  String get mailboxEnableHint => 'Continue receiving emails';

  @override
  String get mailboxDisableLabel => 'අබල කරන්න';

  @override
  String get mailboxDisableHint => 'Receive no more emails';

  @override
  String get mailListNoMail => 'You do not have any emails yet.';

  @override
  String mailboxLabelPrefixForEntry(Object entryLabel) {
    return 'Entry: $entryLabel';
  }

  @override
  String mailboxLabelPrefixUnknownEntry(Object entryUuid) {
    return 'Unknown Entry: $entryUuid';
  }

  @override
  String mailboxLabelPrefixCreatedAt(Object dateTime) {
    return 'Created at: $dateTime';
  }

  @override
  String get masterPasswordDescription =>
      'The master password is used to securely encrypt your password database. Make sure to remember it, it can not be restored.';

  @override
  String get unsavedChangesWarningTitle => 'Unsaved Changes';

  @override
  String get unsavedChangesWarningBody =>
      'There are still unsaved changes. Do you want to discard changes?';

  @override
  String get unsavedChangesDiscardActionLabel => 'Discard Changes';

  @override
  String get deletePermanentlyAction => 'Delete Permanently';

  @override
  String get restoreFromRecycleBinAction => 'Restore';

  @override
  String get deleteAction => 'Delete';

  @override
  String get deletedEntry => 'Deleted entry.';

  @override
  String get successfullyDeletedGroup => 'Deleted group.';

  @override
  String get undoButtonLabel => 'පෙරසේ';

  @override
  String get saveButtonLabel => 'සුරකින්න';

  @override
  String get webDavSettings => 'WebDAV Settings';

  @override
  String get webDavUrlLabel => 'URL';

  @override
  String get webDavUrlHelperText => 'Base Url to your WebDAV service.';

  @override
  String get webDavUrlValidatorError => 'Please enter a URL';

  @override
  String get webDavUrlValidatorInvalidUrlError =>
      'Please enter a valid url with http:// or https://';

  @override
  String get webDavAuthUser => 'Username';

  @override
  String get webDavAuthPassword => 'මුරපදය';

  @override
  String get mergeSuccessDialogTitle => 'Successfully merged password database';

  @override
  String mergeSuccessDialogMessage(Object fileName, Object mergeSummary) {
    return 'Conflict detected while saving $fileName, it was merged successfully with the remote file: \n\n$mergeSummary';
  }

  @override
  String forDetailsVisitUrl(Object url) {
    return 'For details visit $url';
  }

  @override
  String get authPassCloudAuthEmailInputLabel =>
      'Enter email address to register or sign in.';

  @override
  String get authPassCloudAuthEmailInvalid =>
      'Please enter a valid email address.';

  @override
  String get authPassCloudAuthConfirmEmailButtonLabel => 'Confirm Address';

  @override
  String get authPassCloudAuthConfirmEmail =>
      'Please check your emails to confirm your email address.';

  @override
  String get authPassCloudAuthConfirmEmailExplain =>
      'Keep this screen open until you visited the link you received by email.';

  @override
  String get authPassCloudAuthResendExplain =>
      'If you have not received an email, please check your spam folder. Otherwise you can try to request a new confirmation link.';

  @override
  String get authPassCloudAuthResendButtonLabel =>
      'Request a new confirmation link';

  @override
  String permanentlyDeleteEntryConfirm(Object title) {
    return 'This will permanently delete the password entry $title. This can not be undone. Do you want to continue?';
  }

  @override
  String get permanentlyDeletedEntrySnackBar => 'Permanently deleted entry.';

  @override
  String get initialNewGroupName => 'නව සමූහය';

  @override
  String get deleteGroupErrorTitle => 'Unable to delete group';

  @override
  String get deleteGroupErrorBodyContainsGroup =>
      'This group still contains other groups. You can currently only delete empty groups.';

  @override
  String get deleteGroupErrorBodyContainsEntries =>
      'This group still contains password entries. You can currently only delete empty groups.';

  @override
  String get groupListAppBarTitle => 'සමූහ';

  @override
  String get groupListFilterAppbarTitle => 'සමූහ අනුව පෙරන්න';

  @override
  String get clearQuickUnlock => 'Clear Biometric Storage';

  @override
  String get clearQuickUnlockSubtitle => 'Remove saved master passwords';

  @override
  String get unlock => 'Unlock Files';

  @override
  String get closePasswordFiles => 'මුරපද ගොනු වසන්න';

  @override
  String get clearQuickUnlockSuccess =>
      'Removed saved master passwords from biometric storage.';

  @override
  String get diacOptIn => 'Opt in to In-App News, Surveys.';

  @override
  String get diacOptInSubtitle =>
      'Will occasionally send a network request to fetch news.';

  @override
  String browserAutofillThirdPartyModeTitle(String browserName) {
    return 'Enable AutoFill in $browserName';
  }

  @override
  String browserAutofillThirdPartyModeSubtitle(String browserName) {
    return '$browserName currently uses its own password manager. Tap to open its settings and select “Autofill using another service”, then restart $browserName.';
  }

  @override
  String get enableAutofillDebug => 'AutoFill: Enable debug';

  @override
  String get enableAutofillDebugSubtitle =>
      'Shows information overlays for every input field';

  @override
  String get createPasswordDatabase => 'මුරපද දත්තසමුදායක් සාදන්න';

  @override
  String get nameNewPasswordDatabase => 'ඔබගේ නව දත්තසමුදාය නම් කරන්න';

  @override
  String get validatorNameMissing =>
      'ඔබගේ නව දත්තසමුදාය සඳහා නමක් ඇතුළත් කරන්න.';

  @override
  String get masterPasswordHelpText =>
      'Select a secure master Password. Make sure to remember it.';

  @override
  String get inputMasterPasswordText => 'Master Password';

  @override
  String get masterPasswordMissingCreate =>
      'Please enter a secure, rememberable password.';

  @override
  String get createDatabaseAction => 'දත්තසමුදාය සාදන්න';

  @override
  String get databaseExistsError => 'ගොනුව පවතී';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'Error while trying to create database $filePath. File already exists. Please choose another name.';
  }

  @override
  String get databaseCreateDefaultName => 'පුද්ගලික මුරපද';

  @override
  String get preferenceDynamicLoadIcons => 'Dynamically load Icons';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'Will make http requests with the value in $urlFieldName field to load website icons.';
  }

  @override
  String passwordScore(Object score) {
    return 'Strength: $score of 4';
  }

  @override
  String get entryInfoFile => 'ගොනුව:';

  @override
  String get entryInfoGroup => 'සමූහය:';

  @override
  String get entryInfoLastModified => 'Last Modified:';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'Moved entry into $groupName';
  }

  @override
  String sizeBytesStoredAuthPassCloud(Object count) {
    return '$count bytes, stored on AuthPass Cloud';
  }

  @override
  String sizeBytes(Object count) {
    return '$count bytes';
  }

  @override
  String get entryAddAttachment => 'ඇමුණුම එකතු කරන්න';

  @override
  String get entryAttachmentSizeWarning =>
      'Attached files will be embedded in password file. This can significantly increase time required to open/save passwords.';

  @override
  String get iconPngSizeWarning =>
      'Custom icons will be embedded in password file. This can significantly increase time required to open/save passwords.';

  @override
  String get notPngError => 'Chosen file is not a PNG.';

  @override
  String get entryAddField => 'Add Field';

  @override
  String get entryCustomField => 'Custom Field';

  @override
  String get entryCustomFieldTitle => 'Adding new custom Field';

  @override
  String get entryCustomFieldInputLabel => 'Enter a name for the field';

  @override
  String get swipeCopyField => 'Copy Field';

  @override
  String get fieldRename => 'යලි නම් කරන්න';

  @override
  String get fieldGeneratePassword => 'Generate Password …';

  @override
  String get fieldProtect => 'Protect Value';

  @override
  String get fieldUnprotect => 'Unprotect Value';

  @override
  String get fieldPresent => 'Present';

  @override
  String get fieldGenerateEmail => 'Generate Email';

  @override
  String get onboardingBackToOnboarding => 'Tour';

  @override
  String get onboardingBackToOnboardingSubtitle =>
      'Relive the first run experience 😅️';

  @override
  String get onboardingHeadline => 'Let\'s make your Passwords Secure!';

  @override
  String get onboardingQuestion => 'Have you used a password manager before?';

  @override
  String get onboardingYesOpenPasswords => 'ඔව්, මාගේ මුරපද විවෘත කරන්න';

  @override
  String get onboardingNoCreate => 'I\'m all new! Get me started.';

  @override
  String get backupButton => 'මේඝයට සුරකින්න';

  @override
  String get dismissBackupButton => 'DISMISS';

  @override
  String backupWarningMessage(Object databasename) {
    return 'Your passwords in $databasename are only saved locally!';
  }

  @override
  String get saveAs => 'Save In...';

  @override
  String get saving => 'සුරකිමින්';

  @override
  String get increaseValue => 'Increase';

  @override
  String get decreaseValue => 'Decrease';

  @override
  String get resetValue => 'Reset';

  @override
  String cloudStorageAppBarTitle(Object cloudStorageName) {
    return 'CloudStorage - $cloudStorageName';
  }

  @override
  String get cloudStorageLogInCaption =>
      'You will be redirected to authenticate AuthPass to access your data.';

  @override
  String get cloudStorageLogInCode => 'Enter code';

  @override
  String launchUrlError(Object url) {
    return 'Unable to launch url. Please visit $url';
  }

  @override
  String cloudStorageLogInActionLabel(Object cloudStorageName) {
    return 'Login to $cloudStorageName';
  }

  @override
  String cloudStorageAuthCodeDialogTitle(Object cloudStorageName) {
    return '$cloudStorageName Authentication';
  }

  @override
  String get cloudStorageAuthCodeLabel => 'Authentication Code';

  @override
  String get cloudStorageAuthErrorTitle => 'Error while authenticating';

  @override
  String cloudStorageAuthErrorMessage(
    Object cloudStorageName,
    Object errorMessage,
  ) {
    return 'Error while trying to authenticate to $cloudStorageName: $errorMessage';
  }

  @override
  String get cloudStorageSearchBoxLabel => 'Search Query';

  @override
  String cloudStorageItemsInFolder(Object itemCount) {
    return '$itemCount items in this folder.';
  }

  @override
  String get mailSubject => 'Subject';

  @override
  String get mailFrom => 'From';

  @override
  String get mailDate => 'Date';

  @override
  String get mailMailbox => 'Mailbox';

  @override
  String get mailNoData => 'No Data';

  @override
  String get mailMailboxesTitle => 'Mailboxes';

  @override
  String get mailboxCreateButtonLabel => 'Create';

  @override
  String get mailboxNameInputDialogTitle => 'Optionally label for new mailbox';

  @override
  String get mailboxNameInputLabel => '(Internal) Label';

  @override
  String get mailScreenTitle => 'AuthPass Mail';

  @override
  String get mailTabBarTitleMailbox => 'Mailbox';

  @override
  String get mailTabBarTitleMail => 'Mail';

  @override
  String get mailMailboxListEmpty => 'You do not have any mailboxes yet.';

  @override
  String mailMailboxAddressCopied(Object mailboxAddress) {
    return 'Copied mailbox address to clipboard: $mailboxAddress';
  }

  @override
  String get errorWhileSavingTitle => 'Error while saving';

  @override
  String errorWhileSavingBody(Object errorMessage) {
    return 'Unable to save file: $errorMessage';
  }

  @override
  String get databaseDoesNotSupportSaving =>
      'Sorry this database does not support saving. Please open a local database file. Or use \"Save As\".';

  @override
  String get otpInvalidKeyTitle => 'Invalid Key';

  @override
  String get otpInvalidKeyBody =>
      'Given input is not a valid base32 TOTP code. Please verify your input.';

  @override
  String get otpUnsupportedMigrationTitle => 'Unsupported OTP Migration';

  @override
  String otpUnsupportedMigrationBody(Object uriCount) {
    return 'We currently only support single item migrations. Got $uriCount';
  }

  @override
  String get otpPromptTitle => 'Time Based Authentication';

  @override
  String get otpPromptHelperText => 'Please enter time based key.';

  @override
  String otpErrorMessageGeneration(Object errorMessage) {
    return 'Error generating invite code: $errorMessage';
  }

  @override
  String get otpCopySecretActionLabel => 'Copy Secret';

  @override
  String get otpEntryLabel => 'One Time Token';

  @override
  String get entryFieldProtected => 'Protected field. Click to reveal.';

  @override
  String get entryFieldActionRevealField => 'Show protected field';

  @override
  String get entryAttachmentOpenActionLabel => 'Open';

  @override
  String get entryAttachmentShareActionLabel => 'Share';

  @override
  String get entryAttachmentShareSubject => 'Attachment';

  @override
  String get entryAttachmentSaveActionLabel => 'Save to device';

  @override
  String get entryAttachmentRemoveActionLabel => 'Remove';

  @override
  String entryAttachmentRemoveConfirm(Object attachmentLabel) {
    return 'Do you really want to delete $attachmentLabel?';
  }

  @override
  String get entryRenameFieldPromptTitle => 'Renaming field';

  @override
  String get removerecentfile => 'Hide';

  @override
  String get entryRenameFieldPromptLabel => 'Enter the new name for the field';

  @override
  String get promptDialogPasteActionTooltip => 'Paste from Clipboard';

  @override
  String get promptDialogPasteHint =>
      'Hint: If you need to paste, try the button to the left ;-)';

  @override
  String get genericErrorDialogTitle => 'Error while handling action';

  @override
  String genericErrorDialogBody(Object errorMessage) {
    return 'Encountered an unexpected error. $errorMessage';
  }

  @override
  String get saveAsEntryLocalFile => 'Local File';

  @override
  String get fileTypePngs => 'Images (png)';

  @override
  String get selectIconDialogAction => 'SELECT ICON';

  @override
  String get retryDialogActionLabel => 'RETRY';

  @override
  String errorDuringNetworkCall(Object errorMessage) {
    return 'Error during api call. $errorMessage';
  }

  @override
  String get passwordFilterHideDeleted => 'Hide Deleted Entries';

  @override
  String get passwordFilterOnlyDeleted => 'Deleted Entries';

  @override
  String passwordFilterPrefixForOneGroup(Object groupName) {
    return 'Group: $groupName';
  }

  @override
  String passwordFilterPrefixForMultipleGroups(Object groupCount) {
    return 'Custom Filter ($groupCount Groups)';
  }

  @override
  String get menuItemAuthPassCloudAuthenticate =>
      'Authenticate with AuthPass Cloud';

  @override
  String get menuItemAuthPassCloudMailboxes => 'AuthPass Mailboxes';

  @override
  String changesWithoutSaving(Object fileName) {
    return 'You have changes in \"$fileName\", which does not support writing of changes.';
  }

  @override
  String get changesSaveLocally => 'Save locally';

  @override
  String get clearColor => 'Clear Color';

  @override
  String get databaseRenameInputLabel => 'Enter database name';

  @override
  String get databasePath => 'Path';

  @override
  String get databaseColor => 'Color';

  @override
  String get databaseColorChoose =>
      'Select a color to distinguish between files.';

  @override
  String get databaseAutofill => 'AutoFill';

  @override
  String get databaseAutofillSubtitle =>
      'Offer this database\'s entries when apps and websites ask for a password.';

  @override
  String get databaseAutofillCopyWarning =>
      'An encrypted copy of this database is kept for AutoFill until you switch it off, or close the database.';

  @override
  String get databaseAutofillNeedsKdbx4 =>
      'AutoFill needs KDBX 4. Upgrade this database below to use it.';

  @override
  String get databaseAutofillSystemHint =>
      'Also turn AuthPass on in Settings › General › AutoFill & Passwords.';

  @override
  String get databaseKdbxVersion => 'KDBX File Version';

  @override
  String databaseKdbxUpgradeVersion(Object versionName) {
    return 'Upgrade to $versionName';
  }

  @override
  String get databaseKdbxUpgradeSuccessful =>
      'Successfully upgraded file and saved.';

  @override
  String get databaseReload => 'Reload and Merge';

  @override
  String progressStatus(Object statusProgress) {
    return 'Status: $statusProgress';
  }

  @override
  String finishedMerge(Object status) {
    return 'Finished Merge $status';
  }

  @override
  String get closeAndLockFile => 'Close/Lock';

  @override
  String get authPassHomeScreenTagline =>
      'password manager, open source, available on all platforms.';

  @override
  String get addNewPasswordButtonLabel => 'Add new Password';

  @override
  String get unnamedEntryPlaceholder => '(Unnamed)';

  @override
  String get unnamedGroupPlaceholder => '(Unnamed)';

  @override
  String get unnamedFilePlaceholder => '(Unnamed)';

  @override
  String get editGroupScreenTitle => 'Edit Group';

  @override
  String get editGroupGroupNameLabel => 'Group Name';

  @override
  String get files => 'Files';

  @override
  String get newGroupDialogTitle => 'නව සමූහය';

  @override
  String get newGroupDialogInputLabel => 'Name for the new group';

  @override
  String get groupActionShowPasswords => 'Show passwords';

  @override
  String get groupActionDelete => 'Delete';

  @override
  String get logoutTooltip => 'Logout';

  @override
  String get successfullyDeletedFileCloudStorage =>
      'Successfully deleted file.';

  @override
  String shareDialogTitle(Object fileName) {
    return 'Sharing Options for $fileName';
  }

  @override
  String get shareFileActionLabel => 'Share …';

  @override
  String get shareTokenListEmptyScreenPlaceholder => 'File not shared yet.';

  @override
  String get shareTokenNoLabel => 'No Label/Description';

  @override
  String get shareTokenReadWrite => 'Read/Write';

  @override
  String get shareTokenReadOnly => 'Read only';

  @override
  String get shareCreateTokenDialogTitle => 'Share file';

  @override
  String get shareCreateTokenReadOnly => 'Read only';

  @override
  String get shareCreateTokenReadOnlyHelpText =>
      'Do not allow saving of changes';

  @override
  String get shareCreateTokenLabelText => 'Description';

  @override
  String get shareCreateTokenLabelHint => 'Share for my friend';

  @override
  String get shareCreateTokenLabelHelp =>
      'Optional label to differentiate share code.';

  @override
  String get shareCreateTokenSuccess => 'Successfully created share code.';

  @override
  String get sharePresentDialogTitle => 'Share file with secret share code';

  @override
  String get sharePresentDialogHelp =>
      'Using the following share code users can access the password file. They will need the password and/or key file to open it.';

  @override
  String get sharePresentToken => 'Share Code';

  @override
  String get sharePresentCopied => 'Copied share code to clipboard.';

  @override
  String get authPassCloudOpenWithShareCodeTooltip => 'Open with Share Code';

  @override
  String get authPassCloudShareFileActionLabel => 'Share';

  @override
  String get preferenceAuthPassCloudAttachmentTitle =>
      'Use AuthPass Cloud Attachments';

  @override
  String get preferenceAuthPassCloudAttachmentSubtitle =>
      'Store Attachments encrypted on AuthPass Cloud separately.';

  @override
  String get shareCodeInputDialogTitle => 'Input Secret Share Code';

  @override
  String get shareCodeInputDialogScan => 'Scan QR Code';

  @override
  String get shareCodeInputLabel => 'Secret Share Code';

  @override
  String get shareCodeInputHelperText =>
      'If you have received a share code, please paste it above.';

  @override
  String get shareCodeOpen => 'Received a Share Code for AuthPass Cloud?';

  @override
  String get shareCodeOpenScreenTitle => 'Loading file with share code';

  @override
  String get shareCodeLoadingProgress => 'ගොනුව පූරණය වෙමින්…';

  @override
  String get shareCodeOpenFileButtonLabel => 'OPEN';

  @override
  String get shareCodeOpenInstallAppCaption =>
      'Want to open this file with one of our native Apps instead?';

  @override
  String get shareCodeOpenAnotherAppCaption =>
      'Want to open this file on another device?';

  @override
  String get shareCodeOpenInstallAppButtonLabel => 'Install App';

  @override
  String get shareCodeOpenShowCodeButtonLabel => 'Show Share Code';

  @override
  String get changeMasterPasswordActionLabel => 'Change Master Password';

  @override
  String get changeMasterPasswordFormSubmit => 'Save with new password';

  @override
  String get changeMasterPasswordSuccess =>
      'Successfully saved master password.';

  @override
  String get changeMasterPasswordScreenTitle => 'Change Master Password';

  @override
  String get authPassCloudAuthClickedLink =>
      'I received email and visited link';

  @override
  String get authPassCloudAuthNotConfirmed =>
      'Email address was not yet confirmed. Make sure to click the link in the email you received and solve the captcha to confirm your email address.';

  @override
  String get getHelpButton => 'Get help in the forum';

  @override
  String get shortcutCopyUsername => 'පරිශීලක නාමය පිටපත්';

  @override
  String get shortcutCopyPassword => 'මුරපදය පිටපත්';

  @override
  String get shortcutCopyTotp => 'Copy TOTP';

  @override
  String get shortcutMoveUp => 'Select the previous password';

  @override
  String get shortcutMoveDown => 'Select the next password';

  @override
  String get shortcutGeneratePassword => 'Generate Password';

  @override
  String get shortcutCopyUrl => 'Copy URL';

  @override
  String get shortcutOpenUrl => 'Open URL';

  @override
  String get shortcutCancelSearch => 'Cancel Search';

  @override
  String get shortcutShortcutHelp => 'යතුරුපුවරුවේ කෙටිමං උදව්';

  @override
  String get shortcutHelpTitle => 'යතුරුපුවරුවේ කෙටිමං';

  @override
  String unexpectedError(String error) {
    return 'අනපේක්ෂිත දෝෂයකි: $error';
  }

  @override
  String get googleDriveMorePermissionsRequired =>
      'Additional permissions needed to access Google Drive.';

  @override
  String get googleDriveRequestPermissionButtonLabel => 'Request Permissions';

  @override
  String get scanQrCodeTitle => 'Scan QR Code.';
}
