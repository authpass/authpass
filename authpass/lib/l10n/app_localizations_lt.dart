// Generated file, do not modify.
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
  String get copiedToClipboard => 'Nukopijuota į iškarpinę.';

  @override
  String unexpectedError(String error) {
    return 'Nenumatyta klaida: ${error}';
  }
}
