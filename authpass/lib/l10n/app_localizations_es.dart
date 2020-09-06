// ignore_for_file: omit_local_variable_types,unused_local_variable
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get fieldUserName => 'User';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldWebsite => 'Website';

  @override
  String get fieldTitle => 'Title';

  @override
  String get fieldTotp => 'One Time Password (Time Based)';

  @override
  String get selectKeepassFile => 'AuthPass - Select KeePass File';

  @override
  String get quickUnlockingFiles => 'Quick unlocking files';

  @override
  String get selectKeepassFileLabel => 'Please select a KeePass (.kdbx) file.';

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
  String get createNewKeepass => 'New to KeePass?\nCreate New Password Database';

  @override
  String get labelLastOpenFiles => 'Last opened files:';

  @override
  String get noFilesHaveBeenOpenYet => 'No files have been opened yet.';

  @override
  String get preferenceSelectLanguage => 'Select Language';

  @override
  String get preferenceLanguage => 'Language';

  @override
  String get preferenceTextScaleFactor => 'Text Scale Factor';

  @override
  String get preferenceVisualDensity => 'Visual Density';

  @override
  String get preferenceTheme => 'Theme';

  @override
  String get preferenceThemeLight => 'Light';

  @override
  String get preferenceThemeDark => 'Dark';

  @override
  String get preferenceSystemDefault => 'System Default';

  @override
  String get preferenceDefault => 'Default';

  @override
  String get lockAllFiles => 'Lock all open files';

  @override
  String get preferenceAllowScreenshots => 'Allow Screenshots of the App';

  @override
  String get preferenceEnableAutoFill => 'Enable autofill';

  @override
  String get preferenceAutoFillDescription => 'Only supported on Android Oreo (8.0) or later.';

  @override
  String get preferenceTitle => 'Preferences';

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback => 'We welcome any kind of feedback!';

  @override
  String get aboutLinkVisitWebsite => 'Also make sure to visit our website';

  @override
  String get aboutLinkGitHub => 'And Open Source Project';

  @override
  String aboutLogFile(String logFilePath) {
    return 'Log File: ${logFilePath}';
  }

  @override
  String get menuItemGeneratePassword => 'Generate Password';

  @override
  String get menuItemPreferences => 'Preferences';

  @override
  String get menuItemOpenAnotherFile => 'Open another File';

  @override
  String get menuItemCheckForUpdates => 'Check for updates';

  @override
  String get menuItemSupport => 'Email Support';

  @override
  String get menuItemSupportSubtitle => 'Send logs by email/ask for help.';

  @override
  String get menuItemHelp => 'Help';

  @override
  String get menuItemHelpSubtitle => 'Show documentation';

  @override
  String get menuItemAbout => 'About';

  @override
  String get passwordPlainText => 'Reveal password';

  @override
  String get generatorPassword => 'Password';

  @override
  String get generatePassword => 'Generate Password';

  @override
  String get doneButtonLabel => 'Done';

  @override
  String get useAsDefault => 'Use as Default';

  @override
  String get characterSetLowerCase => 'Lowercase (a-z)';

  @override
  String get characterSetUpperCase => 'Uppercase (A-Z)';

  @override
  String get characterSetNumeric => 'Numeric (0-9)';

  @override
  String get characterSetUmlauts => 'Umlauts (ä)';

  @override
  String get characterSetSpecial => 'Special (@%+)';

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
  String get copiedToClipboard => 'Copied to clipboard.';

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
  String unexpectedError(String error) {
    return 'Unexpected Error: ${error}';
  }
}
