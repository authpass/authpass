// ignore_for_file: omit_local_variable_types,unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get fieldUserName => 'Používateľ';

  @override
  String get fieldPassword => 'Heslo';

  @override
  String get fieldWebsite => 'Web';

  @override
  String get fieldTitle => 'Názov';

  @override
  String get fieldTotp => 'Jednorázové heslo (podľa času)';

  @override
  String get english => 'Angličtina';

  @override
  String get german => 'Nemčina';

  @override
  String get russian => 'Ruština';

  @override
  String get ukrainian => 'Ukrajinčina';

  @override
  String get lithuanian => 'Litovčina';

  @override
  String get french => 'Francúzština';

  @override
  String get spanish => 'Španielčina';

  @override
  String get indonesian => 'Indonézčina';

  @override
  String get turkish => 'Turčina';

  @override
  String get hebrew => 'Hebrejčina';

  @override
  String get italian => 'taliančina';

  @override
  String get chineseSimplified => 'Zjednodušená Čínština';

  @override
  String get chineseTraditional => 'Tradičná Čínština';

  @override
  String get portugueseBrazilian => 'Portugalčina';

  @override
  String get slovak => 'Slovak';

  @override
  String get dutch => 'Dutch';

  @override
  String get selectItem => 'Select';

  @override
  String get selectKeepassFile => 'AuthPass - Zvoľte KeePass Súbor';

  @override
  String get selectKeepassFileLabel => 'Prosím zvoľte KeePass (.kdbx) súbor.';

  @override
  String get createNewFile => 'Vytvoriť nový súbor';

  @override
  String get openLocalFile => 'Otvoriť lokálny súbor';

  @override
  String get openFile => 'Otvoriť súbor';

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
    return 'Načítať z $cloudStorageName';
  }

  @override
  String get loadFromRemoteUrl => 'Otvoriť. kdbx súbor z URL';

  @override
  String get createNewKeepass =>
      'Nový použivateľ služby KeePass?\nZaložte si novú heslovú databázu';

  @override
  String get labelLastOpenFiles => 'Naposledy otvorené súbory:';

  @override
  String get noFilesHaveBeenOpenYet => 'Zatiaľ neboli otvorené žiadne súbory.';

  @override
  String get preferenceSelectLanguage => 'Zvoľte Jazyk';

  @override
  String get preferenceLanguage => 'Jazyk';

  @override
  String get preferenceTextScaleFactor => 'Faktor mierky textu';

  @override
  String get preferenceVisualDensity => 'Vizuálna hustota';

  @override
  String get preferenceTheme => 'Téma';

  @override
  String get preferenceThemeLight => 'Svetlá';

  @override
  String get preferenceThemeDark => 'Tmavá';

  @override
  String get preferenceSystemDefault => 'Predvolená Systémová';

  @override
  String get preferenceDefault => 'Predvolená';

  @override
  String get lockAllFiles => 'Zamknúť všetky otvorené súbory';

  @override
  String get preferenceAllowScreenshots =>
      'Povoliť snímky obrazovky v aplikácii';

  @override
  String get preferenceEnableAutoFill => 'Povoliť automatické doplňovanie';

  @override
  String get enableAutofillSuggestionBanner =>
      'You can you can fill field of other application by enabling autofill!';

  @override
  String get dismissAutofillSuggestionBannerButton => 'ZRUŠIŤ';

  @override
  String get enableAutofillSuggestionBannerButton => 'ENABLE!';

  @override
  String get preferenceAutoFillDescription =>
      'Podporované iba v systéme Android Oreo (8.0) alebo novšom.';

  @override
  String get preferenceTitle => 'Predvoľby';

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
      Object wildCardCharacter, Object defaultSearchFields) {
    return 'Use $wildCardCharacter for all, leave empty for default ($defaultSearchFields)';
  }

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback => 'Uvítame akýkoľvek druh spätnej väzby!';

  @override
  String get aboutLinkVisitWebsite =>
      'Nezabudnite tiež navštíviť našu webovú stránku';

  @override
  String get aboutLinkGitHub => 'Open Source Projekt';

  @override
  String aboutLogFile(String logFilePath) {
    return 'Log Súbor: $logFilePath';
  }

  @override
  String get aboutLinkContributors => 'Show Contributors';

  @override
  String get unableToLaunchUrlTitle => 'Nepodarilo sa otvoriť URL';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'Nepodarilo sa otvoriť Url: $url: $openError';
  }

  @override
  String get unableToLaunchUrlNoHandler =>
      'Pre adresu URL nie je k dispozícii žiadna aplikácia.';

  @override
  String launchedUrl(Object url) {
    return 'Otvorená URL adresa: $url';
  }

  @override
  String get menuItemGeneratePassword => 'Generovať Heslo';

  @override
  String get menuItemPreferences => 'Predvoľby';

  @override
  String get menuItemOpenAnotherFile => 'Otvoriť iný súbor';

  @override
  String get menuItemCheckForUpdates => 'Skontrolovať aktualizácie';

  @override
  String get menuItemSupport => 'Send logs';

  @override
  String get menuItemSupportSubtitle => 'Send logs by email';

  @override
  String get menuItemForum => 'Support Forum';

  @override
  String get menuItemForumSubtitle => 'Report Problems and get help';

  @override
  String get menuItemHelp => 'Pomoc';

  @override
  String get menuItemHelpSubtitle => 'Zobraziť dokumentáciu';

  @override
  String get menuItemAbout => 'O nás';

  @override
  String get actionOpenUrl => 'Otvoriť URL';

  @override
  String get passwordPlainText => 'Odhaliť heslo';

  @override
  String get generatorPassword => 'Heslo';

  @override
  String get generatePassword => 'Generovať heslo';

  @override
  String get doneButtonLabel => 'Hotovo';

  @override
  String get useAsDefault => 'Použiť ako predvolené heslo';

  @override
  String get characterSetLowerCase => 'Malé písmená (a-z)';

  @override
  String get characterSetUpperCase => 'Veľké písmená (A-Z)';

  @override
  String get characterSetNumeric => 'Číslice (0-9)';

  @override
  String get characterSetUmlauts => 'Prehlásky (ä)';

  @override
  String get characterSetSpecial => 'Špeciálne znaky (@%+)';

  @override
  String get length => 'Dĺžka';

  @override
  String get customLength => 'Vlastná Dĺžka';

  @override
  String customLengthHelperText(Object customMinLength) {
    return 'Používa sa dĺžka > $customMinLength';
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
      other: '$numFilesString súborov uložených: $files',
      one: 'Jeden súbor uložený: $files',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => 'Spravovať Skupiny';

  @override
  String get lockFiles => 'Zamknúť súbory';

  @override
  String get searchHint => 'Hľadať';

  @override
  String get searchButtonLabel => 'Hľadať';

  @override
  String get filterButtonLabel => 'Filter by group';

  @override
  String get clear => 'Vyčistiť';

  @override
  String get autofillFilterPrefix => 'Filter:';

  @override
  String get autofillPrompt =>
      'Vyberte zadanie hesla pre automatické dopĺňanie.';

  @override
  String get copiedToClipboard => 'Skopírované do schránky.';

  @override
  String get noTitle => '(žiadny nadpis)';

  @override
  String get noUsername => '(žiadne meno)';

  @override
  String get filterCustomize => 'Prispôsobiť …';

  @override
  String get swipeCopyPassword => 'Kopírovať Heslo';

  @override
  String get swipeCopyUsername => 'Kopírovať používateľské meno';

  @override
  String get copyUsernameNotExists => 'Entry has no username defined.';

  @override
  String get copyPasswordNotExists => 'Entry has no password defined.';

  @override
  String get doneCopiedPassword => 'Heslo bolo skopírované do schránky.';

  @override
  String get doneCopiedUsername =>
      'Skopírované používateľské meno do schránky.';

  @override
  String get doneCopiedField => 'Skopírované.';

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
      'Zatiaľ nemáte vo svojej databáze žiadne heslo.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Vytvorte si svoje prvé heslo';

  @override
  String get loading => 'Loading';

  @override
  String get loadingFile => 'Načítavam súbor …';

  @override
  String get internalFile => 'Interný súbor';

  @override
  String get internalFileSubtitle =>
      'Databáza predtým vytvorená pomocou aplikácie AuthPass';

  @override
  String get filePicker => 'Výber Súborov';

  @override
  String get filePickerSubtitle => 'Otvoriť súbor z tohto zariadenia.';

  @override
  String get credentialsAppBarTitle => 'Prihlasovacie údaje';

  @override
  String get credentialLabel => 'Zadajte heslo pre:';

  @override
  String get masterPasswordInputLabel => 'Heslo';

  @override
  String get masterPasswordEmptyValidator => 'Prosím vložte heslo.';

  @override
  String get masterPasswordIncorrectValidator => 'Nesprávne heslo';

  @override
  String get useKeyFile => 'Použiť súbor s kľúčom';

  @override
  String get saveMasterPasswordBiometric =>
      'Uložiť heslo pomocou biometrických kľúčov?';

  @override
  String get close => 'Close';

  @override
  String get addNewPassword => 'Add New Password';

  @override
  String get errorOpenFileInvalidFileStructureTitle =>
      'Tried to open invalid file type';

  @override
  String errorOpenFileInvalidFileStructureBody(Object fileName) {
    return 'The file ($fileName) does not appear to be a valid KDBX file. Please either choose a valid KDBX file or create a new password database.';
  }

  @override
  String get errorOpenFileAlreadyOpenTitle => 'Súbor je už otvorený';

  @override
  String errorOpenFileAlreadyOpenBody(
      Object databaseName, Object openFileSource, Object newFileSource) {
    return 'Vybraná databáza $databaseName je už otvorená z $openFileSource (pokus o otvorenie z $newFileSource)';
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
  String get errorUnlockFileTitle => 'Súbor sa nepodarilo otvoriť';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Neznáma chyba pri otvárani súboruor. $error';
  }

  @override
  String get dialogContinue => 'Pokračovať';

  @override
  String get dialogSendErrorReport => 'Send Error Report';

  @override
  String get dialogReportErrorForum => 'Report Error in Forum/Help';

  @override
  String get groupFilterDescription =>
      'Vyberte, ktoré skupiny sa majú zobrazovať (rekurzívne)';

  @override
  String get groupFilterSelectAll => 'Označiť všetko';

  @override
  String get groupFilterDeselectAll => 'Odznačiť všetko';

  @override
  String get createSubgroup => 'Vytvoriť podskupinu';

  @override
  String get editAction => 'Editovať';

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
  String get deleteAction => 'Zmazať';

  @override
  String get deletedEntry => 'Deleted entry.';

  @override
  String get successfullyDeletedGroup => 'Zmazať skupinu.';

  @override
  String get undoButtonLabel => 'Vrátiť';

  @override
  String get saveButtonLabel => 'Uložiť';

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
  String get webDavAuthPassword => 'Heslo';

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
  String get initialNewGroupName => 'Nová Skupina';

  @override
  String get deleteGroupErrorTitle => 'Nepodarilo sa zmazať skupinu';

  @override
  String get deleteGroupErrorBodyContainsGroup =>
      'Táto skupina stále obsahuje ďalšie skupiny. Momentálne môžete mazať iba prázdne skupiny.';

  @override
  String get deleteGroupErrorBodyContainsEntries =>
      'Táto skupina stále obsahuje heslá. Momentálne môžete mazať iba prázdne skupiny.';

  @override
  String get groupListAppBarTitle => 'Skupiny';

  @override
  String get groupListFilterAppbarTitle => 'Filtrovať podľa skupín';

  @override
  String get clearQuickUnlock => 'Vyčistiť biometrické úložisko';

  @override
  String get clearQuickUnlockSubtitle => 'Odstrániť hlavné heslá';

  @override
  String get unlock => 'Odomknúť súbory';

  @override
  String get closePasswordFiles => 'zavrieť súbory s heslom';

  @override
  String get clearQuickUnlockSuccess =>
      'Uložené heslá boli odstránené z biometrického úložiska.';

  @override
  String get diacOptIn =>
      'Prihlásiť sa k odberu noviniek a prieskumov v aplikácii.';

  @override
  String get diacOptInSubtitle =>
      'Príležitostne pošle požiadavku na sieť na získanie noviniek.';

  @override
  String get enableAutofillDebug => 'Automatické dopĺňanie: Povoliť ladenie';

  @override
  String get enableAutofillDebugSubtitle =>
      'Zobrazuje informačné vrstvy pre každé vstupné pole';

  @override
  String get createPasswordDatabase => 'Vytvoriť heslovú databázu';

  @override
  String get nameNewPasswordDatabase => 'Meno vašej novej databázy';

  @override
  String get validatorNameMissing => 'Zadajte názov svojej novej databázy.';

  @override
  String get masterPasswordHelpText =>
      'Vyberte zabezpečené hlavné heslo. Určite si to pamätajte.';

  @override
  String get inputMasterPasswordText => 'Hlavné Heslo';

  @override
  String get masterPasswordMissingCreate =>
      'Zadajte bezpečné, nezabudnuteľné heslo.';

  @override
  String get createDatabaseAction => 'Vytvoriť Databázu';

  @override
  String get databaseExistsError => 'Súbor existuje';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'Chyba pri pokuse o vytvorenie databázy $filePath. Súbor už existuje. Vyberte iné meno.';
  }

  @override
  String get databaseCreateDefaultName => 'Osobné heslá';

  @override
  String get preferenceDynamicLoadIcons => 'Dynamické načítanie ikon';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'Vykoná žiadosti Http s hodnotou v poli $urlFieldName, aby sa načítali ikony webových stránok.';
  }

  @override
  String passwordScore(Object score) {
    return 'Sila: $score z 4';
  }

  @override
  String get entryInfoFile => 'Súbor:';

  @override
  String get entryInfoGroup => 'Skupina:';

  @override
  String get entryInfoLastModified => 'Naposledy Upravené:';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'Položka bola presunutá do skupiny $groupName';
  }

  @override
  String sizeBytesStoredAuthPassCloud(Object count) {
    return '$count bytes, stored on AuthPass Cloud';
  }

  @override
  String sizeBytes(Object count) {
    return '$count bajtov';
  }

  @override
  String get entryAddAttachment => 'Pridať Prílohu';

  @override
  String get entryAttachmentSizeWarning =>
      'Priložené súbory budú vložené do súboru s heslom. To môže výrazne predĺžiť čas potrebný na otvorenie/uloženie hesiel.';

  @override
  String get iconPngSizeWarning =>
      'Vlastné ikony budú vložené do súboru s heslom. To môže výrazne predĺžiť čas potrebný na otvorenie/uloženie hesiel.';

  @override
  String get notPngError => 'Zvolený súbor nieje PNG.';

  @override
  String get entryAddField => 'Pridať Pole';

  @override
  String get entryCustomField => 'Vlastné Pole';

  @override
  String get entryCustomFieldTitle => 'Pridáva sa nové vlastné Pole';

  @override
  String get entryCustomFieldInputLabel => 'Zadajte meno pre pole';

  @override
  String get swipeCopyField => 'Kopírovať pole';

  @override
  String get fieldRename => 'Premenovať';

  @override
  String get fieldGeneratePassword => 'Generovať heslo…';

  @override
  String get fieldProtect => 'Chrániť hodnotu';

  @override
  String get fieldUnprotect => 'Zrušiť ochranu hodnoty';

  @override
  String get fieldPresent => 'Prezentovať';

  @override
  String get fieldGenerateEmail => 'Generovať Email';

  @override
  String get onboardingBackToOnboarding => 'Prehliadka';

  @override
  String get onboardingBackToOnboardingSubtitle => 'Zažite prvý beh 😅️';

  @override
  String get onboardingHeadline => 'Poďme urobiť vaše heslo bezpečným!';

  @override
  String get onboardingQuestion => 'Už ste predtým používali správcu hesiel?';

  @override
  String get onboardingYesOpenPasswords => 'Áno, otvorte moje heslá';

  @override
  String get onboardingNoCreate => 'Som úplne nový! Ukáž mi ako.';

  @override
  String get backupButton => 'ULOŽIŤ DO CLOUDU';

  @override
  String get dismissBackupButton => 'ZRUŠIŤ';

  @override
  String backupWarningMessage(Object databasename) {
    return 'Vaše heslá v databáze $databasename su uložené iba lokálne!';
  }

  @override
  String get saveAs => 'Uložiť v...';

  @override
  String get saving => 'Ukladám';

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
      Object cloudStorageName, Object errorMessage) {
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
  String get newGroupDialogTitle => 'Nová Skupina';

  @override
  String get newGroupDialogInputLabel => 'Name for the new group';

  @override
  String get groupActionShowPasswords => 'Show passwords';

  @override
  String get groupActionDelete => 'Zmazať';

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
  String get shareCodeLoadingProgress => 'Načítavam súbor …';

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
  String get shortcutCopyUsername => 'Kopírovať používateľské meno';

  @override
  String get shortcutCopyPassword => 'Kopírovať Heslo';

  @override
  String get shortcutCopyTotp => 'Copy TOTP';

  @override
  String get shortcutMoveUp => 'Select the previous password';

  @override
  String get shortcutMoveDown => 'Select the next password';

  @override
  String get shortcutGeneratePassword => 'Generovať heslo';

  @override
  String get shortcutCopyUrl => 'Copy URL';

  @override
  String get shortcutOpenUrl => 'Otvoriť URL';

  @override
  String get shortcutCancelSearch => 'Cancel Search';

  @override
  String get shortcutShortcutHelp => 'Keyboard Shortcut Help';

  @override
  String get shortcutHelpTitle => 'Keyboard Shortcuts';

  @override
  String unexpectedError(String error) {
    return 'Neočakávaná chyba: $error';
  }

  @override
  String get googleDriveMorePermissionsRequired =>
      'Additional permissions needed to access Google Drive.';

  @override
  String get googleDriveRequestPermissionButtonLabel => 'Request Permissions';

  @override
  String get scanQrCodeTitle => 'Scan QR Code.';
}
