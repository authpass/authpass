// ignore_for_file: omit_local_variable_types,unused_local_variable
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get fieldUserName => 'Користувач';

  @override
  String get fieldPassword => 'Пароль';

  @override
  String get fieldWebsite => 'Сайт';

  @override
  String get fieldTitle => 'Найменування';

  @override
  String get fieldTotp => 'Одноразовий пароль (залежить від часу)';

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
  String get selectKeepassFile => 'AuthPass - виберіть KeePass файл';

  @override
  String get quickUnlockingFiles => 'Швидке розблокування файлів';

  @override
  String get selectKeepassFileLabel => 'Оберіть файл KeePass (.kdbx).';

  @override
  String get createNewFile => 'Create New File';

  @override
  String get openLocalFile => 'Відкрити\nлокальний файл';

  @override
  String get openFile => 'Відкрити файл';

  @override
  String loadFrom(String cloudStorageName) {
    return 'Завантажити з ${cloudStorageName}';
  }

  @override
  String get loadFromUrl => 'Завантажити з URL';

  @override
  String get loadFromRemoteUrl => 'Open kdbx from URL';

  @override
  String get createNewKeepass => 'Вперше у KeePass?\nСтворити нову базу паролів';

  @override
  String get labelLastOpenFiles => 'Останні відкриті файли:';

  @override
  String get noFilesHaveBeenOpenYet => 'Не було відкрито жодного файлу.';

  @override
  String get preferenceSelectLanguage => 'Оберіть мову';

  @override
  String get preferenceLanguage => 'Мова';

  @override
  String get preferenceTextScaleFactor => 'Коефіцієнт масштабування тексту';

  @override
  String get preferenceVisualDensity => 'Візуальна щільність';

  @override
  String get preferenceTheme => 'Тема';

  @override
  String get preferenceThemeLight => 'Світла';

  @override
  String get preferenceThemeDark => 'Темна';

  @override
  String get preferenceSystemDefault => 'Системні налаштування';

  @override
  String get preferenceDefault => 'Типово';

  @override
  String get lockAllFiles => 'Заблокувати всі відкриті файли';

  @override
  String get preferenceAllowScreenshots => 'Дозволити знімки екрану';

  @override
  String get preferenceEnableAutoFill => 'Увімкнути автозаповнення';

  @override
  String get preferenceAutoFillDescription => 'Підтримується лише на Android Oreo (8.0) або новіше.';

  @override
  String get preferenceTitle => 'Налаштування';

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback => 'Ми раді будь-яким відгукам!';

  @override
  String get aboutLinkVisitWebsite => 'Також не забудьте відвідати наш сайт';

  @override
  String get aboutLinkGitHub => 'І джерельний код програми';

  @override
  String aboutLogFile(String logFilePath) {
    return 'Файл журналу: ${logFilePath}';
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
  String get menuItemGeneratePassword => 'Згенерувати пароль';

  @override
  String get menuItemPreferences => 'Налаштування';

  @override
  String get menuItemOpenAnotherFile => 'Відкрити інший файл';

  @override
  String get menuItemCheckForUpdates => 'Перевірити наявність оновлень';

  @override
  String get menuItemSupport => 'Підтримка по електронній пошті';

  @override
  String get menuItemSupportSubtitle => 'Надіслати журнали електронною поштою та запитом про допомогу.';

  @override
  String get menuItemHelp => 'Допомога';

  @override
  String get menuItemHelpSubtitle => 'Показати документацію';

  @override
  String get menuItemAbout => 'Про програму';

  @override
  String get actionOpenUrl => 'Open URL';

  @override
  String get passwordPlainText => 'Показати пароль';

  @override
  String get generatorPassword => 'Пароль';

  @override
  String get generatePassword => 'Згенерувати пароль';

  @override
  String get doneButtonLabel => 'Готово';

  @override
  String get useAsDefault => 'Використовувати за замовчуванням';

  @override
  String get characterSetLowerCase => 'Нижній регістр (а-я)';

  @override
  String get characterSetUpperCase => 'Верхній регістр (A-Я)';

  @override
  String get characterSetNumeric => 'Цифри (0-9)';

  @override
  String get characterSetUmlauts => 'Умляути (ä)';

  @override
  String get characterSetSpecial => 'Спеціальні символи (@%+)';

  @override
  String get length => 'Довжина';

  @override
  String get customLength => 'Особлива довжина';

  @override
  String customLengthHelperText(Object customMinLength) {
    return 'Використовується лише для довжини > ${customMinLength}';
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
      few: '${numFiles} файли збережено: ${files}',
      many: '${numFiles} файлів збережено: ${files}',
      other: '${numFiles} файли збережено: ${files}',
    );
  }

  @override
  String get manageGroups => 'Керування групами';

  @override
  String get lockFiles => 'Блокування файлів';

  @override
  String get searchHint => 'Пошук';

  @override
  String get clear => 'Очистити';

  @override
  String get autofillFilterPrefix => 'Фільтр:';

  @override
  String get autofillPrompt => 'Оберіть пароль для автозаповнення.';

  @override
  String get copiedToClipboard => 'Скопійовано до буфера обміну.';

  @override
  String get noTitle => '(нема заголовка)';

  @override
  String get noUsername => '(нема ім\'я користувача)';

  @override
  String get filterCustomize => 'Налаштувати …';

  @override
  String get swipeCopyPassword => 'Копіювати пароль';

  @override
  String get swipeCopyUsername => 'Копіювати ім\'я користувача';

  @override
  String get doneCopiedPassword => 'Пароль скопійовано до буфера обміну.';

  @override
  String get doneCopiedUsername => 'Ім\'я користувача було скопійовано до буфера обміну.';

  @override
  String get doneCopiedField => 'Copied.';

  @override
  String get emptyPasswordVaultPlaceholder => 'Ви ще не маєте жодного пароля в базі даних.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Створити свій перший пароль';

  @override
  String get loadingFile => 'Завантаження файлу …';

  @override
  String get internalFile => 'Внутрішній файл';

  @override
  String get internalFileSubtitle => 'Попередня база паролів створена в AuthPass';

  @override
  String get filePicker => 'Вибір файлу';

  @override
  String get filePickerSubtitle => 'Відкрити файл з пристрою.';

  @override
  String get credentialsAppBarTitle => 'Облікові дані';

  @override
  String get credentialLabel => 'Введіть пароль для:';

  @override
  String get masterPasswordInputLabel => 'Пароль';

  @override
  String get masterPasswordEmptyValidator => 'Будь ласка, введіть ваш пароль.';

  @override
  String get masterPasswordIncorrectValidator => 'Невірний пароль';

  @override
  String get useKeyFile => 'Використати файл-ключ';

  @override
  String get saveMasterPasswordBiometric => 'Зберегти пароль із біометричним сховищем ключів?';

  @override
  String get errorOpenFileAlreadyOpenTitle => 'File already open';

  @override
  String errorOpenFileAlreadyOpenBody(Object databaseName, Object openFileSource, Object newFileSource) {
    return 'The selected database ${databaseName} is already open from ${openFileSource} (Tried to open from ${newFileSource})';
  }

  @override
  String get errorUnlockFileTitle => 'Не вдалося відкрити файл';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Сталася невідома помилка під час спроби відкрити файл. ${error}';
  }

  @override
  String get dialogContinue => 'Продовжити';

  @override
  String get dialogSendErrorReport => 'Надіслати звіт про помилку/запит про допомогу';

  @override
  String get groupFilterDescription => 'Виберіть, які групи показувати (рекурсивно)';

  @override
  String get groupFilterSelectAll => 'Обрати все';

  @override
  String get groupFilterDeselectAll => 'Зняти всі виділення';

  @override
  String get createSubgroup => 'Створити підгрупу';

  @override
  String get editAction => 'Редагувати';

  @override
  String get deleteAction => 'Видалити';

  @override
  String get successfullyDeletedGroup => 'Видалити групу.';

  @override
  String get undoButtonLabel => 'Скасувати';

  @override
  String get saveButtonLabel => 'Save';

  @override
  String get initialNewGroupName => 'Нова група';

  @override
  String get deleteGroupErrorTitle => 'Не вдалося видалити групу';

  @override
  String get deleteGroupErrorBodyContainsGroup => 'Ця група містить підгрупи. Ви можете видаляти лише порожні групи.';

  @override
  String get deleteGroupErrorBodyContainsEntries => 'Ця група все ще містить збережені паролі. Видалити можна тільки порожні групи.';

  @override
  String get groupListAppBarTitle => 'Групи';

  @override
  String get groupListFilterAppbarTitle => 'Фільтрувати за групами';

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
    return 'Неочікувана помилка: ${error}';
  }
}
