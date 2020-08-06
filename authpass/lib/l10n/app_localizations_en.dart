// Generated file, do not modify.
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get fieldUserName => 'User';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldWebsite => 'Website';

  @override
  String get fieldTitle => 'Title';

  @override
  String get selectKeepassFile => 'AuthPass - Select KeePass File';

  @override
  String get quickUnlockingFiles => 'Quick unlocking files';

  @override
  String get selectKeepassFileLabel => 'Please select a KeePass (.kdbx) file.';

  @override
  String get openLocalFile => 'Open\nLocal File';

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
}
