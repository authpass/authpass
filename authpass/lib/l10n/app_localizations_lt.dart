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
  String get fieldTotp => 'One Time Password (Time Based)';

  @override
  String get selectKeepassFile => '„AuthPass“ - Pasirinkti „KeePass“ failą';

  @override
  String get quickUnlockingFiles => 'Greitas failų atrakinimas';

  @override
  String get selectKeepassFileLabel => 'Prašome pasirinkti „KeePass“ (.kdbx) failą.';

  @override
  String get openLocalFile => 'Atidaryti\nVietinis failas';

  @override
  String get openFile => 'Open File';

  @override
  String loadFrom(String cloudStorageName) {
    return 'Iškelti iš ${cloudStorageName}';
  }

  @override
  String get loadFromUrl => 'Atsisiųsti iš URL';

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
      other: '${numFiles} files saved: ${files}',
    );
  }

  @override
  String get manageGroups => 'Manage Groups';

  @override
  String get lockFiles => 'Lock Files';

  @override
  String get searchHint => 'Search';

  @override
  String get clear => 'Clear';

  @override
  String get autofillFilterPrefix => 'Filter:';

  @override
  String get autofillPrompt => 'Select password entry for autofill.';

  @override
  String get copiedToClipboard => 'Nukopijuota į iškarpinę.';

  @override
  String get noTitle => '(no title)';

  @override
  String get noUsername => '(no username)';

  @override
  String get filterCustomize => 'Customize …';

  @override
  String get swipeCopyPassword => 'Copy Password';

  @override
  String get swipeCopyUsername => 'Copy Username';

  @override
  String get doneCopiedPassword => 'Copied password to clipboard.';

  @override
  String get doneCopiedUsername => 'Copied username to clipboard.';

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
  String get filePickerSubtitle => 'Open file from the device.';

  @override
  String get credentialsAppBarTitle => 'Credentials';

  @override
  String get credentialLabel => 'Enter the password for:';

  @override
  String get masterPasswordInputLabel => 'Password';

  @override
  String get masterPasswordEmptyValidator => 'Please enter your password.';

  @override
  String get masterPasswordIncorrectValidator => 'Invalid password';

  @override
  String get useKeyFile => 'Use Key File';

  @override
  String get saveMasterPasswordBiometric => 'Save Password with biometric key store?';

  @override
  String get errorUnlockFileTitle => 'Unable to open File';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Unknown error while trying to open file. ${error}';
  }

  @override
  String get dialogContinue => 'Continue';

  @override
  String get dialogSendErrorReport => 'Send Error Report/Help';

  @override
  String get groupFilterDescription => 'Select which Groups to show (recursively)';

  @override
  String get groupFilterSelectAll => 'Select all';

  @override
  String get groupFilterDeselectAll => 'Deselect all';

  @override
  String get createSubgroup => 'Create Subgroup';

  @override
  String get editAction => 'Edit';

  @override
  String get deleteAction => 'Delete';

  @override
  String get successfullyDeletedGroup => 'Deleted group.';

  @override
  String get undoButtonLabel => 'Undo';

  @override
  String get initialNewGroupName => 'New Group';

  @override
  String get deleteGroupErrorTitle => 'Unable to delete group';

  @override
  String get deleteGroupErrorBodyContainsGroup => 'This group still contains other groups. You can currently only delete empty groups.';

  @override
  String get deleteGroupErrorBodyContainsEntries => 'This group still contains password entries. You can currently only delete empty groups.';

  @override
  String get groupListAppBarTitle => 'Groups';

  @override
  String get groupListFilterAppbarTitle => 'Filter by groups';

  @override
  String unexpectedError(String error) {
    return 'Nenumatyta klaida: ${error}';
  }
}
