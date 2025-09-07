// ignore_for_file: omit_local_variable_types,unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get fieldUserName => 'Gebruiker';

  @override
  String get fieldPassword => 'Wachtwoord';

  @override
  String get fieldWebsite => 'Website';

  @override
  String get fieldTitle => 'Titel';

  @override
  String get fieldTotp => 'Eenmalig wachtwoord (Tijd gebaseerd)';

  @override
  String get english => 'Engels';

  @override
  String get german => 'Duits';

  @override
  String get russian => 'Russisch';

  @override
  String get ukrainian => 'Oekraïens';

  @override
  String get lithuanian => 'Litouws';

  @override
  String get french => 'Frans';

  @override
  String get spanish => 'Spaans';

  @override
  String get indonesian => 'Indonesisch';

  @override
  String get turkish => 'Turks';

  @override
  String get hebrew => 'Hebreeuws';

  @override
  String get italian => 'Italiaans';

  @override
  String get chineseSimplified => 'Chinees, vereenvoudigd';

  @override
  String get chineseTraditional => 'Chinees, traditioneel';

  @override
  String get portugueseBrazilian => 'Portugees, Braziliaans';

  @override
  String get slovak => 'Slowaaks';

  @override
  String get dutch => 'Nederlands';

  @override
  String get selectItem => 'Selecteer';

  @override
  String get selectKeepassFile => 'AuthPass - Selecteer KeePass Bestand';

  @override
  String get selectKeepassFileLabel => 'Selecteer een KeePass (.kdbx) bestand.';

  @override
  String get createNewFile => 'Maak nieuw bestand';

  @override
  String get openLocalFile => 'Open\nlokaal bestand';

  @override
  String get openFile => 'Open bestand';

  @override
  String get loadFromDropdownMenu => 'Laden uit …';

  @override
  String get quickUnlockingFiles => 'Bestanden snel ontgrendelen …';

  @override
  String openFileProgress(Object fileName, Object current, Object totalCount) {
    return 'Openen $fileName … ($current / $totalCount)';
  }

  @override
  String loadFrom(String cloudStorageName) {
    return 'Laad van $cloudStorageName';
  }

  @override
  String get loadFromRemoteUrl => 'Open kdbx vanaf URL';

  @override
  String get createNewKeepass =>
      'Nieuw bij KeePass?\nNieuw wachtwoord database aanmaken';

  @override
  String get labelLastOpenFiles => 'Laatste geopende bestanden:';

  @override
  String get noFilesHaveBeenOpenYet => 'Nog geen bestanden geopend.';

  @override
  String get preferenceSelectLanguage => 'Selecteer Taal';

  @override
  String get preferenceLanguage => 'Taal';

  @override
  String get preferenceTextScaleFactor => 'Tekst schaalfactor';

  @override
  String get preferenceVisualDensity => 'Visuele dichtheid';

  @override
  String get preferenceTheme => 'Thema';

  @override
  String get preferenceThemeLight => 'Licht';

  @override
  String get preferenceThemeDark => 'Donker';

  @override
  String get preferenceSystemDefault => 'Systeem standaard';

  @override
  String get preferenceDefault => 'Standaard';

  @override
  String get lockAllFiles => 'Vergrendel alle geopende bestanden';

  @override
  String get preferenceAllowScreenshots =>
      'Schermafbeeldingen in de App toestaan';

  @override
  String get preferenceEnableAutoFill => 'Automatisch aanvullen inschakelen';

  @override
  String get enableAutofillSuggestionBanner =>
      'Je kunt het velden invullen van andere programma\'s aanzetten door automatisch aanvullen in te schakelen!';

  @override
  String get dismissAutofillSuggestionBannerButton => 'AFWIJZEN';

  @override
  String get enableAutofillSuggestionBannerButton => 'INSCHAKELEN!';

  @override
  String get preferenceAutoFillDescription =>
      'Alleen ondersteund op Android Oreo (8.0) of later.';

  @override
  String get preferenceTitle => 'Voorkeuren';

  @override
  String get preferenceEnableSystemWideShortcuts =>
      'Activeer systeem brede snelkoppelingen';

  @override
  String get preferenceEnableSystemWideShortcutsHelp =>
      'Registreert ctrl + alt+f als systeem brede snelkoppeling om te zoeken.';

  @override
  String get preferencesSearchFields => 'Zoekvelden aanpassen';

  @override
  String get preferencesSearchFieldPromptTitle => 'Zoekvelden';

  @override
  String get preferencesSearchFieldPromptLabel =>
      'Komma\'s gescheiden lijst van velden om te gebruiken bij het zoeken in wachtwoordlijsten.';

  @override
  String preferencesSearchFieldPromptHelp(
    Object wildCardCharacter,
    Object defaultSearchFields,
  ) {
    return 'Gebruik $wildCardCharacter voor iedereen, laat leeg voor standaard ($defaultSearchFields)';
  }

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback => 'Wij verwelkomen elke vorm van feedback!';

  @override
  String get aboutLinkVisitWebsite => 'Kijk ook op onze website';

  @override
  String get aboutLinkGitHub => 'En Open Source Project';

  @override
  String aboutLogFile(String logFilePath) {
    return 'Logbestand: $logFilePath';
  }

  @override
  String get aboutLinkContributors => 'Toon bijdragers';

  @override
  String get unableToLaunchUrlTitle => 'Kan URL niet openen';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'Kan $url niet open: $openError';
  }

  @override
  String get unableToLaunchUrlNoHandler =>
      'Geen toepassing beschikbaar voor URL.';

  @override
  String launchedUrl(Object url) {
    return 'Geopende URL: $url';
  }

  @override
  String get menuItemGeneratePassword => 'Wachtwoord genereren';

  @override
  String get menuItemPreferences => 'Voorkeuren';

  @override
  String get menuItemOpenAnotherFile => 'Open een ander bestand';

  @override
  String get menuItemCheckForUpdates => 'Controleer op updates';

  @override
  String get menuItemSupport => 'Verstuur logs';

  @override
  String get menuItemSupportSubtitle => 'Verstuur logs via e-mail';

  @override
  String get menuItemForum => 'Ondersteuningsforum';

  @override
  String get menuItemForumSubtitle => 'Rapporteer problemen en hulp vragen';

  @override
  String get menuItemHelp => 'Help';

  @override
  String get menuItemHelpSubtitle => 'Documentatie weergeven';

  @override
  String get menuItemAbout => 'Over';

  @override
  String get actionOpenUrl => 'Open URL';

  @override
  String get passwordPlainText => 'Wachtwoord tonen';

  @override
  String get generatorPassword => 'Wachtwoord';

  @override
  String get generatePassword => 'Wachtwoord genereren';

  @override
  String get doneButtonLabel => 'Voltooid';

  @override
  String get useAsDefault => 'Gebruik als standaard';

  @override
  String get characterSetLowerCase => 'Kleine letters (a-z)';

  @override
  String get characterSetUpperCase => 'Hoofdletters (A-Z)';

  @override
  String get characterSetNumeric => 'Numeriek (0-9)';

  @override
  String get characterSetUmlauts => 'Umlauts (ä)';

  @override
  String get characterSetSpecial => 'Speciaal (@%+)';

  @override
  String get length => 'Lengte';

  @override
  String get customLength => 'Aangepaste lengte';

  @override
  String customLengthHelperText(Object customMinLength) {
    return 'Alleen gebruikt voor lengte > $customMinLength';
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
      other: '$numFilesString bestanden opgeslagen: $files',
      one: 'Eén bestand opgeslagen: $files',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => 'Groepen beheren';

  @override
  String get lockFiles => 'Bestanden vergrendelen';

  @override
  String get searchHint => 'Zoeken';

  @override
  String get searchButtonLabel => 'Zoeken';

  @override
  String get filterButtonLabel => 'Filteren op groepen';

  @override
  String get clear => 'Leegmaken';

  @override
  String get autofillFilterPrefix => 'Filter:';

  @override
  String get autofillPrompt =>
      'Selecteer wachtwoord invoer voor Automatisch aanvullen.';

  @override
  String get copiedToClipboard => 'Gekopieerd naar klembord.';

  @override
  String get noTitle => '(geen titel)';

  @override
  String get noUsername => '(geen gebruikersnaam)';

  @override
  String get filterCustomize => 'Aanpassen …';

  @override
  String get swipeCopyPassword => 'Wachtwoord kopiëren';

  @override
  String get swipeCopyUsername => 'Gebruikersnaam kopiëren';

  @override
  String get copyUsernameNotExists =>
      'Item heeft geen gebruikersnaam ingesteld.';

  @override
  String get copyPasswordNotExists =>
      'Item heeft geen wachtwoord gedefinieerd.';

  @override
  String get doneCopiedPassword => 'Wachtwoord gekopieerd naar klembord.';

  @override
  String get doneCopiedUsername => 'Gebruikersnaam gekopieerd naar klembord.';

  @override
  String get doneCopiedField => 'Gekopieerd.';

  @override
  String copiedFieldToClipboard(Object fieldName) {
    return '$fieldName gekopieerd.';
  }

  @override
  String copiedFieldEmpty(Object fieldName) {
    return '$fieldName is leeg.';
  }

  @override
  String get emptyPasswordVaultPlaceholder =>
      'Je hebt nog geen wachtwoord in je database.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Maak je eerste wachtwoord aan';

  @override
  String get loading => 'Laden';

  @override
  String get loadingFile => 'Bestand laden …';

  @override
  String get internalFile => 'Intern bestand';

  @override
  String get internalFileSubtitle => 'Database eerder aangemaakt met AuthPass';

  @override
  String get filePicker => 'Bestandskiezer';

  @override
  String get filePickerSubtitle => 'Open bestand op het apparaat.';

  @override
  String get credentialsAppBarTitle => 'Aanmeldgegevens';

  @override
  String get credentialLabel => 'Vul het wachtwoord in voor:';

  @override
  String get masterPasswordInputLabel => 'Wachtwoord';

  @override
  String get masterPasswordEmptyValidator => 'Voer je wachtwoord in.';

  @override
  String get masterPasswordIncorrectValidator => 'Ongeldig wachtwoord';

  @override
  String get useKeyFile => 'Gebruik sleutelbestand';

  @override
  String get saveMasterPasswordBiometric =>
      'Wachtwoord opslaan met biometrische sleutelopslag?';

  @override
  String get close => 'Sluiten';

  @override
  String get addNewPassword => 'Voeg nieuw wachtwoord toe';

  @override
  String get errorOpenFileInvalidFileStructureTitle =>
      'Geprobeerd om een ongeldig bestandstype te openen';

  @override
  String errorOpenFileInvalidFileStructureBody(Object fileName) {
    return 'Het bestand ($fileName) lijkt geen geldig KDBX bestand te zijn. Selecteer een geldig KDBX-bestand of maak een nieuwe wachtwoorddatabase.';
  }

  @override
  String get errorOpenFileAlreadyOpenTitle => 'Bestand al geopend';

  @override
  String errorOpenFileAlreadyOpenBody(
    Object databaseName,
    Object openFileSource,
    Object newFileSource,
  ) {
    return 'De geselecteerde database $databaseName is al geopend vanuit $openFileSource (Geprobeerd om te openen vanuit $newFileSource)';
  }

  @override
  String get loadFromUrl => 'Download vanaf URL';

  @override
  String get loadFromUrlEnterUrl => 'Voer URL in';

  @override
  String get loadFromUrlErrorEnterFullUrl =>
      'Voer de volledige URL in die begint met http:// of https://';

  @override
  String get loadFromUrlErrorInvalidUrl => 'Voer een geldige URL in.';

  @override
  String get linuxAppArmorWarning =>
      'AuthPass vereist toestemming om te communiceren met de Secrets Service om referenties op te slaan voor cloud opslag.\nVoer het volgende commando uit:';

  @override
  String get cancel => 'Annuleer';

  @override
  String get errorLoadFileFromSourceTitle => 'Fout bij het openen van bestand.';

  @override
  String errorLoadFileFromSourceBody(Object source, Object error) {
    return 'Niet mogelijk om $source te openen.\n$error';
  }

  @override
  String get errorUnlockFileTitle => 'Kan bestand niet openen';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Onbekende fout bij het openen van bestand. $error';
  }

  @override
  String get dialogContinue => 'Doorgaan';

  @override
  String get dialogSendErrorReport => 'Foutrapport versturen';

  @override
  String get dialogReportErrorForum => 'Rapporteer fout in Forum/Hulp';

  @override
  String get groupFilterDescription =>
      'Selecteer de groepen om te tonen (recursief)';

  @override
  String get groupFilterSelectAll => 'Alles selecteren';

  @override
  String get groupFilterDeselectAll => 'Alles deselecteren';

  @override
  String get createSubgroup => 'Subgroep aanmaken';

  @override
  String get editAction => 'Bewerken';

  @override
  String get mailboxEnableLabel => '(opnieuw) inschakelen';

  @override
  String get mailboxEnableHint => 'Doorgaan met ontvangen e-mails';

  @override
  String get mailboxDisableLabel => 'Uitschakelen';

  @override
  String get mailboxDisableHint => 'Ontvang geen e-mails meer';

  @override
  String get mailListNoMail => 'U heeft nog geen e-mails.';

  @override
  String mailboxLabelPrefixForEntry(Object entryLabel) {
    return 'Entry: $entryLabel';
  }

  @override
  String mailboxLabelPrefixUnknownEntry(Object entryUuid) {
    return 'Onbekende invoer: $entryUuid';
  }

  @override
  String mailboxLabelPrefixCreatedAt(Object dateTime) {
    return 'Aangemaakt op: $dateTime';
  }

  @override
  String get masterPasswordDescription =>
      'Het hoofdwachtwoord gebruik je om je wachtwoorddatabase veilig te versleutelen. Zorg ervoor dat u het onthoudt. Het wachtwoord kan niet hersteld worden.';

  @override
  String get unsavedChangesWarningTitle => 'Niet-opgeslagen wijzigingen';

  @override
  String get unsavedChangesWarningBody =>
      'Er zijn nog steeds niet-opgeslagen wijzigingen. Wilt u de wijzigingen weggooien?';

  @override
  String get unsavedChangesDiscardActionLabel => 'Wijzigingen weggooien';

  @override
  String get deletePermanentlyAction => 'Permanent verwijderen';

  @override
  String get restoreFromRecycleBinAction => 'Herstellen';

  @override
  String get deleteAction => 'Verwijderen';

  @override
  String get deletedEntry => 'Verwijderde invoer.';

  @override
  String get successfullyDeletedGroup => 'Verwijderde groep.';

  @override
  String get undoButtonLabel => 'Herstel';

  @override
  String get saveButtonLabel => 'Opslaan';

  @override
  String get webDavSettings => 'WebDAV instellingen';

  @override
  String get webDavUrlLabel => 'URL';

  @override
  String get webDavUrlHelperText => 'Basis URL voor je WebDAV service.';

  @override
  String get webDavUrlValidatorError => 'Voer een URL in';

  @override
  String get webDavUrlValidatorInvalidUrlError =>
      'Voer een geldige URL in met http:// of https://';

  @override
  String get webDavAuthUser => 'Gebruikersnaam';

  @override
  String get webDavAuthPassword => 'Wachtwoord';

  @override
  String get mergeSuccessDialogTitle =>
      'Wachtwoorddatabase succesvol samengevoegd';

  @override
  String mergeSuccessDialogMessage(Object fileName, Object mergeSummary) {
    return 'Conflict gedetecteerd bij het opslaan van $fileName, het is succesvol samengevoegd met het externe bestand: \n\n$mergeSummary';
  }

  @override
  String forDetailsVisitUrl(Object url) {
    return 'Voor details bezoek $url';
  }

  @override
  String get authPassCloudAuthEmailInputLabel =>
      'Voer e-mailadres in om te registreren of in te loggen.';

  @override
  String get authPassCloudAuthEmailInvalid => 'Vul een geldig e-mailadres in.';

  @override
  String get authPassCloudAuthConfirmEmailButtonLabel => 'Bevestig Adres';

  @override
  String get authPassCloudAuthConfirmEmail =>
      'Controleer uw e-mails om uw e-mailadres te bevestigen.';

  @override
  String get authPassCloudAuthConfirmEmailExplain =>
      'Houd dit scherm open totdat u de link heeft bezocht die u per e-mail heeft ontvangen.';

  @override
  String get authPassCloudAuthResendExplain =>
      'Als je nog geen e-mail hebt ontvangen, controleer dan je spam folder. Anders kun je proberen een nieuwe bevestigingslink aan te vragen.';

  @override
  String get authPassCloudAuthResendButtonLabel =>
      'Vraag een nieuwe bevestigingslink aan';

  @override
  String permanentlyDeleteEntryConfirm(Object title) {
    return 'Dit zal het wachtwoord permanent verwijderen $title. Dit kan niet ongedaan gemaakt worden. Wilt u doorgaan?';
  }

  @override
  String get permanentlyDeletedEntrySnackBar => 'Item permanent verwijderd.';

  @override
  String get initialNewGroupName => 'Nieuwe groep';

  @override
  String get deleteGroupErrorTitle => 'Kan groep niet verwijderen';

  @override
  String get deleteGroupErrorBodyContainsGroup =>
      'Deze groep bevat nog andere groepen. Je kunt op dit moment alleen lege groepen verwijderen.';

  @override
  String get deleteGroupErrorBodyContainsEntries =>
      'Deze groep bevat nog steeds wachtwoordvermeldingen. Je kunt op dit moment alleen lege groepen verwijderen.';

  @override
  String get groupListAppBarTitle => 'Groepen';

  @override
  String get groupListFilterAppbarTitle => 'Filteren op groepen';

  @override
  String get clearQuickUnlock => 'Biometrische opslag wissen';

  @override
  String get clearQuickUnlockSubtitle =>
      'Verwijder opgeslagen hoofdwachtwoorden';

  @override
  String get unlock => 'Bestanden ontgrendelen';

  @override
  String get closePasswordFiles => 'sluit wachtwoordbestanden';

  @override
  String get clearQuickUnlockSuccess =>
      'Hoofdwachtwoorden verwijderd uit biometrische opslag.';

  @override
  String get diacOptIn => 'Meld je aan voor In-App Nieuws, Enquêtes.';

  @override
  String get diacOptInSubtitle =>
      'Zal af en toe een netwerkverzoek verzenden om nieuws op te halen.';

  @override
  String get enableAutofillDebug => 'Automatisch aanvullen: Debug inschakelen';

  @override
  String get enableAutofillDebugSubtitle =>
      'Toont informatie overlays voor elk invoerveld';

  @override
  String get createPasswordDatabase => 'Maak wachtwoord database';

  @override
  String get nameNewPasswordDatabase => 'Naam van je nieuwe database';

  @override
  String get validatorNameMissing =>
      'Voer een naam in voor de nieuwe database.';

  @override
  String get masterPasswordHelpText =>
      'Selecteer een veilig hoofdwachtwoord. Zorg ervoor dat je het onthoudt.';

  @override
  String get inputMasterPasswordText => 'Hoofdwachtwoord';

  @override
  String get masterPasswordMissingCreate =>
      'Voer een veilig, te onthouden wachtwoord in.';

  @override
  String get createDatabaseAction => 'Maak Database';

  @override
  String get databaseExistsError => 'Bestand bestaat';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'Fout bij het maken van database $filePath. Bestand bestaat al. Kies een andere naam.';
  }

  @override
  String get databaseCreateDefaultName => 'PersoonlijkeWachtwoorden';

  @override
  String get preferenceDynamicLoadIcons => 'Pictogrammen dynamisch laden';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'Zal http verzoeken indienen met de waarde in het $urlFieldName veld om de website-iconen te laden.';
  }

  @override
  String passwordScore(Object score) {
    return 'Sterkte: $score van 4';
  }

  @override
  String get entryInfoFile => 'Bestand:';

  @override
  String get entryInfoGroup => 'Groep:';

  @override
  String get entryInfoLastModified => 'Laatst gewijzigd:';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'Invoer verplaatst naar $groupName';
  }

  @override
  String sizeBytesStoredAuthPassCloud(Object count) {
    return '$count bytes, opgeslagen in AuthPass Cloud';
  }

  @override
  String sizeBytes(Object count) {
    return '$count bytes';
  }

  @override
  String get entryAddAttachment => 'Bijlage toevoegen';

  @override
  String get entryAttachmentSizeWarning =>
      'Bijgevoegde bestanden worden toegevoegd in het wachtwoordbestand. Dit kan de tijd die nodig is om wachtwoorden te openen/opslaan, aanzienlijk verhogen.';

  @override
  String get iconPngSizeWarning =>
      'Aangepaste pictogrammen worden toegevoegd het wachtwoordbestand. Dit kan de tijd die nodig is voor het openen/opslaan van wachtwoorden aanzienlijk verhogen.';

  @override
  String get notPngError => 'Het gekozen bestand is geen PNG.';

  @override
  String get entryAddField => 'Veld toevoegen';

  @override
  String get entryCustomField => 'Aangepast veld';

  @override
  String get entryCustomFieldTitle => 'Toevoegen van nieuw aangepast veld';

  @override
  String get entryCustomFieldInputLabel => 'Voer een naam in voor het veld';

  @override
  String get swipeCopyField => 'Veld kopiëren';

  @override
  String get fieldRename => 'Hernoem';

  @override
  String get fieldGeneratePassword => 'Wachtwoord genereren …';

  @override
  String get fieldProtect => 'Bescherm waarde';

  @override
  String get fieldUnprotect => 'Waarde niet beschermen';

  @override
  String get fieldPresent => 'Tonen';

  @override
  String get fieldGenerateEmail => 'Genereer E-mail';

  @override
  String get onboardingBackToOnboarding => 'Rondleiding';

  @override
  String get onboardingBackToOnboardingSubtitle =>
      'Herhaal de eerste keer tour 😅';

  @override
  String get onboardingHeadline => 'Laten we je wachtwoorden veilig maken!';

  @override
  String get onboardingQuestion =>
      'Heb je al eerder een wachtwoordmanager gebruikt?';

  @override
  String get onboardingYesOpenPasswords => 'Ja, open mijn wachtwoorden';

  @override
  String get onboardingNoCreate => 'Ik ben allemaal nieuw! Help me op gang.';

  @override
  String get backupButton => 'OPSLAAN NAAR CLOUD';

  @override
  String get dismissBackupButton => 'AFWIJZEN';

  @override
  String backupWarningMessage(Object databasename) {
    return 'Je wachtwoorden in $databasename worden alleen lokaal opgeslagen!';
  }

  @override
  String get saveAs => 'Opslaan in...';

  @override
  String get saving => 'Opslaan';

  @override
  String get increaseValue => 'Toename';

  @override
  String get decreaseValue => 'Verminderen';

  @override
  String get resetValue => 'Reset';

  @override
  String cloudStorageAppBarTitle(Object cloudStorageName) {
    return 'Cloudopslag - $cloudStorageName';
  }

  @override
  String get cloudStorageLogInCaption =>
      'U wordt omgeleid naar AuthPass authenticeren om toegang te krijgen tot uw gegevens.';

  @override
  String get cloudStorageLogInCode => 'Voer code in';

  @override
  String launchUrlError(Object url) {
    return 'Kan URL niet starten. Bezoek $url';
  }

  @override
  String cloudStorageLogInActionLabel(Object cloudStorageName) {
    return 'Inloggen op $cloudStorageName';
  }

  @override
  String cloudStorageAuthCodeDialogTitle(Object cloudStorageName) {
    return '$cloudStorageName authenticatie';
  }

  @override
  String get cloudStorageAuthCodeLabel => 'Authenticatie code';

  @override
  String get cloudStorageAuthErrorTitle => 'Fout tijdens authenticatie';

  @override
  String cloudStorageAuthErrorMessage(
    Object cloudStorageName,
    Object errorMessage,
  ) {
    return 'Fout bij het authenticeren van $cloudStorageName: $errorMessage';
  }

  @override
  String get cloudStorageSearchBoxLabel => 'Zoekopdracht';

  @override
  String cloudStorageItemsInFolder(Object itemCount) {
    return '$itemCount items in deze map.';
  }

  @override
  String get mailSubject => 'Onderwerp';

  @override
  String get mailFrom => 'Van';

  @override
  String get mailDate => 'Datum';

  @override
  String get mailMailbox => 'Postvak';

  @override
  String get mailNoData => 'Geen gegevens';

  @override
  String get mailMailboxesTitle => 'Postvakken';

  @override
  String get mailboxCreateButtonLabel => 'Maken';

  @override
  String get mailboxNameInputDialogTitle =>
      'Optioneel labelen voor nieuw postvak';

  @override
  String get mailboxNameInputLabel => '(intern) label';

  @override
  String get mailScreenTitle => 'AuthPass mail';

  @override
  String get mailTabBarTitleMailbox => 'Postvak';

  @override
  String get mailTabBarTitleMail => 'E-mail';

  @override
  String get mailMailboxListEmpty => 'Je hebt nog geen postvakken.';

  @override
  String mailMailboxAddressCopied(Object mailboxAddress) {
    return 'Postvak adres gekopieerd naar het klembord: $mailboxAddress';
  }

  @override
  String get errorWhileSavingTitle => 'Fout bij opslaan';

  @override
  String errorWhileSavingBody(Object errorMessage) {
    return 'Kan bestand niet opslaan: $errorMessage';
  }

  @override
  String get databaseDoesNotSupportSaving =>
      'Sorry, deze database ondersteunt geen opslaan. Open een lokaal databasebestand. Of gebruik \"Opslaan als\".';

  @override
  String get otpInvalidKeyTitle => 'Ongeldige sleutel';

  @override
  String get otpInvalidKeyBody =>
      'De gegeven invoer is geen geldige base32 TOTP-code. Controleer je invoer.';

  @override
  String get otpUnsupportedMigrationTitle => 'Unsupported OTP Migration';

  @override
  String otpUnsupportedMigrationBody(Object uriCount) {
    return 'We currently only support single item migrations. Got $uriCount';
  }

  @override
  String get otpPromptTitle => 'Authenticatie op basis van tijd';

  @override
  String get otpPromptHelperText => 'Voer de op tijd gebaseerde sleutel in.';

  @override
  String otpErrorMessageGeneration(Object errorMessage) {
    return 'Fout bij genereren uitnodigingscode: $errorMessage';
  }

  @override
  String get otpCopySecretActionLabel => 'Kopieer Secret';

  @override
  String get otpEntryLabel => 'Eenmalige token';

  @override
  String get entryFieldProtected => 'Beschermd veld. Klik om te tonen.';

  @override
  String get entryFieldActionRevealField => 'Toon beschermd veld';

  @override
  String get entryAttachmentOpenActionLabel => 'Open';

  @override
  String get entryAttachmentShareActionLabel => 'Delen';

  @override
  String get entryAttachmentShareSubject => 'Bijlage';

  @override
  String get entryAttachmentSaveActionLabel => 'Opslaan op apparaat';

  @override
  String get entryAttachmentRemoveActionLabel => 'Verwijderen';

  @override
  String entryAttachmentRemoveConfirm(Object attachmentLabel) {
    return 'Weet je zeker dat je $attachmentLabel wilt verwijderen?';
  }

  @override
  String get entryRenameFieldPromptTitle => 'Veld hernoemen';

  @override
  String get removerecentfile => 'Verbergen';

  @override
  String get entryRenameFieldPromptLabel =>
      'Voer de nieuwe naam voor het veld in';

  @override
  String get promptDialogPasteActionTooltip => 'Plakken vanaf klembord';

  @override
  String get promptDialogPasteHint =>
      'Tip: Als je wilt plakken, probeer dan de knop links ;-)';

  @override
  String get genericErrorDialogTitle => 'Fout bij het afhandelen actie';

  @override
  String genericErrorDialogBody(Object errorMessage) {
    return 'Onverwachte fout opgetreden. $errorMessage';
  }

  @override
  String get saveAsEntryLocalFile => 'Lokaal bestand';

  @override
  String get fileTypePngs => 'Afbeeldingen (png)';

  @override
  String get selectIconDialogAction => 'SELECTEER ICON';

  @override
  String get retryDialogActionLabel => 'OPNIEUW';

  @override
  String errorDuringNetworkCall(Object errorMessage) {
    return 'Fout tijdens Api oproep. $errorMessage';
  }

  @override
  String get passwordFilterHideDeleted => 'Verwijderde items verbergen';

  @override
  String get passwordFilterOnlyDeleted => 'Verwijderde items';

  @override
  String passwordFilterPrefixForOneGroup(Object groupName) {
    return 'Groep: $groupName';
  }

  @override
  String passwordFilterPrefixForMultipleGroups(Object groupCount) {
    return 'Aangepast filter ($groupCount groepen)';
  }

  @override
  String get menuItemAuthPassCloudAuthenticate =>
      'Authenticeer met AuthPass Cloud';

  @override
  String get menuItemAuthPassCloudMailboxes => 'Authass postbussen';

  @override
  String changesWithoutSaving(Object fileName) {
    return 'Je hebt wijzigingen in \"$fileName\", die geen ondersteuning heeft voor het schrijven van wijzigingen.';
  }

  @override
  String get changesSaveLocally => 'Bewaar lokaal';

  @override
  String get clearColor => 'Kleur verwijderen';

  @override
  String get databaseRenameInputLabel => 'Voer databasenaam in';

  @override
  String get databasePath => 'Pad';

  @override
  String get databaseColor => 'Kleur';

  @override
  String get databaseColorChoose =>
      'Selecteer een kleur om onderscheid te maken tussen bestanden.';

  @override
  String get databaseKdbxVersion => 'KDBX Bestandsversie';

  @override
  String databaseKdbxUpgradeVersion(Object versionName) {
    return 'Upgrade naar $versionName';
  }

  @override
  String get databaseKdbxUpgradeSuccessful =>
      'Bestand succesvol bijgewerkt en opgeslagen.';

  @override
  String get databaseReload => 'Herladen en samenvoegen';

  @override
  String progressStatus(Object statusProgress) {
    return 'Status: $statusProgress';
  }

  @override
  String finishedMerge(Object status) {
    return 'Samenvoegen $status gelukt';
  }

  @override
  String get closeAndLockFile => 'Sluiten/Vergrendelen';

  @override
  String get authPassHomeScreenTagline =>
      'wachtwoordmanager, open source, beschikbaar op alle platformen.';

  @override
  String get addNewPasswordButtonLabel => 'Nieuw wachtwoord toevoegen';

  @override
  String get unnamedEntryPlaceholder => '(naamloos)';

  @override
  String get unnamedGroupPlaceholder => '(naamloos)';

  @override
  String get unnamedFilePlaceholder => '(naamloos)';

  @override
  String get editGroupScreenTitle => 'Groep bewerken';

  @override
  String get editGroupGroupNameLabel => 'Groep Naam';

  @override
  String get files => 'Bestanden';

  @override
  String get newGroupDialogTitle => 'Nieuwe groep';

  @override
  String get newGroupDialogInputLabel => 'Naam voor de nieuwe groep';

  @override
  String get groupActionShowPasswords => 'Wachtwoord weergeven';

  @override
  String get groupActionDelete => 'Verwijderen';

  @override
  String get logoutTooltip => 'Uitloggen';

  @override
  String get successfullyDeletedFileCloudStorage =>
      'Bestand succesvol verwijderd.';

  @override
  String shareDialogTitle(Object fileName) {
    return 'Opties voor delen $fileName';
  }

  @override
  String get shareFileActionLabel => 'Delen …';

  @override
  String get shareTokenListEmptyScreenPlaceholder =>
      'Bestand nog niet gedeeld.';

  @override
  String get shareTokenNoLabel => 'Geen label/omschrijving';

  @override
  String get shareTokenReadWrite => 'Lezen/schrijven';

  @override
  String get shareTokenReadOnly => 'Alleen lezen';

  @override
  String get shareCreateTokenDialogTitle => 'Bestand delen';

  @override
  String get shareCreateTokenReadOnly => 'Alleen lezen';

  @override
  String get shareCreateTokenReadOnlyHelpText =>
      'Opslaan van wijzigingen niet toestaan';

  @override
  String get shareCreateTokenLabelText => 'Omschrijving';

  @override
  String get shareCreateTokenLabelHint => 'Deel met mijn vriend';

  @override
  String get shareCreateTokenLabelHelp =>
      'Optioneel label om de deelcode te differentiëren.';

  @override
  String get shareCreateTokenSuccess => 'Deelcode succesvol aangemaakt.';

  @override
  String get sharePresentDialogTitle => 'Deel bestand met geheime deelcode';

  @override
  String get sharePresentDialogHelp =>
      'Met de volgende deelcode hebben gebruikers toegang tot het wachtwoord bestand. Ze hebben het wachtwoord en/of sleutelbestand nodig om het te openen.';

  @override
  String get sharePresentToken => 'Deelcode';

  @override
  String get sharePresentCopied => 'Deelcode gekopieerd naar klembord.';

  @override
  String get authPassCloudOpenWithShareCodeTooltip => 'Openen met deelcode';

  @override
  String get authPassCloudShareFileActionLabel => 'Delen';

  @override
  String get preferenceAuthPassCloudAttachmentTitle =>
      'Gebruik AuthPass Cloudbijlagen';

  @override
  String get preferenceAuthPassCloudAttachmentSubtitle =>
      'Sla bijlagen afzonderlijk versleuteld in AuthPass Cloud.';

  @override
  String get shareCodeInputDialogTitle => 'Geheime deelcode invoeren';

  @override
  String get shareCodeInputDialogScan => 'Scan QR Code';

  @override
  String get shareCodeInputLabel => 'Geheime deelcode';

  @override
  String get shareCodeInputHelperText =>
      'Als je een deelcode hebt ontvangen, plak deze dan hierboven.';

  @override
  String get shareCodeOpen => 'Een deelcode ontvangen voor AuthPass Cloud?';

  @override
  String get shareCodeOpenScreenTitle => 'Bestand met deelcode laden';

  @override
  String get shareCodeLoadingProgress => 'Bestand laden …';

  @override
  String get shareCodeOpenFileButtonLabel => 'OPEN';

  @override
  String get shareCodeOpenInstallAppCaption =>
      'Wil je dit bestand in plaats daarvan openen met een van onze native Apps?';

  @override
  String get shareCodeOpenAnotherAppCaption =>
      'Wil je dit bestand op een ander apparaat openen?';

  @override
  String get shareCodeOpenInstallAppButtonLabel => 'App installeren';

  @override
  String get shareCodeOpenShowCodeButtonLabel => 'Toon deelcode';

  @override
  String get changeMasterPasswordActionLabel => 'Hoofdwachtwoord wijzigen';

  @override
  String get changeMasterPasswordFormSubmit => 'Opslaan met nieuw wachtwoord';

  @override
  String get changeMasterPasswordSuccess =>
      'Hoofdwachtwoord succesvol opgeslagen.';

  @override
  String get changeMasterPasswordScreenTitle => 'Hoofdwachtwoord wijzigen';

  @override
  String get authPassCloudAuthClickedLink =>
      'Ik heb de e-mail ontvangen en de link bezocht';

  @override
  String get authPassCloudAuthNotConfirmed =>
      'E-mailadres is nog niet bevestigd. Zorg ervoor dat in de e-mail op de link klikt en vervolgens de captcha oplost om je e-mailadres te bevestigen.';

  @override
  String get getHelpButton => 'Hulp krijgen in het forum';

  @override
  String get shortcutCopyUsername => 'Gebruikersnaam kopiëren';

  @override
  String get shortcutCopyPassword => 'Wachtwoord kopiëren';

  @override
  String get shortcutCopyTotp => 'TOTP kopiëren';

  @override
  String get shortcutMoveUp => 'Selecteer vorig wachtwoord';

  @override
  String get shortcutMoveDown => 'Selecteer het volgende wachtwoord';

  @override
  String get shortcutGeneratePassword => 'Wachtwoord genereren';

  @override
  String get shortcutCopyUrl => 'Kopieer URL';

  @override
  String get shortcutOpenUrl => 'Open URL';

  @override
  String get shortcutCancelSearch => 'Zoeken annuleren';

  @override
  String get shortcutShortcutHelp => 'Toetsenbord sneltoets Help';

  @override
  String get shortcutHelpTitle => 'Toetsenbord sneltoetsen';

  @override
  String unexpectedError(String error) {
    return 'Onverwachte fout: $error';
  }

  @override
  String get googleDriveMorePermissionsRequired =>
      'Additional permissions needed to access Google Drive.';

  @override
  String get googleDriveRequestPermissionButtonLabel => 'Request Permissions';

  @override
  String get scanQrCodeTitle => 'Scan QR Code.';
}
