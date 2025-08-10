// ignore_for_file: omit_local_variable_types,unused_local_variable
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_si.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n-generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
    Locale('de'),
    Locale('es'),
    Locale('et'),
    Locale('fi'),
    Locale('fr'),
    Locale('he'),
    Locale('id'),
    Locale('it'),
    Locale('lt'),
    Locale('nl'),
    Locale('pa'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('si'),
    Locale('sk'),
    Locale('tr'),
    Locale('uk'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @fieldUserName.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get fieldUserName;

  /// No description provided for @fieldPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPassword;

  /// No description provided for @fieldWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get fieldWebsite;

  /// No description provided for @fieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fieldTitle;

  /// Label for fields of TOTP (Time based one time passwords)
  ///
  /// In en, this message translates to:
  /// **'One Time Password (Time Based)'**
  String get fieldTotp;

  /// language switcher subtitle
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// language switcher subtitle
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// language switcher subtitle
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// language switcher subtitle
  ///
  /// In en, this message translates to:
  /// **'Ukrainian'**
  String get ukrainian;

  /// language switcher subtitle
  ///
  /// In en, this message translates to:
  /// **'Lithuanian'**
  String get lithuanian;

  /// language switcher subtitle
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// language switcher subtitle
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// language switcher subtitle
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesian;

  /// Language switcher subtitle
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get turkish;

  /// Language switcher subtitle
  ///
  /// In en, this message translates to:
  /// **'Hebrew'**
  String get hebrew;

  /// Language switcher subtitle
  ///
  /// In en, this message translates to:
  /// **'italian'**
  String get italian;

  /// Language switcher subtitle
  ///
  /// In en, this message translates to:
  /// **'Chinese Simplified'**
  String get chineseSimplified;

  /// Language switcher subtitle
  ///
  /// In en, this message translates to:
  /// **'Chinese Traditional'**
  String get chineseTraditional;

  /// Language switcher subtitle
  ///
  /// In en, this message translates to:
  /// **'Portuguese, Brazilian'**
  String get portugueseBrazilian;

  /// Language switcher subtitle
  ///
  /// In en, this message translates to:
  /// **'Slovak'**
  String get slovak;

  /// Language switcher subtitle
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get dutch;

  /// semantic label for checkboxes to select item.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectItem;

  /// No description provided for @selectKeepassFile.
  ///
  /// In en, this message translates to:
  /// **'AuthPass - Select KeePass File'**
  String get selectKeepassFile;

  /// No description provided for @selectKeepassFileLabel.
  ///
  /// In en, this message translates to:
  /// **'Please select a KeePass (.kdbx) file.'**
  String get selectKeepassFileLabel;

  /// button on select file screen to create a new password database.
  ///
  /// In en, this message translates to:
  /// **'Create New File'**
  String get createNewFile;

  /// No description provided for @openLocalFile.
  ///
  /// In en, this message translates to:
  /// **'Open\nLocal File'**
  String get openLocalFile;

  /// Displayed as placeholder in password list when no file is open.
  ///
  /// In en, this message translates to:
  /// **'Open File'**
  String get openFile;

  /// label for dropdown menu which shows more cloud storage options.
  ///
  /// In en, this message translates to:
  /// **'Load from …'**
  String get loadFromDropdownMenu;

  /// Status shown while we are loading files and trying to unlock them.
  ///
  /// In en, this message translates to:
  /// **'Quick unlocking files …'**
  String get quickUnlockingFiles;

  /// Progress shown while files are loaded during quick unlock.
  ///
  /// In en, this message translates to:
  /// **'Opening {fileName} … ({current} / {totalCount})'**
  String openFileProgress(Object fileName, Object current, Object totalCount);

  /// No description provided for @loadFrom.
  ///
  /// In en, this message translates to:
  /// **'Load from {cloudStorageName}'**
  String loadFrom(String cloudStorageName);

  /// Overflow menu option to load KeePass file from URL.
  ///
  /// In en, this message translates to:
  /// **'Open kdbx from URL'**
  String get loadFromRemoteUrl;

  /// deprecated
  ///
  /// In en, this message translates to:
  /// **'New to KeePass?\nCreate New Password Database'**
  String get createNewKeepass;

  /// No description provided for @labelLastOpenFiles.
  ///
  /// In en, this message translates to:
  /// **'Last opened files:'**
  String get labelLastOpenFiles;

  /// No description provided for @noFilesHaveBeenOpenYet.
  ///
  /// In en, this message translates to:
  /// **'No files have been opened yet.'**
  String get noFilesHaveBeenOpenYet;

  /// No description provided for @preferenceSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get preferenceSelectLanguage;

  /// No description provided for @preferenceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get preferenceLanguage;

  /// No description provided for @preferenceTextScaleFactor.
  ///
  /// In en, this message translates to:
  /// **'Text Scale Factor'**
  String get preferenceTextScaleFactor;

  /// No description provided for @preferenceVisualDensity.
  ///
  /// In en, this message translates to:
  /// **'Visual Density'**
  String get preferenceVisualDensity;

  /// No description provided for @preferenceTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get preferenceTheme;

  /// No description provided for @preferenceThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get preferenceThemeLight;

  /// No description provided for @preferenceThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get preferenceThemeDark;

  /// No description provided for @preferenceSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get preferenceSystemDefault;

  /// No description provided for @preferenceDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get preferenceDefault;

  /// No description provided for @lockAllFiles.
  ///
  /// In en, this message translates to:
  /// **'Lock all open files'**
  String get lockAllFiles;

  /// No description provided for @preferenceAllowScreenshots.
  ///
  /// In en, this message translates to:
  /// **'Allow Screenshots of the App'**
  String get preferenceAllowScreenshots;

  /// No description provided for @preferenceEnableAutoFill.
  ///
  /// In en, this message translates to:
  /// **'Enable autofill'**
  String get preferenceEnableAutoFill;

  /// This text will shown as a banner on top of password list
  ///
  /// In en, this message translates to:
  /// **'You can you can fill field of other application by enabling autofill!'**
  String get enableAutofillSuggestionBanner;

  /// Button that is displayed in autofill suggestion warnings to dismiss the warning
  ///
  /// In en, this message translates to:
  /// **'DISMISS'**
  String get dismissAutofillSuggestionBannerButton;

  /// Button that is displayed in autofill suggestion warnings to enable autofill
  ///
  /// In en, this message translates to:
  /// **'ENABLE!'**
  String get enableAutofillSuggestionBannerButton;

  /// No description provided for @preferenceAutoFillDescription.
  ///
  /// In en, this message translates to:
  /// **'Only supported on Android Oreo (8.0) or later.'**
  String get preferenceAutoFillDescription;

  /// No description provided for @preferenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferenceTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Enable system wide shortcuts'**
  String get preferenceEnableSystemWideShortcuts;

  ///
  ///
  /// In en, this message translates to:
  /// **'Registers ctrl+alt+f as system wide shortcut to open search.'**
  String get preferenceEnableSystemWideShortcutsHelp;

  ///
  ///
  /// In en, this message translates to:
  /// **'Customize Search fields'**
  String get preferencesSearchFields;

  ///
  ///
  /// In en, this message translates to:
  /// **'Search fields'**
  String get preferencesSearchFieldPromptTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Comma separated list of fields to use in the password list search.'**
  String get preferencesSearchFieldPromptLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Use {wildCardCharacter} for all, leave empty for default ({defaultSearchFields})'**
  String preferencesSearchFieldPromptHelp(
      Object wildCardCharacter, Object defaultSearchFields);

  /// No description provided for @aboutAppName.
  ///
  /// In en, this message translates to:
  /// **'AuthPass'**
  String get aboutAppName;

  /// No description provided for @aboutLinkFeedback.
  ///
  /// In en, this message translates to:
  /// **'We welcome any kind of feedback!'**
  String get aboutLinkFeedback;

  /// No description provided for @aboutLinkVisitWebsite.
  ///
  /// In en, this message translates to:
  /// **'Also make sure to visit our website'**
  String get aboutLinkVisitWebsite;

  /// No description provided for @aboutLinkGitHub.
  ///
  /// In en, this message translates to:
  /// **'And Open Source Project'**
  String get aboutLinkGitHub;

  /// No description provided for @aboutLogFile.
  ///
  /// In en, this message translates to:
  /// **'Log File: {logFilePath}'**
  String aboutLogFile(String logFilePath);

  /// No description provided for @aboutLinkContributors.
  ///
  /// In en, this message translates to:
  /// **'Show Contributors'**
  String get aboutLinkContributors;

  ///
  ///
  /// In en, this message translates to:
  /// **'Unable to open Url'**
  String get unableToLaunchUrlTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Unable to launch {url}: {openError}'**
  String unableToLaunchUrlDescription(Object url, Object openError);

  ///
  ///
  /// In en, this message translates to:
  /// **'No application available for url.'**
  String get unableToLaunchUrlNoHandler;

  /// snackbar confirmation after opening a url externally
  ///
  /// In en, this message translates to:
  /// **'Opened URL: {url}'**
  String launchedUrl(Object url);

  /// No description provided for @menuItemGeneratePassword.
  ///
  /// In en, this message translates to:
  /// **'Generate Password'**
  String get menuItemGeneratePassword;

  /// No description provided for @menuItemPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get menuItemPreferences;

  /// No description provided for @menuItemOpenAnotherFile.
  ///
  /// In en, this message translates to:
  /// **'Open another File'**
  String get menuItemOpenAnotherFile;

  /// No description provided for @menuItemCheckForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get menuItemCheckForUpdates;

  /// No description provided for @menuItemSupport.
  ///
  /// In en, this message translates to:
  /// **'Send logs'**
  String get menuItemSupport;

  /// No description provided for @menuItemSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send logs by email'**
  String get menuItemSupportSubtitle;

  /// No description provided for @menuItemForum.
  ///
  /// In en, this message translates to:
  /// **'Support Forum'**
  String get menuItemForum;

  /// No description provided for @menuItemForumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Report Problems and get help'**
  String get menuItemForumSubtitle;

  /// No description provided for @menuItemHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get menuItemHelp;

  /// No description provided for @menuItemHelpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show documentation'**
  String get menuItemHelpSubtitle;

  /// No description provided for @menuItemAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get menuItemAbout;

  /// tooltip for button to open URL/Website of an entry.
  ///
  /// In en, this message translates to:
  /// **'Open URL'**
  String get actionOpenUrl;

  /// Master password input: show password as plain text during input. (shown as tooltip)
  ///
  /// In en, this message translates to:
  /// **'Reveal password'**
  String get passwordPlainText;

  /// Label for generated password
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get generatorPassword;

  /// screen title for password generator
  ///
  /// In en, this message translates to:
  /// **'Generate Password'**
  String get generatePassword;

  /// generic button label for 'Done' action.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButtonLabel;

  /// Button Label for Password generator settings: use as defaults
  ///
  /// In en, this message translates to:
  /// **'Use as Default'**
  String get useAsDefault;

  /// No description provided for @characterSetLowerCase.
  ///
  /// In en, this message translates to:
  /// **'Lowercase (a-z)'**
  String get characterSetLowerCase;

  /// No description provided for @characterSetUpperCase.
  ///
  /// In en, this message translates to:
  /// **'Uppercase (A-Z)'**
  String get characterSetUpperCase;

  /// No description provided for @characterSetNumeric.
  ///
  /// In en, this message translates to:
  /// **'Numeric (0-9)'**
  String get characterSetNumeric;

  /// No description provided for @characterSetUmlauts.
  ///
  /// In en, this message translates to:
  /// **'Umlauts (ä)'**
  String get characterSetUmlauts;

  /// No description provided for @characterSetSpecial.
  ///
  /// In en, this message translates to:
  /// **'Special (@%+)'**
  String get characterSetSpecial;

  /// Length of password
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get length;

  /// Label for custom length field
  ///
  /// In en, this message translates to:
  /// **'Custom Length'**
  String get customLength;

  /// Help text for custom length field
  ///
  /// In en, this message translates to:
  /// **'Only used for length > {customMinLength}'**
  String customLengthHelperText(Object customMinLength);

  /// Message displayed when files were saved. (One or more).
  ///
  /// In en, this message translates to:
  /// **'{numFiles, plural, =1 {One file saved: {files}} other {{numFiles} files saved: {files}}}'**
  String savedFiles(int numFiles, Object files);

  ///
  ///
  /// In en, this message translates to:
  /// **'Manage Groups'**
  String get manageGroups;

  /// Close all files and return to start screen.
  ///
  /// In en, this message translates to:
  /// **'Lock Files'**
  String get lockFiles;

  /// Placeholder in the password list search box
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchHint;

  /// search button tooltip/semantic label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchButtonLabel;

  /// tooltip/semantic label for filter app bar icon.
  ///
  /// In en, this message translates to:
  /// **'Filter by group'**
  String get filterButtonLabel;

  /// Remove existing group filter from password list
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Label displayed for android auto fill
  ///
  /// In en, this message translates to:
  /// **'Filter:'**
  String get autofillFilterPrefix;

  ///
  ///
  /// In en, this message translates to:
  /// **'Select password entry for autofill.'**
  String get autofillPrompt;

  /// Snackbar text when copying text to clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard.'**
  String get copiedToClipboard;

  /// Text to display in place of a title, when password entry has no name assigned.
  ///
  /// In en, this message translates to:
  /// **'(no title)'**
  String get noTitle;

  /// Text to display in place of a user name in the password list if none is defined.
  ///
  /// In en, this message translates to:
  /// **'(no username)'**
  String get noUsername;

  /// Customize filter in password list
  ///
  /// In en, this message translates to:
  /// **'Customize …'**
  String get filterCustomize;

  /// swipe action in password list to copy password
  ///
  /// In en, this message translates to:
  /// **'Copy Password'**
  String get swipeCopyPassword;

  /// swipe action in password list to copy username
  ///
  /// In en, this message translates to:
  /// **'Copy Username'**
  String get swipeCopyUsername;

  /// Error message when trying to copy username from an entry which has none.
  ///
  /// In en, this message translates to:
  /// **'Entry has no username defined.'**
  String get copyUsernameNotExists;

  /// Error message when trying to copy password from an entry which has none.
  ///
  /// In en, this message translates to:
  /// **'Entry has no password defined.'**
  String get copyPasswordNotExists;

  /// snackbar confirmation that password was copied.
  ///
  /// In en, this message translates to:
  /// **'Copied password to clipboard.'**
  String get doneCopiedPassword;

  /// snackbar confirmation that username was copied.
  ///
  /// In en, this message translates to:
  /// **'Copied username to clipboard.'**
  String get doneCopiedUsername;

  ///
  ///
  /// In en, this message translates to:
  /// **'Copied.'**
  String get doneCopiedField;

  ///
  ///
  /// In en, this message translates to:
  /// **'{fieldName} copied.'**
  String copiedFieldToClipboard(Object fieldName);

  /// Displayed when user wants to copy a field which is empty or not defined.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is empty.'**
  String copiedFieldEmpty(Object fieldName);

  /// Placeholder text shown when a user opens an empty password file.
  ///
  /// In en, this message translates to:
  /// **'You do not have any password in your database yet.'**
  String get emptyPasswordVaultPlaceholder;

  /// Button shown under placeholder text when password database is empty
  ///
  /// In en, this message translates to:
  /// **'Create your first Password'**
  String get emptyPasswordVaultButtonLabel;

  /// generic loading indicator displayed during network request (e.g. when loading file list from cloud storage)
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// credential screen while unlocking file.
  ///
  /// In en, this message translates to:
  /// **'Loading file …'**
  String get loadingFile;

  /// Choose a file previously created in AuthPass app sandbox
  ///
  /// In en, this message translates to:
  /// **'Internal file'**
  String get internalFile;

  /// Choose a file previously created in AuthPass app sandbox
  ///
  /// In en, this message translates to:
  /// **'Database previously created with AuthPass'**
  String get internalFileSubtitle;

  /// Choose a file with the system's file picker. (ios/android)
  ///
  /// In en, this message translates to:
  /// **'File Picker'**
  String get filePicker;

  /// Choose a file with the system's file picker. (ios/android)
  ///
  /// In en, this message translates to:
  /// **'Open file from the device.'**
  String get filePickerSubtitle;

  /// Credential screen to enter master password when opening kdbx file.
  ///
  /// In en, this message translates to:
  /// **'Credentials'**
  String get credentialsAppBarTitle;

  /// Label for the file/database being opened
  ///
  /// In en, this message translates to:
  /// **'Enter the password for:'**
  String get credentialLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get masterPasswordInputLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Please enter your password.'**
  String get masterPasswordEmptyValidator;

  ///
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get masterPasswordIncorrectValidator;

  /// label for a key file in combination with mater password
  ///
  /// In en, this message translates to:
  /// **'Use Key File'**
  String get useKeyFile;

  /// Label for the checkbox to save master password for quick unlock.
  ///
  /// In en, this message translates to:
  /// **'Save Password with biometric key store?'**
  String get saveMasterPasswordBiometric;

  /// Tooltip/semantic label for close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Tooltip for adding new password button (floating action button)
  ///
  /// In en, this message translates to:
  /// **'Add New Password'**
  String get addNewPassword;

  /// Title of error dialog when trying to open an invalid/unsupported file type
  ///
  /// In en, this message translates to:
  /// **'Tried to open invalid file type'**
  String get errorOpenFileInvalidFileStructureTitle;

  /// Body of error dialog when trying to open an invalid/unsupported file type
  ///
  /// In en, this message translates to:
  /// **'The file ({fileName}) does not appear to be a valid KDBX file. Please either choose a valid KDBX file or create a new password database.'**
  String errorOpenFileInvalidFileStructureBody(Object fileName);

  /// Trying to open a database from a second file source which is already open.
  ///
  /// In en, this message translates to:
  /// **'File already open'**
  String get errorOpenFileAlreadyOpenTitle;

  /// Trying to open a database from a second file source which is already open.
  ///
  /// In en, this message translates to:
  /// **'The selected database {databaseName} is already open from {openFileSource} (Tried to open from {newFileSource})'**
  String errorOpenFileAlreadyOpenBody(
      Object databaseName, Object openFileSource, Object newFileSource);

  ///
  ///
  /// In en, this message translates to:
  /// **'Download from Url'**
  String get loadFromUrl;

  /// label for input box to enter url.
  ///
  /// In en, this message translates to:
  /// **'Enter URL'**
  String get loadFromUrlEnterUrl;

  /// validator error message when user does not enter a absolute url.
  ///
  /// In en, this message translates to:
  /// **'Please enter full url starting with http:// or https://'**
  String get loadFromUrlErrorEnterFullUrl;

  /// validator error message hwen user enters a url which could not be parsed.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid url.'**
  String get loadFromUrlErrorInvalidUrl;

  /// On linux when user has not given AuthPass permission to connect to secret service he has to execute a command on the console.
  ///
  /// In en, this message translates to:
  /// **'AuthPass requires permission to communicate with Secret Service to store credentials for cloud storage.\nPlease run the following command:'**
  String get linuxAppArmorWarning;

  /// button label for cancelling an action.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// error title when user selects a file which can't be downloaded.
  ///
  /// In en, this message translates to:
  /// **'Error while opening file.'**
  String get errorLoadFileFromSourceTitle;

  /// error body when user selects a file which can't be downloaded.
  ///
  /// In en, this message translates to:
  /// **'Unable to open {source}.\n{error}'**
  String errorLoadFileFromSourceBody(Object source, Object error);

  /// generic error when opening a file (dialog title)
  ///
  /// In en, this message translates to:
  /// **'Unable to open File'**
  String get errorUnlockFileTitle;

  /// generic error when opening a file (description)
  ///
  /// In en, this message translates to:
  /// **'Unknown error while trying to open file. {error}'**
  String errorUnlockFileBody(Object error);

  /// Dialog action to continue to next step (e.g. credential screen when finished with master password)
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get dialogContinue;

  /// action button in error dialogs to send email to support with log file.
  ///
  /// In en, this message translates to:
  /// **'Send Error Report'**
  String get dialogSendErrorReport;

  /// action button in error dialog to open forum and create new topic.
  ///
  /// In en, this message translates to:
  /// **'Report Error in Forum/Help'**
  String get dialogReportErrorForum;

  /// Description shown in the group list for filtering (e.g. app drawer)
  ///
  /// In en, this message translates to:
  /// **'Select which Groups to show (recursively)'**
  String get groupFilterDescription;

  /// No description provided for @groupFilterSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get groupFilterSelectAll;

  /// No description provided for @groupFilterDeselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get groupFilterDeselectAll;

  /// menu action: create nested group inside another group
  ///
  /// In en, this message translates to:
  /// **'Create Subgroup'**
  String get createSubgroup;

  /// menu action: edit item (e.g. delete a group)
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  ///
  ///
  /// In en, this message translates to:
  /// **'(re)enable'**
  String get mailboxEnableLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Continue receiving emails'**
  String get mailboxEnableHint;

  ///
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get mailboxDisableLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Receive no more emails'**
  String get mailboxDisableHint;

  ///
  ///
  /// In en, this message translates to:
  /// **'You do not have any emails yet.'**
  String get mailListNoMail;

  /// when a mailbox was created for a (password) entry.
  ///
  /// In en, this message translates to:
  /// **'Entry: {entryLabel}'**
  String mailboxLabelPrefixForEntry(Object entryLabel);

  /// when a mailbox was created for password entry which has been deleted or is otherwise not in the currently opened password files.
  ///
  /// In en, this message translates to:
  /// **'Unknown Entry: {entryUuid}'**
  String mailboxLabelPrefixUnknownEntry(Object entryUuid);

  /// When a mailbox was not created for an entry and has no label, the creation date is shown.
  ///
  /// In en, this message translates to:
  /// **'Created at: {dateTime}'**
  String mailboxLabelPrefixCreatedAt(Object dateTime);

  ///
  ///
  /// In en, this message translates to:
  /// **'The master password is used to securely encrypt your password database. Make sure to remember it, it can not be restored.'**
  String get masterPasswordDescription;

  ///
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsavedChangesWarningTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'There are still unsaved changes. Do you want to discard changes?'**
  String get unsavedChangesWarningBody;

  ///
  ///
  /// In en, this message translates to:
  /// **'Discard Changes'**
  String get unsavedChangesDiscardActionLabel;

  /// menu action: delete an item permanently from the file (only shown for entries/groups already in the recycle bin.
  ///
  /// In en, this message translates to:
  /// **'Delete Permanently'**
  String get deletePermanentlyAction;

  /// menu action: restore an entry/group which was moved into the recycle bin.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreFromRecycleBinAction;

  /// menu action: delete item (e.g. delete a group)
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// Confirmation when a password entry was deleted (ie. moved to recycle bin)
  ///
  /// In en, this message translates to:
  /// **'Deleted entry.'**
  String get deletedEntry;

  /// snackbar after deleting a group.
  ///
  /// In en, this message translates to:
  /// **'Deleted group.'**
  String get successfullyDeletedGroup;

  /// undo action label (e.g. in a snackbar after deleting a group, or some other action)
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undoButtonLabel;

  /// save file, for example button displayed in entry details
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButtonLabel;

  /// dialog title for entering WebDAV settings.
  ///
  /// In en, this message translates to:
  /// **'WebDAV Settings'**
  String get webDavSettings;

  ///
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get webDavUrlLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Base Url to your WebDAV service.'**
  String get webDavUrlHelperText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Please enter a URL'**
  String get webDavUrlValidatorError;

  ///
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid url with http:// or https://'**
  String get webDavUrlValidatorInvalidUrlError;

  ///
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get webDavAuthUser;

  ///
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get webDavAuthPassword;

  ///
  ///
  /// In en, this message translates to:
  /// **'Successfully merged password database'**
  String get mergeSuccessDialogTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Conflict detected while saving {fileName}, it was merged successfully with the remote file: \n\n{mergeSummary}'**
  String mergeSuccessDialogMessage(Object fileName, Object mergeSummary);

  ///
  ///
  /// In en, this message translates to:
  /// **'For details visit {url}'**
  String forDetailsVisitUrl(Object url);

  ///
  ///
  /// In en, this message translates to:
  /// **'Enter email address to register or sign in.'**
  String get authPassCloudAuthEmailInputLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get authPassCloudAuthEmailInvalid;

  ///
  ///
  /// In en, this message translates to:
  /// **'Confirm Address'**
  String get authPassCloudAuthConfirmEmailButtonLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Please check your emails to confirm your email address.'**
  String get authPassCloudAuthConfirmEmail;

  ///
  ///
  /// In en, this message translates to:
  /// **'Keep this screen open until you visited the link you received by email.'**
  String get authPassCloudAuthConfirmEmailExplain;

  ///
  ///
  /// In en, this message translates to:
  /// **'If you have not received an email, please check your spam folder. Otherwise you can try to request a new confirmation link.'**
  String get authPassCloudAuthResendExplain;

  ///
  ///
  /// In en, this message translates to:
  /// **'Request a new confirmation link'**
  String get authPassCloudAuthResendButtonLabel;

  /// shown to force user to acknowledge delete before a entry will be permanently deleted.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete the password entry {title}. This can not be undone. Do you want to continue?'**
  String permanentlyDeleteEntryConfirm(Object title);

  /// snackbar confirming that the entry was deleted.
  ///
  /// In en, this message translates to:
  /// **'Permanently deleted entry.'**
  String get permanentlyDeletedEntrySnackBar;

  /// initial name of groups when user creates a new one.
  ///
  /// In en, this message translates to:
  /// **'New Group'**
  String get initialNewGroupName;

  /// Title of error dialog when group could not be deleted.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete group'**
  String get deleteGroupErrorTitle;

  /// Body of error dialog when a group can't be deleted because it is not empty.
  ///
  /// In en, this message translates to:
  /// **'This group still contains other groups. You can currently only delete empty groups.'**
  String get deleteGroupErrorBodyContainsGroup;

  /// Body of error dialog when a group can't be deleted because it is not empty.
  ///
  /// In en, this message translates to:
  /// **'This group still contains password entries. You can currently only delete empty groups.'**
  String get deleteGroupErrorBodyContainsEntries;

  /// title in the app bar for the groups list
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groupListAppBarTitle;

  /// title in the app bar for group lists when displayed for filtering password list
  ///
  /// In en, this message translates to:
  /// **'Filter by groups'**
  String get groupListFilterAppbarTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Clear Biometric Storage'**
  String get clearQuickUnlock;

  ///
  ///
  /// In en, this message translates to:
  /// **'Remove saved master passwords'**
  String get clearQuickUnlockSubtitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Unlock Files'**
  String get unlock;

  /// delete quick unlock (passwords stored in biometric storage)
  ///
  /// In en, this message translates to:
  /// **'close password files'**
  String get closePasswordFiles;

  ///
  ///
  /// In en, this message translates to:
  /// **'Removed saved master passwords from biometric storage.'**
  String get clearQuickUnlockSuccess;

  /// No description provided for @diacOptIn.
  ///
  /// In en, this message translates to:
  /// **'Opt in to In-App News, Surveys.'**
  String get diacOptIn;

  /// No description provided for @diacOptInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Will occasionally send a network request to fetch news.'**
  String get diacOptInSubtitle;

  /// only visible in debug build. Preference to enable Auto-Fill Debugging.
  ///
  /// In en, this message translates to:
  /// **'AutoFill: Enable debug'**
  String get enableAutofillDebug;

  /// only visible in debug build. Preference to enable Auto-Fill Debugging.
  ///
  /// In en, this message translates to:
  /// **'Shows information overlays for every input field'**
  String get enableAutofillDebugSubtitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Create Password Database'**
  String get createPasswordDatabase;

  /// creating new kdbx file, prompt
  ///
  /// In en, this message translates to:
  /// **'Name of your new Database'**
  String get nameNewPasswordDatabase;

  /// Error message when no password database name is given.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name for your new database.'**
  String get validatorNameMissing;

  /// DEPRECATED FOR NOW help text for master password when creating new password database
  ///
  /// In en, this message translates to:
  /// **'Select a secure master Password. Make sure to remember it.'**
  String get masterPasswordHelpText;

  /// Creating new file: input field for master password
  ///
  /// In en, this message translates to:
  /// **'Master Password'**
  String get inputMasterPasswordText;

  /// Text displayed when master password is empty while creating new password database
  ///
  /// In en, this message translates to:
  /// **'Please enter a secure, rememberable password.'**
  String get masterPasswordMissingCreate;

  /// Label for button to create new database
  ///
  /// In en, this message translates to:
  /// **'Create Database'**
  String get createDatabaseAction;

  /// dialog title for error message when creating a new database with a name which already exists.
  ///
  /// In en, this message translates to:
  /// **'File Exists'**
  String get databaseExistsError;

  /// dialog body for error message when creating a new database with a name which already exists.
  ///
  /// In en, this message translates to:
  /// **'Error while trying to create database {filePath}. File already exists. Please choose another name.'**
  String databaseExistsErrorDescription(Object filePath);

  /// Default database name when creating a new database file. (WITHOUT .kdbx extension)
  ///
  /// In en, this message translates to:
  /// **'PersonalPasswords'**
  String get databaseCreateDefaultName;

  /// preferences: dynamically load website icons
  ///
  /// In en, this message translates to:
  /// **'Dynamically load Icons'**
  String get preferenceDynamicLoadIcons;

  /// preferences: dynamically load website icons help text.
  ///
  /// In en, this message translates to:
  /// **'Will make http requests with the value in {urlFieldName} field to load website icons.'**
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName);

  /// choosing a master password - calculated password strength.
  ///
  /// In en, this message translates to:
  /// **'Strength: {score} of 4'**
  String passwordScore(Object score);

  ///
  ///
  /// In en, this message translates to:
  /// **'File:'**
  String get entryInfoFile;

  ///
  ///
  /// In en, this message translates to:
  /// **'Group:'**
  String get entryInfoGroup;

  ///
  ///
  /// In en, this message translates to:
  /// **'Last Modified:'**
  String get entryInfoLastModified;

  ///
  ///
  /// In en, this message translates to:
  /// **'Moved entry into {groupName}'**
  String movedEntryToGroup(Object groupName);

  ///
  ///
  /// In en, this message translates to:
  /// **'{count} bytes, stored on AuthPass Cloud'**
  String sizeBytesStoredAuthPassCloud(Object count);

  ///
  ///
  /// In en, this message translates to:
  /// **'{count} bytes'**
  String sizeBytes(Object count);

  ///
  ///
  /// In en, this message translates to:
  /// **'Add Attachment'**
  String get entryAddAttachment;

  ///
  ///
  /// In en, this message translates to:
  /// **'Attached files will be embedded in password file. This can significantly increase time required to open/save passwords.'**
  String get entryAttachmentSizeWarning;

  /// Warning shown when user selects a large png file as custom icon.
  ///
  /// In en, this message translates to:
  /// **'Custom icons will be embedded in password file. This can significantly increase time required to open/save passwords.'**
  String get iconPngSizeWarning;

  /// Error when user selects an unsupported file as custom icon.
  ///
  /// In en, this message translates to:
  /// **'Chosen file is not a PNG.'**
  String get notPngError;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add Field'**
  String get entryAddField;

  ///
  ///
  /// In en, this message translates to:
  /// **'Custom Field'**
  String get entryCustomField;

  ///
  ///
  /// In en, this message translates to:
  /// **'Adding new custom Field'**
  String get entryCustomFieldTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Enter a name for the field'**
  String get entryCustomFieldInputLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Copy Field'**
  String get swipeCopyField;

  ///
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get fieldRename;

  ///
  ///
  /// In en, this message translates to:
  /// **'Generate Password …'**
  String get fieldGeneratePassword;

  ///
  ///
  /// In en, this message translates to:
  /// **'Protect Value'**
  String get fieldProtect;

  ///
  ///
  /// In en, this message translates to:
  /// **'Unprotect Value'**
  String get fieldUnprotect;

  ///
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get fieldPresent;

  ///
  ///
  /// In en, this message translates to:
  /// **'Generate Email'**
  String get fieldGenerateEmail;

  /// Context menu entry which reverts to onboarding
  ///
  /// In en, this message translates to:
  /// **'Tour'**
  String get onboardingBackToOnboarding;

  /// Context menu entry which reverts to onboarding
  ///
  /// In en, this message translates to:
  /// **'Relive the first run experience 😅️'**
  String get onboardingBackToOnboardingSubtitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Let\'s make your Passwords Secure!'**
  String get onboardingHeadline;

  ///
  ///
  /// In en, this message translates to:
  /// **'Have you used a password manager before?'**
  String get onboardingQuestion;

  ///
  ///
  /// In en, this message translates to:
  /// **'Yes, open my passwords'**
  String get onboardingYesOpenPasswords;

  ///
  ///
  /// In en, this message translates to:
  /// **'I\'m all new! Get me started.'**
  String get onboardingNoCreate;

  /// Button that is displayed in backup warnings
  ///
  /// In en, this message translates to:
  /// **'SAVE TO CLOUD'**
  String get backupButton;

  /// Button that is displayed in backup warnings to dismiss the warning
  ///
  /// In en, this message translates to:
  /// **'DISMISS'**
  String get dismissBackupButton;

  /// Warning message that is displayed in backup warnings
  ///
  /// In en, this message translates to:
  /// **'Your passwords in {databasename} are only saved locally!'**
  String backupWarningMessage(Object databasename);

  /// Save as text
  ///
  /// In en, this message translates to:
  /// **'Save In...'**
  String get saveAs;

  /// Saving text
  ///
  /// In en, this message translates to:
  /// **'Saving'**
  String get saving;

  /// Preferences value modifier (Text Scale Factor/Visual Density)
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get increaseValue;

  /// Preferences value modifier (Text Scale Factor/Visual Density)
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get decreaseValue;

  /// Preferences value modifier (Text Scale Factor/Visual Density)
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetValue;

  /// app bar title for opening/saving to cloud storage.
  ///
  /// In en, this message translates to:
  /// **'CloudStorage - {cloudStorageName}'**
  String cloudStorageAppBarTitle(Object cloudStorageName);

  ///
  ///
  /// In en, this message translates to:
  /// **'You will be redirected to authenticate AuthPass to access your data.'**
  String get cloudStorageLogInCaption;

  /// for oauth authentication user has to enter auth code - this is the label for the text field.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get cloudStorageLogInCode;

  ///
  ///
  /// In en, this message translates to:
  /// **'Unable to launch url. Please visit {url}'**
  String launchUrlError(Object url);

  /// when the user has not authenticated yet, he will see this button to start the login flow of a cloud storage backend.
  ///
  /// In en, this message translates to:
  /// **'Login to {cloudStorageName}'**
  String cloudStorageLogInActionLabel(Object cloudStorageName);

  ///
  ///
  /// In en, this message translates to:
  /// **'{cloudStorageName} Authentication'**
  String cloudStorageAuthCodeDialogTitle(Object cloudStorageName);

  ///
  ///
  /// In en, this message translates to:
  /// **'Authentication Code'**
  String get cloudStorageAuthCodeLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Error while authenticating'**
  String get cloudStorageAuthErrorTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Error while trying to authenticate to {cloudStorageName}: {errorMessage}'**
  String cloudStorageAuthErrorMessage(
      Object cloudStorageName, Object errorMessage);

  ///
  ///
  /// In en, this message translates to:
  /// **'Search Query'**
  String get cloudStorageSearchBoxLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'{itemCount} items in this folder.'**
  String cloudStorageItemsInFolder(Object itemCount);

  ///
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get mailSubject;

  ///
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get mailFrom;

  ///
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get mailDate;

  ///
  ///
  /// In en, this message translates to:
  /// **'Mailbox'**
  String get mailMailbox;

  /// Message shown when email text body is empty (or can't be decoded)
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get mailNoData;

  /// Title of the screen showing all available mailboxes.
  ///
  /// In en, this message translates to:
  /// **'Mailboxes'**
  String get mailMailboxesTitle;

  /// FAB label to create a new mailbox.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get mailboxCreateButtonLabel;

  /// title of the dialog asking for a mailbox label/name
  ///
  /// In en, this message translates to:
  /// **'Optionally label for new mailbox'**
  String get mailboxNameInputDialogTitle;

  /// Label for the text field asking for a label for a mailbox, while creating it.
  ///
  /// In en, this message translates to:
  /// **'(Internal) Label'**
  String get mailboxNameInputLabel;

  /// title for the screen showing available emails
  ///
  /// In en, this message translates to:
  /// **'AuthPass Mail'**
  String get mailScreenTitle;

  /// title for the tab showing list of mailboxes.
  ///
  /// In en, this message translates to:
  /// **'Mailbox'**
  String get mailTabBarTitleMailbox;

  /// title for the tab showing list of mails.
  ///
  /// In en, this message translates to:
  /// **'Mail'**
  String get mailTabBarTitleMail;

  ///
  ///
  /// In en, this message translates to:
  /// **'You do not have any mailboxes yet.'**
  String get mailMailboxListEmpty;

  /// Success message when mailbox email address was copied to clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied mailbox address to clipboard: {mailboxAddress}'**
  String mailMailboxAddressCopied(Object mailboxAddress);

  /// title for error dialog shown when an error occurs while saving
  ///
  /// In en, this message translates to:
  /// **'Error while saving'**
  String get errorWhileSavingTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Unable to save file: {errorMessage}'**
  String errorWhileSavingBody(Object errorMessage);

  /// keepass files loaded through a URL can't be saved.
  ///
  /// In en, this message translates to:
  /// **'Sorry this database does not support saving. Please open a local database file. Or use \"Save As\".'**
  String get databaseDoesNotSupportSaving;

  /// dialog title for an invalid key of a one time password (OTP/TOTP)
  ///
  /// In en, this message translates to:
  /// **'Invalid Key'**
  String get otpInvalidKeyTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Given input is not a valid base32 TOTP code. Please verify your input.'**
  String get otpInvalidKeyBody;

  /// No description provided for @otpUnsupportedMigrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsupported OTP Migration'**
  String get otpUnsupportedMigrationTitle;

  /// No description provided for @otpUnsupportedMigrationBody.
  ///
  /// In en, this message translates to:
  /// **'We currently only support single item migrations. Got {uriCount}'**
  String otpUnsupportedMigrationBody(Object uriCount);

  ///
  ///
  /// In en, this message translates to:
  /// **'Time Based Authentication'**
  String get otpPromptTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Please enter time based key.'**
  String get otpPromptHelperText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Error generating invite code: {errorMessage}'**
  String otpErrorMessageGeneration(Object errorMessage);

  ///
  ///
  /// In en, this message translates to:
  /// **'Copy Secret'**
  String get otpCopySecretActionLabel;

  /// The label for entries which show a one time token for a TOTP
  ///
  /// In en, this message translates to:
  /// **'One Time Token'**
  String get otpEntryLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Protected field. Click to reveal.'**
  String get entryFieldProtected;

  ///
  ///
  /// In en, this message translates to:
  /// **'Show protected field'**
  String get entryFieldActionRevealField;

  ///
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get entryAttachmentOpenActionLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get entryAttachmentShareActionLabel;

  /// the 'subject' passed to the system when sharing an attachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get entryAttachmentShareSubject;

  ///
  ///
  /// In en, this message translates to:
  /// **'Save to device'**
  String get entryAttachmentSaveActionLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get entryAttachmentRemoveActionLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete {attachmentLabel}?'**
  String entryAttachmentRemoveConfirm(Object attachmentLabel);

  ///
  ///
  /// In en, this message translates to:
  /// **'Renaming field'**
  String get entryRenameFieldPromptTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get removerecentfile;

  ///
  ///
  /// In en, this message translates to:
  /// **'Enter the new name for the field'**
  String get entryRenameFieldPromptLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Paste from Clipboard'**
  String get promptDialogPasteActionTooltip;

  /// sometimes the paste shortcut is not working properly, so tell users they can use the paste button from the UI
  ///
  /// In en, this message translates to:
  /// **'Hint: If you need to paste, try the button to the left ;-)'**
  String get promptDialogPasteHint;

  ///
  ///
  /// In en, this message translates to:
  /// **'Error while handling action'**
  String get genericErrorDialogTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Encountered an unexpected error. {errorMessage}'**
  String genericErrorDialogBody(Object errorMessage);

  /// menu entry in the 'save as' dialog for saving as local file.
  ///
  /// In en, this message translates to:
  /// **'Local File'**
  String get saveAsEntryLocalFile;

  /// When selecting custom icons, users can choose a png image. This is the name of the 'file group'
  ///
  /// In en, this message translates to:
  /// **'Images (png)'**
  String get fileTypePngs;

  ///
  ///
  /// In en, this message translates to:
  /// **'SELECT ICON'**
  String get selectIconDialogAction;

  ///
  ///
  /// In en, this message translates to:
  /// **'RETRY'**
  String get retryDialogActionLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Error during api call. {errorMessage}'**
  String errorDuringNetworkCall(Object errorMessage);

  /// filter name to show only password entries which are not deleted
  ///
  /// In en, this message translates to:
  /// **'Hide Deleted Entries'**
  String get passwordFilterHideDeleted;

  /// filter name to show only deleted password entries
  ///
  /// In en, this message translates to:
  /// **'Deleted Entries'**
  String get passwordFilterOnlyDeleted;

  /// The label for a password filter for one specific group
  ///
  /// In en, this message translates to:
  /// **'Group: {groupName}'**
  String passwordFilterPrefixForOneGroup(Object groupName);

  /// The label for a password filter for multiple groups
  ///
  /// In en, this message translates to:
  /// **'Custom Filter ({groupCount} Groups)'**
  String passwordFilterPrefixForMultipleGroups(Object groupCount);

  /// menu entry in password list to allow users to authenticate with AuthPass Cloud
  ///
  /// In en, this message translates to:
  /// **'Authenticate with AuthPass Cloud'**
  String get menuItemAuthPassCloudAuthenticate;

  ///
  ///
  /// In en, this message translates to:
  /// **'AuthPass Mailboxes'**
  String get menuItemAuthPassCloudMailboxes;

  ///
  ///
  /// In en, this message translates to:
  /// **'You have changes in \"{fileName}\", which does not support writing of changes.'**
  String changesWithoutSaving(Object fileName);

  ///
  ///
  /// In en, this message translates to:
  /// **'Save locally'**
  String get changesSaveLocally;

  /// Action to remove a selected color and reset to default.
  ///
  /// In en, this message translates to:
  /// **'Clear Color'**
  String get clearColor;

  ///
  ///
  /// In en, this message translates to:
  /// **'Enter database name'**
  String get databaseRenameInputLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get databasePath;

  ///
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get databaseColor;

  ///
  ///
  /// In en, this message translates to:
  /// **'Select a color to distinguish between files.'**
  String get databaseColorChoose;

  ///
  ///
  /// In en, this message translates to:
  /// **'KDBX File Version'**
  String get databaseKdbxVersion;

  ///
  ///
  /// In en, this message translates to:
  /// **'Upgrade to {versionName}'**
  String databaseKdbxUpgradeVersion(Object versionName);

  ///
  ///
  /// In en, this message translates to:
  /// **'Successfully upgraded file and saved.'**
  String get databaseKdbxUpgradeSuccessful;

  ///
  ///
  /// In en, this message translates to:
  /// **'Reload and Merge'**
  String get databaseReload;

  /// While an action is running this is displayed as status message. Don't worry too much, users should typically not see this for too long (if at all)
  ///
  /// In en, this message translates to:
  /// **'Status: {statusProgress}'**
  String progressStatus(Object statusProgress);

  ///
  ///
  /// In en, this message translates to:
  /// **'Finished Merge {status}'**
  String finishedMerge(Object status);

  ///
  ///
  /// In en, this message translates to:
  /// **'Close/Lock'**
  String get closeAndLockFile;

  ///
  ///
  /// In en, this message translates to:
  /// **'password manager, open source, available on all platforms.'**
  String get authPassHomeScreenTagline;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add new Password'**
  String get addNewPasswordButtonLabel;

  /// displayed instead of entry label, if entry has no name or it is blank.
  ///
  /// In en, this message translates to:
  /// **'(Unnamed)'**
  String get unnamedEntryPlaceholder;

  /// displayed instead of a groups name, it is unnamed or it's name is empty
  ///
  /// In en, this message translates to:
  /// **'(Unnamed)'**
  String get unnamedGroupPlaceholder;

  ///
  ///
  /// In en, this message translates to:
  /// **'(Unnamed)'**
  String get unnamedFilePlaceholder;

  ///
  ///
  /// In en, this message translates to:
  /// **'Edit Group'**
  String get editGroupScreenTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get editGroupGroupNameLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get files;

  ///
  ///
  /// In en, this message translates to:
  /// **'New Group'**
  String get newGroupDialogTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Name for the new group'**
  String get newGroupDialogInputLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Show passwords'**
  String get groupActionShowPasswords;

  ///
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get groupActionDelete;

  /// Tooltip for logging out of a cloud storage provider.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutTooltip;

  /// deleted file from cloud storage.
  ///
  /// In en, this message translates to:
  /// **'Successfully deleted file.'**
  String get successfullyDeletedFileCloudStorage;

  ///
  ///
  /// In en, this message translates to:
  /// **'Sharing Options for {fileName}'**
  String shareDialogTitle(Object fileName);

  ///
  ///
  /// In en, this message translates to:
  /// **'Share …'**
  String get shareFileActionLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'File not shared yet.'**
  String get shareTokenListEmptyScreenPlaceholder;

  /// User did not specify a description for a given share code.
  ///
  /// In en, this message translates to:
  /// **'No Label/Description'**
  String get shareTokenNoLabel;

  /// Share Code allows reading and writing
  ///
  /// In en, this message translates to:
  /// **'Read/Write'**
  String get shareTokenReadWrite;

  /// Share code only allows reading.
  ///
  /// In en, this message translates to:
  /// **'Read only'**
  String get shareTokenReadOnly;

  ///
  ///
  /// In en, this message translates to:
  /// **'Share file'**
  String get shareCreateTokenDialogTitle;

  /// switch between read only and read/write
  ///
  /// In en, this message translates to:
  /// **'Read only'**
  String get shareCreateTokenReadOnly;

  /// help text for the switch between read only and read/write
  ///
  /// In en, this message translates to:
  /// **'Do not allow saving of changes'**
  String get shareCreateTokenReadOnlyHelpText;

  /// Allows users to add a description/label to a share code.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get shareCreateTokenLabelText;

  /// the placeholder/hint text displayed when the user has not yet entered a label
  ///
  /// In en, this message translates to:
  /// **'Share for my friend'**
  String get shareCreateTokenLabelHint;

  ///
  ///
  /// In en, this message translates to:
  /// **'Optional label to differentiate share code.'**
  String get shareCreateTokenLabelHelp;

  /// snackbar when share code was created successfully.
  ///
  /// In en, this message translates to:
  /// **'Successfully created share code.'**
  String get shareCreateTokenSuccess;

  ///
  ///
  /// In en, this message translates to:
  /// **'Share file with secret share code'**
  String get sharePresentDialogTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Using the following share code users can access the password file. They will need the password and/or key file to open it.'**
  String get sharePresentDialogHelp;

  ///
  ///
  /// In en, this message translates to:
  /// **'Share Code'**
  String get sharePresentToken;

  ///
  ///
  /// In en, this message translates to:
  /// **'Copied share code to clipboard.'**
  String get sharePresentCopied;

  /// Allows users to open cloud files using a share code/token.
  ///
  /// In en, this message translates to:
  /// **'Open with Share Code'**
  String get authPassCloudOpenWithShareCodeTooltip;

  ///
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get authPassCloudShareFileActionLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Use AuthPass Cloud Attachments'**
  String get preferenceAuthPassCloudAttachmentTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Store Attachments encrypted on AuthPass Cloud separately.'**
  String get preferenceAuthPassCloudAttachmentSubtitle;

  /// input dialog for inputting secret share code to access password file in AuthPassCloud
  ///
  /// In en, this message translates to:
  /// **'Input Secret Share Code'**
  String get shareCodeInputDialogTitle;

  /// button label for triggering QR code scanner
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get shareCodeInputDialogScan;

  ///
  ///
  /// In en, this message translates to:
  /// **'Secret Share Code'**
  String get shareCodeInputLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'If you have received a share code, please paste it above.'**
  String get shareCodeInputHelperText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Received a Share Code for AuthPass Cloud?'**
  String get shareCodeOpen;

  ///
  ///
  /// In en, this message translates to:
  /// **'Loading file with share code'**
  String get shareCodeOpenScreenTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Loading file …'**
  String get shareCodeLoadingProgress;

  ///
  ///
  /// In en, this message translates to:
  /// **'OPEN'**
  String get shareCodeOpenFileButtonLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Want to open this file with one of our native Apps instead?'**
  String get shareCodeOpenInstallAppCaption;

  ///
  ///
  /// In en, this message translates to:
  /// **'Want to open this file on another device?'**
  String get shareCodeOpenAnotherAppCaption;

  ///
  ///
  /// In en, this message translates to:
  /// **'Install App'**
  String get shareCodeOpenInstallAppButtonLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Show Share Code'**
  String get shareCodeOpenShowCodeButtonLabel;

  /// label for the button to show the dialog for changing master password.
  ///
  /// In en, this message translates to:
  /// **'Change Master Password'**
  String get changeMasterPasswordActionLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Save with new password'**
  String get changeMasterPasswordFormSubmit;

  ///
  ///
  /// In en, this message translates to:
  /// **'Successfully saved master password.'**
  String get changeMasterPasswordSuccess;

  /// app bar title for change password screen.
  ///
  /// In en, this message translates to:
  /// **'Change Master Password'**
  String get changeMasterPasswordScreenTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'I received email and visited link'**
  String get authPassCloudAuthClickedLink;

  ///
  ///
  /// In en, this message translates to:
  /// **'Email address was not yet confirmed. Make sure to click the link in the email you received and solve the captcha to confirm your email address.'**
  String get authPassCloudAuthNotConfirmed;

  ///
  ///
  /// In en, this message translates to:
  /// **'Get help in the forum'**
  String get getHelpButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Copy Username'**
  String get shortcutCopyUsername;

  ///
  ///
  /// In en, this message translates to:
  /// **'Copy Password'**
  String get shortcutCopyPassword;

  ///
  ///
  /// In en, this message translates to:
  /// **'Copy TOTP'**
  String get shortcutCopyTotp;

  ///
  ///
  /// In en, this message translates to:
  /// **'Select the previous password'**
  String get shortcutMoveUp;

  ///
  ///
  /// In en, this message translates to:
  /// **'Select the next password'**
  String get shortcutMoveDown;

  ///
  ///
  /// In en, this message translates to:
  /// **'Generate Password'**
  String get shortcutGeneratePassword;

  ///
  ///
  /// In en, this message translates to:
  /// **'Copy URL'**
  String get shortcutCopyUrl;

  ///
  ///
  /// In en, this message translates to:
  /// **'Open URL'**
  String get shortcutOpenUrl;

  ///
  ///
  /// In en, this message translates to:
  /// **'Cancel Search'**
  String get shortcutCancelSearch;

  ///
  ///
  /// In en, this message translates to:
  /// **'Keyboard Shortcut Help'**
  String get shortcutShortcutHelp;

  /// title of dialog showing keyboard shortcuts.
  ///
  /// In en, this message translates to:
  /// **'Keyboard Shortcuts'**
  String get shortcutHelpTitle;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected Error: {error}'**
  String unexpectedError(String error);

  /// No description provided for @googleDriveMorePermissionsRequired.
  ///
  /// In en, this message translates to:
  /// **'Additional permissions needed to access Google Drive.'**
  String get googleDriveMorePermissionsRequired;

  /// No description provided for @googleDriveRequestPermissionButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Request Permissions'**
  String get googleDriveRequestPermissionButtonLabel;

  /// No description provided for @scanQrCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code.'**
  String get scanQrCodeTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'et',
        'fi',
        'fr',
        'he',
        'id',
        'it',
        'lt',
        'nl',
        'pa',
        'pl',
        'pt',
        'ru',
        'si',
        'sk',
        'tr',
        'uk',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'lt':
      return AppLocalizationsLt();
    case 'nl':
      return AppLocalizationsNl();
    case 'pa':
      return AppLocalizationsPa();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'si':
      return AppLocalizationsSi();
    case 'sk':
      return AppLocalizationsSk();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
