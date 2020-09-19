// ignore_for_file: omit_local_variable_types,unused_local_variable
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

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
  String get english => 'English';

  @override
  String get german => 'German';

  @override
  String get russian => 'Russian';

  @override
  String get ukrainian => 'Ukrainian';

  @override
  String get lithuanian => 'Lithuanian';

  @override
  String get french => 'French';

  @override
  String get spanish => 'Spanish';

  @override
  String get indonesian => 'Indonesian';

  @override
  String get selectKeepassFile => 'AuthPass - Wähle eine KeePass Datei';

  @override
  String get quickUnlockingFiles => 'Quick-Unlock Dateien';

  @override
  String get selectKeepassFileLabel => 'Bitte wähle eine KeePass (.kdbx) Datei.';

  @override
  String get createNewFile => 'Create New File';

  @override
  String get openLocalFile => 'Öffne\nLokale Datei';

  @override
  String get openFile => 'Datei öffnen';

  @override
  String loadFrom(String cloudStorageName) {
    return 'Lade von ${cloudStorageName}';
  }

  @override
  String get loadFromUrl => 'Lade von URL';

  @override
  String get loadFromRemoteUrl => 'Open kdbx from URL';

  @override
  String get createNewKeepass => 'KeePass noch nie verwendet?\nJetzt neue Passwort Datenbank erstellen';

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
  String get preferenceAutoFillDescription => 'Wird nur auf ab Android Oreo (8.0) unterstützt.';

  @override
  String get preferenceTitle => 'Einstellungen';

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
    return 'Log-Datei: ${logFilePath}';
  }

  @override
  String get unableToLaunchUrlTitle => 'Unable to open Url';

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
  String get menuItemGeneratePassword => 'Passwort generieren';

  @override
  String get menuItemPreferences => 'Einstellungen';

  @override
  String get menuItemOpenAnotherFile => 'Weitere Datei öffnen';

  @override
  String get menuItemCheckForUpdates => 'Nach Updates suchen';

  @override
  String get menuItemSupport => 'E-Mail Support';

  @override
  String get menuItemSupportSubtitle => 'Log-Datei per E-Mail versenden / Support kontaktieren.';

  @override
  String get menuItemHelp => 'Hilfe';

  @override
  String get menuItemHelpSubtitle => 'Dokumentation anzeigen';

  @override
  String get menuItemAbout => 'Über AuthPass';

  @override
  String get actionOpenUrl => 'Open URL';

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
    return 'Nur für > ${customMinLength} verwendet';
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
      other: '${numFiles} Dateien gespeichert: ${files}',
    );
  }

  @override
  String get manageGroups => 'Gruppen verwalten';

  @override
  String get lockFiles => 'Dateien sperren/schließen';

  @override
  String get searchHint => 'Suchen';

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
  String get doneCopiedPassword => 'Passwort in die Zwischenablage kopiert.';

  @override
  String get doneCopiedUsername => 'Benutzername in die Zwischenablage kopiert.';

  @override
  String get doneCopiedField => 'Copied.';

  @override
  String get emptyPasswordVaultPlaceholder => 'Du hast noch kein Passwort in deiner Datenbank.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Erstelle dein erstes Passwort';

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
  String get saveMasterPasswordBiometric => 'Passwort sicher speichern (mit biometrischen Schutz)?';

  @override
  String get errorOpenFileAlreadyOpenTitle => 'File already open';

  @override
  String errorOpenFileAlreadyOpenBody(Object databaseName, Object openFileSource, Object newFileSource) {
    return 'The selected database ${databaseName} is already open from ${openFileSource} (Tried to open from ${newFileSource})';
  }

  @override
  String get errorUnlockFileTitle => 'Datei kann nicht geöffnet werden';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Unbekannter Fehler beim Öffnen der Datei. ${error}';
  }

  @override
  String get dialogContinue => 'Weiter';

  @override
  String get dialogSendErrorReport => 'Fehlerbericht senden/Hilfe';

  @override
  String get groupFilterDescription => 'Wähle Gruppen die (rekursiv) angezeigt werden sollen';

  @override
  String get groupFilterSelectAll => 'Alles auswählen';

  @override
  String get groupFilterDeselectAll => 'Auswahl aufheben';

  @override
  String get createSubgroup => 'Untergruppe erstellen';

  @override
  String get editAction => 'Bearbeiten';

  @override
  String get deleteAction => 'Löschen';

  @override
  String get successfullyDeletedGroup => 'Gruppe gelöscht.';

  @override
  String get undoButtonLabel => 'Rückgängig';

  @override
  String get saveButtonLabel => 'Save';

  @override
  String get initialNewGroupName => 'Neue Gruppe';

  @override
  String get deleteGroupErrorTitle => 'Gruppe kann nicht gelöscht werden';

  @override
  String get deleteGroupErrorBodyContainsGroup => 'Diese Gruppe enthält noch andere Gruppen. Sie können derzeit nur leere Gruppen löschen.';

  @override
  String get deleteGroupErrorBodyContainsEntries => 'Diese Gruppe enthält noch Passwort-Einträge. Sie können derzeit nur leere Gruppen löschen.';

  @override
  String get groupListAppBarTitle => 'Gruppen';

  @override
  String get groupListFilterAppbarTitle => 'Nach Gruppen filtern';

  @override
  String get clearQuickUnlock => 'Clear Biometric Storage';

  @override
  String get clearQuickUnlockSubtitle => 'Remove saved master passwords';

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
  String get createDatabaseAction => 'Create Database';

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
  String get entryInfoFile => 'File:';

  @override
  String get entryInfoGroup => 'Group:';

  @override
  String get entryInfoLastModified => 'Last Modified:';

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
  String get fieldRename => 'Rename';

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
  String get onboardingBackToOnboardingSubtitle => 'Relive the first run experience 😅️';

  @override
  String get onboardingHeadline => 'Let\'s make your Passwords Secure!';

  @override
  String get onboardingQuestion => 'Have you used a password manager before?';

  @override
  String get onboardingYesOpenPasswords => 'Yes, open my passwords';

  @override
  String get onboardingNoCreate => 'I\'m all new! Get me started.';

  @override
  String unexpectedError(String error) {
    return 'Unerwarteter Fehler: ${error}';
  }
}
