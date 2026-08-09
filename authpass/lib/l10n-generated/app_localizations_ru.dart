// ignore_for_file: omit_local_variable_types,unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get fieldUserName => 'Пользователь';

  @override
  String get fieldPassword => 'Пароль';

  @override
  String get fieldWebsite => 'Сайт';

  @override
  String get fieldTitle => 'Название';

  @override
  String get fieldTotp => 'Одноразовый пароль (основанный на времени)';

  @override
  String get english => 'English';

  @override
  String get german => 'Немецкий';

  @override
  String get russian => 'Русский';

  @override
  String get ukrainian => 'Украинский';

  @override
  String get lithuanian => 'Литовский';

  @override
  String get french => 'Французский';

  @override
  String get spanish => 'Испанский';

  @override
  String get indonesian => 'Индонезийский';

  @override
  String get turkish => 'Турецкий';

  @override
  String get hebrew => 'Иврит';

  @override
  String get italian => 'итальянский';

  @override
  String get chineseSimplified => 'Китайский упрощённый';

  @override
  String get chineseTraditional => 'Китайский традиционный';

  @override
  String get portugueseBrazilian => 'Португальский, бразильский';

  @override
  String get slovak => 'Словацкий';

  @override
  String get dutch => 'Голландский';

  @override
  String get selectItem => 'Выбрать';

  @override
  String get selectKeepassFile => 'AuthPass - выберите KeePass файл';

  @override
  String get selectKeepassFileLabel => 'Выберите файл KeePass (.kdbx).';

  @override
  String get createNewFile => 'Создать новый файл';

  @override
  String get openLocalFile => 'Открыть\nлокальный файл';

  @override
  String get openFile => 'Открыть файл';

  @override
  String get loadFromDropdownMenu => 'Загрузить из …';

  @override
  String get quickUnlockingFiles => 'Быстрая разблокировка файлов…';

  @override
  String openFileProgress(Object fileName, Object current, Object totalCount) {
    return 'Открывается $fileName… ($current / $totalCount)';
  }

  @override
  String loadFrom(String cloudStorageName) {
    return 'Загрузить из $cloudStorageName';
  }

  @override
  String get loadFromRemoteUrl => 'Открыть kdbx из URL-адреса';

  @override
  String get createNewKeepass =>
      'Впервые в KeePass?\nСоздать новую базу данных паролей';

  @override
  String get labelLastOpenFiles => 'Последние открытые файлы:';

  @override
  String get noFilesHaveBeenOpenYet => 'Файлы ещё не были открыты.';

  @override
  String get preferenceSelectLanguage => 'Выберите язык';

  @override
  String get preferenceLanguage => 'Язык';

  @override
  String get preferenceTextScaleFactor => 'Коэффициент размера текста';

  @override
  String get preferenceVisualDensity => 'Плотность';

  @override
  String get preferenceTheme => 'Тема';

  @override
  String get preferenceThemeLight => 'Светлая';

  @override
  String get preferenceThemeDark => 'Тёмная';

  @override
  String get preferenceSystemDefault => 'Системные настройки';

  @override
  String get preferenceDefault => 'По умолчанию';

  @override
  String get lockAllFiles => 'Заблокировать все открытые файлы';

  @override
  String get preferenceAllowScreenshots =>
      'Разрешить делать скриншоты приложения';

  @override
  String get preferenceEnableAutoFill => 'Включить автозаполнение';

  @override
  String get enableAutofillSuggestionBanner =>
      'Вы можете заполнить поле другого приложения, включив автозаполнение!';

  @override
  String get dismissAutofillSuggestionBannerButton => 'ОТКЛЮЧИТЬ';

  @override
  String get enableAutofillSuggestionBannerButton => 'Включить!';

  @override
  String get preferenceAutoFillDescription =>
      'Поддерживается с Android Oreo (8.0) или более поздней версии.';

  @override
  String get preferenceTitle => 'Настройки';

  @override
  String get preferenceEnableSystemWideShortcuts =>
      'Включить общесистемные ярлыки';

  @override
  String get preferenceEnableSystemWideShortcutsHelp =>
      'Регистрирует сочетание клавиш ctrl+alt+f в качестве общесистемного ярлыка для открытия поиска.';

  @override
  String get preferencesSearchFields => 'Настройка полей поиска';

  @override
  String get preferencesSearchFieldPromptTitle => 'Поля поиска';

  @override
  String get preferencesSearchFieldPromptLabel =>
      'Список полей, разделенных запятыми, для использования в поиске по списку паролей.';

  @override
  String preferencesSearchFieldPromptHelp(
    Object wildCardCharacter,
    Object defaultSearchFields,
  ) {
    return 'Используйте $wildCardCharacter для всех, оставьте пустым по умолчанию ($defaultSearchFields)';
  }

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback => 'Мы рады любым отзывам!';

  @override
  String get aboutLinkVisitWebsite => 'Не забудьте посетить наш сайт';

  @override
  String get aboutLinkGitHub => 'И исходный код проекта';

  @override
  String aboutLogFile(String logFilePath) {
    return 'Файл журнала: $logFilePath';
  }

  @override
  String get aboutLinkContributors => 'Показать участников';

  @override
  String get unableToLaunchUrlTitle => 'Не удается открыть Url';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'Не удалось запустить $url: $openError';
  }

  @override
  String get unableToLaunchUrlNoHandler => 'Нет доступных приложений для url.';

  @override
  String launchedUrl(Object url) {
    return 'Открытый URL: $url';
  }

  @override
  String get menuItemGeneratePassword => 'Сгенерировать пароль';

  @override
  String get menuItemPreferences => 'Настройки';

  @override
  String get menuItemOpenAnotherFile => 'Открыть другой файл';

  @override
  String get menuItemCheckForUpdates => 'Проверить обновления';

  @override
  String get menuItemSupport => 'Отправить журнал';

  @override
  String get menuItemSupportSubtitle =>
      'Отправлять журналы по электронной почте';

  @override
  String get menuItemForum => 'Форум поддержки';

  @override
  String get menuItemForumSubtitle => 'Сообщить о проблемах и получить помощь';

  @override
  String get menuItemHelp => 'Помощь';

  @override
  String get menuItemHelpSubtitle => 'Показать документацию';

  @override
  String get menuItemAbout => 'О программе';

  @override
  String get actionOpenUrl => 'Открыть URL-адрес';

  @override
  String get passwordPlainText => 'Показать пароль';

  @override
  String get generatorPassword => 'Пароль';

  @override
  String get generatePassword => 'Сгенерировать пароль';

  @override
  String get doneButtonLabel => 'Готово';

  @override
  String get useAsDefault => 'По умолчанию';

  @override
  String get characterSetLowerCase => 'Строчные буквы (а-я)';

  @override
  String get characterSetUpperCase => 'Прописные буквы (А-Я)';

  @override
  String get characterSetNumeric => 'Числа (0-9)';

  @override
  String get characterSetUmlauts => 'Умляуты (ä)';

  @override
  String get characterSetSpecial => 'Специальные (@%+)';

  @override
  String get length => 'Длина';

  @override
  String get customLength => 'Своя длина';

  @override
  String customLengthHelperText(Object customMinLength) {
    return 'Только для длины > $customMinLength';
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
      other: '$numFilesString файлов сохранено: $files',
      one: 'Сохранён один файл: $files',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => 'Управление группами';

  @override
  String get lockFiles => 'Заблокировать';

  @override
  String get searchHint => 'Поиск';

  @override
  String get searchButtonLabel => 'Поиск';

  @override
  String get filterButtonLabel => 'Фильтр по группе';

  @override
  String get clear => 'Очистить';

  @override
  String get autofillFilterPrefix => 'Фильтр:';

  @override
  String get autofillMatchPrefix => 'Matching entries for:';

  @override
  String get autofillPrompt => 'Выберите пароль для автозаполнения.';

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена.';

  @override
  String get noTitle => '(без заголовка)';

  @override
  String get noUsername => '(без имени пользователя)';

  @override
  String get filterCustomize => 'Настройка …';

  @override
  String get swipeCopyPassword => 'Копировать пароль';

  @override
  String get swipeCopyUsername => 'Копировать имя пользователя';

  @override
  String get copyUsernameNotExists => 'Имя пользователя не определено.';

  @override
  String get copyPasswordNotExists => 'Пароль не определен.';

  @override
  String get doneCopiedPassword => 'Пароль скопирован в буфер обмена.';

  @override
  String get doneCopiedUsername =>
      'Имя пользователя скопировано в буфер обмена.';

  @override
  String get doneCopiedField => 'Скопировано.';

  @override
  String copiedFieldToClipboard(Object fieldName) {
    return '$fieldName скопировано.';
  }

  @override
  String copiedFieldEmpty(Object fieldName) {
    return '$fieldName пустое.';
  }

  @override
  String get emptyPasswordVaultPlaceholder =>
      'У Вас ещё нет паролей в вашей базе данных.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Создайте ваш первый Пароль';

  @override
  String get loading => 'Загрузка';

  @override
  String get loadingFile => 'Загрузка файла …';

  @override
  String get internalFile => 'Локальный файл';

  @override
  String get internalFileSubtitle => 'База данных ранее созданная с AuthPass';

  @override
  String get filePicker => 'Выбор Файла';

  @override
  String get filePickerSubtitle => 'Откройте файл с устройства.';

  @override
  String get credentialsAppBarTitle => 'Учетные данные';

  @override
  String get credentialLabel => 'Введите пароль для:';

  @override
  String get masterPasswordInputLabel => 'Пароль';

  @override
  String get masterPasswordEmptyValidator => 'Пожалуйста, введите Ваш пароль.';

  @override
  String get masterPasswordIncorrectValidator => 'Неверный пароль';

  @override
  String get useKeyFile => 'Использовать файл Ключа';

  @override
  String get saveMasterPasswordBiometric =>
      'Сохранить пароль с биометрической разблокировкой?';

  @override
  String get close => 'Закрыть';

  @override
  String get addNewPassword => 'Добавить Новый Пароль';

  @override
  String get errorOpenFileInvalidFileStructureTitle =>
      'Попытка открыть файл неверного типа';

  @override
  String errorOpenFileInvalidFileStructureBody(Object fileName) {
    return 'Кажется, файл ($fileName) не является валидным файлом KDBX. Пожалуйста, выберите валидный файл KDBX, или создайте новую базу данных паролей.';
  }

  @override
  String get errorOpenFileAlreadyOpenTitle => 'Файл уже открыт';

  @override
  String errorOpenFileAlreadyOpenBody(
    Object databaseName,
    Object openFileSource,
    Object newFileSource,
  ) {
    return 'Выбранная база данных $databaseName уже открыта через $openFileSource (Была попытка открыть её через $newFileSource)';
  }

  @override
  String get loadFromUrl => 'Скачать через URL';

  @override
  String get loadFromUrlEnterUrl => 'Введите URL';

  @override
  String get loadFromUrlErrorEnterFullUrl =>
      'Пожалуйста, введиье полный url начинающийся с http:// или http://';

  @override
  String get loadFromUrlErrorInvalidUrl =>
      'Пожалуйста, введите правильный url.';

  @override
  String get linuxAppArmorWarning =>
      'AuthPass нужны разрешения для взаимодействия с Сервисом Паролей для сохранения учётных данных для облачных хранилищ.\nПожалуйста, введите следующую комманду:';

  @override
  String get cancel => 'Отмена';

  @override
  String get errorLoadFileFromSourceTitle => 'Ошибка во время открытия файла.';

  @override
  String errorLoadFileFromSourceBody(Object source, Object error) {
    return 'Не удалось открыть $source.\n$error';
  }

  @override
  String get errorUnlockFileTitle => 'Не удается открыть файл';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Неизвестная ошибка при попытке открыть файл. $error';
  }

  @override
  String get dialogContinue => 'Продолжить';

  @override
  String get dialogSendErrorReport => 'Отправить отчет об ошибке';

  @override
  String get dialogReportErrorForum => 'Сообщить об ошибке на форум/справка';

  @override
  String get groupFilterDescription =>
      'Выберите, какие группы показывать (рекурсивно)';

  @override
  String get groupFilterSelectAll => 'Выбрать все';

  @override
  String get groupFilterDeselectAll => 'Отменить выбор';

  @override
  String get createSubgroup => 'Создать подгруппу';

  @override
  String get editAction => 'Редактирование';

  @override
  String get mailboxEnableLabel => '(повторно) включить';

  @override
  String get mailboxEnableHint => 'Продолжить получение писем';

  @override
  String get mailboxDisableLabel => 'Отключить';

  @override
  String get mailboxDisableHint => 'Больше не получать электронные письма';

  @override
  String get mailListNoMail => 'У вас пока нет ни одного письма.';

  @override
  String mailboxLabelPrefixForEntry(Object entryLabel) {
    return 'Вход: $entryLabel';
  }

  @override
  String mailboxLabelPrefixUnknownEntry(Object entryUuid) {
    return 'Неизвестная запись: $entryUuid';
  }

  @override
  String mailboxLabelPrefixCreatedAt(Object dateTime) {
    return 'Создано: $dateTime';
  }

  @override
  String get masterPasswordDescription =>
      'Мастер-пароль используется для безопасного шифрования базы данных паролей. Обязательно запомните его, восстановить его будет невозможно.';

  @override
  String get unsavedChangesWarningTitle => 'Несохраненные изменения';

  @override
  String get unsavedChangesWarningBody =>
      'Есть все еще несохраненные изменения. Вы хотите отменить изменения?';

  @override
  String get unsavedChangesDiscardActionLabel => 'Отменить изменения';

  @override
  String get deletePermanentlyAction => 'Удалить навсегда';

  @override
  String get restoreFromRecycleBinAction => 'Восстановить';

  @override
  String get deleteAction => 'Удалить';

  @override
  String get deletedEntry => 'Запись удалена.';

  @override
  String get successfullyDeletedGroup => 'Группа удалена.';

  @override
  String get undoButtonLabel => 'Отменить';

  @override
  String get saveButtonLabel => 'Сохранить';

  @override
  String get webDavSettings => 'Настройки WebDAV';

  @override
  String get webDavUrlLabel => 'URL-адрес';

  @override
  String get webDavUrlHelperText => 'Базовый Url-адрес вашего сервиса WebDAV.';

  @override
  String get webDavUrlValidatorError => 'Пожалуйста, введите URL';

  @override
  String get webDavUrlValidatorInvalidUrlError =>
      'Пожалуйста, введите правильный url с http:// или https://';

  @override
  String get webDavAuthUser => 'Имя пользователя';

  @override
  String get webDavAuthPassword => 'Пароль';

  @override
  String get mergeSuccessDialogTitle =>
      'База данных паролей успешно объединена';

  @override
  String mergeSuccessDialogMessage(Object fileName, Object mergeSummary) {
    return 'Конфликт при сохранении $fileName, он был успешно объединён с удаленным файлом: \n\n$mergeSummary';
  }

  @override
  String forDetailsVisitUrl(Object url) {
    return 'Для получения подробной информации посетите $url';
  }

  @override
  String get authPassCloudAuthEmailInputLabel =>
      'Введите адрес электронной почты для регистрации или входа.';

  @override
  String get authPassCloudAuthEmailInvalid =>
      'Пожалуйста, введите правильный адрес электронной почты.';

  @override
  String get authPassCloudAuthConfirmEmailButtonLabel => 'Подтвердите адрес';

  @override
  String get authPassCloudAuthConfirmEmail =>
      'Пожалуйста, проверьте вашу электронную почту, чтобы подтвердить ваш адрес электронной почты.';

  @override
  String get authPassCloudAuthConfirmEmailExplain =>
      'Держите этот экран открытым, пока вы не перешли по ссылке, которую вы получили по электронной почте.';

  @override
  String get authPassCloudAuthResendExplain =>
      'Если вы не получили электронное письмо, пожалуйста, проверьте папку со спамом. В противном случае вы можете попробовать запросить новую ссылку для подтверждения.';

  @override
  String get authPassCloudAuthResendButtonLabel =>
      'Запросить новую ссылку для подтверждения';

  @override
  String permanentlyDeleteEntryConfirm(Object title) {
    return 'Это навсегда удалит запись с паролем $title. Это действие не может быть отменено. Вы хотите продолжить?';
  }

  @override
  String get permanentlyDeletedEntrySnackBar => 'Запись окончательно удалена.';

  @override
  String get initialNewGroupName => 'Новая группа';

  @override
  String get deleteGroupErrorTitle => 'Не удается удалить группу';

  @override
  String get deleteGroupErrorBodyContainsGroup =>
      'Эта группа все еще содержит другие группы. Вы можете удалить только пустые группы.';

  @override
  String get deleteGroupErrorBodyContainsEntries =>
      'Эта группа по-прежнему содержит записи с паролем. Вы можете удалить только пустые группы.';

  @override
  String get groupListAppBarTitle => 'Группы';

  @override
  String get groupListFilterAppbarTitle => 'Фильтр по группам';

  @override
  String get clearQuickUnlock => 'Очистить Биометрическое Хранилище';

  @override
  String get clearQuickUnlockSubtitle => 'Удалить сохраненные мастер-пароли';

  @override
  String get unlock => 'Разблокировать';

  @override
  String get closePasswordFiles => 'закрыть базу';

  @override
  String get clearQuickUnlockSuccess =>
      'Сохраненные мастер-пароли удалены из биометрического хранилища.';

  @override
  String get diacOptIn => 'Подпишитесь на Новости о приложении, Опросы.';

  @override
  String get diacOptInSubtitle =>
      'Время от времени будет отправлять сетевой запрос для получения новостей.';

  @override
  String browserAutofillThirdPartyModeTitle(String browserName) {
    return 'Enable AutoFill in $browserName';
  }

  @override
  String browserAutofillThirdPartyModeSubtitle(String browserName) {
    return '$browserName currently uses its own password manager. Tap to open its settings and select “Autofill using another service”, then restart $browserName.';
  }

  @override
  String get enableAutofillDebug => 'Автозаполнение: Включить отладку';

  @override
  String get enableAutofillDebugSubtitle =>
      'Показывает информационные слои для каждого поля ввода';

  @override
  String get createPasswordDatabase => 'Создать базу данных паролей';

  @override
  String get nameNewPasswordDatabase => 'Имя вашей новой базы данных';

  @override
  String get validatorNameMissing =>
      'Пожалуйста, введите имя для вашей новой базы данных.';

  @override
  String get masterPasswordHelpText =>
      'Выберите мастер-пароль. Не забудьте его запомнить.';

  @override
  String get inputMasterPasswordText => 'Мастер-пароль';

  @override
  String get masterPasswordMissingCreate =>
      'Пожалуйста, введите безопасный, запоминающийся пароль.';

  @override
  String get createDatabaseAction => 'Создать базу данных';

  @override
  String get databaseExistsError => 'Файл уже существует';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'Ошибка во время создания базы данных $filePath. Файл уже существует. Пожалуйста, выберите другое имя.';
  }

  @override
  String get databaseCreateDefaultName => 'Личные Пароли';

  @override
  String get preferenceDynamicLoadIcons => 'Динамически загружать иконки';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'Будут посылаться http запросы со значением поля $urlFieldName для загрузки иконок сайтов.';
  }

  @override
  String passwordScore(Object score) {
    return 'Надежность: $score из 4';
  }

  @override
  String get entryInfoFile => 'Файл:';

  @override
  String get entryInfoGroup => 'Группа:';

  @override
  String get entryInfoLastModified => 'Последняя дата изменения:';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'Перемещена запись в $groupName';
  }

  @override
  String sizeBytesStoredAuthPassCloud(Object count) {
    return '$count байт, сохранено в облаке AuthPass';
  }

  @override
  String sizeBytes(Object count) {
    return '$count байтов';
  }

  @override
  String get entryAddAttachment => 'Добавить вложение';

  @override
  String get entryAttachmentSizeWarning =>
      'Вложенные файлы будут встроены в файл пароля. Это может значительно увеличить время необходимое для открытия/сохранения паролей.';

  @override
  String get iconPngSizeWarning =>
      'Пользовательские значки будут встроены в файл пароля. Это может значительно увеличить время, необходимое для открытия/сохранения паролей.';

  @override
  String get notPngError => 'Выбранный файл не является PNG.';

  @override
  String get entryAddField => 'Добавить поле';

  @override
  String get entryCustomField => 'Настраиваемое поле';

  @override
  String get entryCustomFieldTitle => 'Добавление нового настраиваемого поля';

  @override
  String get entryCustomFieldInputLabel => 'Введите имя поля';

  @override
  String get swipeCopyField => 'Скопировать поле';

  @override
  String get fieldRename => 'Переименовать';

  @override
  String get fieldGeneratePassword => 'Сгенерировать пароль …';

  @override
  String get fieldProtect => 'Защитить значение';

  @override
  String get fieldUnprotect => 'Не защищать значение';

  @override
  String get fieldPresent => 'Показать';

  @override
  String get fieldGenerateEmail => 'Сгенерировать почту';

  @override
  String get onboardingBackToOnboarding => 'Тур';

  @override
  String get onboardingBackToOnboardingSubtitle =>
      'Переживите опыт первого запуска 😅️';

  @override
  String get onboardingHeadline => 'Давайте обезопасим Ваши пароли!';

  @override
  String get onboardingQuestion => 'Вы использовали менеджер паролей раньше?';

  @override
  String get onboardingYesOpenPasswords => 'Да, открыть мои пароли';

  @override
  String get onboardingNoCreate => 'Я новичок! Научите меня.';

  @override
  String get backupButton => 'СОХРАНИТЬ В ОБЛАКО';

  @override
  String get dismissBackupButton => 'ОТКЛОНИТЬ';

  @override
  String backupWarningMessage(Object databasename) {
    return 'Ваши пароли в $databasename сохранены только локально!';
  }

  @override
  String get saveAs => 'Сохранить в...';

  @override
  String get saving => 'Сохранение';

  @override
  String get increaseValue => 'Увеличить';

  @override
  String get decreaseValue => 'Уменьшить';

  @override
  String get resetValue => 'Сбросить';

  @override
  String cloudStorageAppBarTitle(Object cloudStorageName) {
    return 'Облачное Хранилище - $cloudStorageName';
  }

  @override
  String get cloudStorageLogInCaption =>
      'Вы будете перенаправлены чтобы авторизовать AuthPass для доступа к вашим данным.';

  @override
  String get cloudStorageLogInCode => 'Введите код';

  @override
  String launchUrlError(Object url) {
    return 'Невозможно открыть url. Пожалуйста, откройте $url';
  }

  @override
  String cloudStorageLogInActionLabel(Object cloudStorageName) {
    return 'Войдите в $cloudStorageName';
  }

  @override
  String cloudStorageAuthCodeDialogTitle(Object cloudStorageName) {
    return 'Аутентификация $cloudStorageName';
  }

  @override
  String get cloudStorageAuthCodeLabel => 'Код аутентификации';

  @override
  String get cloudStorageAuthErrorTitle => 'Ошибка при аутентификации';

  @override
  String cloudStorageAuthErrorMessage(
    Object cloudStorageName,
    Object errorMessage,
  ) {
    return 'Ошибка при попытке аутентификации в $cloudStorageName: $errorMessage';
  }

  @override
  String get cloudStorageSearchBoxLabel => 'Поисковый запрос';

  @override
  String cloudStorageItemsInFolder(Object itemCount) {
    return '$itemCount элементов в этой папке.';
  }

  @override
  String get mailSubject => 'Тема';

  @override
  String get mailFrom => 'Из';

  @override
  String get mailDate => 'Дата';

  @override
  String get mailMailbox => 'Почтовый ящик';

  @override
  String get mailNoData => 'Нет данных';

  @override
  String get mailMailboxesTitle => 'Почтовые ящики';

  @override
  String get mailboxCreateButtonLabel => 'Создать';

  @override
  String get mailboxNameInputDialogTitle =>
      'При необходимости метка для нового почтового ящика';

  @override
  String get mailboxNameInputLabel => '(внутренняя) Метка';

  @override
  String get mailScreenTitle => 'Почта AuthPass';

  @override
  String get mailTabBarTitleMailbox => 'Почтовый ящик';

  @override
  String get mailTabBarTitleMail => 'Почта';

  @override
  String get mailMailboxListEmpty => 'У вас еще нет почтовых ящиков.';

  @override
  String mailMailboxAddressCopied(Object mailboxAddress) {
    return 'Адрес почтового ящика скопирован в буфер обмена: $mailboxAddress';
  }

  @override
  String get errorWhileSavingTitle => 'Ошибка при сохранении';

  @override
  String errorWhileSavingBody(Object errorMessage) {
    return 'Не удалось сохранить файл: $errorMessage';
  }

  @override
  String get databaseDoesNotSupportSaving =>
      'Извините, эта база данных не поддерживает сохранение. Пожалуйста, откройте локальный файл базы данных. Или используйте \"Сохранить как\".';

  @override
  String get otpInvalidKeyTitle => 'Неверный ключ';

  @override
  String get otpInvalidKeyBody =>
      'Данный ввод не является допустимым кодом TOTP base32. Пожалуйста, проверьте введённые данные.';

  @override
  String get otpUnsupportedMigrationTitle => 'Unsupported OTP Migration';

  @override
  String otpUnsupportedMigrationBody(Object uriCount) {
    return 'We currently only support single item migrations. Got $uriCount';
  }

  @override
  String get otpPromptTitle => 'Аутентификация на основе времени';

  @override
  String get otpPromptHelperText =>
      'Пожалуйста, введите ключ, основанный на времени.';

  @override
  String otpErrorMessageGeneration(Object errorMessage) {
    return 'Ошибка при создании кода приглашения: $errorMessage';
  }

  @override
  String get otpCopySecretActionLabel => 'Копировать секрет';

  @override
  String get otpEntryLabel => 'Одноразовый токен';

  @override
  String get entryFieldProtected => 'Защищенное поле. Нажмите, чтобы открыть.';

  @override
  String get entryFieldActionRevealField => 'Показать защищённое поле';

  @override
  String get entryAttachmentOpenActionLabel => 'Открыть';

  @override
  String get entryAttachmentShareActionLabel => 'Поделиться';

  @override
  String get entryAttachmentShareSubject => 'Вложение';

  @override
  String get entryAttachmentSaveActionLabel => 'Сохранить на устройство';

  @override
  String get entryAttachmentRemoveActionLabel => 'Удалить';

  @override
  String entryAttachmentRemoveConfirm(Object attachmentLabel) {
    return 'Вы действительно хотите удалить $attachmentLabel?';
  }

  @override
  String get entryRenameFieldPromptTitle => 'Переименование поля';

  @override
  String get removerecentfile => 'Скрыть';

  @override
  String get entryRenameFieldPromptLabel => 'Введите новое имя для поля';

  @override
  String get promptDialogPasteActionTooltip => 'Вставить из буфера обмена';

  @override
  String get promptDialogPasteHint =>
      'Подсказка: Если вам нужно вставить, попробуйте кнопку слева ;-)';

  @override
  String get genericErrorDialogTitle => 'Ошибка при обработке действия';

  @override
  String genericErrorDialogBody(Object errorMessage) {
    return 'Произошла непредвиденная ошибка. $errorMessage';
  }

  @override
  String get saveAsEntryLocalFile => 'Локальный файл';

  @override
  String get fileTypePngs => 'Изображения (png)';

  @override
  String get selectIconDialogAction => 'ВЫБЕРИТЕ ЗНАЧОК';

  @override
  String get retryDialogActionLabel => 'Повторить';

  @override
  String errorDuringNetworkCall(Object errorMessage) {
    return 'Ошибка во время api вызова. $errorMessage';
  }

  @override
  String get passwordFilterHideDeleted => 'Скрыть удалённые записи';

  @override
  String get passwordFilterOnlyDeleted => 'Удалённые записи';

  @override
  String passwordFilterPrefixForOneGroup(Object groupName) {
    return 'Группа: $groupName';
  }

  @override
  String passwordFilterPrefixForMultipleGroups(Object groupCount) {
    return 'Кастомный фильтр ($groupCount групп)';
  }

  @override
  String get menuItemAuthPassCloudAuthenticate =>
      'Авторизоваться с AuthPass Cloud';

  @override
  String get menuItemAuthPassCloudMailboxes => 'Почтовые ящики AuthPass';

  @override
  String changesWithoutSaving(Object fileName) {
    return 'У вас есть изменения в \"$fileName\", которые не поддерживают запись изменений.';
  }

  @override
  String get changesSaveLocally => 'Сохранить локально';

  @override
  String get clearColor => 'Очистить цвет';

  @override
  String get databaseRenameInputLabel => 'Введите имя базы данных';

  @override
  String get databasePath => 'Путь';

  @override
  String get databaseColor => 'Цвет';

  @override
  String get databaseColorChoose =>
      'Выберите цвет, чтобы отличать среди файлов.';

  @override
  String get databaseKdbxVersion => 'Версия файла KDBX';

  @override
  String databaseKdbxUpgradeVersion(Object versionName) {
    return 'Обновите до $versionName';
  }

  @override
  String get databaseKdbxUpgradeSuccessful =>
      'Файл успешно обновлён и сохранён.';

  @override
  String get databaseReload => 'Обновить и слить';

  @override
  String progressStatus(Object statusProgress) {
    return 'Статус: $statusProgress';
  }

  @override
  String finishedMerge(Object status) {
    return 'Закончено слитие $status';
  }

  @override
  String get closeAndLockFile => 'Закрыть/заблокровать';

  @override
  String get authPassHomeScreenTagline =>
      'менеджер паролей, с открым исходных кодом, доступный на всех платформах.';

  @override
  String get addNewPasswordButtonLabel => 'Добавить новый пароль';

  @override
  String get unnamedEntryPlaceholder => '(Безымянный)';

  @override
  String get unnamedGroupPlaceholder => '(Безымянный)';

  @override
  String get unnamedFilePlaceholder => '(Безымянный)';

  @override
  String get editGroupScreenTitle => 'Редактировать группу';

  @override
  String get editGroupGroupNameLabel => 'Имя группы';

  @override
  String get files => 'Файлы';

  @override
  String get newGroupDialogTitle => 'Новая группа';

  @override
  String get newGroupDialogInputLabel => 'Имя новой группы';

  @override
  String get groupActionShowPasswords => 'Показать пароли';

  @override
  String get groupActionDelete => 'Удалить';

  @override
  String get logoutTooltip => 'Выйти';

  @override
  String get successfullyDeletedFileCloudStorage => 'Файл успешно удалён.';

  @override
  String shareDialogTitle(Object fileName) {
    return 'Опции общего доступа для $fileName';
  }

  @override
  String get shareFileActionLabel => 'Поделиться …';

  @override
  String get shareTokenListEmptyScreenPlaceholder =>
      'Вы ещё не поделились файлом.';

  @override
  String get shareTokenNoLabel => 'Нет метки/описания';

  @override
  String get shareTokenReadWrite => 'Чтение/запись';

  @override
  String get shareTokenReadOnly => 'Только чтение';

  @override
  String get shareCreateTokenDialogTitle => 'Поделиться файлом';

  @override
  String get shareCreateTokenReadOnly => 'Только чтение';

  @override
  String get shareCreateTokenReadOnlyHelpText =>
      'Не разрешать сохранение изменений';

  @override
  String get shareCreateTokenLabelText => 'Описание';

  @override
  String get shareCreateTokenLabelHint => 'Поделиться с моим другом';

  @override
  String get shareCreateTokenLabelHelp =>
      'Не обязательная метка чтобы различать код общего доступа.';

  @override
  String get shareCreateTokenSuccess => 'Успешно создан код общего доступа.';

  @override
  String get sharePresentDialogTitle =>
      'Поделиться файлом используя код общего доступа';

  @override
  String get sharePresentDialogHelp =>
      'Используя этот код общего доступа пользователи могут иметь доступ к файлу паролей. Им нужен будет пароль и/или файл ключа чтобы открыть его.';

  @override
  String get sharePresentToken => 'Код доступа';

  @override
  String get sharePresentCopied => 'Код доступа скопирован в буфер обмена.';

  @override
  String get authPassCloudOpenWithShareCodeTooltip =>
      'Открыть с помощью кода общего доступа';

  @override
  String get authPassCloudShareFileActionLabel => 'Поделиться';

  @override
  String get preferenceAuthPassCloudAttachmentTitle =>
      'Использовать облачные вложения AuthPass';

  @override
  String get preferenceAuthPassCloudAttachmentSubtitle =>
      'Хранить вложения, зашифрованные в облаке AuthPass, отдельно.';

  @override
  String get shareCodeInputDialogTitle => 'Ввести секретный код доступа';

  @override
  String get shareCodeInputDialogScan => 'Сканировать QR-код';

  @override
  String get shareCodeInputLabel => 'Секретный код доступа';

  @override
  String get shareCodeInputHelperText =>
      'Если вы получили код доступа, вставьте его выше.';

  @override
  String get shareCodeOpen => 'Получен код доступа для AuthPass Cloud?';

  @override
  String get shareCodeOpenScreenTitle => 'Загрузка файла с кодом доступа';

  @override
  String get shareCodeLoadingProgress => 'Загрузка файла …';

  @override
  String get shareCodeOpenFileButtonLabel => 'Открыть';

  @override
  String get shareCodeOpenInstallAppCaption =>
      'Хотите вместо этого открыть этот файл с помощью одного из наших собственных приложений?';

  @override
  String get shareCodeOpenAnotherAppCaption =>
      'Хотите открыть этот файл на другом устройстве?';

  @override
  String get shareCodeOpenInstallAppButtonLabel => 'Установить приложение';

  @override
  String get shareCodeOpenShowCodeButtonLabel => 'Показать код общего доступа';

  @override
  String get changeMasterPasswordActionLabel => 'Изменить мастер-пароль';

  @override
  String get changeMasterPasswordFormSubmit => 'Сохранить с новым паролем';

  @override
  String get changeMasterPasswordSuccess => 'Пароль успешно сохранен.';

  @override
  String get changeMasterPasswordScreenTitle => 'Изменить мастер-пароль';

  @override
  String get authPassCloudAuthClickedLink =>
      'Я получил электронную почту и посетил ссылку';

  @override
  String get authPassCloudAuthNotConfirmed =>
      'Адрес электронной почты еще не подтвержден. Обязательно нажмите ссылку в полученном электронном письме и введите код, чтобы подтвердить свой адрес электронной почты.';

  @override
  String get getHelpButton => 'Получить помощь на форуме';

  @override
  String get shortcutCopyUsername => 'Копировать имя пользователя';

  @override
  String get shortcutCopyPassword => 'Копировать пароль';

  @override
  String get shortcutCopyTotp => 'Копировать TOTP';

  @override
  String get shortcutMoveUp => 'Выбрать предыдущий пароль';

  @override
  String get shortcutMoveDown => 'Выбрать следующий пароль';

  @override
  String get shortcutGeneratePassword => 'Сгенерировать пароль';

  @override
  String get shortcutCopyUrl => 'Копировать URL';

  @override
  String get shortcutOpenUrl => 'Открыть URL-адрес';

  @override
  String get shortcutCancelSearch => 'Отменить поиск';

  @override
  String get shortcutShortcutHelp => 'Справка по сочетанию клавиш';

  @override
  String get shortcutHelpTitle => 'Горячие клавиши';

  @override
  String unexpectedError(String error) {
    return 'Неожиданная ошибка: $error';
  }

  @override
  String get googleDriveMorePermissionsRequired =>
      'Additional permissions needed to access Google Drive.';

  @override
  String get googleDriveRequestPermissionButtonLabel => 'Request Permissions';

  @override
  String get scanQrCodeTitle => 'Scan QR Code.';
}
