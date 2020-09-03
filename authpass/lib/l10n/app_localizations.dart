// Generated file, do not modify.
import 'dart:async';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

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
    Locale('en')
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

  // No description provided in @selectKeepassFile
  String get selectKeepassFile;

  // No description provided in @quickUnlockingFiles
  String get quickUnlockingFiles;

  // No description provided in @selectKeepassFileLabel
  String get selectKeepassFileLabel;

  // No description provided in @openLocalFile
  String get openLocalFile;

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

  // Snackbar text when copying text to clipboard.
  String get copiedToClipboard;

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
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations _lookupAppLocalizations(Locale locale) {
  
  
  
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  assert(false, 'AppLocalizations.delegate failed to load unsupported locale "$locale"');
  return null;
}
