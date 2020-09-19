// ignore_for_file: omit_local_variable_types,unused_local_variable
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

/// The translations for Lithuanian (`lt`).
class AppLocalizationsLt extends AppLocalizations {
  AppLocalizationsLt([String locale = 'lt']) : super(locale);

  @override
  String get fieldUserName => 'Naudotojas';

  @override
  String get fieldPassword => 'Slaptažodis';

  @override
  String get fieldWebsite => 'Svetainė';

  @override
  String get fieldTitle => 'Pavadinimas';

  @override
  String get fieldTotp => 'Vieno karto slaptažodis (atsižvelgiant į laiką)';

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
  String get selectKeepassFile => '„AuthPass“ - Pasirinkti „KeePass“ failą';

  @override
  String get quickUnlockingFiles => 'Greitas failų atrakinimas';

  @override
  String get selectKeepassFileLabel => 'Prašome pasirinkti „KeePass“ (.kdbx) failą.';

  @override
  String get createNewFile => 'Create New File';

  @override
  String get openLocalFile => 'Atidaryti\nVietinis failas';

  @override
  String get openFile => 'Atidaryti failą';

  @override
  String loadFrom(String cloudStorageName) {
    return 'Iškelti iš ${cloudStorageName}';
  }

  @override
  String get loadFromUrl => 'Atsisiųsti iš URL';

  @override
  String get loadFromRemoteUrl => 'Open kdbx from URL';

  @override
  String get createNewKeepass => 'Esate naujas „KeePass“ programoje?\nSukurti naują slaptažodžių duomenų bazę';

  @override
  String get labelLastOpenFiles => 'Paskiausiai atidaryti failai:';

  @override
  String get noFilesHaveBeenOpenYet => 'Jokie failai dar nebuvo atidaryti.';

  @override
  String get preferenceSelectLanguage => 'Pasirinkti kalbą';

  @override
  String get preferenceLanguage => 'Kalba';

  @override
  String get preferenceTextScaleFactor => 'Teksto dydžio faktorius';

  @override
  String get preferenceVisualDensity => 'Vizualinis tankis';

  @override
  String get preferenceTheme => 'Išvaizda';

  @override
  String get preferenceThemeLight => 'Šviesi';

  @override
  String get preferenceThemeDark => 'Tamsi';

  @override
  String get preferenceSystemDefault => 'Sistemos numatytoji';

  @override
  String get preferenceDefault => 'Numatytasis';

  @override
  String get lockAllFiles => 'Užrakinti visus atidarytus failus';

  @override
  String get preferenceAllowScreenshots => 'Leisti šios programėlės ekrano atvaizdus';

  @override
  String get preferenceEnableAutoFill => 'Įgalinti automatinį užpildymą';

  @override
  String get preferenceAutoFillDescription => 'Palaikoma tik „Android Oreo“ (8.0) sistemoje ar naujesnėje.';

  @override
  String get preferenceTitle => 'Nustatymai';

  @override
  String get aboutAppName => '„AuthPass“';

  @override
  String get aboutLinkFeedback => 'Mes laukiame bet kokių atsiliepimų!';

  @override
  String get aboutLinkVisitWebsite => 'Taip pat nepamirškite apsilankyti mūsų svetainėje';

  @override
  String get aboutLinkGitHub => 'Taip pat atvirojo kodo projekto';

  @override
  String aboutLogFile(String logFilePath) {
    return 'Log failas: ${logFilePath}';
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
  String get menuItemGeneratePassword => 'Generuoti slaptažodį';

  @override
  String get menuItemPreferences => 'Nustatymai';

  @override
  String get menuItemOpenAnotherFile => 'Atidaryti kitą failą';

  @override
  String get menuItemCheckForUpdates => 'Tikrinti, ar nėra atnaujinimų';

  @override
  String get menuItemSupport => 'Pagalba el. paštu';

  @override
  String get menuItemSupportSubtitle => 'Siųsti log failus/klausti pagalbos.';

  @override
  String get menuItemHelp => 'Pagalba';

  @override
  String get menuItemHelpSubtitle => 'Rodyti dokumentaciją';

  @override
  String get menuItemAbout => 'Apie';

  @override
  String get actionOpenUrl => 'Open URL';

  @override
  String get passwordPlainText => 'Rodyti slaptažodį';

  @override
  String get generatorPassword => 'Slaptažodis';

  @override
  String get generatePassword => 'Generuoti slaptažodį';

  @override
  String get doneButtonLabel => 'Gerai';

  @override
  String get useAsDefault => 'Naudoti kaip numatytajį';

  @override
  String get characterSetLowerCase => 'Mažųjų raidžių (a-z)';

  @override
  String get characterSetUpperCase => 'Didžiosios raidės (A-Z)';

  @override
  String get characterSetNumeric => 'Numeriai (0-9)';

  @override
  String get characterSetUmlauts => 'Umliautai (ä)';

  @override
  String get characterSetSpecial => 'Specialieji (@%+)';

  @override
  String get length => 'Ilgis';

  @override
  String get customLength => 'Pritaikytas pagal save ilgis';

  @override
  String customLengthHelperText(Object customMinLength) {
    return 'Naudojamas tik ilgiui > ${customMinLength}';
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
      other: '${numFiles} failai išsaugoti: ${files}',
    );
  }

