// ignore_for_file: omit_local_variable_types,unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

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
  String get english => 'Англійська';

  @override
  String get german => 'Німецька';

  @override
  String get russian => 'російська';

  @override
  String get ukrainian => 'Українська';

  @override
  String get lithuanian => 'Литовська';

  @override
  String get french => 'Французька';

  @override
  String get spanish => 'Іспанська';

  @override
  String get indonesian => 'Indonesian';

  @override
  String get turkish => 'Турецька';

  @override
  String get hebrew => 'Іврит';

  @override
  String get italian => 'Італійська';

  @override
  String get chineseSimplified => 'Китайська (спрощена)';

  @override
  String get chineseTraditional => 'Китайська (традиційна)';

  @override
  String get portugueseBrazilian => 'Португальська, Бразилія';

  @override
  String get slovak => 'Словацька';

  @override
  String get dutch => 'Нідерландська';

  @override
  String get selectItem => 'Вибрати';

  @override
  String get selectKeepassFile => 'AuthPass - виберіть KeePass файл';

  @override
  String get selectKeepassFileLabel => 'Оберіть файл KeePass (.kdbx).';

  @override
  String get createNewFile => 'Створити новий файл';

  @override
  String get openLocalFile => 'Відкрити\nлокальний файл';

  @override
  String get openFile => 'Відкрити файл';

  @override
  String get loadFromDropdownMenu => 'Завантажити з …';

  @override
  String get quickUnlockingFiles => 'Швидке розблокування файлів …';

  @override
  String openFileProgress(Object fileName, Object current, Object totalCount) {
    return 'Відкриття $fileName … ($current / $totalCount)';
  }

  @override
  String loadFrom(String cloudStorageName) {
    return 'Завантажити з $cloudStorageName';
  }

  @override
  String get loadFromRemoteUrl => 'Відкрити kdbx з URL-адреси';

  @override
  String get createNewKeepass =>
      'Вперше у KeePass?\nСтворити нову базу паролів';

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
  String get enableAutofillSuggestionBanner =>
      'Ви можете заповнювати поля в інших додатках якщо включите автозаповнення!';

  @override
  String get dismissAutofillSuggestionBannerButton => 'ВІДХИЛИТИ';

  @override
  String get enableAutofillSuggestionBannerButton => 'ВВІМКНУТИ!';

  @override
  String get preferenceAutoFillDescription =>
      'Підтримується лише на Android Oreo (8.0) або новіше.';

  @override
  String get preferenceTitle => 'Налаштування';

  @override
  String get preferenceEnableSystemWideShortcuts =>
      'Ввімкнути гарячі клавіші всюди';

  @override
  String get preferenceEnableSystemWideShortcutsHelp =>
      'Реєструє ctrl+alt+f в усій системі для відкриття пошуку.';

  @override
  String get preferencesSearchFields => 'Налаштувати поля пошуку';

  @override
  String get preferencesSearchFieldPromptTitle => 'Поля пошуку';

  @override
  String get preferencesSearchFieldPromptLabel =>
      'Список полів за якими буде здійснюватися пошук паролів. Розділені комою.';

  @override
  String preferencesSearchFieldPromptHelp(
      Object wildCardCharacter, Object defaultSearchFields) {
    return 'Використовуйте $wildCardCharacter, щоб включити всі поля або залиште порожнім для використання полів за замовчуванням ($defaultSearchFields)';
  }

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
    return 'Файл журналу: $logFilePath';
  }

  @override
  String get aboutLinkContributors => 'Показати учасників проекту';

  @override
  String get unableToLaunchUrlTitle => 'Не вдалося відкрити URL-адресу';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'Не вдалося запустити $url: $openError';
  }

  @override
  String get unableToLaunchUrlNoHandler =>
      'Додаток для цієї URL-адреси не зареєстровано.';

  @override
  String launchedUrl(Object url) {
    return 'Відкрито посилання: $url';
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
  String get menuItemSupport => 'Надіслати логи';

  @override
  String get menuItemSupportSubtitle => 'Надіслати логи електронною поштою';

  @override
  String get menuItemForum => 'Форум підтримки';

  @override
  String get menuItemForumSubtitle =>
      'Повідомити про проблему й отримати допомогу';

  @override
  String get menuItemHelp => 'Допомога';

  @override
  String get menuItemHelpSubtitle => 'Показати документацію';

  @override
  String get menuItemAbout => 'Про програму';

  @override
  String get actionOpenUrl => 'Відкрити URL-адресу';

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
    return 'Використовується лише для довжини > $customMinLength';
  }

  @override
  String savedFiles(int numFiles, Object files) {
    final intl.NumberFormat numFilesNumberFormat =
        intl.NumberFormat.compactLong(
      locale: localeName,
    );
    final String numFilesString = numFilesNumberFormat.format(numFiles);

    String _temp0 = intl.Intl.pluralLogic(
      numFiles,
      locale: localeName,
      other: 'Всі файли збережено ($numFilesString): $files',
      one: 'Збережено один файл: $files',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => 'Керування групами';

  @override
  String get lockFiles => 'Блокування файлів';

  @override
  String get searchHint => 'Пошук';

  @override
  String get searchButtonLabel => 'Пошук';

  @override
  String get filterButtonLabel => 'Фільтрувати за групою';

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
  String get copyUsernameNotExists => 'Цей запис не має ім\'я користувача.';

  @override
  String get copyPasswordNotExists => 'Цей запис не має пароля.';

  @override
  String get doneCopiedPassword => 'Пароль скопійовано до буфера обміну.';

  @override
  String get doneCopiedUsername =>
      'Ім\'я користувача було скопійовано до буфера обміну.';

  @override
  String get doneCopiedField => 'Скопійовано.';

  @override
  String copiedFieldToClipboard(Object fieldName) {
    return '$fieldName зкопійовано.';
  }

  @override
  String copiedFieldEmpty(Object fieldName) {
    return 'Поле \"$fieldName\" порожнє.';
  }

  @override
  String get emptyPasswordVaultPlaceholder =>
      'Ви ще не маєте жодного пароля в базі даних.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Створити свій перший пароль';

  @override
  String get loading => 'Завантаження';

  @override
  String get loadingFile => 'Завантаження файлу …';

  @override
  String get internalFile => 'Внутрішній файл';

  @override
  String get internalFileSubtitle =>
      'Попередня база паролів створена в AuthPass';

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
  String get saveMasterPasswordBiometric =>
      'Зберегти пароль із біометричним сховищем ключів?';

  @override
  String get close => 'Закрити';

  @override
  String get addNewPassword => 'Додати новий пароль';

  @override
  String get errorOpenFileInvalidFileStructureTitle =>
      'Спроба відкрити невірний тип файлу';

  @override
  String errorOpenFileInvalidFileStructureBody(Object fileName) {
    return 'Файл ($fileName) не є коректним файлом KDBX. Будь ласка, виберіть правильний файл KDBX або створіть нову базу паролів.';
  }

  @override
  String get errorOpenFileAlreadyOpenTitle => 'Цей файл вже відкритий';

  @override
  String errorOpenFileAlreadyOpenBody(
      Object databaseName, Object openFileSource, Object newFileSource) {
    return 'Обрана база даних $databaseName вже відкрита з $openFileSource (Спроба відкрити з $newFileSource)';
  }

  @override
  String get loadFromUrl => 'Завантажити з URL-адреси';

  @override
  String get loadFromUrlEnterUrl => 'Введіть URL-адресу';

  @override
  String get loadFromUrlErrorEnterFullUrl =>
      'Будь ласка, введіть повне посилання починаючи з http:// або https://';

  @override
  String get loadFromUrlErrorInvalidUrl =>
      'Будь ласка, введіть правильний URL.';

  @override
  String get linuxAppArmorWarning =>
      'AuthPass потребує дозволу на зв\'язок зі Службою Паролів для зберігання облікових даних для хмарного сховища.\nБудь ласка, виконайте наступну команду:';

  @override
  String get cancel => 'Скасувати';

  @override
  String get errorLoadFileFromSourceTitle => 'Помилка під час відкриття файлу.';

  @override
  String errorLoadFileFromSourceBody(Object source, Object error) {
    return 'Не вдалося відкрити $source.\n$error';
  }

  @override
  String get errorUnlockFileTitle => 'Не вдалося відкрити файл';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Сталася невідома помилка під час спроби відкрити файл. $error';
  }

  @override
  String get dialogContinue => 'Продовжити';

  @override
  String get dialogSendErrorReport => 'Надіслати звіт про помилки';

  @override
  String get dialogReportErrorForum =>
      'Повідомити про помилку на форумі/центрі допомоги';

  @override
  String get groupFilterDescription =>
      'Виберіть, які групи показувати (рекурсивно)';

  @override
  String get groupFilterSelectAll => 'Обрати все';

  @override
  String get groupFilterDeselectAll => 'Зняти всі виділення';

  @override
  String get createSubgroup => 'Створити підгрупу';

  @override
  String get editAction => 'Редагувати';

  @override
  String get mailboxEnableLabel => 'ввімкнути (знову)';

  @override
  String get mailboxEnableHint => 'Продовжити отримувати листи';

  @override
  String get mailboxDisableLabel => 'Вимкнути';

  @override
  String get mailboxDisableHint => 'Більше не отримувати листів';

  @override
  String get mailListNoMail => 'Ви ще не отримували жодних листів.';

  @override
  String mailboxLabelPrefixForEntry(Object entryLabel) {
    return 'Запис: $entryLabel';
  }

  @override
  String mailboxLabelPrefixUnknownEntry(Object entryUuid) {
    return 'Невідомий запис: $entryUuid';
  }

  @override
  String mailboxLabelPrefixCreatedAt(Object dateTime) {
    return 'Створено: $dateTime';
  }

  @override
  String get masterPasswordDescription =>
      'Головний пароль використовується для безпечного шифрування бази паролів. Його неможливо відновити, тож переконайтеся що ви його пам\'ятаєте.';

  @override
  String get unsavedChangesWarningTitle => 'Не всі зміни збережено';

  @override
  String get unsavedChangesWarningBody =>
      'Дані ще не збережені. Ви бажаєте відхилити зміни?';

  @override
  String get unsavedChangesDiscardActionLabel => 'Скасувати зміни';

  @override
  String get deletePermanentlyAction => 'Видалити назавжди';

  @override
  String get restoreFromRecycleBinAction => 'Відновити';

  @override
  String get deleteAction => 'Видалити';

  @override
  String get deletedEntry => 'Вилучений запис.';

  @override
  String get successfullyDeletedGroup => 'Видалити групу.';

  @override
  String get undoButtonLabel => 'Скасувати';

  @override
  String get saveButtonLabel => 'Зберегти';

  @override
  String get webDavSettings => 'Налаштування WebDAV';

  @override
  String get webDavUrlLabel => 'URL-адреса';

  @override
  String get webDavUrlHelperText => 'Базове посилання на Вашу службу WebDAV.';

  @override
  String get webDavUrlValidatorError => 'Введіть URL-адресу';

  @override
  String get webDavUrlValidatorInvalidUrlError =>
      'Будь ласка, введіть повне посилання починаючи з http:// або https://';

  @override
  String get webDavAuthUser => 'Логін';

  @override
  String get webDavAuthPassword => 'Пароль';

  @override
  String get mergeSuccessDialogTitle => 'База паролів успішно об\'єднана';

  @override
  String mergeSuccessDialogMessage(Object fileName, Object mergeSummary) {
    return 'Виявлено конфлікт під час збереження $fileName, він був успішно об\'єднаний з віддаленим файлом: \n\n$mergeSummary';
  }

  @override
  String forDetailsVisitUrl(Object url) {
    return 'Переглянути деталі за посиланням: $url';
  }

  @override
  String get authPassCloudAuthEmailInputLabel =>
      'Введіть адресу ел. пошти для реєстрації або входу.';

  @override
  String get authPassCloudAuthEmailInvalid =>
      'Будь ласка, введіть правильну адресу електронної пошти.';

  @override
  String get authPassCloudAuthConfirmEmailButtonLabel => 'Підтвердження адреси';

  @override
  String get authPassCloudAuthConfirmEmail =>
      'Будь ласка, перевірте свою електронну скриньку, щоб підтвердити свою електронну адресу.';

  @override
  String get authPassCloudAuthConfirmEmailExplain =>
      'Не закривайте цей екран поки не підтвердите адресу ел. пошти.';

  @override
  String get authPassCloudAuthResendExplain =>
      'Якщо ви не отримали листа, перевірте теку зі спамом. Або ви можете запросити посилання для підтвердження ще раз.';

  @override
  String get authPassCloudAuthResendButtonLabel =>
      'Запросити нове посилання для підтвердження';

  @override
  String permanentlyDeleteEntryConfirm(Object title) {
    return 'Це призведе до остаточного видалення запису пароля $title. Це не може бути скасовано. Ви хочете продовжити?';
  }

  @override
  String get permanentlyDeletedEntrySnackBar => 'Запис видалено назавжди.';

  @override
  String get initialNewGroupName => 'Нова група';

  @override
  String get deleteGroupErrorTitle => 'Не вдалося видалити групу';

  @override
  String get deleteGroupErrorBodyContainsGroup =>
      'Ця група містить підгрупи. Ви можете видаляти лише порожні групи.';

  @override
  String get deleteGroupErrorBodyContainsEntries =>
      'Ця група все ще містить збережені паролі. Видалити можна тільки порожні групи.';

  @override
  String get groupListAppBarTitle => 'Групи';

  @override
  String get groupListFilterAppbarTitle => 'Фільтрувати за групами';

  @override
  String get clearQuickUnlock => 'Очистити сховище біометричних даних';

  @override
  String get clearQuickUnlockSubtitle =>
      'Видалити збережені головні майстер-паролі';

  @override
  String get unlock => 'Розблокувати файли';

  @override
  String get closePasswordFiles => 'закрити файли паролів';

  @override
  String get clearQuickUnlockSuccess =>
      'Збережені майстер-паролі з біометричного сховища вилучено.';

  @override
  String get diacOptIn => 'Підпишіться на новини в додатку, опитування.';

  @override
  String get diacOptInSubtitle =>
      'Час від часу надсилатиме мережевий запит для отримання новин.';

  @override
  String get enableAutofillDebug =>
      'Автозаповнення: увімкнути налагодження (debug)';

  @override
  String get enableAutofillDebugSubtitle =>
      'Показує інформаційні шари для кожного поля введення';

  @override
  String get createPasswordDatabase => 'Створити базу паролів';

  @override
  String get nameNewPasswordDatabase => 'Назва нової бази паролів';

  @override
  String get validatorNameMissing =>
      'Будь ласка, введіть назву для нової бази даних.';

  @override
  String get masterPasswordHelpText =>
      'Виберіть надійний головний пароль. Запам\'ятайте його.';

  @override
  String get inputMasterPasswordText => 'Головний пароль';

  @override
  String get masterPasswordMissingCreate =>
      'Будь ласка, введіть надійний пароль, що легко запам\'ятовується.';

  @override
  String get createDatabaseAction => 'Створити базу даних';

  @override
  String get databaseExistsError => 'Файл вже існує';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'Помилка при спробі створити базу даних $filePath. Файл вже існує. Будь ласка, виберіть іншу назву.';
  }

  @override
  String get databaseCreateDefaultName => 'ОсобистіПаролі';

  @override
  String get preferenceDynamicLoadIcons => 'Завантажувати іконки динамічно';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'Буде робити http-запити зі значенням у полі $urlFieldName для завантаження іконок сайтів.';
  }

  @override
  String passwordScore(Object score) {
    return 'Міцність: $score з 4';
  }

  @override
  String get entryInfoFile => 'Файл:';

  @override
  String get entryInfoGroup => 'Група:';

  @override
  String get entryInfoLastModified => 'Остання зміна:';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'Переміщено запис до $groupName';
  }

  @override
  String sizeBytesStoredAuthPassCloud(Object count) {
    return '$count байт, що зберігаються в AuthPass Cloud';
  }

  @override
  String sizeBytes(Object count) {
    return '$count байт';
  }

  @override
  String get entryAddAttachment => 'Прикріпити файл';

  @override
  String get entryAttachmentSizeWarning =>
      'Прикріплені файли будуть вбудовані у файл паролів. Це може значно збільшити час, необхідний для відкриття/збереження паролів.';

  @override
  String get iconPngSizeWarning =>
      'У файл пароля будуть вбудовані користувацькі іконки. Це може значно збільшити час, необхідний для відкриття/збереження паролів.';

  @override
  String get notPngError => 'Обраний файл не є PNG.';

  @override
  String get entryAddField => 'Створити поле';

  @override
  String get entryCustomField => 'Власне поле';

  @override
  String get entryCustomFieldTitle => 'Додавання нового користувацького поля';

  @override
  String get entryCustomFieldInputLabel => 'Введіть нове ім\'я для поля';

  @override
  String get swipeCopyField => 'Копіювати поле';

  @override
  String get fieldRename => 'Перейменувати';

  @override
  String get fieldGeneratePassword => 'Згенерувати пароль …';

  @override
  String get fieldProtect => 'Захистити Значення';

  @override
  String get fieldUnprotect => 'Прибрати Захист';

  @override
  String get fieldPresent => 'QR код';

  @override
  String get fieldGenerateEmail => 'Згенерувати адресу електронної пошти';

  @override
  String get onboardingBackToOnboarding => 'Тур';

  @override
  String get onboardingBackToOnboardingSubtitle =>
      'Переживіть досвід першого запуску 😅️';

  @override
  String get onboardingHeadline => 'Зробимо ваші паролі безпечними!';

  @override
  String get onboardingQuestion =>
      'Чи користувалися ви раніше менеджером паролів?';

  @override
  String get onboardingYesOpenPasswords => 'Так, відкрити мої паролі';

  @override
  String get onboardingNoCreate => 'Я зовсім новачок! Нумо почнімо.';

  @override
  String get backupButton => 'ЗБЕРЕГТИ В КЛАУД';

  @override
  String get dismissBackupButton => 'ВІДХИЛИТИ';

  @override
  String backupWarningMessage(Object databasename) {
    return 'Ваші паролі в $databasename збережені тільки локально!';
  }

  @override
  String get saveAs => 'Зберегти В...';

  @override
  String get saving => 'Збереження';

  @override
  String get increaseValue => 'Збільшити';

  @override
  String get decreaseValue => 'Зменшити';

  @override
  String get resetValue => 'Скинути';

  @override
  String cloudStorageAppBarTitle(Object cloudStorageName) {
    return 'Хмарне сховище - $cloudStorageName';
  }

  @override
  String get cloudStorageLogInCaption =>
      'Вас буде перенаправлено на сторінку автентифікації AuthPass для доступу до ваших даних.';

  @override
  String get cloudStorageLogInCode => 'Введіть код';

  @override
  String launchUrlError(Object url) {
    return 'Не вдалося відкрити URL-адресу. Будь ласка, перейдіть за посиланням $url';
  }

  @override
  String cloudStorageLogInActionLabel(Object cloudStorageName) {
    return 'Увійти до $cloudStorageName';
  }

  @override
  String cloudStorageAuthCodeDialogTitle(Object cloudStorageName) {
    return '$cloudStorageName Автентифікація';
  }

  @override
  String get cloudStorageAuthCodeLabel => 'Код автентифікації';

  @override
  String get cloudStorageAuthErrorTitle => 'Помилка під час автентифікації';

  @override
  String cloudStorageAuthErrorMessage(
      Object cloudStorageName, Object errorMessage) {
    return 'Помилка при спробі автентифікації в $cloudStorageName: $errorMessage';
  }

  @override
  String get cloudStorageSearchBoxLabel => 'Пошуковий запит';

  @override
  String cloudStorageItemsInFolder(Object itemCount) {
    return '$itemCount елементів у цій теці.';
  }

  @override
  String get mailSubject => 'Тема';

  @override
  String get mailFrom => 'Від';

  @override
  String get mailDate => 'Дата';

  @override
  String get mailMailbox => 'Поштова скринька';

  @override
  String get mailNoData => 'Немає даних';

  @override
  String get mailMailboxesTitle => 'Поштові скриньки';

  @override
  String get mailboxCreateButtonLabel => 'Створити';

  @override
  String get mailboxNameInputDialogTitle =>
      'Назва поштової скриньки (не обовʼязково)';

  @override
  String get mailboxNameInputLabel => '(Внутрішня) Назва';

  @override
  String get mailScreenTitle => 'Електронна пошта AuthPass';

  @override
  String get mailTabBarTitleMailbox => 'Поштова скринька';

  @override
  String get mailTabBarTitleMail => 'Пошта';

  @override
  String get mailMailboxListEmpty => 'У вас поки що немає поштових скриньок.';

  @override
  String mailMailboxAddressCopied(Object mailboxAddress) {
    return 'Скопійовано адресу поштової скриньки: $mailboxAddress';
  }

  @override
  String get errorWhileSavingTitle => 'Помилка збереження';

  @override
  String errorWhileSavingBody(Object errorMessage) {
    return 'Неможливо зберегти файл: $errorMessage';
  }

  @override
  String get databaseDoesNotSupportSaving =>
      'На жаль, ця база даних не підтримує збереження. Будь ласка, відкрийте локальний файл бази даних. Або скористайтеся кнопкою \"Зберегти як\".';

  @override
  String get otpInvalidKeyTitle => 'Недійсний ключ';

  @override
  String get otpInvalidKeyBody =>
      'Введене значення не є коректним base32 TOTP кодом. Будь ласка, перевірте введені дані.';

  @override
  String get otpUnsupportedMigrationTitle => 'Непідтримувана міграція ОТР';

  @override
  String otpUnsupportedMigrationBody(Object uriCount) {
    return 'Наразі ми підтримуємо лише перенесення одного елемента. Отримано $uriCount';
  }

  @override
  String get otpPromptTitle => 'Автентифікація на основі часу';

  @override
  String get otpPromptHelperText =>
      'Будь ласка, введіть ключ, заснований на часі.';

  @override
  String otpErrorMessageGeneration(Object errorMessage) {
    return 'Помилка генерування коду запрошення: $errorMessage';
  }

  @override
  String get otpCopySecretActionLabel => 'Копіювати секрет';

  @override
  String get otpEntryLabel => 'Одноразовий Токен';

  @override
  String get entryFieldProtected => 'Захищене поле. Клацніть, щоб відкрити.';

  @override
  String get entryFieldActionRevealField => 'Показати захищене поле';

  @override
  String get entryAttachmentOpenActionLabel => 'Відкрити';

  @override
  String get entryAttachmentShareActionLabel => 'Поділитись';

  @override
  String get entryAttachmentShareSubject => 'Вкладення';

  @override
  String get entryAttachmentSaveActionLabel => 'Зберегти на пристрій';

  @override
  String get entryAttachmentRemoveActionLabel => 'Видалити';

  @override
  String entryAttachmentRemoveConfirm(Object attachmentLabel) {
    return 'Ви дійсно бажаєте вилучити $attachmentLabel?';
  }

  @override
  String get entryRenameFieldPromptTitle => 'Перейменування поля';

  @override
  String get removerecentfile => 'Приховати';

  @override
  String get entryRenameFieldPromptLabel => 'Введіть нове ім\'я для поля';

  @override
  String get promptDialogPasteActionTooltip => 'Вставити із буферу обміну';

  @override
  String get promptDialogPasteHint =>
      'Підказка: якщо потрібно вставити, спробуйте кнопку ліворуч ;-)';

  @override
  String get genericErrorDialogTitle => 'Помилка під час обробки дії';

  @override
  String genericErrorDialogBody(Object errorMessage) {
    return 'Виникла несподівана помилка. $errorMessage';
  }

  @override
  String get saveAsEntryLocalFile => 'Локальний Файл';

  @override
  String get fileTypePngs => 'Зображення (png)';

  @override
  String get selectIconDialogAction => 'ВИБРАТИ ІКОНКУ';

  @override
  String get retryDialogActionLabel => 'ПОВТОРИТИ';

  @override
  String errorDuringNetworkCall(Object errorMessage) {
    return 'Помилка під час виклику api. $errorMessage';
  }

  @override
  String get passwordFilterHideDeleted => 'Приховати вилучені записи';

  @override
  String get passwordFilterOnlyDeleted => 'Вилучені Записи';

  @override
  String passwordFilterPrefixForOneGroup(Object groupName) {
    return 'Група: $groupName';
  }

  @override
  String passwordFilterPrefixForMultipleGroups(Object groupCount) {
    return 'Власний фільтр ($groupCount груп(и))';
  }

  @override
  String get menuItemAuthPassCloudAuthenticate =>
      'Авторизуватись з AuthPass Cloud';

  @override
  String get menuItemAuthPassCloudMailboxes => 'Електронні скриньки AuthPass';

  @override
  String changesWithoutSaving(Object fileName) {
    return 'У вас є зміни в \"$fileName\", який не підтримує запис змін.';
  }

  @override
  String get changesSaveLocally => 'Зберегти локально';

  @override
  String get clearColor => 'Скинути колір';

  @override
  String get databaseRenameInputLabel => 'Введіть ім\'я бази даних';

  @override
  String get databasePath => 'Шлях до файлу';

  @override
  String get databaseColor => 'Колір';

  @override
  String get databaseColorChoose => 'Виберіть колір, щоб розрізняти файли.';

  @override
  String get databaseKdbxVersion => 'Версія файлу KDBX';

  @override
  String databaseKdbxUpgradeVersion(Object versionName) {
    return 'Оновити до $versionName';
  }

  @override
  String get databaseKdbxUpgradeSuccessful =>
      'Файл успішно оновлено та збережено.';

  @override
  String get databaseReload => 'Перезавантажити та злити';

  @override
  String progressStatus(Object statusProgress) {
    return 'Статус: $statusProgress';
  }

  @override
  String finishedMerge(Object status) {
    return 'Завершено злиття $status';
  }

  @override
  String get closeAndLockFile => 'Закрити/Заблокувати';

  @override
  String get authPassHomeScreenTagline =>
      'менеджер паролів, з відкритим кодом, доступний на всіх платформах.';

  @override
  String get addNewPasswordButtonLabel => 'Додати новий пароль';

  @override
  String get unnamedEntryPlaceholder => '(Без назви)';

  @override
  String get unnamedGroupPlaceholder => '(Без назви)';

  @override
  String get unnamedFilePlaceholder => '(Без назви)';

  @override
  String get editGroupScreenTitle => 'Редагувати групу';

  @override
  String get editGroupGroupNameLabel => 'Назва групи';

  @override
  String get files => 'Файли';

  @override
  String get newGroupDialogTitle => 'Нова група';

  @override
  String get newGroupDialogInputLabel => 'Ім\'я для нової групи';

  @override
  String get groupActionShowPasswords => 'Показати паролі';

  @override
  String get groupActionDelete => 'Видалити';

  @override
  String get logoutTooltip => 'Вихід із системи';

  @override
  String get successfullyDeletedFileCloudStorage => 'Файл успішно видалено.';

  @override
  String shareDialogTitle(Object fileName) {
    return 'Параметри спільного доступу до $fileName';
  }

  @override
  String get shareFileActionLabel => 'Поділіться …';

  @override
  String get shareTokenListEmptyScreenPlaceholder =>
      'До файлу ще не надано доступ.';

  @override
  String get shareTokenNoLabel => 'Без мітки/опису';

  @override
  String get shareTokenReadWrite => 'Читання/запис';

  @override
  String get shareTokenReadOnly => 'Лише для читання';

  @override
  String get shareCreateTokenDialogTitle => 'Поділитися файлом';

  @override
  String get shareCreateTokenReadOnly => 'Тільки для читання';

  @override
  String get shareCreateTokenReadOnlyHelpText => 'Не дозволяти збереження змін';

  @override
  String get shareCreateTokenLabelText => 'Опис';

  @override
  String get shareCreateTokenLabelHint => 'Поширення для Залужного';

  @override
  String get shareCreateTokenLabelHelp =>
      'Необов\'язкова мітка для розрізнення коду спільного доступу.';

  @override
  String get shareCreateTokenSuccess => 'Код поширення успішно створено.';

  @override
  String get sharePresentDialogTitle =>
      'Поділитися файлом з секретним кодом поширення';

  @override
  String get sharePresentDialogHelp =>
      'Використовуючи наступний код доступу, користувачі можуть отримати доступ до файлу з паролями. Щоб відкрити його, їм знадобиться пароль та/або ключ-файл.';

  @override
  String get sharePresentToken => 'Код для поширення';

  @override
  String get sharePresentCopied => 'Скопійовано код поширення.';

  @override
  String get authPassCloudOpenWithShareCodeTooltip =>
      'Відкрити за допомогою коду спільного доступу';

  @override
  String get authPassCloudShareFileActionLabel => 'Поділитись';

  @override
  String get preferenceAuthPassCloudAttachmentTitle =>
      'Використовувати вкладення AuthPass Cloud';

  @override
  String get preferenceAuthPassCloudAttachmentSubtitle =>
      'Зберігати зашифровані вкладення в AuthPass Cloud окремо.';

  @override
  String get shareCodeInputDialogTitle =>
      'Введіть секретний код спільного доступу';

  @override
  String get shareCodeInputDialogScan => 'Проскануйте QR-код';

  @override
  String get shareCodeInputLabel => 'Секретний код поширення';

  @override
  String get shareCodeInputHelperText =>
      'Якщо ви отримали код поширення, будь ласка, вставте його вище.';

  @override
  String get shareCodeOpen => 'Отримали код доступу до AuthPass Cloud?';

  @override
  String get shareCodeOpenScreenTitle =>
      'Завантаження файлу за допомогою коду спільного доступу';

  @override
  String get shareCodeLoadingProgress => 'Завантаження файлу …';

  @override
  String get shareCodeOpenFileButtonLabel => 'ВІДКРИТИ';

  @override
  String get shareCodeOpenInstallAppCaption =>
      'Хочете відкрити цей файл за допомогою однієї з наших програм?';

  @override
  String get shareCodeOpenAnotherAppCaption =>
      'Хочете відкрити цей файл на іншому пристрої?';

  @override
  String get shareCodeOpenInstallAppButtonLabel => 'Встановити додаток';

  @override
  String get shareCodeOpenShowCodeButtonLabel => 'Показати код поширення';

  @override
  String get changeMasterPasswordActionLabel => 'Змінити головний пароль';

  @override
  String get changeMasterPasswordFormSubmit => 'Зберегти з новим паролем';

  @override
  String get changeMasterPasswordSuccess =>
      'Головний пароль успішно збережено.';

  @override
  String get changeMasterPasswordScreenTitle => 'Змінити головний пароль';

  @override
  String get authPassCloudAuthClickedLink =>
      'Я отримав листа і відкрив посилання';

  @override
  String get authPassCloudAuthNotConfirmed =>
      'Адреса електронної пошти ще не підтверджена. Обов\'язково перейдіть за посиланням в отриманому листі та розгадайте капчу, щоб підтвердити свою електронну адресу.';

  @override
  String get getHelpButton => 'Отримати допомогу на форумі';

  @override
  String get shortcutCopyUsername => 'Копіювати ім\'я користувача';

  @override
  String get shortcutCopyPassword => 'Копіювати пароль';

  @override
  String get shortcutCopyTotp => 'Копіювати TOTP';

  @override
  String get shortcutMoveUp => 'Вибрати попередній пароль';

  @override
  String get shortcutMoveDown => 'Вибрати наступний пароль';

  @override
  String get shortcutGeneratePassword => 'Згенерувати пароль';

  @override
  String get shortcutCopyUrl => 'Копіювати URL-адресу';

  @override
  String get shortcutOpenUrl => 'Відкрити URL-адресу';

  @override
  String get shortcutCancelSearch => 'Скасувати пошук';

  @override
  String get shortcutShortcutHelp => 'Довідка по гарячих клавішах';

  @override
  String get shortcutHelpTitle => 'Гарячі Клавіші';

  @override
  String unexpectedError(String error) {
    return 'Неочікувана помилка: $error';
  }

  @override
  String get googleDriveMorePermissionsRequired =>
      'Additional permissions needed to access Google Drive.';

  @override
  String get googleDriveRequestPermissionButtonLabel => 'Request Permissions';

  @override
  String get scanQrCodeTitle => 'Сканувати QR-код.';
}
