// ignore_for_file: omit_local_variable_types,unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get fieldUserName => 'Użytkownik';

  @override
  String get fieldPassword => 'Hasło';

  @override
  String get fieldWebsite => 'Strona WWW';

  @override
  String get fieldTitle => 'Nazwa';

  @override
  String get fieldTotp => 'Hasło jednorazowe OTP (TOTP)';

  @override
  String get fieldNotes => 'Notes';

  @override
  String get english => 'Angielski';

  @override
  String get german => 'Niemiecki';

  @override
  String get russian => 'Rosyjski';

  @override
  String get ukrainian => 'Ukraiński';

  @override
  String get lithuanian => 'Litewski';

  @override
  String get french => 'Francuski';

  @override
  String get spanish => 'Hiszpański';

  @override
  String get indonesian => 'Indonezyjski';

  @override
  String get turkish => 'Turecki';

  @override
  String get hebrew => 'Hebrajski';

  @override
  String get italian => 'Włoski';

  @override
  String get chineseSimplified => 'Chiński uproszczony';

  @override
  String get chineseTraditional => 'Chiński tradycyjny';

  @override
  String get portugueseBrazilian => 'Portugalski, Brazylijski';

  @override
  String get slovak => 'Słowacki';

  @override
  String get dutch => 'Holenderski';

  @override
  String get selectItem => 'Zaznacz';

  @override
  String get selectKeepassFile => 'AuthPass - Wybierz plik KeePass';

  @override
  String get selectKeepassFileLabel => 'Wybierz plik KeePass (.kdbx).';

  @override
  String get createNewFile => 'Utwórz nowy plik';

  @override
  String get openLocalFile => 'Otwórz\nplik lokalny';

  @override
  String get openFile => 'Otwórz plik';

  @override
  String get loadFromDropdownMenu => 'Wczytaj z…';

  @override
  String get quickUnlockingFiles => 'Szybkie odblokowanie plików…';

  @override
  String openFileProgress(Object fileName, Object current, Object totalCount) {
    return 'Otwieranie $fileName … ($current / $totalCount)';
  }

  @override
  String loadFrom(String cloudStorageName) {
    return 'Wczytaj z $cloudStorageName';
  }

  @override
  String get loadFromRemoteUrl => 'Otwórz kdbx z URL';

  @override
  String get createNewKeepass => 'Nowy w KeePass?\nUtwórz nową bazę haseł';

  @override
  String get labelLastOpenFiles => 'Ostatnio otwarte pliki:';

  @override
  String get noFilesHaveBeenOpenYet => 'Nie otwarto jeszcze żadnych plików.';

  @override
  String get preferenceSelectLanguage => 'Wybierz język';

  @override
  String get preferenceLanguage => 'Język';

  @override
  String get preferenceTextScaleFactor => 'Współczynnik Skalowania tekstu';

  @override
  String get preferenceVisualDensity => 'Gęstość rozstawienia elementów';

  @override
  String get preferenceTheme => 'Motyw';

  @override
  String get preferenceThemeLight => 'Jasny';

  @override
  String get preferenceThemeDark => 'Ciemny';

  @override
  String get preferenceSystemDefault => 'Domyślne systemowe';

  @override
  String get preferenceDefault => 'Domyślnie';

  @override
  String get lockAllFiles => 'Zablokuj wszystkie otwarte pliki';

  @override
  String get preferenceAllowScreenshots =>
      'Zezwalaj na zrzuty ekranu w aplikacji';

  @override
  String get preferenceEnableAutoFill => 'Włącz autouzupełnienie';

  @override
  String get enableAutofillSuggestionBanner =>
      'Możesz automatycznie uzupełniać dane logowania w aplikacjach aktywując tę opcję!';

  @override
  String get dismissAutofillSuggestionBannerButton => 'ODRZUĆ';

  @override
  String get enableAutofillSuggestionBannerButton => 'AKTYWUJ!';

  @override
  String get preferenceAutoFillDescription =>
      'Obsługiwane tylko na Androidzie Oreo (8.0) lub nowszym.';

  @override
  String get preferenceTitle => 'Ustawienia';

  @override
  String get preferenceEnableSystemWideShortcuts =>
      'Włącz globalne skróty klawiszowe';

  @override
  String get preferenceEnableSystemWideShortcutsHelp =>
      'Rejestruje w systemie skrót ctrl+alt+f do otwierania wyszukiwania.';

  @override
  String get preferencesSearchFields => 'Dostosuj pola wyszukiwania';

  @override
  String get preferencesSearchFieldPromptTitle => 'Pola wyszukiwania';

  @override
  String get preferencesSearchFieldPromptLabel =>
      'Comma separated list of fields to use in the password list search.';

  @override
  String preferencesSearchFieldPromptHelp(
    Object wildCardCharacter,
    Object defaultSearchFields,
  ) {
    return 'Użyj $wildCardCharacter dla wszystkich, pozostaw puste dla wartości domyślnej ($defaultSearchFields)';
  }

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback => 'Cieszymy się z wszelkiego rodzaju opinii!';

  @override
  String get aboutLinkVisitWebsite =>
      'Upewnij się, że odwiedziłeś naszą stronę internetową';

  @override
  String get aboutLinkGitHub => 'oraz otwartoźródłowy projekt';

  @override
  String aboutLogFile(String logFilePath) {
    return 'Plik dziennika: $logFilePath';
  }

  @override
  String get aboutLinkContributors => 'Pokaż współtwórców';

  @override
  String get unableToLaunchUrlTitle => 'Nie można otworzyć adresu URL';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'Nie można uruchomić $url: $openError';
  }

  @override
  String get unableToLaunchUrlNoHandler =>
      'Brak dostępnej aplikacji dla adresu URL.';

  @override
  String launchedUrl(Object url) {
    return 'Otwarto adres URL: $url';
  }

  @override
  String get menuItemGeneratePassword => 'Wygeneruj hasło';

  @override
  String get menuItemPreferences => 'Ustawienia';

  @override
  String get menuItemOpenAnotherFile => 'Otwórz inny plik';

  @override
  String get menuItemCheckForUpdates => 'Sprawdź aktualizacje';

  @override
  String get menuItemSupport => 'Wyślij plik dziennika';

  @override
  String get menuItemSupportSubtitle => 'Wyślij dziennik przez e-mail';

  @override
  String get menuItemForum => 'Forum pomocy technicznej';

  @override
  String get menuItemForumSubtitle => 'Zgłoś problemy i uzyskaj pomoc';

  @override
  String get menuItemHelp => 'Pomoc';

  @override
  String get menuItemHelpSubtitle => 'Pokaż dokumentację';

  @override
  String get menuItemAbout => 'O aplikacji';

  @override
  String get actionOpenUrl => 'Otwórz adres URL';

  @override
  String get passwordPlainText => 'Pokaż hasło';

  @override
  String get generatorPassword => 'Hasło';

  @override
  String get generatePassword => 'Wygeneruj hasło';

  @override
  String get doneButtonLabel => 'Gotowe';

  @override
  String get useAsDefault => 'Użyj jako domyślnych';

  @override
  String get characterSetLowerCase => 'Małe litery (a-z)';

  @override
  String get characterSetUpperCase => 'Duże litery (A-Z)';

  @override
  String get characterSetNumeric => 'Cyfry (0-9)';

  @override
  String get characterSetUmlauts => 'Umlauty (ä)';

  @override
  String get characterSetSpecial => 'Znaki specjalne (@%+)';

  @override
  String get length => 'Długość';

  @override
  String get customLength => 'Niestandardowa długość';

  @override
  String customLengthHelperText(Object customMinLength) {
    return 'Zostanie użyte dla wartości > $customMinLength';
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
      other: '$numFilesString plików zapisanych: $files',
      few: '$numFilesString pliki zapisane: $files',
      one: 'Plik zapisany: $files',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => 'Zarządzaj grupami';

  @override
  String get lockFiles => 'Zablokuj pliki';

  @override
  String get searchHint => 'Szukaj';

  @override
  String get searchButtonLabel => 'Szukaj';

  @override
  String get filterButtonLabel => 'Filtruj według grup';

  @override
  String get clear => 'Wyczyść';

  @override
  String get autofillFilterPrefix => 'Filtr:';

  @override
  String get autofillMatchPrefix => 'Matching entries for:';

  @override
  String get autofillPrompt => 'Select password entry for autofill.';

  @override
  String get copiedToClipboard => 'Skopiowano do schowka.';

  @override
  String get noTitle => '(brak tytułu)';

  @override
  String get noUsername => '(bez nazwy użytkownika)';

  @override
  String get filterCustomize => 'Dostosuj …';

  @override
  String get swipeCopyPassword => 'Skopiuj hasło';

  @override
  String get swipeCopyUsername => 'Kopiuj nazwę użytkownika';

  @override
  String get copyUsernameNotExists => 'Entry has no username defined.';

  @override
  String get copyPasswordNotExists => 'Entry has no password defined.';

  @override
  String get doneCopiedPassword => 'Skopiowano hasło do schowka.';

  @override
  String get doneCopiedUsername => 'Skopiowano nazwę użytkownika do schowka.';

  @override
  String get doneCopiedField => 'Skopiowano.';

  @override
  String copiedFieldToClipboard(Object fieldName) {
    return 'Skopiowano $fieldName.';
  }

  @override
  String copiedFieldEmpty(Object fieldName) {
    return '$fieldName jest puste.';
  }

  @override
  String get emptyPasswordVaultPlaceholder =>
      'You do not have any password in your database yet.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Utwórz swoje pierwsze hasło';

  @override
  String get loading => 'Ładowanie';

  @override
  String get loadingFile => 'Ładowanie pliku …';

  @override
  String get internalFile => 'Internal file';

  @override
  String get internalFileSubtitle =>
      'Database previously created with AuthPass';

  @override
  String get filePicker => 'Wybierz plik';

  @override
  String get filePickerSubtitle => 'Open file from the device.';

  @override
  String get credentialsAppBarTitle => 'Credentials';

  @override
  String get credentialLabel => 'Wprowadź hasło dla:';

  @override
  String get masterPasswordInputLabel => 'Hasło';

  @override
  String get masterPasswordEmptyValidator => 'Wprowadź hasło.';

  @override
  String get masterPasswordIncorrectValidator => 'Nieprawidłowe hasło';

  @override
  String get useKeyFile => 'Użyj pliku klucza';

  @override
  String get saveMasterPasswordBiometric =>
      'Save Password with biometric key store?';

  @override
  String get close => 'Zamknij';

  @override
  String get addNewPassword => 'Dodaj nowe hasło';

  @override
  String get errorOpenFileInvalidFileStructureTitle =>
      'Tried to open invalid file type';

  @override
  String errorOpenFileInvalidFileStructureBody(Object fileName) {
    return 'The file ($fileName) does not appear to be a valid KDBX file. Please either choose a valid KDBX file or create a new password database.';
  }

  @override
  String get errorOpenFileAlreadyOpenTitle => 'Plik jest już otwarty';

  @override
  String errorOpenFileAlreadyOpenBody(
    Object databaseName,
    Object openFileSource,
    Object newFileSource,
  ) {
    return 'The selected database $databaseName is already open from $openFileSource (Tried to open from $newFileSource)';
  }

  @override
  String get loadFromUrl => 'Pobierz z adresu URL';

  @override
  String get loadFromUrlEnterUrl => 'Wprowadź adres URL';

  @override
  String get loadFromUrlErrorEnterFullUrl =>
      'Please enter full url starting with http:// or https://';

  @override
  String get loadFromUrlErrorInvalidUrl => 'Wprowadź poprawny adres URL.';

  @override
  String get linuxAppArmorWarning =>
      'AuthPass requires permission to communicate with Secret Service to store credentials for cloud storage.\nPlease run the following command:';

  @override
  String get cancel => 'Anuluj';

  @override
  String get errorLoadFileFromSourceTitle => 'Error while opening file.';

  @override
  String errorLoadFileFromSourceBody(Object source, Object error) {
    return 'Unable to open $source.\n$error';
  }

  @override
  String get errorUnlockFileTitle => 'Nie można otworzyć Pliku';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Wystąpił nieznany błąd podczas próby otwarcia pliku. $error';
  }

  @override
  String get dialogContinue => 'Kontynuuj';

  @override
  String get dialogSendErrorReport => 'Send Error Report';

  @override
  String get dialogReportErrorForum => 'Report Error in Forum/Help';

  @override
  String get groupFilterDescription =>
      'Select which Groups to show (recursively)';

  @override
  String get groupFilterSelectAll => 'Zaznacz wszystko';

  @override
  String get groupFilterDeselectAll => 'Odznacz wszystko';

  @override
  String get createSubgroup => 'Utwórz podgrupę';

  @override
  String get editAction => 'Edytuj';

  @override
  String get mailboxEnableLabel => '(re)enable';

  @override
  String get mailboxEnableHint => 'Continue receiving emails';

  @override
  String get mailboxDisableLabel => 'Wyłącz';

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
  String get deleteAction => 'Usuń';

  @override
  String get deletedEntry => 'Deleted entry.';

  @override
  String get successfullyDeletedGroup => 'Usunięto grupę.';

  @override
  String get undoButtonLabel => 'Cofnij';

  @override
  String get saveButtonLabel => 'Zapisz';

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
  String get webDavAuthPassword => 'Hasło';

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
  String get initialNewGroupName => 'Nowa grupa';

  @override
  String get deleteGroupErrorTitle => 'Nie można usunąć grupy';

  @override
  String get deleteGroupErrorBodyContainsGroup =>
      'Ta grupa nadal zawiera inne grupy. Obecnie możesz usunąć tylko puste grupy.';

  @override
  String get deleteGroupErrorBodyContainsEntries =>
      'Ta grupa nadal zawiera hasła. Obecnie możesz usunąć tylko puste grupy.';

  @override
  String get groupListAppBarTitle => 'Grupy';

  @override
  String get groupListFilterAppbarTitle => 'Filtruj według grup';

  @override
  String get clearQuickUnlock => 'Clear Biometric Storage';

  @override
  String get clearQuickUnlockSubtitle => 'Remove saved master passwords';

  @override
  String get unlock => 'Odblokuj pliki';

  @override
  String get closePasswordFiles => 'close password files';

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
  String get createPasswordDatabase => 'Create Password Database';

  @override
  String get nameNewPasswordDatabase => 'Nazwa Twojej nowej bazy danych';

  @override
  String get validatorNameMissing => 'Wprowadź nazwę dla nowej bazy danych.';

  @override
  String get masterPasswordHelpText =>
      'Wybierz bezpieczne hasło główne. Upewnij się, że je zapamiętasz.';

  @override
  String get inputMasterPasswordText => 'Hasło główne';

  @override
  String get masterPasswordMissingCreate =>
      'Wprowadź bezpieczne, hasło które zapamiętasz.';

  @override
  String get createDatabaseAction => 'Utwórz bazę danych';

  @override
  String get databaseExistsError => 'File Exists';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'Error while trying to create database $filePath. File already exists. Please choose another name.';
  }

  @override
  String get databaseCreateDefaultName => 'PersonalPasswords';

  @override
  String get preferenceDynamicLoadIcons => 'Dynamicznie załaduj ikony';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'Will make http requests with the value in $urlFieldName field to load website icons.';
  }

  @override
  String passwordScore(Object score) {
    return 'Strength: $score of 4';
  }

  @override
  String get entryInfoFile => 'Plik:';

  @override
  String get entryInfoGroup => 'Grupa:';

  @override
  String get entryInfoLastModified => 'Ostatnio modyfikowane:';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'Przeniesiono wpis do $groupName';
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
  String get entryAddAttachment => 'Dodaj Załącznik';

  @override
  String get entryAttachmentSizeWarning =>
      'Załączone pliki zostaną osadzone w pliku z hasłami. Może to znacznie zwiększyć czas potrzebny do otwarcia/zapisania hasła.';

  @override
  String get iconPngSizeWarning =>
      'Niestandardowe ikony będą osadzone w pliku hasła. Może to znacznie zwiększyć czas potrzebny do otwarcia/zapisania haseł.';

  @override
  String get notPngError => 'Wybrany plik to nie PNG.';

  @override
  String get entryAddField => 'Dodaj pole';

  @override
  String get entryCustomField => 'Pole Niestandardowe';

  @override
  String get entryCustomFieldTitle => 'Dodawanie nowego niestandardowego pola';

  @override
  String get entryCustomFieldInputLabel => 'Wprowadź nazwę pola';

  @override
  String get swipeCopyField => 'Kopiuj Pole';

  @override
  String get fieldRename => 'Zmień nazwę';

  @override
  String get fieldGeneratePassword => 'Wygeneruj hasło …';

  @override
  String get fieldProtect => 'Chroń wartość';

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
  String get onboardingYesOpenPasswords => 'Yes, open my passwords';

  @override
  String get onboardingNoCreate => 'I\'m all new! Get me started.';

  @override
  String get backupButton => 'Zapisz w chmurze';

  @override
  String get dismissBackupButton => 'DISMISS';

  @override
  String backupWarningMessage(Object databasename) {
    return 'Twoje hasła w $databasename są zapisane tylko lokalnie!';
  }

  @override
  String get saveAs => 'Save In...';

  @override
  String get saving => 'Zapisywanie';

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
  String get newGroupDialogTitle => 'Nowa grupa';

  @override
  String get newGroupDialogInputLabel => 'Name for the new group';

  @override
  String get groupActionShowPasswords => 'Show passwords';

  @override
  String get groupActionDelete => 'Usuń';

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
  String get shareCodeLoadingProgress => 'Ładowanie pliku …';

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
  String get shortcutCopyUsername => 'Kopiuj nazwę użytkownika';

  @override
  String get shortcutCopyPassword => 'Skopiuj hasło';

  @override
  String get shortcutCopyTotp => 'Copy TOTP';

  @override
  String get shortcutMoveUp => 'Select the previous password';

  @override
  String get shortcutMoveDown => 'Select the next password';

  @override
  String get shortcutGeneratePassword => 'Wygeneruj hasło';

  @override
  String get shortcutCopyUrl => 'Copy URL';

  @override
  String get shortcutOpenUrl => 'Otwórz adres URL';

  @override
  String get shortcutCancelSearch => 'Cancel Search';

  @override
  String get shortcutShortcutHelp => 'Keyboard Shortcut Help';

  @override
  String get shortcutHelpTitle => 'Keyboard Shortcuts';

  @override
  String unexpectedError(String error) {
    return 'Nieoczekiwany błąd: $error';
  }

  @override
  String get googleDriveMorePermissionsRequired =>
      'Additional permissions needed to access Google Drive.';

  @override
  String get googleDriveRequestPermissionButtonLabel => 'Request Permissions';

  @override
  String get scanQrCodeTitle => 'Scan QR Code.';

  @override
  String get csvImportMenuItemTitle => 'Import from CSV';

  @override
  String get csvImportScreenTitle => 'Import from CSV';

  @override
  String get csvImportSelectFileButton => 'Select CSV File';

  @override
  String get csvImportSelectFileHint =>
      'Choose a .csv file to import password entries';

  @override
  String get csvImportMappingTitle => 'Map Columns';

  @override
  String get csvImportMappingSubtitle =>
      'Assign each CSV column to an AuthPass field';

  @override
  String get csvImportFieldSkip => 'Skip';

  @override
  String get csvImportPreviewTitle => 'Ready to Import';

  @override
  String csvImportPreviewSubtitle(int count) {
    return '$count entries will be imported';
  }

  @override
  String csvImportConfirmButton(int count) {
    return 'Import $count entries';
  }

  @override
  String csvImportSuccessMessage(int count) {
    return 'Successfully imported $count entries';
  }

  @override
  String csvImportSuccessWithSkipped(int imported, int skipped) {
    return 'Imported $imported entries, $skipped duplicates skipped';
  }

  @override
  String get csvImportErrorNoData =>
      'The CSV file appears to be empty or has no data rows.';

  @override
  String get csvImportErrorNoMappedFields =>
      'Please map at least one column before importing.';
}
