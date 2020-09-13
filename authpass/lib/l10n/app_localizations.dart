// ignore_for_file: omit_local_variable_types,unused_local_variable
import 'dart:async';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'l10n/app_localizations.dart';
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
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: 0.16.1
///
///   # rest of dependencies
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
  AppLocalizations(String locale) : assert(locale != null), localeName = intl.Intl.canonicalizedLocale(locale.toString());

  // ignore: unused_field
  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('et'),
    Locale('fi'),
    Locale('fr'),
    Locale('lt'),
    Locale('ru'),
    Locale('uk')
  ];

  // No description provided in @fieldUserName
  String get fieldUserName;

  // No description provided in @fieldPassword
  String get fieldPassword;

  // No description provided in @fieldWebsite
  String get fieldWebsite;

  // No description provided in @fieldTitle
  String get fieldTitle;

  // Label for fields of TOTP (Time based one time passwords)
  String get fieldTotp;

  // language switcher subtitle
  String get english;

  // language switcher subtitle
  String get german;

  // language switcher subtitle
  String get russian;

  // language switcher subtitle
  String get ukrainian;

  // language switcher subtitle
  String get lithuanian;

  // language switcher subtitle
  String get french;

  // No description provided in @selectKeepassFile
  String get selectKeepassFile;

  // No description provided in @quickUnlockingFiles
  String get quickUnlockingFiles;

  // No description provided in @selectKeepassFileLabel
  String get selectKeepassFileLabel;

  // No description provided in @openLocalFile
  String get openLocalFile;

  // Displayed as placeholder in password list when no file is open.
  String get openFile;

  // No description provided in @loadFrom
  String loadFrom(String cloudStorageName);

  // No description provided in @loadFromUrl
  String get loadFromUrl;

  // No description provided in @createNewKeepass
  String get createNewKeepass;

  // No description provided in @labelLastOpenFiles
  String get labelLastOpenFiles;

  // No description provided in @noFilesHaveBeenOpenYet
  String get noFilesHaveBeenOpenYet;

  // No description provided in @preferenceSelectLanguage
  String get preferenceSelectLanguage;

  // No description provided in @preferenceLanguage
  String get preferenceLanguage;

  // No description provided in @preferenceTextScaleFactor
  String get preferenceTextScaleFactor;

  // No description provided in @preferenceVisualDensity
  String get preferenceVisualDensity;

  // No description provided in @preferenceTheme
  String get preferenceTheme;

  // No description provided in @preferenceThemeLight
  String get preferenceThemeLight;

  // No description provided in @preferenceThemeDark
  String get preferenceThemeDark;

  // No description provided in @preferenceSystemDefault
  String get preferenceSystemDefault;

  // No description provided in @preferenceDefault
  String get preferenceDefault;

  // No description provided in @lockAllFiles
  String get lockAllFiles;

  // No description provided in @preferenceAllowScreenshots
  String get preferenceAllowScreenshots;

  // No description provided in @preferenceEnableAutoFill
  String get preferenceEnableAutoFill;

  // No description provided in @preferenceAutoFillDescription
  String get preferenceAutoFillDescription;

  // No description provided in @preferenceTitle
  String get preferenceTitle;

  // No description provided in @aboutAppName
  String get aboutAppName;

  // No description provided in @aboutLinkFeedback
  String get aboutLinkFeedback;

  // No description provided in @aboutLinkVisitWebsite
  String get aboutLinkVisitWebsite;

  // No description provided in @aboutLinkGitHub
  String get aboutLinkGitHub;

  // No description provided in @aboutLogFile
  String aboutLogFile(String logFilePath);

  // No description provided in @menuItemGeneratePassword
  String get menuItemGeneratePassword;

  // No description provided in @menuItemPreferences
  String get menuItemPreferences;

  // No description provided in @menuItemOpenAnotherFile
  String get menuItemOpenAnotherFile;

  // No description provided in @menuItemCheckForUpdates
  String get menuItemCheckForUpdates;

  // No description provided in @menuItemSupport
  String get menuItemSupport;

  // No description provided in @menuItemSupportSubtitle
  String get menuItemSupportSubtitle;

  // No description provided in @menuItemHelp
  String get menuItemHelp;

  // No description provided in @menuItemHelpSubtitle
  String get menuItemHelpSubtitle;

  // No description provided in @menuItemAbout
  String get menuItemAbout;

  // Master password input: show password as plain text during input. (shown as tooltip)
  String get passwordPlainText;

  // Label for generated password
  String get generatorPassword;

  // screen title for password generator
  String get generatePassword;

  // generic button label for 'Done' action.
  String get doneButtonLabel;

  // Button Label for Password generator settings: use as defaults
  String get useAsDefault;

  // No description provided in @characterSetLowerCase
  String get characterSetLowerCase;

  // No description provided in @characterSetUpperCase
  String get characterSetUpperCase;

  // No description provided in @characterSetNumeric
  String get characterSetNumeric;

  // No description provided in @characterSetUmlauts
  String get characterSetUmlauts;

  // No description provided in @characterSetSpecial
  String get characterSetSpecial;

  // Length of password
  String get length;

  // Label for custom length field
  String get customLength;

  // Help text for custom length field
  String customLengthHelperText(Object customMinLength);

  // Message displayed when files were saved. (One or more).
  String savedFiles(int numFiles, Object files);

  // 
  String get manageGroups;

  // Close all files and return to start screen.
  String get lockFiles;

  // Placeholder in the password list search box
  String get searchHint;

  // Remove existing group filter from password list
  String get clear;

  // Label displayed for android auto fill
  String get autofillFilterPrefix;

  // 
  String get autofillPrompt;

  // Snackbar text when copying text to clipboard.
  String get copiedToClipboard;

  // Text to display in place of a title, when password entry has no name assigned.
  String get noTitle;

  // Text to display in place of a user name in the password list if none is defined.
  String get noUsername;

  // Customize filter in password list
  String get filterCustomize;

  // swipe action in password list to copy password
  String get swipeCopyPassword;

  // swipe action in password list to copy username
  String get swipeCopyUsername;

  // snackbar confirmation that password was copied.
  String get doneCopiedPassword;

  // snackbar confirmation that username was copied.
  String get doneCopiedUsername;

  // Placeholder text shown when a user opens an empty password file.
  String get emptyPasswordVaultPlaceholder;

  // Button shown under placeholder text when password database is empty
  String get emptyPasswordVaultButtonLabel;

  // credential screen while unlocking file.
  String get loadingFile;

  // Choose a file previously created in AuthPass app sandbox
  String get internalFile;

  // Choose a file previously created in AuthPass app sandbox
  String get internalFileSubtitle;

  // Choose a file with the system's file picker. (ios/android)
  String get filePicker;

  // Choose a file with the system's file picker. (ios/android)
  String get filePickerSubtitle;

  // Credential screen to enter master password when opening kdbx file.
  String get credentialsAppBarTitle;

  // Label for the file/database being opened
  String get credentialLabel;

  // 
  String get masterPasswordInputLabel;

  // 
  String get masterPasswordEmptyValidator;

  // 
  String get masterPasswordIncorrectValidator;

  // label for a key file in combination with mater password
  String get useKeyFile;

  // Label for the checkbox to save master password for quick unlock.
  String get saveMasterPasswordBiometric;

  // Trying to open a database from a second file source which is already open.
  String get errorOpenFileAlreadyOpenTitle;

  // Trying to open a database from a second file source which is already open.
  String errorOpenFileAlreadyOpenBody(Object databaseName, Object openFileSource, Object newFileSource);

  // generic error when opening a file (dialog title)
  String get errorUnlockFileTitle;

  // generic error when opening a file (description)
  String errorUnlockFileBody(Object error);

  // Dialog action to continue to next step (e.g. credential screen when finished with master password)
  String get dialogContinue;

  // action button in error dialogs to send email to support with log file.
  String get dialogSendErrorReport;

  // Description shown in the group list for filtering (e.g. app drawer)
  String get groupFilterDescription;

  // No description provided in @groupFilterSelectAll
  String get groupFilterSelectAll;

  // No description provided in @groupFilterDeselectAll
  String get groupFilterDeselectAll;

  // menu action: create nested group inside another group
  String get createSubgroup;

  // menu action: edit item (e.g. delete a group)
  String get editAction;

  // menu action: delete item (e.g. delete a group)
  String get deleteAction;

  // snackbar after deleting a group.
  String get successfullyDeletedGroup;

  // undo action label (e.g. in a snackbar after deleting a group, or some other action)
  String get undoButtonLabel;

  // initial name of groups when user creates a new one.
  String get initialNewGroupName;

  // Title of error dialog when group could not be deleted.
  String get deleteGroupErrorTitle;

  // Body of error dialog when a group can't be deleted because it is not empty.
  String get deleteGroupErrorBodyContainsGroup;

  // Body of error dialog when a group can't be deleted because it is not empty.
  String get deleteGroupErrorBodyContainsEntries;

  // title in the app bar for the groups list
  String get groupListAppBarTitle;

  // title in the app bar for group lists when displayed for filtering password list
  String get groupListFilterAppbarTitle;

  // 
  String get clearQuickUnlock;

  // 
  String get clearQuickUnlockSubtitle;

  // 
  String get unlock;

  // 
  String get clearQuickUnlockSuccess;

  // No description provided in @unexpectedError
  String unexpectedError(String error);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(_lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'et', 'fi', 'fr', 'lt', 'ru', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations _lookupAppLocalizations(Locale locale) {
  
  
  
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'et': return AppLocalizationsEt();
    case 'fi': return AppLocalizationsFi();
    case 'fr': return AppLocalizationsFr();
    case 'lt': return AppLocalizationsLt();
    case 'ru': return AppLocalizationsRu();
    case 'uk': return AppLocalizationsUk();
  }

  assert(false, 'AppLocalizations.delegate failed to load unsupported locale "$locale"');
  return null;
}
