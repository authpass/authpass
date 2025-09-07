// ignore_for_file: omit_local_variable_types,unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get fieldUserName => 'משתמש';

  @override
  String get fieldPassword => 'סיסמה';

  @override
  String get fieldWebsite => 'אתר';

  @override
  String get fieldTitle => 'כותרת';

  @override
  String get fieldTotp => 'סיסמה חד־פעמית (מבוססת זמן)';

  @override
  String get english => 'אנגלית';

  @override
  String get german => 'גרמנית';

  @override
  String get russian => 'רוסית';

  @override
  String get ukrainian => 'אוקראינית';

  @override
  String get lithuanian => 'ליטאית';

  @override
  String get french => 'צרפתית';

  @override
  String get spanish => 'ספרדית';

  @override
  String get indonesian => 'אינדונזית';

  @override
  String get turkish => 'טורקית';

  @override
  String get hebrew => 'עברית';

  @override
  String get italian => 'איטלקית';

  @override
  String get chineseSimplified => 'סינית מפושטת';

  @override
  String get chineseTraditional => 'סינית מסורתית';

  @override
  String get portugueseBrazilian => 'פורטוגלית ברזילאית';

  @override
  String get slovak => 'סלובקית';

  @override
  String get dutch => 'שווידית';

  @override
  String get selectItem => 'בחר';

  @override
  String get selectKeepassFile => 'AuthPass - בחירת קובץ KeePass';

  @override
  String get selectKeepassFileLabel => 'נא לבחור בקובץ KeePass‏ (‎.kdbx).';

  @override
  String get createNewFile => 'יצירת קובץ חדש';

  @override
  String get openLocalFile => 'פתיחת קובץ מקומי';

  @override
  String get openFile => 'פתיחת קובץ';

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
    return 'לטעון מתוך $cloudStorageName';
  }

  @override
  String get loadFromRemoteUrl => 'לפתוח kdbx מכתובת';

  @override
  String get createNewKeepass =>
      'אין לך ניסיון עם KeePass?\nכדאי ליצור מסד נתוני סיסמאות חדש';

  @override
  String get labelLastOpenFiles => 'הקבצים האחרונים שנפתחו:';

  @override
  String get noFilesHaveBeenOpenYet => 'עדיין לא נפתחו קבצים.';

  @override
  String get preferenceSelectLanguage => 'בחר שפה';

  @override
  String get preferenceLanguage => 'שפה';

  @override
  String get preferenceTextScaleFactor => 'קנה מידה של טקסט';

  @override
  String get preferenceVisualDensity => 'צפיפות חזותית';

  @override
  String get preferenceTheme => 'ערכת עיצוב';

  @override
  String get preferenceThemeLight => 'בהירה';

  @override
  String get preferenceThemeDark => 'כהה';

  @override
  String get preferenceSystemDefault => 'ברירת המחדל של המערכת';

  @override
  String get preferenceDefault => 'ברירת מחדל';

  @override
  String get lockAllFiles => 'לנעול את כל הקבצים הפתוחים';

  @override
  String get preferenceAllowScreenshots => 'לאפשר לצלם את מסך היישומון';

  @override
  String get preferenceEnableAutoFill => 'הפעלת מילוי אוטומטי';

  @override
  String get enableAutofillSuggestionBanner =>
      'You can you can fill field of other application by enabling autofill!';

  @override
  String get dismissAutofillSuggestionBannerButton => 'להתעלם';

  @override
  String get enableAutofillSuggestionBannerButton => 'ENABLE!';

  @override
  String get preferenceAutoFillDescription =>
      'נתמך רק באנדרואיד אוריאו (8.0) ומעלה.';

  @override
  String get preferenceTitle => 'העדפות';

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
  String get aboutLinkFeedback => 'אנו פתוחים לכל סוג של משוב!';

  @override
  String get aboutLinkVisitWebsite => 'מזמינים אותך לבקר באתר שלנו';

  @override
  String get aboutLinkGitHub => 'ובמיזם הקוד הפתוח';

  @override
  String aboutLogFile(String logFilePath) {
    return 'קובץ יומן: $logFilePath';
  }

  @override
  String get aboutLinkContributors => 'הראה תורמים';

  @override
  String get unableToLaunchUrlTitle => 'לא ניתן לפתוח את הכתובת';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'הפתיחה של $url נכשלה: $openError';
  }

  @override
  String get unableToLaunchUrlNoHandler => 'לא נמצא יישומון זמין לכתובת.';

  @override
  String launchedUrl(Object url) {
    return 'כתובת שנפתחה: $url';
  }

  @override
  String get menuItemGeneratePassword => 'יצירת סיסמה';

  @override
  String get menuItemPreferences => 'העדפות';

  @override
  String get menuItemOpenAnotherFile => 'לפתוח קובץ אחר';

  @override
  String get menuItemCheckForUpdates => 'לבדוק עדכונים';

  @override
  String get menuItemSupport => 'שלח לוגים';

  @override
  String get menuItemSupportSubtitle => 'שלח לוגים למייל';

  @override
  String get menuItemForum => 'פורום תמיכה';

  @override
  String get menuItemForumSubtitle => 'דווח על בעיית וקבל עזרה';

  @override
  String get menuItemHelp => 'עזרה';

  @override
  String get menuItemHelpSubtitle => 'הצגת תיעוד';

  @override
  String get menuItemAbout => 'על אודות';

  @override
  String get actionOpenUrl => 'פתיחת כתובת';

  @override
  String get passwordPlainText => 'חשיפת הסיסמה';

  @override
  String get generatorPassword => 'סיסמה';

  @override
  String get generatePassword => 'יצירת סיסמה';

  @override
  String get doneButtonLabel => 'בוצע';

  @override
  String get useAsDefault => 'להשתמש כברירת מחדל';

  @override
  String get characterSetLowerCase => 'אותיות קטנות (a-z)';

  @override
  String get characterSetUpperCase => 'אותיות גדולות (A-Z)';

  @override
  String get characterSetNumeric => 'ספרות (0-9)';

  @override
  String get characterSetUmlauts => 'עם נקודות דיאקריטיות (ä)';

  @override
  String get characterSetSpecial => 'תווים מיוחדים (@%+)';

  @override
  String get length => 'אורך';

  @override
  String get customLength => 'אורך מותאם אישית';

  @override
  String customLengthHelperText(Object customMinLength) {
    return 'משמש לאורך > $customMinLength';
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
      other: '$numFilesString קבצים נשמרו: $files',
      one: 'קובץ אחד נשמר: $files',
      many: '$numFilesString קבצים נשמרו: $files',
      two: 'שני קבצים נשמרו: $files',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => 'ניהול קבוצות';

  @override
  String get lockFiles => 'נעילת קבצים';

  @override
  String get searchHint => 'חיפוש';

  @override
  String get searchButtonLabel => 'חיפוש';

  @override
  String get filterButtonLabel => 'פלטר לפי קבוצה';

  @override
  String get clear => 'פינוי';

  @override
  String get autofillFilterPrefix => 'סינון:';

  @override
  String get autofillPrompt => 'נא לבחור רשומת סיסמה למילוי אוטומטי.';

  @override
  String get copiedToClipboard => 'הועתק ללוח הגזירים.';

  @override
  String get noTitle => '(אין כותרת)';

  @override
  String get noUsername => '(אין שם משתמש)';

  @override
  String get filterCustomize => 'התאמה אישית…';

  @override
  String get swipeCopyPassword => 'העתקת סיסמה';

  @override
  String get swipeCopyUsername => 'העתקת שם משתמש';

  @override
  String get copyUsernameNotExists => 'Entry has no username defined.';

  @override
  String get copyPasswordNotExists => 'Entry has no password defined.';

  @override
  String get doneCopiedPassword => 'הסיסמה הועתקה ללוח הגזירים.';

  @override
  String get doneCopiedUsername => 'שם המשתמש הועתק ללוח הגזירים.';

  @override
  String get doneCopiedField => 'הועתק.';

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
      'אין לך עדיין סיסמאות במסד הנתונים שלך.';

  @override
  String get emptyPasswordVaultButtonLabel => 'יצירת הסיסמה הראשונה שלך';

  @override
  String get loading => 'Loading';

  @override
  String get loadingFile => 'הקובץ נטען…';

  @override
  String get internalFile => 'קובץ פנימי';

  @override
  String get internalFileSubtitle => 'מסד נתונים שנוצר קודם לכן עם AuthPass';

  @override
  String get filePicker => 'בוחר קבצים';

  @override
  String get filePickerSubtitle => 'פתיחת קובץ מהמכשיר.';

  @override
  String get credentialsAppBarTitle => 'פרטי זהות';

  @override
  String get credentialLabel => 'נא למלא את הסיסמה עבור:';

  @override
  String get masterPasswordInputLabel => 'סיסמה';

  @override
  String get masterPasswordEmptyValidator => 'נא למלא את הסיסמה שלך.';

  @override
  String get masterPasswordIncorrectValidator => 'סיסמה שגויה';

  @override
  String get useKeyFile => 'להשתמש בקובץ מפתח';

  @override
  String get saveMasterPasswordBiometric =>
      'לשמור את הססמה עם אחסון מפתחות ביומטרי?';

  @override
  String get close => 'סגור';

  @override
  String get addNewPassword => 'הוסף סיסמה';

  @override
  String get errorOpenFileInvalidFileStructureTitle =>
      'Tried to open invalid file type';

  @override
  String errorOpenFileInvalidFileStructureBody(Object fileName) {
    return 'The file ($fileName) does not appear to be a valid KDBX file. Please either choose a valid KDBX file or create a new password database.';
  }

  @override
  String get errorOpenFileAlreadyOpenTitle => 'הקובץ כבר פתוח';

  @override
  String errorOpenFileAlreadyOpenBody(
    Object databaseName,
    Object openFileSource,
    Object newFileSource,
  ) {
    return 'מסד הנתונים הנבחר $databaseName כבר פתוח דרך $openFileSource (ניסיתי לפתוח מתוך $newFileSource)';
  }

  @override
  String get loadFromUrl => 'Download from Url';

  @override
  String get loadFromUrlEnterUrl => 'Enter URL';

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
  String get errorUnlockFileTitle => 'לא ניתן לפתוח קובץ';

  @override
  String errorUnlockFileBody(Object error) {
    return 'אירעה שגיאה בלתי ידועה בעת ניסיון פתיחת הקובץ. $error';
  }

  @override
  String get dialogContinue => 'להמשיך';

  @override
  String get dialogSendErrorReport => 'שלח דוח שגיאה';

  @override
  String get dialogReportErrorForum => 'דוח על שגיאה בפורום/עזרה';

  @override
  String get groupFilterDescription =>
      'נא לבחור אילו קבוצות תוצגנה (רקורסיבית)';

  @override
  String get groupFilterSelectAll => 'לבחור הכול';

  @override
  String get groupFilterDeselectAll => 'לבטל בחירה';

  @override
  String get createSubgroup => 'ליצור תת־קבוצה';

  @override
  String get editAction => 'עריכה';

  @override
  String get mailboxEnableLabel => '(re)enable';

  @override
  String get mailboxEnableHint => 'Continue receiving emails';

  @override
  String get mailboxDisableLabel => 'Disable';

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
  String get deleteAction => 'מחיקה';

  @override
  String get deletedEntry => 'Deleted entry.';

  @override
  String get successfullyDeletedGroup => 'נמחקה קבוצה.';

  @override
  String get undoButtonLabel => 'החזרה';

  @override
  String get saveButtonLabel => 'שמירה';

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
  String get webDavAuthPassword => 'סיסמה';

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
  String get initialNewGroupName => 'קבוצה חדשה';

  @override
  String get deleteGroupErrorTitle => 'לא ניתן למחוק קבוצה';

  @override
  String get deleteGroupErrorBodyContainsGroup =>
      'הקבוצה הזו עדיין מכילה קבוצות אחרות. כרגע ניתן למחוק קבוצות ריקות בלבד.';

  @override
  String get deleteGroupErrorBodyContainsEntries =>
      'הקבוצה הזו עדיין מכילה רשומות של ססמאות. כרגע ניתן למחוק קבוצות ריקות בלבד.';

  @override
  String get groupListAppBarTitle => 'קבוצות';

  @override
  String get groupListFilterAppbarTitle => 'סינון לפי קבוצות';

  @override
  String get clearQuickUnlock => 'פינוי אחסון ביומטרי';

  @override
  String get clearQuickUnlockSubtitle => 'הסרת ססמאות הורה שמורות';

  @override
  String get unlock => 'שחרור קבצים';

  @override
  String get closePasswordFiles => 'סגירת קובצי ססמאות';

  @override
  String get clearQuickUnlockSuccess =>
      'סיסמת ההורה שנשמרה הוסרה מהאחסון הביומטרי.';

  @override
  String get diacOptIn => 'ניתן להירשם כדי לקבל חדשות וסקרים בתוך היישומון.';

  @override
  String get diacOptInSubtitle =>
      'יגרום לשליחת בקשות רשת מדי פעם בפעם כדי לקבל חדשות.';

  @override
  String get enableAutofillDebug => 'מילוי אוטומטי: הפעלת ניפוי שגיאות';

  @override
  String get enableAutofillDebugSubtitle =>
      'תוצג שכבת מידע מעל כל שדה פלט שהוא';

  @override
  String get createPasswordDatabase => 'יצירת מסד נתוני סיסמאות';

  @override
  String get nameNewPasswordDatabase => 'שם מסד הנתונים החדש שלך';

  @override
  String get validatorNameMissing => 'נא למלא את שם מסד הנתונים החדש שלך.';

  @override
  String get masterPasswordHelpText =>
      'נא לבחור סיסמת הורה מאובטחת. חשוב לזכור אותה.';

  @override
  String get inputMasterPasswordText => 'סיסמת הורה';

  @override
  String get masterPasswordMissingCreate => 'נא למלא סיסמה מאובטחת וזכירה.';

  @override
  String get createDatabaseAction => 'יצירת מסד נתונים';

  @override
  String get databaseExistsError => 'הקובץ קיים';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'אירעה שגיאה בניסיון יצירת מסד הנתונים $filePath. הקובץ כבר קיים. נא לבחור בשם אחר.';
  }

  @override
  String get databaseCreateDefaultName => 'סיסמאות_אישיות';

  @override
  String get preferenceDynamicLoadIcons => 'לטעון סמלים דינמית';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'יבצע בקשת http עם הערך של השדה $urlFieldName כדי לטעון סמלים של אתרים.';
  }

  @override
  String passwordScore(Object score) {
    return 'חוזק: $score מתוך 4';
  }

  @override
  String get entryInfoFile => 'קובץ:';

  @override
  String get entryInfoGroup => 'קבוצה:';

  @override
  String get entryInfoLastModified => 'שינוי אחרון:';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'הרשומה הועברה לתוך $groupName';
  }

  @override
  String sizeBytesStoredAuthPassCloud(Object count) {
    return '$count bytes, stored on AuthPass Cloud';
  }

  @override
  String sizeBytes(Object count) {
    return '$count בתים';
  }

  @override
  String get entryAddAttachment => 'צירוף קובץ';

  @override
  String get entryAttachmentSizeWarning =>
      'הקובץ המצורף יוטמע בקובץ הססמאות. מה שעלול להגדיל את הזמן שנדרש לפתיחת/שמירת סיסמאות.';

  @override
  String get iconPngSizeWarning =>
      'סמלים מותאמים אישית יוטמעו בקובץ הססמאות. מה שעלול להגדיל את הזמן שנדרש לפתיחת/שמירת סיסמאות.';

  @override
  String get notPngError => 'הקובץ שנבחר אינו PNG.';

  @override
  String get entryAddField => 'הוספת שדה';

  @override
  String get entryCustomField => 'שדה בהתאמה אישית';

  @override
  String get entryCustomFieldTitle => 'נוסף שדה בהתאמה אישית';

  @override
  String get entryCustomFieldInputLabel => 'נא למלא את שם השדה';

  @override
  String get swipeCopyField => 'העתקת שדה';

  @override
  String get fieldRename => 'שינוי שם';

  @override
  String get fieldGeneratePassword => 'יצירת סיסמה…';

  @override
  String get fieldProtect => 'הגנה על ערך';

  @override
  String get fieldUnprotect => 'הסרת הגנת ערך';

  @override
  String get fieldPresent => 'נוכחי';

  @override
  String get fieldGenerateEmail => 'יצירת דוא״ל';

  @override
  String get onboardingBackToOnboarding => 'סיור';

  @override
  String get onboardingBackToOnboardingSubtitle => 'החוויה הראשונית שלך מחדש';

  @override
  String get onboardingHeadline => 'הגיע הזמן לאבטח לך את הסיסמאות!';

  @override
  String get onboardingQuestion => 'כבר השתמשת פעם במנהל סיסמאות?';

  @override
  String get onboardingYesOpenPasswords => 'כן, לפתוח את הסיסמאות שלי';

  @override
  String get onboardingNoCreate => 'הרגע נחתי! בואו נתחיל.';

  @override
  String get backupButton => 'לשמור לענן';

  @override
  String get dismissBackupButton => 'להתעלם';

  @override
  String backupWarningMessage(Object databasename) {
    return 'הסיסמאות שבתוך $databasename תישמרנה מקומית בלבד!';
  }

  @override
  String get saveAs => 'שמירה ב…';

  @override
  String get saving => 'נשמר';

  @override
  String get increaseValue => 'הגדל';

  @override
  String get decreaseValue => 'הקטן';

  @override
  String get resetValue => 'אפס';

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
  String get newGroupDialogTitle => 'קבוצה חדשה';

  @override
  String get newGroupDialogInputLabel => 'Name for the new group';

  @override
  String get groupActionShowPasswords => 'Show passwords';

  @override
  String get groupActionDelete => 'מחיקה';

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
  String get shareCodeLoadingProgress => 'הקובץ נטען…';

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
  String get shortcutCopyUsername => 'העתקת שם משתמש';

  @override
  String get shortcutCopyPassword => 'העתקת סיסמה';

  @override
  String get shortcutCopyTotp => 'Copy TOTP';

  @override
  String get shortcutMoveUp => 'Select the previous password';

  @override
  String get shortcutMoveDown => 'Select the next password';

  @override
  String get shortcutGeneratePassword => 'יצירת סיסמה';

  @override
  String get shortcutCopyUrl => 'Copy URL';

  @override
  String get shortcutOpenUrl => 'פתיחת כתובת';

  @override
  String get shortcutCancelSearch => 'Cancel Search';

  @override
  String get shortcutShortcutHelp => 'Keyboard Shortcut Help';

  @override
  String get shortcutHelpTitle => 'Keyboard Shortcuts';

  @override
  String unexpectedError(String error) {
    return 'שגיאה בלתי צפויה: $error';
  }

  @override
  String get googleDriveMorePermissionsRequired =>
      'Additional permissions needed to access Google Drive.';

  @override
  String get googleDriveRequestPermissionButtonLabel => 'Request Permissions';

  @override
  String get scanQrCodeTitle => 'Scan QR Code.';
}
