// ignore_for_file: omit_local_variable_types,unused_local_variable
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get fieldUserName => 'Usuario';

  @override
  String get fieldPassword => 'Contraseña';

  @override
  String get fieldWebsite => 'Sitio web';

  @override
  String get fieldTitle => 'Título';

  @override
  String get fieldTotp => 'Contraseña de una sola vez (basada en el tiempo)';

  @override
  String get english => 'Inglés';

  @override
  String get german => 'Alemán';

  @override
  String get russian => 'Ruso';

  @override
  String get ukrainian => 'Ucraniano';

  @override
  String get lithuanian => 'Lituano';

  @override
  String get french => 'Francés';

  @override
  String get spanish => 'Spanish';

  @override
  String get selectKeepassFile => 'AuthPass - Seleccionar archivo KeePass';

  @override
  String get quickUnlockingFiles => 'Desbloqueo rápido de archivos';

  @override
  String get selectKeepassFileLabel => 'Por favor seleccione un archivo KeePass (.kdbx).';

  @override
  String get createNewFile => 'Create New File';

  @override
  String get openLocalFile => 'Abrir archivo local';

  @override
  String get openFile => 'Abrir archivo';

  @override
  String loadFrom(String cloudStorageName) {
    return 'Cargar desde ${cloudStorageName}';
  }

  @override
  String get loadFromUrl => 'Descargar desde URL';

  @override
  String get loadFromRemoteUrl => 'Open kdbx from URL';

  @override
  String get createNewKeepass => '¿Nuevo en KeePass?\nCrear nueva base de datos de contraseñas';

  @override
  String get labelLastOpenFiles => 'Últimos archivos abiertos:';

  @override
  String get noFilesHaveBeenOpenYet => 'Aún no se han abierto archivos.';

  @override
  String get preferenceSelectLanguage => 'Seleccionar Idioma';

  @override
  String get preferenceLanguage => 'Idioma';

  @override
  String get preferenceTextScaleFactor => 'Escala de texto';

  @override
  String get preferenceVisualDensity => 'Densidad visual';

  @override
  String get preferenceTheme => 'Tema';

  @override
  String get preferenceThemeLight => 'Claro';

  @override
  String get preferenceThemeDark => 'Oscuro';

  @override
  String get preferenceSystemDefault => 'Predeterminado del sistema';

  @override
  String get preferenceDefault => 'Predeterminado';

  @override
  String get lockAllFiles => 'Bloquear todos los archivos abiertos';

  @override
  String get preferenceAllowScreenshots => 'Permitir capturas de pantalla de la aplicación';

  @override
  String get preferenceEnableAutoFill => 'Habilitar autocompletar';

  @override
  String get preferenceAutoFillDescription => 'Sólo compatible con Android Oreo (8.0) o posterior.';

  @override
  String get preferenceTitle => 'Preferencias';

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback => '¡Agradecemos cualquier tipo de comentarios!';

  @override
  String get aboutLinkVisitWebsite => 'También asegúrese de visitar nuestro sitio web';

  @override
  String get aboutLinkGitHub => 'Y el proyecto de Código Abierto';

  @override
  String aboutLogFile(String logFilePath) {
    return 'Archivo Log: ${logFilePath}';
  }

  @override
  String get menuItemGeneratePassword => 'Generar contraseña';

  @override
  String get menuItemPreferences => 'Preferencias';

  @override
  String get menuItemOpenAnotherFile => 'Abrir otro archivo';

  @override
  String get menuItemCheckForUpdates => 'Buscar actualizaciones';

  @override
  String get menuItemSupport => 'Email de Soporte';

  @override
  String get menuItemSupportSubtitle => 'Enviar logs por correo electrónico/pedir ayuda.';

  @override
  String get menuItemHelp => 'Ayuda';

  @override
  String get menuItemHelpSubtitle => 'Mostrar documentación';

  @override
  String get menuItemAbout => 'Acerca de';

  @override
  String get passwordPlainText => 'Mostrar contraseña';

  @override
  String get generatorPassword => 'Contraseña';

  @override
  String get generatePassword => 'Generar contraseña';

  @override
  String get doneButtonLabel => 'Listo';

  @override
  String get useAsDefault => 'Usar como predeterminado';

  @override
  String get characterSetLowerCase => 'Minúsculas (a-z)';

  @override
  String get characterSetUpperCase => 'Mayúsculas (A-Z)';

  @override
  String get characterSetNumeric => 'Numérico (0-9)';

  @override
  String get characterSetUmlauts => 'Umlaut (ä)';

  @override
  String get characterSetSpecial => 'Especial (@%+)';

  @override
  String get length => 'Longitud';

  @override
  String get customLength => 'Longitud personalizada';

  @override
  String customLengthHelperText(Object customMinLength) {
    return 'Solo usado para longitud > ${customMinLength}';
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
      other: '${numFiles} archivos guardados: ${files}',
    );
  }

  @override
  String get manageGroups => 'Gestionar Grupos';

  @override
  String get lockFiles => 'Bloquear Archivos';

  @override
  String get searchHint => 'Buscar';

  @override
  String get clear => 'Borrar';

  @override
  String get autofillFilterPrefix => 'Filtro:';

  @override
  String get autofillPrompt => 'Select password entry for autofill.';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles.';

  @override
  String get noTitle => '(sin título)';

  @override
  String get noUsername => '(sin usuario)';

  @override
  String get filterCustomize => 'Personalizar …';

  @override
  String get swipeCopyPassword => 'Copiar contraseña';

  @override
  String get swipeCopyUsername => 'Copiar Usuario';

  @override
  String get doneCopiedPassword => 'Contraseña copiada al portapapeles.';

  @override
  String get doneCopiedUsername => 'Usuario copiado al portapapeles.';

  @override
  String get doneCopiedField => 'Copiado.';

  @override
  String get emptyPasswordVaultPlaceholder => 'Aún no tienes ninguna contraseña en tu base de datos.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Crea tu primera contraseña';

  @override
  String get loadingFile => 'Cargando archivo …';

  @override
  String get internalFile => 'Archivo interno';

  @override
  String get internalFileSubtitle => 'Database previously created with AuthPass';

  @override
  String get filePicker => 'File Picker';

  @override
  String get filePickerSubtitle => 'Open file from the device.';

  @override
  String get credentialsAppBarTitle => 'Credentials';

  @override
  String get credentialLabel => 'Enter the password for:';

  @override
  String get masterPasswordInputLabel => 'Password';

  @override
  String get masterPasswordEmptyValidator => 'Please enter your password.';

  @override
  String get masterPasswordIncorrectValidator => 'Invalid password';

  @override
  String get useKeyFile => 'Use Key File';

  @override
  String get saveMasterPasswordBiometric => 'Save Password with biometric key store?';

  @override
  String get errorOpenFileAlreadyOpenTitle => 'File already open';

  @override
  String errorOpenFileAlreadyOpenBody(Object databaseName, Object openFileSource, Object newFileSource) {
    return 'The selected database ${databaseName} is already open from ${openFileSource} (Tried to open from ${newFileSource})';
  }

  @override
  String get errorUnlockFileTitle => 'Unable to open File';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Unknown error while trying to open file. ${error}';
  }

  @override
  String get dialogContinue => 'Continue';

  @override
  String get dialogSendErrorReport => 'Send Error Report/Help';

  @override
  String get groupFilterDescription => 'Select which Groups to show (recursively)';

  @override
  String get groupFilterSelectAll => 'Select all';

  @override
  String get groupFilterDeselectAll => 'Deselect all';

  @override
  String get createSubgroup => 'Create Subgroup';

  @override
  String get editAction => 'Edit';

  @override
  String get deleteAction => 'Delete';

  @override
  String get successfullyDeletedGroup => 'Deleted group.';

  @override
  String get undoButtonLabel => 'Undo';

  @override
  String get saveButtonLabel => 'Save';

  @override
  String get initialNewGroupName => 'New Group';

  @override
  String get deleteGroupErrorTitle => 'Unable to delete group';

  @override
  String get deleteGroupErrorBodyContainsGroup => 'This group still contains other groups. You can currently only delete empty groups.';

  @override
  String get deleteGroupErrorBodyContainsEntries => 'This group still contains password entries. You can currently only delete empty groups.';

  @override
  String get groupListAppBarTitle => 'Groups';

  @override
  String get groupListFilterAppbarTitle => 'Filter by groups';

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
    return 'Unexpected Error: ${error}';
  }
}