  @override
  String get manageGroups => 'Tvarkyti grupes';

  @override
  String get lockFiles => 'Užrakinti failus';

  @override
  String get searchHint => 'Ieškoti';

  @override
  String get clear => 'Valyti';

  @override
  String get autofillFilterPrefix => 'Filtras:';

  @override
  String get autofillPrompt => 'Pasirinkite slaptažodžio įrašą automatiniam užpildymui.';

  @override
  String get copiedToClipboard => 'Nukopijuota į iškarpinę.';

  @override
  String get noTitle => '(nėra pavadinimo)';

  @override
  String get noUsername => '(nėra naudotojo vardo)';

  @override
  String get filterCustomize => 'Pritaikyti …';

  @override
  String get swipeCopyPassword => 'Kopijuoti slaptažodį';

  @override
  String get swipeCopyUsername => 'Kopijuoti naudotojo vardą';

  @override
  String get doneCopiedPassword => 'Nukopijuotas slaptažodis į iškarpinę.';

  @override
  String get doneCopiedUsername => 'Nukopijuotas naudotojo vardas į iškarpinę.';

  @override
  String get doneCopiedField => 'Copied.';

  @override
  String get emptyPasswordVaultPlaceholder => 'Jūs dar neturite jokio slaptažodžio duomenų bazėje.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Sukurkite savo pirmą slaptažodį';

  @override
  String get loadingFile => 'Atidaromas failas …';

  @override
  String get internalFile => 'Vidinis failas';

  @override
  String get internalFileSubtitle => 'Duomenų bazė prieš tai sukurta su „AuthPass“';

  @override
  String get filePicker => 'Failų parinkėjas';

  @override
  String get filePickerSubtitle => 'Atidaryti failą iš įrenginio.';

  @override
  String get credentialsAppBarTitle => 'Kredencialai';

  @override
  String get credentialLabel => 'Įveskite slaptažodį:';

  @override
  String get masterPasswordInputLabel => 'Slaptažodis';

  @override
  String get masterPasswordEmptyValidator => 'Prašome įvesti slaptažodį.';

  @override
  String get masterPasswordIncorrectValidator => 'Neteisingas slaptažodis';

  @override
  String get useKeyFile => 'Naudoti rakto failą';

  @override
  String get saveMasterPasswordBiometric => 'Išsaugoti slaptažodį su biometriniu raktu?';

  @override
  String get errorOpenFileAlreadyOpenTitle => 'File already open';

  @override
  String errorOpenFileAlreadyOpenBody(Object databaseName, Object openFileSource, Object newFileSource) {
    return 'The selected database ${databaseName} is already open from ${openFileSource} (Tried to open from ${newFileSource})';
  }

  @override
  String get errorUnlockFileTitle => 'Nepavyko atidaryti failo';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Nežinoma klaida bandant atidaryti failą. ${error}';
  }

  @override
  String get dialogContinue => 'Tęsti';

  @override
  String get dialogSendErrorReport => 'Siųsti klaidos ataskaitą/pagalba';

  @override
  String get groupFilterDescription => 'Pasirinkite kokias grupes rodyti (rekursyviai)';

  @override
  String get groupFilterSelectAll => 'Pasirinkti viską';

  @override
  String get groupFilterDeselectAll => 'Atžymėti viską';

  @override
  String get createSubgroup => 'Sukurti pogrupį';

  @override
  String get editAction => 'Redaguoti';

  @override
  String get deleteAction => 'Ištrinti';

  @override
  String get successfullyDeletedGroup => 'Grupė ištrinta.';

  @override
  String get undoButtonLabel => 'Anuliuoti';

  @override
  String get saveButtonLabel => 'Save';

  @override
  String get initialNewGroupName => 'Nauja grupė';

  @override
  String get deleteGroupErrorTitle => 'Nepavyko ištrinti grupės';

  @override
  String get deleteGroupErrorBodyContainsGroup => 'Ši grupė dar turi kitų grupių. Jūs galite ištrinti tik tuščias grupes.';

  @override
  String get deleteGroupErrorBodyContainsEntries => 'Ši grupė dar turi kitų slaptažodžių įrašų. Jūs galite ištrinti tik tuščias grupes.';

  @override
  String get groupListAppBarTitle => 'Grupės';

  @override
  String get groupListFilterAppbarTitle => 'Filtruoti pagal grupes';

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
    return 'Nenumatyta klaida: ${error}';
  }
}
