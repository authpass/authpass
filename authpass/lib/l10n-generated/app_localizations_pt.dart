// ignore_for_file: omit_local_variable_types,unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get fieldUserName => 'Usuário';

  @override
  String get fieldPassword => 'Palavra-passe';

  @override
  String get fieldWebsite => 'Website';

  @override
  String get fieldTitle => 'Título';

  @override
  String get fieldTotp => 'Senha Única (Baseado no Tempo)';

  @override
  String get english => 'Inglês';

  @override
  String get german => 'Alemão';

  @override
  String get russian => 'Russo';

  @override
  String get ukrainian => 'Ucraniano';

  @override
  String get lithuanian => 'Lituano';

  @override
  String get french => 'Francês';

  @override
  String get spanish => 'Espanhol';

  @override
  String get indonesian => 'Indonésio';

  @override
  String get turkish => 'Turco';

  @override
  String get hebrew => 'Hebraico';

  @override
  String get italian => 'Italiano';

  @override
  String get chineseSimplified => 'Chinês simplificado';

  @override
  String get chineseTraditional => 'Chinês tradicional';

  @override
  String get portugueseBrazilian => 'Português brasileiro';

  @override
  String get slovak => 'Eslovaco';

  @override
  String get dutch => 'Holandês';

  @override
  String get selectItem => 'Selecionar';

  @override
  String get selectKeepassFile => 'AuthPass - Selecionar arquivo KeePass';

  @override
  String get selectKeepassFileLabel =>
      'Por favor, selecione um arquivo KeePass (.kdbx)';

  @override
  String get createNewFile => 'Criar novo arquivo';

  @override
  String get openLocalFile => 'Abrir\nArquivo Local';

  @override
  String get openFile => 'Abrir arquivo';

  @override
  String get loadFromDropdownMenu => 'Carregar de …';

  @override
  String get quickUnlockingFiles => 'Desbloqueio rápido de arquivos …';

  @override
  String openFileProgress(Object fileName, Object current, Object totalCount) {
    return 'Abrindo $fileName … ($current / $totalCount)';
  }

  @override
  String loadFrom(String cloudStorageName) {
    return 'Carregar de $cloudStorageName';
  }

  @override
  String get loadFromRemoteUrl => 'Abrir kdbx de URL';

  @override
  String get createNewKeepass =>
      'Novo no KeePass?\nCriar nova base de dados de senhas';

  @override
  String get labelLastOpenFiles => 'Últimos arquivos abertos:';

  @override
  String get noFilesHaveBeenOpenYet => 'Nenhum arquivo foi aberto ainda.';

  @override
  String get preferenceSelectLanguage => 'Selecione o idioma';

  @override
  String get preferenceLanguage => 'Língua';

  @override
  String get preferenceTextScaleFactor => 'Fator de Escala de Texto';

  @override
  String get preferenceVisualDensity => 'Densidade visual';

  @override
  String get preferenceTheme => 'Tema';

  @override
  String get preferenceThemeLight => 'Claro';

  @override
  String get preferenceThemeDark => 'Escuro';

  @override
  String get preferenceSystemDefault => 'Padrão do Sistema';

  @override
  String get preferenceDefault => 'Predefinição';

  @override
  String get lockAllFiles => 'Bloquear todos os arquivos abertos';

  @override
  String get preferenceAllowScreenshots => 'Permitir capturas de tela do App';

  @override
  String get preferenceEnableAutoFill => 'Ativar preenchimento automático';

  @override
  String get enableAutofillSuggestionBanner =>
      'Você pode preencher o campo de outra aplicação ativando o preenchimento automático!';

  @override
  String get dismissAutofillSuggestionBannerButton => 'Dispensar';

  @override
  String get enableAutofillSuggestionBannerButton => 'ATIVAR!';

  @override
  String get preferenceAutoFillDescription =>
      'Suportado somente no Android Oreo (8.0) ou superior.';

  @override
  String get preferenceTitle => 'Preferências';

  @override
  String get preferenceEnableSystemWideShortcuts =>
      'Enable system wide shortcuts';

  @override
  String get preferenceEnableSystemWideShortcutsHelp =>
      'Registers ctrl+alt+f as system wide shortcut to open search.';

  @override
  String get preferencesSearchFields => 'Personalizar os Campos de Pesquisa';

  @override
  String get preferencesSearchFieldPromptTitle => 'Campos de pesquisa';

  @override
  String get preferencesSearchFieldPromptLabel =>
      'Comma separated list of fields to use in the password list search.';

  @override
  String preferencesSearchFieldPromptHelp(
    Object wildCardCharacter,
    Object defaultSearchFields,
  ) {
    return 'Use $wildCardCharacter for all, leave empty for default ($defaultSearchFields)';
  }

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
    return 'Log File: $logFilePath';
  }

  @override
  String get aboutLinkContributors => 'Show Contributors';

  @override
  String get unableToLaunchUrlTitle => 'Unable to open Url';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'Unable to launch $url: $openError';
  }

  @override
  String get unableToLaunchUrlNoHandler => 'No application available for url.';

  @override
  String launchedUrl(Object url) {
    return 'Opened URL: $url';
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
  String get menuItemSupport => 'Send logs';

  @override
  String get menuItemSupportSubtitle => 'Send logs by email';

  @override
  String get menuItemForum => 'Support Forum';

  @override
  String get menuItemForumSubtitle => 'Report Problems and get help';

  @override
  String get menuItemHelp => 'Help';

  @override
  String get menuItemHelpSubtitle => 'Show documentation';

  @override
  String get menuItemAbout => 'Sobre';

  @override
  String get actionOpenUrl => 'Abrir URL';

  @override
  String get passwordPlainText => 'Mostrar senha';

  @override
  String get generatorPassword => 'Senha';

  @override
  String get generatePassword => 'Gerar Senha';

  @override
  String get doneButtonLabel => 'Concluído';

  @override
  String get useAsDefault => 'Usar como Padrão';

  @override
  String get characterSetLowerCase => 'Minúsculas (a-z)';

  @override
  String get characterSetUpperCase => 'Maiúsculas (A-Z)';

  @override
  String get characterSetNumeric => 'Números (0-9)';

  @override
  String get characterSetUmlauts => 'Trema (ä)';

  @override
  String get characterSetSpecial => 'Caracteres especiais (@%+)';

  @override
  String get length => 'Tamanho';

  @override
  String get customLength => 'Tamanho personalizado';

  @override
  String customLengthHelperText(Object customMinLength) {
    return 'Only used for length > $customMinLength';
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
      other: '$numFilesString files saved: $files',
      one: 'One file saved: $files',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => 'Gerenciar Grupos';

  @override
  String get lockFiles => 'Bloquear Arquivos';

  @override
  String get searchHint => 'Pesquisar';

  @override
  String get searchButtonLabel => 'Pesquisar';

  @override
  String get filterButtonLabel => 'Filtrar por grupo';

  @override
  String get clear => 'Limpar';

  @override
  String get autofillFilterPrefix => 'Filtro:';

  @override
  String get autofillPrompt =>
      'Selecione a senha para preenchimento automático.';

  @override
  String get copiedToClipboard => 'Copiado para a área de transferência.';

  @override
  String get noTitle => '(sem título)';

  @override
  String get noUsername => '(sem nome)';

  @override
  String get filterCustomize => 'Personalizar …';

  @override
  String get swipeCopyPassword => 'Copiar Senha';

  @override
  String get swipeCopyUsername => 'Copiar Usuário';

  @override
  String get copyUsernameNotExists =>
      'Entrada não possui um nome de usuário definido.';

  @override
  String get copyPasswordNotExists =>
      'Entrada não possui um nome de usuário definido.';

  @override
  String get doneCopiedPassword => 'Senha copiada para área de transferência.';

  @override
  String get doneCopiedUsername => 'Senha copiada para área de transferência.';

  @override
  String get doneCopiedField => 'Copiado.';

  @override
  String copiedFieldToClipboard(Object fieldName) {
    return '$fieldName copiado.';
  }

  @override
  String copiedFieldEmpty(Object fieldName) {
    return '$fieldName está vazio.';
  }

  @override
  String get emptyPasswordVaultPlaceholder =>
      'Você ainda não tem nenhuma senha no seu banco de dados.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Crie sua primeira senha';

  @override
  String get loading => 'Carregando...';

  @override
  String get loadingFile => 'Carregando arquivo …';

  @override
  String get internalFile => 'Arquivo interno';

  @override
  String get internalFileSubtitle => 'Banco de dados criado com o AuthPass';

  @override
  String get filePicker => 'Selecionador de Arquivo';

  @override
  String get filePickerSubtitle => 'Abrir arquivo a partir do dispositivo.';

  @override
  String get credentialsAppBarTitle => 'Credenciais';

  @override
  String get credentialLabel => 'Digite a senha para:';

  @override
  String get masterPasswordInputLabel => 'Palavra-passe';

  @override
  String get masterPasswordEmptyValidator => 'Por favor, digite sua senha.';

  @override
  String get masterPasswordIncorrectValidator => 'Senha inválida';

  @override
  String get useKeyFile => 'Usar o arquivo chave';

  @override
  String get saveMasterPasswordBiometric =>
      'Salvar senha com armazenamento de chave biométrica?';

  @override
  String get close => 'Fechar';

  @override
  String get addNewPassword => 'Adicionar nova senha';

  @override
  String get errorOpenFileInvalidFileStructureTitle =>
      'Tentou abrir arquivo inválido';

  @override
  String errorOpenFileInvalidFileStructureBody(Object fileName) {
    return 'O arquivo ($fileName) parece não ser um arquivo KDBX válido. Por favor escolha um arquivo KDBX válido ou crie um novo banco de dados de senhas.';
  }

  @override
  String get errorOpenFileAlreadyOpenTitle => 'Arquivo já aberto';

  @override
  String errorOpenFileAlreadyOpenBody(
    Object databaseName,
    Object openFileSource,
    Object newFileSource,
  ) {
    return 'O banco de dados $databaseName já está aberto a partir de $openFileSource (Tentativa de abrir a partir de $newFileSource)';
  }

  @override
  String get loadFromUrl => 'Baixar do Url';

  @override
  String get loadFromUrlEnterUrl => 'Inserir URL';

  @override
  String get loadFromUrlErrorEnterFullUrl =>
      'Por favor, insira a url completa, começando com http:// ou https://';

  @override
  String get loadFromUrlErrorInvalidUrl => 'Por favor, insira uma URL válida.';

  @override
  String get linuxAppArmorWarning =>
      'AuthPass requer permissão para se comunicar com o Serviço Secreto para armazenar credenciais de armazenamento em nuvem.\nPor favor, execute o seguinte comando:';

  @override
  String get cancel => 'Cancelar';

  @override
  String get errorLoadFileFromSourceTitle => 'Erro ao abrir o arquivo.';

  @override
  String errorLoadFileFromSourceBody(Object source, Object error) {
    return 'Não é possível abrir $source.\n$error';
  }

  @override
  String get errorUnlockFileTitle => 'Não foi possível abrir o arquivo';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Erro desconhecido ao tentar abrir o arquivo. $error';
  }

  @override
  String get dialogContinue => 'Continuar';

  @override
  String get dialogSendErrorReport => 'Enviar relatório de erro';

  @override
  String get dialogReportErrorForum => 'Relatar erro no Fórum/Ajuda';

  @override
  String get groupFilterDescription =>
      'Selecionar quais grupos a exibir (recursivamente)';

  @override
  String get groupFilterSelectAll => 'Selecionar todos';

  @override
  String get groupFilterDeselectAll => 'Deselect all';

  @override
  String get createSubgroup => 'Create Subgroup';

  @override
  String get editAction => 'Edit';

  @override
  String get mailboxEnableLabel => '(re)enable';

  @override
  String get mailboxEnableHint => 'Continue receiving emails';

  @override
  String get mailboxDisableLabel => 'Disable';

  @override
  String get mailboxDisableHint => 'Receive no more emails';

  @override
  String get mailListNoMail => 'You do not have any emails yet.';

  @override
  String mailboxLabelPrefixForEntry(Object entryLabel) {
    return 'Entry: $entryLabel';
  }

  @override
  String mailboxLabelPrefixUnknownEntry(Object entryUuid) {
    return 'Unknown Entry: $entryUuid';
  }

  @override
  String mailboxLabelPrefixCreatedAt(Object dateTime) {
    return 'Created at: $dateTime';
  }

  @override
  String get masterPasswordDescription =>
      'The master password is used to securely encrypt your password database. Make sure to remember it, it can not be restored.';

  @override
  String get unsavedChangesWarningTitle => 'Unsaved Changes';

  @override
  String get unsavedChangesWarningBody =>
      'There are still unsaved changes. Do you want to discard changes?';

  @override
  String get unsavedChangesDiscardActionLabel => 'Discard Changes';

  @override
  String get deletePermanentlyAction => 'Delete Permanently';

  @override
  String get restoreFromRecycleBinAction => 'Restore';

  @override
  String get deleteAction => 'Delete';

  @override
  String get deletedEntry => 'Deleted entry.';

  @override
  String get successfullyDeletedGroup => 'Deleted group.';

  @override
  String get undoButtonLabel => 'Undo';

  @override
  String get saveButtonLabel => 'Save';

  @override
  String get webDavSettings => 'WebDAV Settings';

  @override
  String get webDavUrlLabel => 'URL';

  @override
  String get webDavUrlHelperText => 'Base Url to your WebDAV service.';

  @override
  String get webDavUrlValidatorError => 'Please enter a URL';

  @override
  String get webDavUrlValidatorInvalidUrlError =>
      'Please enter a valid url with http:// or https://';

  @override
  String get webDavAuthUser => 'Username';

  @override
  String get webDavAuthPassword => 'Password';

  @override
  String get mergeSuccessDialogTitle => 'Successfully merged password database';

  @override
  String mergeSuccessDialogMessage(Object fileName, Object mergeSummary) {
    return 'Conflict detected while saving $fileName, it was merged successfully with the remote file: \n\n$mergeSummary';
  }

  @override
  String forDetailsVisitUrl(Object url) {
    return 'For details visit $url';
  }

  @override
  String get authPassCloudAuthEmailInputLabel =>
      'Enter email address to register or sign in.';

  @override
  String get authPassCloudAuthEmailInvalid =>
      'Please enter a valid email address.';

  @override
  String get authPassCloudAuthConfirmEmailButtonLabel => 'Confirm Address';

  @override
  String get authPassCloudAuthConfirmEmail =>
      'Please check your emails to confirm your email address.';

  @override
  String get authPassCloudAuthConfirmEmailExplain =>
      'Keep this screen open until you visited the link you received by email.';

  @override
  String get authPassCloudAuthResendExplain =>
      'If you have not received an email, please check your spam folder. Otherwise you can try to request a new confirmation link.';

  @override
  String get authPassCloudAuthResendButtonLabel =>
      'Request a new confirmation link';

  @override
  String permanentlyDeleteEntryConfirm(Object title) {
    return 'This will permanently delete the password entry $title. This can not be undone. Do you want to continue?';
  }

  @override
  String get permanentlyDeletedEntrySnackBar => 'Permanently deleted entry.';

  @override
  String get initialNewGroupName => 'New Group';

  @override
  String get deleteGroupErrorTitle => 'Unable to delete group';

  @override
  String get deleteGroupErrorBodyContainsGroup =>
      'This group still contains other groups. You can currently only delete empty groups.';

  @override
  String get deleteGroupErrorBodyContainsEntries =>
      'This group still contains password entries. You can currently only delete empty groups.';

  @override
  String get groupListAppBarTitle => 'Groups';

  @override
  String get groupListFilterAppbarTitle => 'Filter by groups';

  @override
  String get clearQuickUnlock => 'Clear Biometric Storage';

  @override
  String get clearQuickUnlockSubtitle => 'Remove saved master passwords';

  @override
  String get unlock => 'Desbloquear arquivos';

  @override
  String get closePasswordFiles => 'fechar arquivos de senha';

  @override
  String get clearQuickUnlockSuccess =>
      'Senha mestra salva do armazenamento biométrico.';

  @override
  String get diacOptIn =>
      'Opte por receber notícias do aplicativo, Inquéritos.';

  @override
  String get diacOptInSubtitle =>
      'Às vezes, enviará uma solicitação de rede para buscar notícias.';

  @override
  String get enableAutofillDebug => 'Preenchimento automático: Ativar debug';

  @override
  String get enableAutofillDebugSubtitle =>
      'Mostra camadas de informações para cada campo de entrada';

  @override
  String get createPasswordDatabase => 'Criar banco de dados de senha';

  @override
  String get nameNewPasswordDatabase => 'Nome do seu novo banco de dados';

  @override
  String get validatorNameMissing =>
      'Please enter a name for your new database.';

  @override
  String get masterPasswordHelpText =>
      'Select a secure master Password. Make sure to remember it.';

  @override
  String get inputMasterPasswordText => 'Master Password';

  @override
  String get masterPasswordMissingCreate =>
      'Please enter a secure, rememberable password.';

  @override
  String get createDatabaseAction => 'Create Database';

  @override
  String get databaseExistsError => 'File Exists';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'Error while trying to create database $filePath. File already exists. Please choose another name.';
  }

  @override
  String get databaseCreateDefaultName => 'PersonalPasswords';

  @override
  String get preferenceDynamicLoadIcons => 'Dynamically load Icons';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'Will make http requests with the value in $urlFieldName field to load website icons.';
  }

  @override
  String passwordScore(Object score) {
    return 'Strength: $score of 4';
  }

  @override
  String get entryInfoFile => 'File:';

  @override
  String get entryInfoGroup => 'Group:';

  @override
  String get entryInfoLastModified => 'Last Modified:';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'Moved entry into $groupName';
  }

  @override
  String sizeBytesStoredAuthPassCloud(Object count) {
    return '$count bytes, stored on AuthPass Cloud';
  }

  @override
  String sizeBytes(Object count) {
    return '$count bytes';
  }

  @override
  String get entryAddAttachment => 'Add Attachment';

  @override
  String get entryAttachmentSizeWarning =>
      'Attached files will be embedded in password file. This can significantly increase time required to open/save passwords.';

  @override
  String get iconPngSizeWarning =>
      'Custom icons will be embedded in password file. This can significantly increase time required to open/save passwords.';

  @override
  String get notPngError => 'Chosen file is not a PNG.';

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
  String get onboardingBackToOnboardingSubtitle =>
      'Relive the first run experience 😅️';

  @override
  String get onboardingHeadline => 'Let\'s make your Passwords Secure!';

  @override
  String get onboardingQuestion => 'Have you used a password manager before?';

  @override
  String get onboardingYesOpenPasswords => 'Yes, open my passwords';

  @override
  String get onboardingNoCreate => 'I\'m all new! Get me started.';

  @override
  String get backupButton => 'SAVE TO CLOUD';

  @override
  String get dismissBackupButton => 'DISMISS';

  @override
  String backupWarningMessage(Object databasename) {
    return 'Your passwords in $databasename are only saved locally!';
  }

  @override
  String get saveAs => 'Save In...';

  @override
  String get saving => 'Saving';

  @override
  String get increaseValue => 'Increase';

  @override
  String get decreaseValue => 'Decrease';

  @override
  String get resetValue => 'Reset';

  @override
  String cloudStorageAppBarTitle(Object cloudStorageName) {
    return 'CloudStorage - $cloudStorageName';
  }

  @override
  String get cloudStorageLogInCaption =>
      'You will be redirected to authenticate AuthPass to access your data.';

  @override
  String get cloudStorageLogInCode => 'Enter code';

  @override
  String launchUrlError(Object url) {
    return 'Unable to launch url. Please visit $url';
  }

  @override
  String cloudStorageLogInActionLabel(Object cloudStorageName) {
    return 'Login to $cloudStorageName';
  }

  @override
  String cloudStorageAuthCodeDialogTitle(Object cloudStorageName) {
    return '$cloudStorageName Authentication';
  }

  @override
  String get cloudStorageAuthCodeLabel => 'Authentication Code';

  @override
  String get cloudStorageAuthErrorTitle => 'Error while authenticating';

  @override
  String cloudStorageAuthErrorMessage(
    Object cloudStorageName,
    Object errorMessage,
  ) {
    return 'Error while trying to authenticate to $cloudStorageName: $errorMessage';
  }

  @override
  String get cloudStorageSearchBoxLabel => 'Search Query';

  @override
  String cloudStorageItemsInFolder(Object itemCount) {
    return '$itemCount items in this folder.';
  }

  @override
  String get mailSubject => 'Subject';

  @override
  String get mailFrom => 'From';

  @override
  String get mailDate => 'Date';

  @override
  String get mailMailbox => 'Mailbox';

  @override
  String get mailNoData => 'No Data';

  @override
  String get mailMailboxesTitle => 'Mailboxes';

  @override
  String get mailboxCreateButtonLabel => 'Create';

  @override
  String get mailboxNameInputDialogTitle => 'Optionally label for new mailbox';

  @override
  String get mailboxNameInputLabel => '(Internal) Label';

  @override
  String get mailScreenTitle => 'AuthPass Mail';

  @override
  String get mailTabBarTitleMailbox => 'Mailbox';

  @override
  String get mailTabBarTitleMail => 'Mail';

  @override
  String get mailMailboxListEmpty => 'You do not have any mailboxes yet.';

  @override
  String mailMailboxAddressCopied(Object mailboxAddress) {
    return 'Copied mailbox address to clipboard: $mailboxAddress';
  }

  @override
  String get errorWhileSavingTitle => 'Error while saving';

  @override
  String errorWhileSavingBody(Object errorMessage) {
    return 'Unable to save file: $errorMessage';
  }

  @override
  String get databaseDoesNotSupportSaving =>
      'Sorry this database does not support saving. Please open a local database file. Or use \"Save As\".';

  @override
  String get otpInvalidKeyTitle => 'Invalid Key';

  @override
  String get otpInvalidKeyBody =>
      'Given input is not a valid base32 TOTP code. Please verify your input.';

  @override
  String get otpUnsupportedMigrationTitle => 'Unsupported OTP Migration';

  @override
  String otpUnsupportedMigrationBody(Object uriCount) {
    return 'We currently only support single item migrations. Got $uriCount';
  }

  @override
  String get otpPromptTitle => 'Time Based Authentication';

  @override
  String get otpPromptHelperText => 'Please enter time based key.';

  @override
  String otpErrorMessageGeneration(Object errorMessage) {
    return 'Error generating invite code: $errorMessage';
  }

  @override
  String get otpCopySecretActionLabel => 'Copy Secret';

  @override
  String get otpEntryLabel => 'One Time Token';

  @override
  String get entryFieldProtected => 'Protected field. Click to reveal.';

  @override
  String get entryFieldActionRevealField => 'Show protected field';

  @override
  String get entryAttachmentOpenActionLabel => 'Open';

  @override
  String get entryAttachmentShareActionLabel => 'Share';

  @override
  String get entryAttachmentShareSubject => 'Attachment';

  @override
  String get entryAttachmentSaveActionLabel => 'Save to device';

  @override
  String get entryAttachmentRemoveActionLabel => 'Remove';

  @override
  String entryAttachmentRemoveConfirm(Object attachmentLabel) {
    return 'Do you really want to delete $attachmentLabel?';
  }

  @override
  String get entryRenameFieldPromptTitle => 'Renaming field';

  @override
  String get removerecentfile => 'Hide';

  @override
  String get entryRenameFieldPromptLabel => 'Enter the new name for the field';

  @override
  String get promptDialogPasteActionTooltip => 'Paste from Clipboard';

  @override
  String get promptDialogPasteHint =>
      'Hint: If you need to paste, try the button to the left ;-)';

  @override
  String get genericErrorDialogTitle => 'Error while handling action';

  @override
  String genericErrorDialogBody(Object errorMessage) {
    return 'Encountered an unexpected error. $errorMessage';
  }

  @override
  String get saveAsEntryLocalFile => 'Local File';

  @override
  String get fileTypePngs => 'Images (png)';

  @override
  String get selectIconDialogAction => 'SELECT ICON';

  @override
  String get retryDialogActionLabel => 'RETRY';

  @override
  String errorDuringNetworkCall(Object errorMessage) {
    return 'Error during api call. $errorMessage';
  }

  @override
  String get passwordFilterHideDeleted => 'Hide Deleted Entries';

  @override
  String get passwordFilterOnlyDeleted => 'Deleted Entries';

  @override
  String passwordFilterPrefixForOneGroup(Object groupName) {
    return 'Group: $groupName';
  }

  @override
  String passwordFilterPrefixForMultipleGroups(Object groupCount) {
    return 'Custom Filter ($groupCount Groups)';
  }

  @override
  String get menuItemAuthPassCloudAuthenticate =>
      'Authenticate with AuthPass Cloud';

  @override
  String get menuItemAuthPassCloudMailboxes => 'AuthPass Mailboxes';

  @override
  String changesWithoutSaving(Object fileName) {
    return 'You have changes in \"$fileName\", which does not support writing of changes.';
  }

  @override
  String get changesSaveLocally => 'Save locally';

  @override
  String get clearColor => 'Clear Color';

  @override
  String get databaseRenameInputLabel => 'Enter database name';

  @override
  String get databasePath => 'Path';

  @override
  String get databaseColor => 'Color';

  @override
  String get databaseColorChoose =>
      'Select a color to distinguish between files.';

  @override
  String get databaseKdbxVersion => 'KDBX File Version';

  @override
  String databaseKdbxUpgradeVersion(Object versionName) {
    return 'Upgrade to $versionName';
  }

  @override
  String get databaseKdbxUpgradeSuccessful =>
      'Successfully upgraded file and saved.';

  @override
  String get databaseReload => 'Reload and Merge';

  @override
  String progressStatus(Object statusProgress) {
    return 'Status: $statusProgress';
  }

  @override
  String finishedMerge(Object status) {
    return 'Finished Merge $status';
  }

  @override
  String get closeAndLockFile => 'Close/Lock';

  @override
  String get authPassHomeScreenTagline =>
      'password manager, open source, available on all platforms.';

  @override
  String get addNewPasswordButtonLabel => 'Add new Password';

  @override
  String get unnamedEntryPlaceholder => '(Unnamed)';

  @override
  String get unnamedGroupPlaceholder => '(Unnamed)';

  @override
  String get unnamedFilePlaceholder => '(Unnamed)';

  @override
  String get editGroupScreenTitle => 'Edit Group';

  @override
  String get editGroupGroupNameLabel => 'Group Name';

  @override
  String get files => 'Files';

  @override
  String get newGroupDialogTitle => 'New Group';

  @override
  String get newGroupDialogInputLabel => 'Name for the new group';

  @override
  String get groupActionShowPasswords => 'Show passwords';

  @override
  String get groupActionDelete => 'Delete';

  @override
  String get logoutTooltip => 'Logout';

  @override
  String get successfullyDeletedFileCloudStorage =>
      'Successfully deleted file.';

  @override
  String shareDialogTitle(Object fileName) {
    return 'Sharing Options for $fileName';
  }

  @override
  String get shareFileActionLabel => 'Share …';

  @override
  String get shareTokenListEmptyScreenPlaceholder => 'File not shared yet.';

  @override
  String get shareTokenNoLabel => 'No Label/Description';

  @override
  String get shareTokenReadWrite => 'Read/Write';

  @override
  String get shareTokenReadOnly => 'Read only';

  @override
  String get shareCreateTokenDialogTitle => 'Share file';

  @override
  String get shareCreateTokenReadOnly => 'Read only';

  @override
  String get shareCreateTokenReadOnlyHelpText =>
      'Do not allow saving of changes';

  @override
  String get shareCreateTokenLabelText => 'Description';

  @override
  String get shareCreateTokenLabelHint => 'Share for my friend';

  @override
  String get shareCreateTokenLabelHelp =>
      'Optional label to differentiate share code.';

  @override
  String get shareCreateTokenSuccess => 'Successfully created share code.';

  @override
  String get sharePresentDialogTitle => 'Share file with secret share code';

  @override
  String get sharePresentDialogHelp =>
      'Using the following share code users can access the password file. They will need the password and/or key file to open it.';

  @override
  String get sharePresentToken => 'Share Code';

  @override
  String get sharePresentCopied => 'Copied share code to clipboard.';

  @override
  String get authPassCloudOpenWithShareCodeTooltip => 'Open with Share Code';

  @override
  String get authPassCloudShareFileActionLabel => 'Share';

  @override
  String get preferenceAuthPassCloudAttachmentTitle =>
      'Use AuthPass Cloud Attachments';

  @override
  String get preferenceAuthPassCloudAttachmentSubtitle =>
      'Store Attachments encrypted on AuthPass Cloud separately.';

  @override
  String get shareCodeInputDialogTitle => 'Input Secret Share Code';

  @override
  String get shareCodeInputDialogScan => 'Scan QR Code';

  @override
  String get shareCodeInputLabel => 'Secret Share Code';

  @override
  String get shareCodeInputHelperText =>
      'If you have received a share code, please paste it above.';

  @override
  String get shareCodeOpen => 'Received a Share Code for AuthPass Cloud?';

  @override
  String get shareCodeOpenScreenTitle => 'Loading file with share code';

  @override
  String get shareCodeLoadingProgress => 'Loading file …';

  @override
  String get shareCodeOpenFileButtonLabel => 'OPEN';

  @override
  String get shareCodeOpenInstallAppCaption =>
      'Want to open this file with one of our native Apps instead?';

  @override
  String get shareCodeOpenAnotherAppCaption =>
      'Want to open this file on another device?';

  @override
  String get shareCodeOpenInstallAppButtonLabel => 'Install App';

  @override
  String get shareCodeOpenShowCodeButtonLabel => 'Show Share Code';

  @override
  String get changeMasterPasswordActionLabel => 'Change Master Password';

  @override
  String get changeMasterPasswordFormSubmit => 'Save with new password';

  @override
  String get changeMasterPasswordSuccess =>
      'Successfully saved master password.';

  @override
  String get changeMasterPasswordScreenTitle => 'Change Master Password';

  @override
  String get authPassCloudAuthClickedLink =>
      'I received email and visited link';

  @override
  String get authPassCloudAuthNotConfirmed =>
      'Email address was not yet confirmed. Make sure to click the link in the email you received and solve the captcha to confirm your email address.';

  @override
  String get getHelpButton => 'Get help in the forum';

  @override
  String get shortcutCopyUsername => 'Copy Username';

  @override
  String get shortcutCopyPassword => 'Copy Password';

  @override
  String get shortcutCopyTotp => 'Copy TOTP';

  @override
  String get shortcutMoveUp => 'Select the previous password';

  @override
  String get shortcutMoveDown => 'Select the next password';

  @override
  String get shortcutGeneratePassword => 'Generate Password';

  @override
  String get shortcutCopyUrl => 'Copy URL';

  @override
  String get shortcutOpenUrl => 'Open URL';

  @override
  String get shortcutCancelSearch => 'Cancel Search';

  @override
  String get shortcutShortcutHelp => 'Keyboard Shortcut Help';

  @override
  String get shortcutHelpTitle => 'Keyboard Shortcuts';

  @override
  String unexpectedError(String error) {
    return 'Unexpected Error: $error';
  }

  @override
  String get googleDriveMorePermissionsRequired =>
      'Additional permissions needed to access Google Drive.';

  @override
  String get googleDriveRequestPermissionButtonLabel => 'Request Permissions';

  @override
  String get scanQrCodeTitle => 'Scan QR Code.';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get fieldUserName => 'Usuário';

  @override
  String get fieldPassword => 'Senha';

  @override
  String get fieldWebsite => 'Site';

  @override
  String get fieldTitle => 'Título';

  @override
  String get fieldTotp => 'Senha Única (Baseado no Tempo)';

  @override
  String get english => 'Inglês';

  @override
  String get german => 'Alemão';

  @override
  String get russian => 'Russo';

  @override
  String get ukrainian => 'Ucraniano';

  @override
  String get lithuanian => 'Lituano';

  @override
  String get french => 'Francês';

  @override
  String get spanish => 'Espanhol';

  @override
  String get indonesian => 'Indonésio';

  @override
  String get turkish => 'Turco';

  @override
  String get hebrew => 'Hebraico';

  @override
  String get italian => 'Italiano';

  @override
  String get chineseSimplified => 'Chinês Simplificado';

  @override
  String get chineseTraditional => 'Chinês Tradicional';

  @override
  String get portugueseBrazilian => 'Português (Brasil)';

  @override
  String get slovak => 'Eslovaco';

  @override
  String get dutch => 'Holandês';

  @override
  String get selectItem => 'Selecione';

  @override
  String get selectKeepassFile => 'AuthPass - Selecionar Arquivo do KeePass';

  @override
  String get selectKeepassFileLabel =>
      'Selecione um arquivo do KeePass (.kdbx).';

  @override
  String get createNewFile => 'Criar Novo Arquivo';

  @override
  String get openLocalFile => 'Abrir\nArquivo Local';

  @override
  String get openFile => 'Abrir Arquivo';

  @override
  String get loadFromDropdownMenu => 'Carregar a partir de…';

  @override
  String get quickUnlockingFiles => 'Desbloqueio rápido de arquivos…';

  @override
  String openFileProgress(Object fileName, Object current, Object totalCount) {
    return 'Abrindo $fileName … ($current / $totalCount)';
  }

  @override
  String loadFrom(String cloudStorageName) {
    return 'Carregar de $cloudStorageName';
  }

  @override
  String get loadFromRemoteUrl => 'Abrir kdbx da URL';

  @override
  String get createNewKeepass =>
      'Novo no KeePass?\nCriar Novo Banco de Dados de Senhas';

  @override
  String get labelLastOpenFiles => 'Últimos arquivos abertos:';

  @override
  String get noFilesHaveBeenOpenYet => 'Nenhum arquivo foi aberto ainda.';

  @override
  String get preferenceSelectLanguage => 'Selecionar Idioma';

  @override
  String get preferenceLanguage => 'Idioma';

  @override
  String get preferenceTextScaleFactor => 'Tamanho do Texto';

  @override
  String get preferenceVisualDensity => 'Densidade Visual';

  @override
  String get preferenceTheme => 'Tema';

  @override
  String get preferenceThemeLight => 'Claro';

  @override
  String get preferenceThemeDark => 'Escuro';

  @override
  String get preferenceSystemDefault => 'Padrão do Sistema';

  @override
  String get preferenceDefault => 'Padrão';

  @override
  String get lockAllFiles => 'Bloquear todos os arquivos abertos';

  @override
  String get preferenceAllowScreenshots =>
      'Permitir Capturas de Tela do Aplicativo';

  @override
  String get preferenceEnableAutoFill => 'Habilitar preenchimento automático';

  @override
  String get enableAutofillSuggestionBanner =>
      'Você pode preencher as credenciais de outros aplicativos ativando o preenchimento automático!';

  @override
  String get dismissAutofillSuggestionBannerButton => 'DISPENSAR';

  @override
  String get enableAutofillSuggestionBannerButton => 'ATIVE!';

  @override
  String get preferenceAutoFillDescription =>
      'Somente suportado em Android Oreo (8.0) ou posterior.';

  @override
  String get preferenceTitle => 'Preferências';

  @override
  String get preferenceEnableSystemWideShortcuts =>
      'Ative os atalhos do sistema';

  @override
  String get preferenceEnableSystemWideShortcutsHelp =>
      'Registre ctrl+alt+f como atalho do sistema para abrir a pesquisa.';

  @override
  String get preferencesSearchFields => 'Customizar campos de pesquisa';

  @override
  String get preferencesSearchFieldPromptTitle => 'Campos de pesquisa';

  @override
  String get preferencesSearchFieldPromptLabel =>
      'Lista de campos separados por vírgula para usar na lista de busca de senhas.';

  @override
  String preferencesSearchFieldPromptHelp(
    Object wildCardCharacter,
    Object defaultSearchFields,
  ) {
    return 'Use $wildCardCharacter para todos, deixe em branco por padrão ($defaultSearchFields)';
  }

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback => 'Qualquer tipo de feedback é bem-vindo!';

  @override
  String get aboutLinkVisitWebsite =>
      'Lembre-se também de visitar o nosso site';

  @override
  String get aboutLinkGitHub => 'Um Projeto de Código Aberto';

  @override
  String aboutLogFile(String logFilePath) {
    return 'Arquivo de Log: $logFilePath';
  }

  @override
  String get aboutLinkContributors => 'Mostrar Colaboradores';

  @override
  String get unableToLaunchUrlTitle => 'Não foi possível abrir a URL';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'Não foi possível iniciar $url: $openError';
  }

  @override
  String get unableToLaunchUrlNoHandler =>
      'Nenhum aplicativo disponível para URL.';

  @override
  String launchedUrl(Object url) {
    return 'URL Aberta: $url';
  }

  @override
  String get menuItemGeneratePassword => 'Gerar Senha';

  @override
  String get menuItemPreferences => 'Preferências';

  @override
  String get menuItemOpenAnotherFile => 'Abrir outro Arquivo';

  @override
  String get menuItemCheckForUpdates => 'Verificar por atualizações';

  @override
  String get menuItemSupport => 'Enviar registros';

  @override
  String get menuItemSupportSubtitle => 'Enviar registros por e-mail';

  @override
  String get menuItemForum => 'Fórum de Suporte';

  @override
  String get menuItemForumSubtitle => 'Relatar problemas e obter ajuda';

  @override
  String get menuItemHelp => 'Ajuda';

  @override
  String get menuItemHelpSubtitle => 'Mostrar documentação';

  @override
  String get menuItemAbout => 'Sobre';

  @override
  String get actionOpenUrl => 'Abrir URL';

  @override
  String get passwordPlainText => 'Mostrar senha';

  @override
  String get generatorPassword => 'Senha';

  @override
  String get generatePassword => 'Gerar Senha';

  @override
  String get doneButtonLabel => 'Concluído';

  @override
  String get useAsDefault => 'Usar como Padrão';

  @override
  String get characterSetLowerCase => 'Minúsculas (a-z)';

  @override
  String get characterSetUpperCase => 'Maiúsculas (A-Z)';

  @override
  String get characterSetNumeric => 'Numérico (0-9)';

  @override
  String get characterSetUmlauts => 'Metafonia (ä)';

  @override
  String get characterSetSpecial => 'Especial (@%+)';

  @override
  String get length => 'Comprimento';

  @override
  String get customLength => 'Comprimento Personalizado';

  @override
  String customLengthHelperText(Object customMinLength) {
    return 'Usado apenas para comprimento > $customMinLength';
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
      other: '$numFilesString arquivos salvos: $files',
      one: 'Um arquivo salvo: $files',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => 'Gerenciar Grupos';

  @override
  String get lockFiles => 'Bloquear Arquivos';

  @override
  String get searchHint => 'Pesquisar';

  @override
  String get searchButtonLabel => 'Pesquisar';

  @override
  String get filterButtonLabel => 'Filtrar por grupos';

  @override
  String get clear => 'Limpar';

  @override
  String get autofillFilterPrefix => 'Filtro:';

  @override
  String get autofillPrompt =>
      'Selecione a senha para preenchimento automático.';

  @override
  String get copiedToClipboard => 'Copiado para a área de transferência.';

  @override
  String get noTitle => '(sem título)';

  @override
  String get noUsername => '(sem nome)';

  @override
  String get filterCustomize => 'Personalizar …';

  @override
  String get swipeCopyPassword => 'Copiar Senha';

  @override
  String get swipeCopyUsername => 'Copiar Usuário';

  @override
  String get copyUsernameNotExists =>
      'Entrada não tem nenhum nome de usuário definido.';

  @override
  String get copyPasswordNotExists =>
      'A entrada não possui uma senha definida.';

  @override
  String get doneCopiedPassword => 'Senha copiada para área de transferência.';

  @override
  String get doneCopiedUsername =>
      'Nome de usuário copiado para área de transferência.';

  @override
  String get doneCopiedField => 'Copiado.';

  @override
  String copiedFieldToClipboard(Object fieldName) {
    return '$fieldName copiado.';
  }

  @override
  String copiedFieldEmpty(Object fieldName) {
    return '$fieldName está vazio.';
  }

  @override
  String get emptyPasswordVaultPlaceholder =>
      'Você ainda não possui nenhuma senha no seu banco de dados.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Crie a sua primeira Senha';

  @override
  String get loading => 'Carregando...';

  @override
  String get loadingFile => 'Carregando arquivo …';

  @override
  String get internalFile => 'Arquivo interno';

  @override
  String get internalFileSubtitle =>
      'Banco de dados previamente criado com o AuthPass';

  @override
  String get filePicker => 'Selecionar Arquivo';

  @override
  String get filePickerSubtitle => 'Abrir arquivo a partir do dispositivo.';

  @override
  String get credentialsAppBarTitle => 'Credenciais';

  @override
  String get credentialLabel => 'Digite a senha para:';

  @override
  String get masterPasswordInputLabel => 'Senha';

  @override
  String get masterPasswordEmptyValidator => 'Por favor, digite sua senha.';

  @override
  String get masterPasswordIncorrectValidator => 'Senha inválida';

  @override
  String get useKeyFile => 'Usar Arquivo Chave';

  @override
  String get saveMasterPasswordBiometric =>
      'Salvar Senha com armazenamento de chave biométrica?';

  @override
  String get close => 'Fechar';

  @override
  String get addNewPassword => 'Adicionar nova senha';

  @override
  String get errorOpenFileInvalidFileStructureTitle =>
      'Tentou abrir um tipo de arquivo inválido';

  @override
  String errorOpenFileInvalidFileStructureBody(Object fileName) {
    return 'O arquivo ($fileName) parece não ser um arquivo KDBX válido. Por favor, escolha um arquivo KDBX válido ou crie um novo banco de senhas.';
  }

  @override
  String get errorOpenFileAlreadyOpenTitle => 'Arquivo já aberto';

  @override
  String errorOpenFileAlreadyOpenBody(
    Object databaseName,
    Object openFileSource,
    Object newFileSource,
  ) {
    return 'O banco de dados $databaseName já está aberto a partir de $openFileSource (Tentativa de abrir a partir de $newFileSource)';
  }

  @override
  String get loadFromUrl => 'Baixar da URL';

  @override
  String get loadFromUrlEnterUrl => 'Insira a URL';

  @override
  String get loadFromUrlErrorEnterFullUrl =>
      'Por favor, insira a URL completa, começando com http:// ou https://';

  @override
  String get loadFromUrlErrorInvalidUrl => 'Por favor, insira uma URL válida.';

  @override
  String get linuxAppArmorWarning =>
      'AuthPass requer permissão para se comunicar com o Serviço Secreto para armazenar credenciais na nuvem.\nPor favor, execute o seguinte comando:';

  @override
  String get cancel => 'Cancelar';

  @override
  String get errorLoadFileFromSourceTitle =>
      'Ocorreu um erro ao abrir arquivo.';

  @override
  String errorLoadFileFromSourceBody(Object source, Object error) {
    return 'Não é possível abrir $source.\n$error';
  }

  @override
  String get errorUnlockFileTitle => 'Não foi possível abrir o arquivo';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Erro desconhecido ao tentar abrir o arquivo. $error';
  }

  @override
  String get dialogContinue => 'Continuar';

  @override
  String get dialogSendErrorReport => 'Enviar Relatório de Erro/Ajuda';

  @override
  String get dialogReportErrorForum => 'Relatar erro no Fórum/Ajuda';

  @override
  String get groupFilterDescription =>
      'Selecione quais Grupos exibir (recursivamente)';

  @override
  String get groupFilterSelectAll => 'Selecionar todos';

  @override
  String get groupFilterDeselectAll => 'Desmarcar todos';

  @override
  String get createSubgroup => 'Criar Subgrupo';

  @override
  String get editAction => 'Editar';

  @override
  String get mailboxEnableLabel => '(re)ativar';

  @override
  String get mailboxEnableHint => 'Continuar recebendo e-mails';

  @override
  String get mailboxDisableLabel => 'Desativar';

  @override
  String get mailboxDisableHint => 'Não receber mais e-mails';

  @override
  String get mailListNoMail => 'Você ainda não tem nenhum e-mail.';

  @override
  String mailboxLabelPrefixForEntry(Object entryLabel) {
    return 'Entrada: $entryLabel';
  }

  @override
  String mailboxLabelPrefixUnknownEntry(Object entryUuid) {
    return 'Entrada desconhecida: $entryUuid';
  }

  @override
  String mailboxLabelPrefixCreatedAt(Object dateTime) {
    return 'Criado em: $dateTime';
  }

  @override
  String get masterPasswordDescription =>
      'A senha mestra é usada para criptografar com segurança seu banco de senhas. Certifique-se de lembrá-la, ela não pode ser restaurada.';

  @override
  String get unsavedChangesWarningTitle => 'Mudanças não salvas';

  @override
  String get unsavedChangesWarningBody =>
      'Ainda existem mudanças não salvas. Você deseja descartar as mudanças?';

  @override
  String get unsavedChangesDiscardActionLabel => 'Descartar Alterações';

  @override
  String get deletePermanentlyAction => 'Excluir permanentemente';

  @override
  String get restoreFromRecycleBinAction => 'Restaurar';

  @override
  String get deleteAction => 'Apagar';

  @override
  String get deletedEntry => 'Entrada excluída.';

  @override
  String get successfullyDeletedGroup => 'Grupo apagado.';

  @override
  String get undoButtonLabel => 'Desfazer';

  @override
  String get saveButtonLabel => 'Salvar';

  @override
  String get webDavSettings => 'Configurações WebDAV';

  @override
  String get webDavUrlLabel => 'URL';

  @override
  String get webDavUrlHelperText => 'URL de base para seu serviço WebDAV.';

  @override
  String get webDavUrlValidatorError => 'Por favor, insira uma URL';

  @override
  String get webDavUrlValidatorInvalidUrlError =>
      'Digite uma URL válida com http:// ou https://';

  @override
  String get webDavAuthUser => 'Usuário';

  @override
  String get webDavAuthPassword => 'Senha';

  @override
  String get mergeSuccessDialogTitle => 'Dados de senhas mesclados com sucesso';

  @override
  String mergeSuccessDialogMessage(Object fileName, Object mergeSummary) {
    return 'Conflito detectado ao salvar $fileName, ele foi mesclado com sucesso com o arquivo remoto: \n\n$mergeSummary';
  }

  @override
  String forDetailsVisitUrl(Object url) {
    return 'Para mais detalhes visite $url';
  }

  @override
  String get authPassCloudAuthEmailInputLabel =>
      'Insira o endereço de e-mail para registrar-se ou fazer login.';

  @override
  String get authPassCloudAuthEmailInvalid =>
      'Por favor, insira um endereço de e-mail válido.';

  @override
  String get authPassCloudAuthConfirmEmailButtonLabel =>
      'Confirmar endereço de e-mail';

  @override
  String get authPassCloudAuthConfirmEmail =>
      'Por favor, verifique seus e-mails para confirmar seu endereço de e-mail.';

  @override
  String get authPassCloudAuthConfirmEmailExplain =>
      'Mantenha essa tela aberta até você ter aberto o link que recebeu por e-mail.';

  @override
  String get authPassCloudAuthResendExplain =>
      'Se você não recebeu um e-mail, por favor, verifique sua pasta de spam. Caso contrário, você pode tentar solicitar um novo link de confirmação.';

  @override
  String get authPassCloudAuthResendButtonLabel =>
      'Solicitar um novo link de confirmação';

  @override
  String permanentlyDeleteEntryConfirm(Object title) {
    return 'Isto irá excluir permanentemente a senha $title. Isso não pode ser desfeito. Você quer continuar?';
  }

  @override
  String get permanentlyDeletedEntrySnackBar =>
      'Entrada excluída permanentemente.';

  @override
  String get initialNewGroupName => 'Novo Grupo';

  @override
  String get deleteGroupErrorTitle => 'Não é possível excluir o grupo';

  @override
  String get deleteGroupErrorBodyContainsGroup =>
      'Este grupo ainda contém outros grupos. No momento, você só pode excluir grupos vazios.';

  @override
  String get deleteGroupErrorBodyContainsEntries =>
      'Este grupo ainda contém entradas de senha. Você atualmente só pode excluir grupos vazios.';

  @override
  String get groupListAppBarTitle => 'Grupos';

  @override
  String get groupListFilterAppbarTitle => 'Filtrar por grupos';

  @override
  String get clearQuickUnlock => 'Limpar Armazenamento Biométrico';

  @override
  String get clearQuickUnlockSubtitle => 'Remover senhas mestres salvas';

  @override
  String get unlock => 'Desbloquear Arquivos';

  @override
  String get closePasswordFiles => 'fechar arquivos de senha';

  @override
  String get clearQuickUnlockSuccess =>
      'Removidas as senhas mestres salvas do armazenamento biométrico.';

  @override
  String get diacOptIn => 'Opte por Notícias no aplicativo, Pesquisas.';

  @override
  String get diacOptInSubtitle =>
      'Às vezes, será enviado uma solicitação de rede para buscar notícias.';

  @override
  String get enableAutofillDebug =>
      'Preenchimento Automático: Ativar depuração';

  @override
  String get enableAutofillDebugSubtitle =>
      'Mostra camadas de informações para cada campo de entrada';

  @override
  String get createPasswordDatabase => 'Criar Banco de Dados de Senhas';

  @override
  String get nameNewPasswordDatabase => 'Nome do seu novo Banco de Dados';

  @override
  String get validatorNameMissing =>
      'Por favor, digite um nome para o novo banco de dados.';

  @override
  String get masterPasswordHelpText =>
      'Selecione uma senha mestra segura. Certifique-se de lembrá-la.';

  @override
  String get inputMasterPasswordText => 'Senha Mestra';

  @override
  String get masterPasswordMissingCreate =>
      'Por favor, digite uma senha segura e fácil de ser lembrada.';

  @override
  String get createDatabaseAction => 'Criar Banco de Dados';

  @override
  String get databaseExistsError => 'O Arquivo Existe';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'Erro ao tentar criar o banco de dados $filePath. Já existe um arquivo. Escolha outro nome.';
  }

  @override
  String get databaseCreateDefaultName => 'Senhas_Pessoais';

  @override
  String get preferenceDynamicLoadIcons => 'Carregar ícones dinamicamente';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'Irá fazer solicitações http com o valor no campo $urlFieldName para carregar ícones de site.';
  }

  @override
  String passwordScore(Object score) {
    return 'Força: $score de 4';
  }

  @override
  String get entryInfoFile => 'Arquivo:';

  @override
  String get entryInfoGroup => 'Grupo:';

  @override
  String get entryInfoLastModified => 'Última Modificação:';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'Entrada movida para $groupName';
  }

  @override
  String sizeBytesStoredAuthPassCloud(Object count) {
    return '$count bytes, armazenados no AuthPass Cloud';
  }

  @override
  String sizeBytes(Object count) {
    return '$count bytes';
  }

  @override
  String get entryAddAttachment => 'Adicionar Anexo';

  @override
  String get entryAttachmentSizeWarning =>
      'Arquivos anexados serão incorporados no arquivo de senha. Isto pode aumentar significativamente o tempo necessário para abrir/salvar senhas.';

  @override
  String get iconPngSizeWarning =>
      'Ícones personalizados serão incorporados no arquivo de senha. Isto pode aumentar significativamente o tempo necessário para abrir/salvar senhas.';

  @override
  String get notPngError => 'O arquivo escolhido não é um PNG.';

  @override
  String get entryAddField => 'Adicionar Campo';

  @override
  String get entryCustomField => 'Campo Personalizado';

  @override
  String get entryCustomFieldTitle => 'Adicionando novo campo personalizado';

  @override
  String get entryCustomFieldInputLabel => 'Digite um nome para o campo';

  @override
  String get swipeCopyField => 'Copiar Campo';

  @override
  String get fieldRename => 'Renomear';

  @override
  String get fieldGeneratePassword => 'Gerar Senha …';

  @override
  String get fieldProtect => 'Proteger Valor';

  @override
  String get fieldUnprotect => 'Desproteger Valor';

  @override
  String get fieldPresent => 'Exibir';

  @override
  String get fieldGenerateEmail => 'Gerar E-mail';

  @override
  String get onboardingBackToOnboarding => 'Demonstração';

  @override
  String get onboardingBackToOnboardingSubtitle =>
      'Reviva a primeira experiência de execução 😅';

  @override
  String get onboardingHeadline => 'Vamos tornar suas Senhas Seguras!';

  @override
  String get onboardingQuestion =>
      'Você já usou um gerenciador de senhas antes?';

  @override
  String get onboardingYesOpenPasswords => 'Sim, abrir minhas senhas';

  @override
  String get onboardingNoCreate => 'Sou novo! Vou começar.';

  @override
  String get backupButton => 'SALVAR NA NUVEM';

  @override
  String get dismissBackupButton => 'DISPENSAR';

  @override
  String backupWarningMessage(Object databasename) {
    return 'Suas senhas em $databasename são salvas somente localmente!';
  }

  @override
  String get saveAs => 'Salvar em...';

  @override
  String get saving => 'Salvando';

  @override
  String get increaseValue => 'Aumentar';

  @override
  String get decreaseValue => 'Diminuir';

  @override
  String get resetValue => 'Reset';

  @override
  String cloudStorageAppBarTitle(Object cloudStorageName) {
    return 'Armazenamento em nuvem - $cloudStorageName';
  }

  @override
  String get cloudStorageLogInCaption =>
      'Você será redirecionado para autenticar o AuthPass para acessar seus dados.';

  @override
  String get cloudStorageLogInCode => 'Insira o código';

  @override
  String launchUrlError(Object url) {
    return 'Não é possível iniciar a URL. Por favor, visite $url';
  }

  @override
  String cloudStorageLogInActionLabel(Object cloudStorageName) {
    return 'Acessar $cloudStorageName';
  }

  @override
  String cloudStorageAuthCodeDialogTitle(Object cloudStorageName) {
    return 'Autenticação no $cloudStorageName';
  }

  @override
  String get cloudStorageAuthCodeLabel => 'Código de Autenticação';

  @override
  String get cloudStorageAuthErrorTitle => 'Erro durante a autenticação';

  @override
  String cloudStorageAuthErrorMessage(
    Object cloudStorageName,
    Object errorMessage,
  ) {
    return 'Erro ao tentar autenticar em $cloudStorageName: $errorMessage';
  }

  @override
  String get cloudStorageSearchBoxLabel => 'Consulta de Pesquisa';

  @override
  String cloudStorageItemsInFolder(Object itemCount) {
    return '$itemCount itens nesta pasta.';
  }

  @override
  String get mailSubject => 'Assunto';

  @override
  String get mailFrom => 'De';

  @override
  String get mailDate => 'Data';

  @override
  String get mailMailbox => 'Caixa de Entrada';

  @override
  String get mailNoData => 'Não há dados';

  @override
  String get mailMailboxesTitle => 'Caixa de Entrada';

  @override
  String get mailboxCreateButtonLabel => 'Criar';

  @override
  String get newGroupDialogTitle => 'Novo Grupo';

  @override
  String get groupActionDelete => 'Apagar';

  @override
  String get shareCodeLoadingProgress => 'Carregando arquivo …';

  @override
  String get shortcutCopyUsername => 'Copiar Usuário';

  @override
  String get shortcutCopyPassword => 'Copiar Senha';

  @override
  String get shortcutGeneratePassword => 'Gerar Senha';

  @override
  String get shortcutOpenUrl => 'Abrir URL';

  @override
  String unexpectedError(String error) {
    return 'Erro Inesperado: $error';
  }
}
