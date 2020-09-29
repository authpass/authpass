// ignore_for_file: omit_local_variable_types,unused_local_variable
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get fieldUserName => 'Kullanıcı';

  @override
  String get fieldPassword => 'Şifre';

  @override
  String get fieldWebsite => 'Web site';

  @override
  String get fieldTitle => 'Başlık';

  @override
  String get fieldTotp => 'One Time Password (Time Based)';

  @override
  String get english => 'İngilizce';

  @override
  String get german => 'Almanca';

  @override
  String get russian => 'Rusça';

  @override
  String get ukrainian => 'Ukraynaca';

  @override
  String get lithuanian => 'Lithuanian';

  @override
  String get french => 'Fransızca';

  @override
  String get spanish => 'İspanyolca';

  @override
  String get indonesian => 'Indonesian';

  @override
  String get selectKeepassFile => 'AuthPass - Select KeePass File';

  @override
  String get quickUnlockingFiles => 'Quick unlocking files';

  @override
  String get selectKeepassFileLabel => 'Please select a KeePass (.kdbx) file.';

  @override
  String get createNewFile => 'Create New File';

  @override
  String get openLocalFile => 'Open\nLocal File';

  @override
  String get openFile => 'Open File';

  @override
  String loadFrom(String cloudStorageName) {
    return 'Load from ${cloudStorageName}';
  }

  @override
  String get loadFromUrl => 'Download from URL';

  @override
  String get loadFromRemoteUrl => 'Open kdbx from URL';

  @override
  String get createNewKeepass => 'New to KeePass?\nCreate New Password Database';

  @override
  String get labelLastOpenFiles => 'Last opened files:';

  @override
  String get noFilesHaveBeenOpenYet => 'No files have been opened yet.';

  @override
  String get preferenceSelectLanguage => 'Dil Seçin';

  @override
  String get preferenceLanguage => 'Dil';

  @override
  String get preferenceTextScaleFactor => 'Text Scale Factor';

  @override
  String get preferenceVisualDensity => 'Visual Density';

  @override
  String get preferenceTheme => 'Tema';

  @override
  String get preferenceThemeLight => 'Light';

  @override
  String get preferenceThemeDark => 'Koyu';

  @override
  String get preferenceSystemDefault => 'Sistem varsayılanı';

  @override
  String get preferenceDefault => 'Varsayılan';

  @override
  String get lockAllFiles => 'Lock all open files';

  @override
  String get preferenceAllowScreenshots => 'Uygulamanın ekran görüntülerine izin verin';

  @override
  String get preferenceEnableAutoFill => 'Otomatik doldurmayı etkinleştir';

  @override
  String get preferenceAutoFillDescription => 'Only supported on Android Oreo (8.0) or later.';

  @override
  String get preferenceTitle => 'Preferences';

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback => 'Her türlü geri bildirimi memnuniyetle karşılıyoruz!';

  @override
  String get aboutLinkVisitWebsite => 'Ayrıca web sitemizi ziyaret ettiğinizden emin olun';

  @override
  String get aboutLinkGitHub => 'Ve Açık Kaynak Projesi';

  @override
  String aboutLogFile(String logFilePath) {
    return 'Log File: ${logFilePath}';
  }

  @override
  String get unableToLaunchUrlTitle => 'Url açılamıyor';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'Unable to launch ${url}: ${openError}';
  }

  @override
  String get unableToLaunchUrlNoHandler => 'No application available for url.';

  @override
  String launchedUrl(Object url) {
    return 'Opened URL: ${url}';
  }

  @override
  String get menuItemGeneratePassword => 'Generate Password';

  @override
  String get menuItemPreferences => 'Preferences';

  @override
  String get menuItemOpenAnotherFile => 'Open another File';

  @override
  String get menuItemCheckForUpdates => 'Güncellemeleri kontrol et';

  @override
  String get menuItemSupport => 'Email Support';

  @override
  String get menuItemSupportSubtitle => 'Send logs by email/ask for help.';

  @override
  String get menuItemHelp => 'Yardım';

  @override
  String get menuItemHelpSubtitle => 'Belgeleri göster';

  @override
  String get menuItemAbout => 'Hakkında';

  @override
  String get actionOpenUrl => 'Open URL';

  @override
  String get passwordPlainText => 'Şifreyi göster';

  @override
  String get generatorPassword => 'Şifre';

  @override
  String get generatePassword => 'Parola oluştur';

  @override
  String get doneButtonLabel => 'Done';

  @override
  String get useAsDefault => 'Varsayılan olarak kullan';

  @override
  String get characterSetLowerCase => 'Lowercase (a-z)';

  @override
  String get characterSetUpperCase => 'Uppercase (A-Z)';

  @override
  String get characterSetNumeric => 'Sayısal (0-9)';

  @override
  String get characterSetUmlauts => 'Umlauts (ä)';

  @override
  String get characterSetSpecial => 'Özel (@%+)';

  @override
  String get length => 'Length';

  @override
  String get customLength => 'Custom Length';

  @override
  String customLengthHelperText(Object customMinLength) {
    return 'Only used for length > ${customMinLength}';
  }

  @override
  String savedFiles(int numFiles, Object files) {
    final intl.NumberFormat numFilesNumberFormat = intl.NumberFormat.compactLong(
      locale: localeName,
      
    );
    final String numFilesString = numFilesNumberFormat.format(numFiles);

    return intl.Intl.pluralLogic(
      numFiles,
      locale: localeName,
      other: '${numFiles} files saved: ${files}',
    );
  }

  @override
  String get manageGroups => 'Grupları Yönet';

  @override
  String get lockFiles => 'Lock Files';

  @override
  String get searchHint => 'Ara';

  @override
  String get clear => 'Sil';

  @override
  String get autofillFilterPrefix => 'Filtrele:';

  @override
  String get autofillPrompt => 'Select password entry for autofill.';

  @override
  String get copiedToClipboard => 'Panoya kopyalandı.';

  @override
  String get noTitle => '(no title)';

  @override
  String get noUsername => '(no username)';

  @override
  String get filterCustomize => 'Customize …';

  @override
  String get swipeCopyPassword => 'Şifreyi Kopyala';

  @override
  String get swipeCopyUsername => 'Kullanıcı Adını Kopyala';

  @override
  String get doneCopiedPassword => 'Copied password to clipboard.';

  @override
  String get doneCopiedUsername => 'Copied username to clipboard.';

  @override
  String get doneCopiedField => 'Kopyalandı.';

  @override
  String get emptyPasswordVaultPlaceholder => 'You do not have any password in your database yet.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Create your first Password';

  @override
  String get loadingFile => 'Loading file …';

  @override
  String get internalFile => 'Internal file';

  @override
  String get internalFileSubtitle => 'Database previously created with AuthPass';

  @override
  String get filePicker => 'File Picker';

  @override
  String get filePickerSubtitle => 'Cihazdan dosyayı açın.';

  @override
  String get credentialsAppBarTitle => 'Credentials';

  @override
  String get credentialLabel => 'Şunun için parolayı girin:';

  @override
  String get masterPasswordInputLabel => 'Şifre';

  @override
  String get masterPasswordEmptyValidator => 'Lütfen şifrenizi giriniz.';

  @override
  String get masterPasswordIncorrectValidator => 'Geçersiz şifre';

  @override
  String get useKeyFile => 'Use Key File';

  @override
  String get saveMasterPasswordBiometric => 'Save Password with biometric key store?';

  @override
  String get errorOpenFileAlreadyOpenTitle => 'File already open';

  @override
  String errorOpenFileAlreadyOpenBody(Object databaseName, Object openFileSource, Object newFileSource) {
    return 'The selected database ${databaseName} is already open from ${openFileSource} (Tried to open from ${newFileSource})';
  }

  @override
  String get errorUnlockFileTitle => 'Unable to open File';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Dosyayı açmaya çalışırken bilinmeyen hata. ${error}';
  }

  @override
  String get dialogContinue => 'Devam';

  @override
  String get dialogSendErrorReport => 'Send Error Report/Help';

  @override
  String get groupFilterDescription => 'Select which Groups to show (recursively)';

  @override
  String get groupFilterSelectAll => 'Hepsini seç';

  @override
  String get groupFilterDeselectAll => 'Tüm seçimleri kaldır';

  @override
  String get createSubgroup => 'Alt Grup Oluşturun';

  @override
  String get editAction => 'Düzenle';

  @override
  String get deleteAction => 'Sil';

  @override
  String get successfullyDeletedGroup => 'Grubu sil.';

  @override
  String get undoButtonLabel => 'Geri al';

  @override
  String get saveButtonLabel => 'Kaydet';

  @override
  String get initialNewGroupName => 'Yeni Grup';

  @override
  String get deleteGroupErrorTitle => 'Grup silinemiyor';

  @override
  String get deleteGroupErrorBodyContainsGroup => 'Bu grup hala başka grupları içerir. Şu anda yalnızca boş grupları silebilirsiniz.';

  @override
  String get deleteGroupErrorBodyContainsEntries => 'Bu grup hala şifre kayıtlarını içeriyor. Şu anda yalnızca boş grupları silebilirsiniz.';

  @override
  String get groupListAppBarTitle => 'Gruplar';

  @override
  String get groupListFilterAppbarTitle => 'Gruplara göre filtrele';

  @override
  String get clearQuickUnlock => 'Clear Biometric Storage';

  @override
  String get clearQuickUnlockSubtitle => 'Kaydedilmiş ana parolaları kaldırın';

  @override
  String get unlock => 'Unlock Files';

  @override
  String get closePasswordFiles => 'close password files';

  @override
  String get clearQuickUnlockSuccess => 'Removed saved master passwords from biometric storage.';

  @override
  String get diacOptIn => 'Opt in to In-App News, Surveys.';

  @override
  String get diacOptInSubtitle => 'Will occasionally send a network request to fetch news.';

  @override
  String get enableAutofillDebug => 'AutoFill: Enable debug';

  @override
  String get enableAutofillDebugSubtitle => 'Shows information overlays for every input field';

  @override
  String get createPasswordDatabase => 'Create Password Database';

  @override
  String get nameNewPasswordDatabase => 'Name of your new Database';

  @override
  String get validatorNameMissing => 'Please enter a name for your new database.';

  @override
  String get masterPasswordHelpText => 'Select a secure master Password. Make sure to remember it.';

  @override
  String get inputMasterPasswordText => 'Master Password';

  @override
  String get masterPasswordMissingCreate => 'Please enter a secure, rememberable password.';

  @override
  String get createDatabaseAction => 'Veritabanı Yarat';

  @override
  String get databaseExistsError => 'File Exists';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'Error while trying to create database ${filePath}. File already exists. Please choose another name.';
  }

  @override
  String get databaseCreateDefaultName => 'PersonalPasswords';

  @override
  String get preferenceDynamicLoadIcons => 'Dynamically load Icons';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'Will make http requests with the value in ${urlFieldName} field to load website icons.';
  }

  @override
  String passwordScore(Object score) {
    return 'Strength: ${score} of 4';
  }

  @override
  String get entryInfoFile => 'Dosya:';

  @override
  String get entryInfoGroup => 'Grup:';

  @override
  String get entryInfoLastModified => 'Son düzenleme:';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'Moved entry into ${groupName}';
  }

  @override
  String sizeBytes(Object bytes) {
    return '{count} bytes';
  }

  @override
  String get entryAddAttachment => 'Add Attachment';

  @override
  String get entryAttachmentSizeWarning => 'Attached files will be embedded in password file. This can significantly increase time required to open/save passwords.';

  @override
  String get entryAddField => 'Alan Ekle';

  @override
  String get entryCustomField => 'Custom Field';

  @override
  String get entryCustomFieldTitle => 'Adding new custom Field';

  @override
  String get entryCustomFieldInputLabel => 'Enter a name for the field';

  @override
  String get swipeCopyField => 'Alanı Kopyala';

  @override
  String get fieldRename => 'Yeniden adlandır';

  @override
  String get fieldGeneratePassword => 'Generate Password …';

  @override
  String get fieldProtect => 'Protect Value';

  @override
  String get fieldUnprotect => 'Unprotect Value';

  @override
  String get fieldPresent => 'Present';

  @override
  String get fieldGenerateEmail => 'E-posta Oluştur';

  @override
  String get onboardingBackToOnboarding => 'Tur';

  @override
  String get onboardingBackToOnboardingSubtitle => 'Relive the first run experience 😅️';

  @override
  String get onboardingHeadline => 'Let\'s make your Passwords Secure!';

  @override
  String get onboardingQuestion => 'Daha önce bir şifre yöneticisi kullandınız mı?';

  @override
  String get onboardingYesOpenPasswords => 'Evet, parolalarımı aç';

  @override
  String get onboardingNoCreate => 'I\'m all new! Get me started.';

  @override
  String unexpectedError(String error) {
    return 'Beklenmeyen Hata: ${error}';
  }
}
