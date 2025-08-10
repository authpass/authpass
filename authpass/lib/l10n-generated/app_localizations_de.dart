// ignore_for_file: omit_local_variable_types,unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get fieldUserName => 'Benutzer';

  @override
  String get fieldPassword => 'Passwort';

  @override
  String get fieldWebsite => 'Webseite';

  @override
  String get fieldTitle => 'Titel';

  @override
  String get fieldTotp => 'Einmalpasswort (Zeitbasiert)';

  @override
  String get english => 'Englisch';

  @override
  String get german => 'Deutsch';

  @override
  String get russian => 'Russisch';

  @override
  String get ukrainian => 'Ukrainisch';

  @override
  String get lithuanian => 'Litauisch';

  @override
  String get french => 'Französisch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get indonesian => 'Indonesisch';

  @override
  String get turkish => 'Türkisch';

  @override
  String get hebrew => 'Hebräisch';

  @override
  String get italian => 'Italienisch';

  @override
  String get chineseSimplified => 'Vereinfachtes Chinesisch';

  @override
  String get chineseTraditional => 'Traditionelles Chinesisch';

  @override
  String get portugueseBrazilian => 'Portugiesisch, Brasilianisch';

  @override
  String get slovak => 'Slowakisch';

  @override
  String get dutch => 'Niederländisch';

  @override
  String get selectItem => 'Auswählen';

  @override
  String get selectKeepassFile => 'AuthPass - Wähle eine KeePass Datei';

  @override
  String get selectKeepassFileLabel =>
      'Bitte wähle eine KeePass (.kdbx) Datei.';

  @override
  String get createNewFile => 'Datei Erstellen';

  @override
  String get openLocalFile => 'Öffne\nLokale Datei';

  @override
  String get openFile => 'Datei öffnen';

  @override
  String get loadFromDropdownMenu => 'Lade von …';

  @override
  String get quickUnlockingFiles => 'Dateien schnell entsperren …';

  @override
  String openFileProgress(Object fileName, Object current, Object totalCount) {
    return 'Öffne $fileName … ($current / $totalCount)';
  }

  @override
  String loadFrom(String cloudStorageName) {
    return 'Lade von $cloudStorageName';
  }

  @override
  String get loadFromRemoteUrl => 'Lade von URL';

  @override
  String get createNewKeepass =>
      'KeePass noch nie verwendet?\nJetzt neue Passwort Datenbank erstellen';

  @override
  String get labelLastOpenFiles => 'Zuletzt geöffnete Dateien:';

  @override
  String get noFilesHaveBeenOpenYet => 'Keine Dateien bisher geöffnet.';

  @override
  String get preferenceSelectLanguage => 'Sprache wählen';

  @override
  String get preferenceLanguage => 'Sprache';

  @override
  String get preferenceTextScaleFactor => 'Text Skalierung';

  @override
  String get preferenceVisualDensity => 'Visuelle Dichte';

  @override
  String get preferenceTheme => 'Theme';

  @override
  String get preferenceThemeLight => 'Hell';

  @override
  String get preferenceThemeDark => 'Dunkel';

  @override
  String get preferenceSystemDefault => 'Geräte Standardeinstellung';

  @override
  String get preferenceDefault => 'Standard';

  @override
  String get lockAllFiles => 'Alle offenen Dateien schließen';

  @override
  String get preferenceAllowScreenshots => 'Screenshots der App zulassen';

  @override
  String get preferenceEnableAutoFill => 'Autofill aktivieren';

  @override
  String get enableAutofillSuggestionBanner =>
      'Sie können das Feld einer anderen Anwendung ausfüllen, indem Sie Autofill aktivieren!';

  @override
  String get dismissAutofillSuggestionBannerButton => 'Schließen';

  @override
  String get enableAutofillSuggestionBannerButton => 'Aktivieren!';

  @override
  String get preferenceAutoFillDescription =>
      'Wird nur auf ab Android Oreo (8.0) unterstützt.';

  @override
  String get preferenceTitle => 'Einstellungen';

  @override
  String get preferenceEnableSystemWideShortcuts =>
      'Aktiviere Systemweite Verknüpfungen';

  @override
  String get preferenceEnableSystemWideShortcutsHelp =>
      'Registriert Strg+alt+f als systemweite Verknüpfung um die Suche zu öffnen.';

  @override
  String get preferencesSearchFields => 'Suchfelder anpassen';

  @override
  String get preferencesSearchFieldPromptTitle => 'Suchfeld';

  @override
  String get preferencesSearchFieldPromptLabel =>
      'Kommagetrennte Liste von Feldern, die in der Passwortlistensuche verwendet werden sollen.';

  @override
  String preferencesSearchFieldPromptHelp(
      Object wildCardCharacter, Object defaultSearchFields) {
    return 'Verwende $wildCardCharacter für alle, lasse leer für Standard ($defaultSearchFields)';
  }

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback => 'Wir freuen uns über jede Art von Feedback!';

  @override
  String get aboutLinkVisitWebsite => 'Besuchen Sie auch unsere Website';

  @override
  String get aboutLinkGitHub => 'Und Open Source Projekt';

  @override
  String aboutLogFile(String logFilePath) {
    return 'Log-Datei: $logFilePath';
  }

  @override
  String get aboutLinkContributors => 'Mitwirkende anzeigen';

  @override
  String get unableToLaunchUrlTitle => 'Kann URL nicht öffnen';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'Fehler beim öffnen von $url: $openError';
  }

  @override
  String get unableToLaunchUrlNoHandler => 'Keine App für die URL gefunden.';

  @override
  String launchedUrl(Object url) {
    return 'URL $url geöffnet';
  }

  @override
  String get menuItemGeneratePassword => 'Passwort generieren';

  @override
  String get menuItemPreferences => 'Einstellungen';

  @override
  String get menuItemOpenAnotherFile => 'Weitere Datei öffnen';

  @override
  String get menuItemCheckForUpdates => 'Nach Updates suchen';

  @override
  String get menuItemSupport => 'Protokolle senden';

  @override
  String get menuItemSupportSubtitle => 'Protokolle per E-Mail senden';

  @override
  String get menuItemForum => 'Support Forum';

  @override
  String get menuItemForumSubtitle => 'Melde Probleme und erhalte Hilfe';

  @override
  String get menuItemHelp => 'Hilfe';

  @override
  String get menuItemHelpSubtitle => 'Dokumentation anzeigen';

  @override
  String get menuItemAbout => 'Über AuthPass';

  @override
  String get actionOpenUrl => 'URL Öffnen';

  @override
  String get passwordPlainText => 'Passwort anzeigen';

  @override
  String get generatorPassword => 'Passwort';

  @override
  String get generatePassword => 'Passwort generieren';

  @override
  String get doneButtonLabel => 'Fertig';

  @override
  String get useAsDefault => 'Als Standard speichern';

  @override
  String get characterSetLowerCase => 'Kleinbuchstaben (a-z)';

  @override
  String get characterSetUpperCase => 'Großbuchstaben (A-Z)';

  @override
  String get characterSetNumeric => 'Ziffern (0-9)';

  @override
  String get characterSetUmlauts => 'Umlaute (äöü)';

  @override
  String get characterSetSpecial => 'Sonderzeichen (@%+)';

  @override
  String get length => 'Länge';

  @override
  String get customLength => 'Andere Länge';

  @override
  String customLengthHelperText(Object customMinLength) {
    return 'Nur für > $customMinLength verwendet';
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
      other: '$numFilesString Dateien gespeichert: $files',
      one: 'Eine Datei gespeichert: $files',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => 'Gruppen verwalten';

  @override
  String get lockFiles => 'Dateien sperren/schließen';

  @override
  String get searchHint => 'Suchen';

  @override
  String get searchButtonLabel => 'Suchen';

  @override
  String get filterButtonLabel => 'Nach Gruppe filtern';

  @override
  String get clear => 'Löschen';

  @override
  String get autofillFilterPrefix => 'Filter:';

  @override
  String get autofillPrompt => 'Wähle einen Passwort-Eintrag für Autofill.';

  @override
  String get copiedToClipboard => 'In die Zwischenablage kopiert.';

  @override
  String get noTitle => '(kein Titel)';

  @override
  String get noUsername => '(kein Benutzername)';

  @override
  String get filterCustomize => 'Anpassen …';

  @override
  String get swipeCopyPassword => 'Passwort kopieren';

  @override
  String get swipeCopyUsername => 'Benutzername kopieren';

  @override
  String get copyUsernameNotExists => 'Eintrag hat keinen Benutzernamen.';

  @override
  String get copyPasswordNotExists => 'Eintrag hat kein Passwort definiert.';

  @override
  String get doneCopiedPassword => 'Passwort in die Zwischenablage kopiert.';

  @override
  String get doneCopiedUsername =>
      'Benutzername in die Zwischenablage kopiert.';

  @override
  String get doneCopiedField => 'Kopiert.';

  @override
  String copiedFieldToClipboard(Object fieldName) {
    return '$fieldName kopiert.';
  }

  @override
  String copiedFieldEmpty(Object fieldName) {
    return '$fieldName ist leer.';
  }

  @override
  String get emptyPasswordVaultPlaceholder =>
      'Du hast noch keine Passworter in deiner Datenbank.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Erstelle dein erstes Passwort';

  @override
  String get loading => 'Wird geladen';

  @override
  String get loadingFile => 'Datei wird geladen …';

  @override
  String get internalFile => 'Interne Dateien';

  @override
  String get internalFileSubtitle => 'Datenbank zuvor mit AuthPass erstellt';

  @override
  String get filePicker => 'File Picker';

  @override
  String get filePickerSubtitle => 'Datei vom lokalen Gerät öffnen.';

  @override
  String get credentialsAppBarTitle => 'Entschlüsselung';

  @override
  String get credentialLabel => 'Passwort eingeben für:';

  @override
  String get masterPasswordInputLabel => 'Passwort';

  @override
  String get masterPasswordEmptyValidator => 'Bitte gib dein Passwort ein.';

  @override
  String get masterPasswordIncorrectValidator => 'Ungültiges Passwort';

  @override
  String get useKeyFile => 'Schlüsseldatei verwenden';

  @override
  String get saveMasterPasswordBiometric =>
      'Passwort sicher speichern (mit biometrischen Schutz)?';

  @override
  String get close => 'Schließen';

  @override
  String get addNewPassword => 'Neues Passwort hinzufügen';

  @override
  String get errorOpenFileInvalidFileStructureTitle =>
      'Es wurde versucht, einen ungültigen Dateityp zu öffnen';

  @override
  String errorOpenFileInvalidFileStructureBody(Object fileName) {
    return 'Die Datei ($fileName) scheint keine gültige KDBX-Datei zu sein. Bitte wählen Sie entweder eine gültige KDBX-Datei oder erstellen Sie eine neue Passwortdatenbank.';
  }

  @override
  String get errorOpenFileAlreadyOpenTitle => 'Datei schon geöffnet';

  @override
  String errorOpenFileAlreadyOpenBody(
      Object databaseName, Object openFileSource, Object newFileSource) {
    return 'Die Datenbank $databaseName ist bereits von $openFileSource aus geöffnet. (Versuchte $newFileSource zu öffnen)';
  }

  @override
  String get loadFromUrl => 'Von der url herunterladen';

  @override
  String get loadFromUrlEnterUrl => 'URL eingeben';

  @override
  String get loadFromUrlErrorEnterFullUrl =>
      'Bitte geben Sie die vollständige URL ein, beginnend mit http:// oder https://';

  @override
  String get loadFromUrlErrorInvalidUrl => 'Bitte eine gültige URL eingeben.';

  @override
  String get linuxAppArmorWarning =>
      'AuthPass benötigt die Berechtigung, mit dem Geheimdienst zu kommunizieren, um Anmeldedaten für den Cloud-Speicher zu speichern.\nBitte führen Sie den folgenden Befehl aus:';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get errorLoadFileFromSourceTitle => 'Fehler beim öffnen der Datei.';

  @override
  String errorLoadFileFromSourceBody(Object source, Object error) {
    return '$source konnte nicht geöffnet werden.\n$error';
  }

  @override
  String get errorUnlockFileTitle => 'Datei kann nicht geöffnet werden';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Unbekannter Fehler beim Öffnen der Datei. $error';
  }

  @override
  String get dialogContinue => 'Weiter';

  @override
  String get dialogSendErrorReport => 'Fehlerbericht senden';

  @override
  String get dialogReportErrorForum => 'Fehler im Forum melden/Hilfe';

  @override
  String get groupFilterDescription =>
      'Wähle Gruppen die (rekursiv) angezeigt werden sollen';

  @override
  String get groupFilterSelectAll => 'Alles auswählen';

  @override
  String get groupFilterDeselectAll => 'Auswahl aufheben';

  @override
  String get createSubgroup => 'Untergruppe erstellen';

  @override
  String get editAction => 'Bearbeiten';

  @override
  String get mailboxEnableLabel => '(erneut) aktivieren';

  @override
  String get mailboxEnableHint => 'E-Mails weiterhin empfangen';

  @override
  String get mailboxDisableLabel => 'Deaktivieren';

  @override
  String get mailboxDisableHint => 'Keine weiteren E-Mails empfangen';

  @override
  String get mailListNoMail => 'Sie haben noch keine Emails erhalten.';

  @override
  String mailboxLabelPrefixForEntry(Object entryLabel) {
    return 'Eintrag: $entryLabel';
  }

  @override
  String mailboxLabelPrefixUnknownEntry(Object entryUuid) {
    return 'Unbekannter Eintrag: $entryUuid';
  }

  @override
  String mailboxLabelPrefixCreatedAt(Object dateTime) {
    return 'Erstellt am: $dateTime';
  }

  @override
  String get masterPasswordDescription =>
      'Das Master-Passwort wird verwendet, um Ihre Passwortdatenbank sicher zu verschlüsseln. Denken Sie daran, bei Verlust ihres Master-Passwort können ihre Daten nicht wiederhergestellt werden.';

  @override
  String get unsavedChangesWarningTitle => 'Nicht gespeicherte Änderungen';

  @override
  String get unsavedChangesWarningBody =>
      'Es gibt noch ungespeicherte Änderungen. Möchten Sie die Änderungen verwerfen?';

  @override
  String get unsavedChangesDiscardActionLabel => 'Änderungen verwerfen';

  @override
  String get deletePermanentlyAction => 'Dauerhaft löschen';

  @override
  String get restoreFromRecycleBinAction => 'Wiederherstellen';

  @override
  String get deleteAction => 'Löschen';

  @override
  String get deletedEntry => 'Eintrag gelöscht.';

  @override
  String get successfullyDeletedGroup => 'Gruppe gelöscht.';

  @override
  String get undoButtonLabel => 'Rückgängig';

  @override
  String get saveButtonLabel => 'Speichern';

  @override
  String get webDavSettings => 'WebDAV Einstellungen';

  @override
  String get webDavUrlLabel => 'URL';

  @override
  String get webDavUrlHelperText => 'Basis-URL zu Ihrem WebDAV-Service.';

  @override
  String get webDavUrlValidatorError => 'Bitte eine URL eingeben';

  @override
  String get webDavUrlValidatorInvalidUrlError =>
      'Bitte geben Sie eine gültige URL mit http:// oder https:// ein';

  @override
  String get webDavAuthUser => 'Benutzername';

  @override
  String get webDavAuthPassword => 'Passwort';

  @override
  String get mergeSuccessDialogTitle =>
      'Passwortdatenbank erfolgreich verbunden';

  @override
  String mergeSuccessDialogMessage(Object fileName, Object mergeSummary) {
    return 'Konflikt beim Speichern von $fileName erkannt, wurde erfolgreich mit der entfernten Datei verbunden: \n\n$mergeSummary';
  }

  @override
  String forDetailsVisitUrl(Object url) {
    return 'Für weitere Informationen besuchen Sie $url';
  }

  @override
  String get authPassCloudAuthEmailInputLabel =>
      'Geben Sie die E-Mail-Adresse ein, um sich zu registrieren oder anzumelden.';

  @override
  String get authPassCloudAuthEmailInvalid =>
      'Bitte geben sie ein gültige Email-Adresse an.';

  @override
  String get authPassCloudAuthConfirmEmailButtonLabel => 'Adresse Bestätigen';

  @override
  String get authPassCloudAuthConfirmEmail =>
      'Bitte überprüfen sie ihre Email-Adresse um diese zu bestätigen.';

  @override
  String get authPassCloudAuthConfirmEmailExplain =>
      'Bitte schließen Sie nicht diese Seite bevor Sie denn Link geöffnet haben den wir ihnen per Email geschickt haben.';

  @override
  String get authPassCloudAuthResendExplain =>
      'Falls sie noch keine Email von uns geschickt bekommen haben, dann kontrollieren Sie ihren Spam Ordner. Andernfalls können sie versuchen einen neuen Bestätigungslink anzufordern.';

  @override
  String get authPassCloudAuthResendButtonLabel =>
      'Einen neuen Bestätigungslink anfordern';

  @override
  String permanentlyDeleteEntryConfirm(Object title) {
    return 'Das führt zur permanenten Löschung des Passwordeintrag $title. Dies kann nicht Rückgänging gemacht werden. Wollen sie trotzdem fortfahren?';
  }

  @override
  String get permanentlyDeletedEntrySnackBar => 'Eintrag würde gelöscht.';

  @override
  String get initialNewGroupName => 'Neue Gruppe';

  @override
  String get deleteGroupErrorTitle => 'Gruppe kann nicht gelöscht werden';

  @override
  String get deleteGroupErrorBodyContainsGroup =>
      'Diese Gruppe enthält noch andere Gruppen. Sie können derzeit nur leere Gruppen löschen.';

  @override
  String get deleteGroupErrorBodyContainsEntries =>
      'Diese Gruppe enthält noch Passwort-Einträge. Sie können derzeit nur leere Gruppen löschen.';

  @override
  String get groupListAppBarTitle => 'Gruppen';

  @override
  String get groupListFilterAppbarTitle => 'Nach Gruppen filtern';

  @override
  String get clearQuickUnlock => 'Biometrischen Speicher löschen';

  @override
  String get clearQuickUnlockSubtitle =>
      'Lösche gespeicherte master Passwörter';

  @override
  String get unlock => 'Dateien entsperren';

  @override
  String get closePasswordFiles => 'schliesse Passwortdateien';

  @override
  String get clearQuickUnlockSuccess =>
      'Lösche gespeicherte master Passwörter vom biometrischen Speicher.';

  @override
  String get diacOptIn => 'In-App Neuigkeiten und Umfragen erhalten.';

  @override
  String get diacOptInSubtitle =>
      'Kann gelegentlich Internetanfragen um Neuigkeiten zu sammeln verursachen.';

  @override
  String get enableAutofillDebug => 'AutoFill: Debugging aktivieren';

  @override
  String get enableAutofillDebugSubtitle =>
      'Zeigt informationen für jedes Eingabefeld in einem overlay';

  @override
  String get createPasswordDatabase => 'Erstelle Passwort Datenbank';

  @override
  String get nameNewPasswordDatabase => 'Name der neuen Datenbank';

  @override
  String get validatorNameMissing =>
      'Bitte gib den namen der neuen Datenbank an';

  @override
  String get masterPasswordHelpText => 'Gib ein sicheres master Passwort an.';

  @override
  String get inputMasterPasswordText => 'Master Passwort';

  @override
  String get masterPasswordMissingCreate =>
      'Bitte gib ein sicheres Passwort an.';

  @override
  String get createDatabaseAction => 'Erstelle Datenbank';

  @override
  String get databaseExistsError => 'Datei exisiert bereits';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'Fehler beim versuch die Datenbank zu erstellen: $filePath. Die Datei exisitert bereits. Bitte wähle einen anderen Namen.';
  }

  @override
  String get databaseCreateDefaultName => 'PersönlichePasswörter';

  @override
  String get preferenceDynamicLoadIcons => 'Dynamisch Website icons laden';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'Macht abfragen auf $urlFieldName um Dynamisch Icons zu suchen.';
  }

  @override
  String passwordScore(Object score) {
    return 'Stärke: $score von 4';
  }

  @override
  String get entryInfoFile => 'Datei:';

  @override
  String get entryInfoGroup => 'Gruppe:';

  @override
  String get entryInfoLastModified => 'Letzte Änderung:';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'Eintrag verschoben nach $groupName';
  }

  @override
  String sizeBytesStoredAuthPassCloud(Object count) {
    return '$count Bytes, in der AuthPass Cloud gespeichert';
  }

  @override
  String sizeBytes(Object count) {
    return '$count Bytes';
  }

  @override
  String get entryAddAttachment => 'Anhang anfügen';

  @override
  String get entryAttachmentSizeWarning =>
      'Anhänge werden in der Passwort Datei gespeichert. Dies kann die Zeit zum öffnen der Passwörter stark erhöhen!';

  @override
  String get iconPngSizeWarning =>
      'Benutzerdefinierte Symbole werden in die Passwortdatei gespeichert. Dies kann die Zeit zum Öffnen und Speichern von Passwörtern erheblich erhöhen.';

  @override
  String get notPngError => 'Die gewählte Datei ist kein PNG.';

  @override
  String get entryAddField => 'Feld hinzufügen';

  @override
  String get entryCustomField => 'Benutzerdefiniertes Feld';

  @override
  String get entryCustomFieldTitle =>
      'Füge neues Benutzerdefiniertes Feld hinzu';

  @override
  String get entryCustomFieldInputLabel => 'Namen für Feld eingeben';

  @override
  String get swipeCopyField => 'Feld kopieren';

  @override
  String get fieldRename => 'Umbenennen';

  @override
  String get fieldGeneratePassword => 'Passwort generieren …';

  @override
  String get fieldProtect => 'Geschützter Wert';

  @override
  String get fieldUnprotect => 'Ungeschützter Wert';

  @override
  String get fieldPresent => 'Präsentieren';

  @override
  String get fieldGenerateEmail => 'Email generieren';

  @override
  String get onboardingBackToOnboarding => 'Führung';

  @override
  String get onboardingBackToOnboardingSubtitle => 'App tour neu erleben 😅️';

  @override
  String get onboardingHeadline => 'Lass uns deine Passwörter sicher machen!';

  @override
  String get onboardingQuestion =>
      'Hast du schon einen Passwort Manager benutzt?';

  @override
  String get onboardingYesOpenPasswords => 'Ja, öffne meine Passwörter';

  @override
  String get onboardingNoCreate => 'Ich bin neu. Lass uns loslegen!';

  @override
  String get backupButton => 'IN DER CLOUD SPEICHERN';

  @override
  String get dismissBackupButton => 'Schließen';

  @override
  String backupWarningMessage(Object databasename) {
    return 'Ihre Passwörter in $databasename sind nur lokal gespeichert!';
  }

  @override
  String get saveAs => 'Speichern in...';

  @override
  String get saving => 'Speichere';

  @override
  String get increaseValue => 'Vergrößern';

  @override
  String get decreaseValue => 'Verkleinern';

  @override
  String get resetValue => 'Zurücksetzen';

  @override
  String cloudStorageAppBarTitle(Object cloudStorageName) {
    return 'Cloud-Speicher - $cloudStorageName';
  }

  @override
  String get cloudStorageLogInCaption =>
      'Sie werden weitergeleitet, um AuthPass zu authentifizieren, um auf Ihre Daten zuzugreifen.';

  @override
  String get cloudStorageLogInCode => 'Code eingeben';

  @override
  String launchUrlError(Object url) {
    return 'Url kann nicht gestartet werden. Bitte besuchen Sie $url';
  }

  @override
  String cloudStorageLogInActionLabel(Object cloudStorageName) {
    return 'Anmelden bei $cloudStorageName';
  }

  @override
  String cloudStorageAuthCodeDialogTitle(Object cloudStorageName) {
    return '$cloudStorageName Authentifizierung';
  }

  @override
  String get cloudStorageAuthCodeLabel => 'Authentifizierungs-Code';

  @override
  String get cloudStorageAuthErrorTitle =>
      'Fehler während der Authentifizierung';

  @override
  String cloudStorageAuthErrorMessage(
      Object cloudStorageName, Object errorMessage) {
    return 'Fehler beim Versuch, sich bei $cloudStorageName zu authentifizieren: $errorMessage';
  }

  @override
  String get cloudStorageSearchBoxLabel => 'Suchanfrage';

  @override
  String cloudStorageItemsInFolder(Object itemCount) {
    return '$itemCount Einträge in diesem Ordner.';
  }

  @override
  String get mailSubject => 'Betreff';

  @override
  String get mailFrom => 'Von';

  @override
  String get mailDate => 'Datum';

  @override
  String get mailMailbox => 'Postfach';

  @override
  String get mailNoData => 'Keine Daten';

  @override
  String get mailMailboxesTitle => 'Postfächer';

  @override
  String get mailboxCreateButtonLabel => 'Erstellen';

  @override
  String get mailboxNameInputDialogTitle =>
      'Optionale Bezeichnung für neue Postfach';

  @override
  String get mailboxNameInputLabel => '(interne) Bezeichnung';

  @override
  String get mailScreenTitle => 'AuthPass E-Mail';

  @override
  String get mailTabBarTitleMailbox => 'Postfach';

  @override
  String get mailTabBarTitleMail => 'E-Mail';

  @override
  String get mailMailboxListEmpty => 'Sie haben noch keine Postfächer.';

  @override
  String mailMailboxAddressCopied(Object mailboxAddress) {
    return 'Mailbox-Adresse wurde in die Zwischenablage kopiert: $mailboxAddress';
  }

  @override
  String get errorWhileSavingTitle => 'Fehler beim Speichern';

  @override
  String errorWhileSavingBody(Object errorMessage) {
    return 'Datei konnte nicht gespeichert werden: $errorMessage';
  }

  @override
  String get databaseDoesNotSupportSaving =>
      'Entschuldigung, diese Datenbank unterstützt das Speichern nicht. Bitte öffnen Sie eine lokale Datenbankdatei. Oder verwenden Sie \"Speichern unter\".';

  @override
  String get otpInvalidKeyTitle => 'Ungültiger Schlüssel';

  @override
  String get otpInvalidKeyBody =>
      'Die angegebene Eingabe ist kein gültiger Base32 TOTP-Code. Bitte überprüfen Sie Ihre Eingabe.';

  @override
  String get otpUnsupportedMigrationTitle => 'Nicht unterstützt';

  @override
  String otpUnsupportedMigrationBody(Object uriCount) {
    return 'Momentan unterstützen wir nur Migration einzelner Tokens. Enthalten sind $uriCount';
  }

  @override
  String get otpPromptTitle => 'Zeitbasierte Authentifizierung';

  @override
  String get otpPromptHelperText =>
      'Bitte geben Sie einen zeitbasierten Schlüssel ein.';

  @override
  String otpErrorMessageGeneration(Object errorMessage) {
    return 'Fehler beim Generieren des Einladungscodes: $errorMessage';
  }

  @override
  String get otpCopySecretActionLabel => 'Geheimnis kopieren';

  @override
  String get otpEntryLabel => 'Einmal-Token';

  @override
  String get entryFieldProtected =>
      'Geschütztes Feld. Klicken, um zu enthüllen.';

  @override
  String get entryFieldActionRevealField => 'Geschütztes Feld anzeigen';

  @override
  String get entryAttachmentOpenActionLabel => 'Öffnen';

  @override
  String get entryAttachmentShareActionLabel => 'Teilen';

  @override
  String get entryAttachmentShareSubject => 'Anhang';

  @override
  String get entryAttachmentSaveActionLabel => 'Auf Gerät speichern';

  @override
  String get entryAttachmentRemoveActionLabel => 'Entfernen';

  @override
  String entryAttachmentRemoveConfirm(Object attachmentLabel) {
    return 'Wollen Sie $attachmentLabel wirklich löschen?';
  }

  @override
  String get entryRenameFieldPromptTitle => 'Feld umbenennen';

  @override
  String get removerecentfile => 'Verstecken';

  @override
  String get entryRenameFieldPromptLabel => 'Neuen Namen für das Feld eingeben';

  @override
  String get promptDialogPasteActionTooltip =>
      'Einfügen von der Zwischenablage';

  @override
  String get promptDialogPasteHint =>
      'Hinweis: Wenn sie etwas einfügen wollen, versuchen sie den Knopf zu ihrer linken ;-)';

  @override
  String get genericErrorDialogTitle => 'Fehler beim ausführen der Aktion';

  @override
  String genericErrorDialogBody(Object errorMessage) {
    return 'Es ist ein unerwarteter Fehler aufgetreten. $errorMessage';
  }

  @override
  String get saveAsEntryLocalFile => 'Speichern als Lokale Datei';

  @override
  String get fileTypePngs => 'Bilder (png)';

  @override
  String get selectIconDialogAction => 'WÄHLE ICON';

  @override
  String get retryDialogActionLabel => 'Erneut versuchen';

  @override
  String errorDuringNetworkCall(Object errorMessage) {
    return 'Fehler beim Api-Abfrage. $errorMessage';
  }

  @override
  String get passwordFilterHideDeleted => 'Gelöschte Einträge ausblenden';

  @override
  String get passwordFilterOnlyDeleted => 'Gelöschte Einträge';

  @override
  String passwordFilterPrefixForOneGroup(Object groupName) {
    return 'Gruppe: $groupName';
  }

  @override
  String passwordFilterPrefixForMultipleGroups(Object groupCount) {
    return 'Eigener Filter ($groupCount Gruppen)';
  }

  @override
  String get menuItemAuthPassCloudAuthenticate =>
      'Mit AuthPass Cloud authentifizieren';

  @override
  String get menuItemAuthPassCloudMailboxes => 'AuthPass Postfächer';

  @override
  String changesWithoutSaving(Object fileName) {
    return 'Sie haben Änderungen in \"$fileName\", die das Schreiben von Änderungen nicht unterstützen.';
  }

  @override
  String get changesSaveLocally => 'Lokal speichern';

  @override
  String get clearColor => 'Farbe löschen';

  @override
  String get databaseRenameInputLabel => 'Datenbank-Name eingeben';

  @override
  String get databasePath => 'Pfad';

  @override
  String get databaseColor => 'Farbe';

  @override
  String get databaseColorChoose =>
      'Wählen Sie eine Farbe um zwischen Dateien zu unterscheiden.';

  @override
  String get databaseKdbxVersion => 'KDBX Datei-Version';

  @override
  String databaseKdbxUpgradeVersion(Object versionName) {
    return 'Upgrade auf $versionName';
  }

  @override
  String get databaseKdbxUpgradeSuccessful =>
      'Datei erfolgreich aktualisiert und gespeichert.';

  @override
  String get databaseReload => 'Neuladen und Zusammenführen';

  @override
  String progressStatus(Object statusProgress) {
    return 'Status: $statusProgress';
  }

  @override
  String finishedMerge(Object status) {
    return 'Zusammenführung beendet $status';
  }

  @override
  String get closeAndLockFile => 'Schließen/Sperren';

  @override
  String get authPassHomeScreenTagline =>
      'password manager, open source, verfügbar auf allen Plattformen.';

  @override
  String get addNewPasswordButtonLabel => 'Neues Passwort hinzufügen';

  @override
  String get unnamedEntryPlaceholder => '(Unbenannt)';

  @override
  String get unnamedGroupPlaceholder => '(Unbenannt)';

  @override
  String get unnamedFilePlaceholder => '(Unbenannt)';

  @override
  String get editGroupScreenTitle => 'Gruppe bearbeiten';

  @override
  String get editGroupGroupNameLabel => 'Name der Gruppe';

  @override
  String get files => 'Dateien';

  @override
  String get newGroupDialogTitle => 'Neue Gruppe';

  @override
  String get newGroupDialogInputLabel => 'Name für die neue Gruppe';

  @override
  String get groupActionShowPasswords => 'Passwörter anzeigen';

  @override
  String get groupActionDelete => 'Löschen';

  @override
  String get logoutTooltip => 'Abmelden';

  @override
  String get successfullyDeletedFileCloudStorage =>
      'Datei erfolgreich gelöscht.';

  @override
  String shareDialogTitle(Object fileName) {
    return 'Freigabe-Optionen für $fileName';
  }

  @override
  String get shareFileActionLabel => 'Teilen …';

  @override
  String get shareTokenListEmptyScreenPlaceholder =>
      'Datei noch nicht freigegeben.';

  @override
  String get shareTokenNoLabel => 'Keine Beschriftung';

  @override
  String get shareTokenReadWrite => 'Lesen/Schreiben';

  @override
  String get shareTokenReadOnly => 'Nur Lesen';

  @override
  String get shareCreateTokenDialogTitle => 'Datei teilen';

  @override
  String get shareCreateTokenReadOnly => 'Nur lesen';

  @override
  String get shareCreateTokenReadOnlyHelpText =>
      'Speichern von Änderungen nicht zulassen';

  @override
  String get shareCreateTokenLabelText => 'Beschreibung';

  @override
  String get shareCreateTokenLabelHint => 'Für meinen Freund freigeben';

  @override
  String get shareCreateTokenLabelHelp =>
      'Optionales Label zur Differenzierung von Share Code.';

  @override
  String get shareCreateTokenSuccess => 'Freigabecode erfolgreich erstellt.';

  @override
  String get sharePresentDialogTitle =>
      'Datei mit geheimem Freigabecode teilen';

  @override
  String get sharePresentDialogHelp =>
      'Benutzer des folgenden Freigabecodes können auf die Passwortdatei zugreifen. Sie benötigen zum Öffnen das Passwort und/oder die Schlüsseldatei.';

  @override
  String get sharePresentToken => 'Code teilen';

  @override
  String get sharePresentCopied => 'Code wurde in die Zwischenablage kopiert.';

  @override
  String get authPassCloudOpenWithShareCodeTooltip => 'Mit Freigabecode öffnen';

  @override
  String get authPassCloudShareFileActionLabel => 'Teilen';

  @override
  String get preferenceAuthPassCloudAttachmentTitle =>
      'AuthPass Cloud-Anhänge verwenden';

  @override
  String get preferenceAuthPassCloudAttachmentSubtitle =>
      'Anhänge speichern, die in AuthPass Cloud separat verschlüsselt werden.';

  @override
  String get shareCodeInputDialogTitle => 'Geheime Freigabe-Code eingeben';

  @override
  String get shareCodeInputDialogScan => 'Scan QR Code';

  @override
  String get shareCodeInputLabel => 'Geheime Freigabe-Code';

  @override
  String get shareCodeInputHelperText =>
      'Wenn Sie einen Teilcode erhalten haben, fügen Sie ihn bitte oben ein.';

  @override
  String get shareCodeOpen => 'Freigabecode für AuthPass Cloud erhalten?';

  @override
  String get shareCodeOpenScreenTitle => 'Datei mit Freigabecode wird geladen';

  @override
  String get shareCodeLoadingProgress => 'Datei wird geladen …';

  @override
  String get shareCodeOpenFileButtonLabel => 'Öffnen';

  @override
  String get shareCodeOpenInstallAppCaption =>
      'Möchten Sie diese Datei stattdessen mit einer unserer nativen Apps öffnen?';

  @override
  String get shareCodeOpenAnotherAppCaption =>
      'Möchten Sie diese Datei auf einem anderen Gerät öffnen?';

  @override
  String get shareCodeOpenInstallAppButtonLabel => 'App installieren';

  @override
  String get shareCodeOpenShowCodeButtonLabel => 'Freigabecode anzeigen';

  @override
  String get changeMasterPasswordActionLabel => 'Master-Passwort ändern';

  @override
  String get changeMasterPasswordFormSubmit => 'Mit neuem Passwort speichern';

  @override
  String get changeMasterPasswordSuccess =>
      'Master-Passwort erfolgreich gespeichert.';

  @override
  String get changeMasterPasswordScreenTitle => 'Master-Passwort ändern';

  @override
  String get authPassCloudAuthClickedLink =>
      'Ich habe eine Email erhalten und klickte auf denn Link';

  @override
  String get authPassCloudAuthNotConfirmed =>
      'Die E-Mail-Adresse wurde noch nicht bestätigt. Bitte klicken Sie auf den Link in der erhaltenen E-Mail und lösen Sie das Captcha, um Ihre E-Mail-Adresse zu bestätigen.';

  @override
  String get getHelpButton => 'Erhalte Hilfe im Forum';

  @override
  String get shortcutCopyUsername => 'Benutzername kopieren';

  @override
  String get shortcutCopyPassword => 'Passwort kopieren';

  @override
  String get shortcutCopyTotp => 'TOTP kopieren';

  @override
  String get shortcutMoveUp => 'Vorheriges Passwort auswählen';

  @override
  String get shortcutMoveDown => 'Wählen Sie das nächste Passwort';

  @override
  String get shortcutGeneratePassword => 'Passwort generieren';

  @override
  String get shortcutCopyUrl => 'URL kopieren';

  @override
  String get shortcutOpenUrl => 'URL Öffnen';

  @override
  String get shortcutCancelSearch => 'Suche abbrechen';

  @override
  String get shortcutShortcutHelp => 'Hilfe zu dennTastenkombinationen';

  @override
  String get shortcutHelpTitle => 'Tastenkombinationen';

  @override
  String unexpectedError(String error) {
    return 'Unerwarteter Fehler: $error';
  }

  @override
  String get googleDriveMorePermissionsRequired =>
      'Additional permissions needed to access Google Drive.';

  @override
  String get googleDriveRequestPermissionButtonLabel => 'Request Permissions';

  @override
  String get scanQrCodeTitle => 'QR-Code Scannen.';
}
