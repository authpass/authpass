// ignore_for_file: omit_local_variable_types,unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

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
  String get spanish => 'Español';

  @override
  String get indonesian => 'Indonesio';

  @override
  String get turkish => 'Turco';

  @override
  String get hebrew => 'Hebreo';

  @override
  String get italian => 'italiano';

  @override
  String get chineseSimplified => 'Chino simplificado';

  @override
  String get chineseTraditional => 'Chino Tradicional';

  @override
  String get portugueseBrazilian => 'Portugués, Basilero';

  @override
  String get slovak => 'Eslovaco';

  @override
  String get dutch => 'Holandés';

  @override
  String get selectItem => 'Seleccionar';

  @override
  String get selectKeepassFile => 'AuthPass - Seleccionar archivo KeePass';

  @override
  String get selectKeepassFileLabel =>
      'Por favor seleccione un archivo KeePass (.kdbx).';

  @override
  String get createNewFile => 'Crear nuevo archivo';

  @override
  String get openLocalFile => 'Abrir archivo local';

  @override
  String get openFile => 'Abrir archivo';

  @override
  String get loadFromDropdownMenu => 'Cargar desde …';

  @override
  String get quickUnlockingFiles => 'Desbloqueo rápido de archivos…';

  @override
  String openFileProgress(Object fileName, Object current, Object totalCount) {
    return 'Abriendo $fileName … ($current / $totalCount)';
  }

  @override
  String loadFrom(String cloudStorageName) {
    return 'Cargar desde $cloudStorageName';
  }

  @override
  String get loadFromRemoteUrl => 'Abrir kdbx desde URL';

  @override
  String get createNewKeepass =>
      '¿Nuevo en KeePass?\nCrear nueva base de datos de contraseñas';

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
  String get preferenceAllowScreenshots =>
      'Permitir capturas de pantalla de la aplicación';

  @override
  String get preferenceEnableAutoFill => 'Habilitar autocompletar';

  @override
  String get enableAutofillSuggestionBanner =>
      '¡Puedes rellenar los espacios en otras aplicaciones habilitando el llenado automático!';

  @override
  String get dismissAutofillSuggestionBannerButton => 'DESCARTAR';

  @override
  String get enableAutofillSuggestionBannerButton => '¡HABILITAR!';

  @override
  String get preferenceAutoFillDescription =>
      'Sólo compatible con Android Oreo (8.0) o posterior.';

  @override
  String get preferenceTitle => 'Preferencias';

  @override
  String get preferenceEnableSystemWideShortcuts =>
      'Habilitar accesos directos del sistema';

  @override
  String get preferenceEnableSystemWideShortcutsHelp =>
      'Registra CTRL + ALT + F como un atajo general para abrir el buscador.';

  @override
  String get preferencesSearchFields => 'Personalizar campos de búsqueda';

  @override
  String get preferencesSearchFieldPromptTitle => 'Campos de búsqueda';

  @override
  String get preferencesSearchFieldPromptLabel =>
      'Lista de espacios separados por una coma para usar en la búsqueda de la lista de contraseñas.';

  @override
  String preferencesSearchFieldPromptHelp(
      Object wildCardCharacter, Object defaultSearchFields) {
    return 'Utilizar $wildCardCharacter para todo, dejar vacío por defecto ($defaultSearchFields)';
  }

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback => '¡Agradecemos cualquier tipo de comentarios!';

  @override
  String get aboutLinkVisitWebsite =>
      'También asegúrese de visitar nuestro sitio web';

  @override
  String get aboutLinkGitHub => 'Y el proyecto de Código Abierto';

  @override
  String aboutLogFile(String logFilePath) {
    return 'Archivo Log: $logFilePath';
  }

  @override
  String get aboutLinkContributors => 'Mostrar colaboradores';

  @override
  String get unableToLaunchUrlTitle => 'No se pudo abrir la Url';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'No se puede abrir $url: $openError';
  }

  @override
  String get unableToLaunchUrlNoHandler =>
      'Ninguna aplicación disponible para la url.';

  @override
  String launchedUrl(Object url) {
    return 'URL abierta: $url';
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
  String get menuItemSupport => 'Enviar bitácoras';

  @override
  String get menuItemSupportSubtitle =>
      'Enviar registros por correo electrónico';

  @override
  String get menuItemForum => 'Foro de Soporte';

  @override
  String get menuItemForumSubtitle => 'Reportar problemas y obtener ayuda';

  @override
  String get menuItemHelp => 'Ayuda';

  @override
  String get menuItemHelpSubtitle => 'Mostrar documentación';

  @override
  String get menuItemAbout => 'Acerca de';

  @override
  String get actionOpenUrl => 'Abrir URL';

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
    return 'Solo usado para longitud > $customMinLength';
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
      other: '$numFilesString archivos guardados: $files',
      one: 'Un archivo guardado: $files',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => 'Gestionar Grupos';

  @override
  String get lockFiles => 'Bloquear Archivos';

  @override
  String get searchHint => 'Buscar';

  @override
  String get searchButtonLabel => 'Buscar';

  @override
  String get filterButtonLabel => 'Filtrar por grupo';

  @override
  String get clear => 'Borrar';

  @override
  String get autofillFilterPrefix => 'Filtro:';

  @override
  String get autofillPrompt =>
      'Seleccione campo de contraseña para autollenado.';

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
  String get copyUsernameNotExists => 'La entrada no tiene nombre de usuario.';

  @override
  String get copyPasswordNotExists => 'La entrada no tiene contraseña.';

  @override
  String get doneCopiedPassword => 'Contraseña copiada al portapapeles.';

  @override
  String get doneCopiedUsername => 'Usuario copiado al portapapeles.';

  @override
  String get doneCopiedField => 'Copiado.';

  @override
  String copiedFieldToClipboard(Object fieldName) {
    return '$fieldName copiado.';
  }

  @override
  String copiedFieldEmpty(Object fieldName) {
    return '$fieldName está vacío.';
  }

  @override
  String get emptyPasswordVaultPlaceholder =>
      'Aún no tienes ninguna contraseña en tu base de datos.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Crea tu primera contraseña';

  @override
  String get loading => 'Cargando';

  @override
  String get loadingFile => 'Cargando archivo …';

  @override
  String get internalFile => 'Archivo interno';

  @override
  String get internalFileSubtitle =>
      'Base de datos previamente creada con AuthPass';

  @override
  String get filePicker => 'Selector de archivos';

  @override
  String get filePickerSubtitle => 'Abrir archivo desde el dispositivo.';

  @override
  String get credentialsAppBarTitle => 'Credenciales';

  @override
  String get credentialLabel => 'Introduzca la contraseña para:';

  @override
  String get masterPasswordInputLabel => 'Contraseña';

  @override
  String get masterPasswordEmptyValidator =>
      'Por favor, introduzca su contraseña.';

  @override
  String get masterPasswordIncorrectValidator => 'Contraseña inválida';

  @override
  String get useKeyFile => 'Usar archivo clave';

  @override
  String get saveMasterPasswordBiometric =>
      '¿Guardar contraseña con clave biométrica?';

  @override
  String get close => 'Cerrar';

  @override
  String get addNewPassword => 'Añadir nueva contraseña';

  @override
  String get errorOpenFileInvalidFileStructureTitle =>
      'Se intentó abrir un tipo de archivo inválido';

  @override
  String errorOpenFileInvalidFileStructureBody(Object fileName) {
    return 'El archivo ($fileName) parece no ser un archivo KDBX válido. Por favor, elija un archivo KDBX válido o cree una nueva base de datos para las contraseñas.';
  }

  @override
  String get errorOpenFileAlreadyOpenTitle => 'Archivo ya abierto';

  @override
  String errorOpenFileAlreadyOpenBody(
      Object databaseName, Object openFileSource, Object newFileSource) {
    return 'La base de datos seleccionada $databaseName ya está abierta desde $openFileSource (Se intentó abrir desde $newFileSource)';
  }

  @override
  String get loadFromUrl => 'Descargar desde URL';

  @override
  String get loadFromUrlEnterUrl => 'Introducir URL';

  @override
  String get loadFromUrlErrorEnterFullUrl =>
      'Por favor, introduzca una URL completa que comience con http:// o https://';

  @override
  String get loadFromUrlErrorInvalidUrl =>
      'Por favor, introduzca una url válida.';

  @override
  String get linuxAppArmorWarning =>
      'AuthPass requiere su permiso para comunicarse con el Servicio Secreto para almacenar las credenciales del almacenamiento en la nube.\n\nPor favor, ejecute el siguiente comando:';

  @override
  String get cancel => 'Cancelar';

  @override
  String get errorLoadFileFromSourceTitle => 'Error al abrir el archivo.';

  @override
  String errorLoadFileFromSourceBody(Object source, Object error) {
    return 'No se puede abrir $source.\n$error';
  }

  @override
  String get errorUnlockFileTitle => 'No se puede abrir el archivo';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Error desconocido al intentar abrir el archivo. $error';
  }

  @override
  String get dialogContinue => 'Continuar';

  @override
  String get dialogSendErrorReport => 'Enviar Informe de Error';

  @override
  String get dialogReportErrorForum => 'Reportar error en el Foro/Ayuda';

  @override
  String get groupFilterDescription =>
      'Seleccione qué grupos mostrar (recursivamente)';

  @override
  String get groupFilterSelectAll => 'Seleccionar todo';

  @override
  String get groupFilterDeselectAll => 'Deseleccionar todo';

  @override
  String get createSubgroup => 'Crear subgrupo';

  @override
  String get editAction => 'Editar';

  @override
  String get mailboxEnableLabel => '(re)habilitar';

  @override
  String get mailboxEnableHint => 'Continuar recibiendo correos';

  @override
  String get mailboxDisableLabel => 'Deshabilitar';

  @override
  String get mailboxDisableHint => 'No recibir más correos';

  @override
  String get mailListNoMail => 'Aún no tienes ningún correo.';

  @override
  String mailboxLabelPrefixForEntry(Object entryLabel) {
    return 'Entrada: $entryLabel';
  }

  @override
  String mailboxLabelPrefixUnknownEntry(Object entryUuid) {
    return 'Entrada desconocida: $entryUuid';
  }

  @override
  String mailboxLabelPrefixCreatedAt(Object dateTime) {
    return 'Creado el: $dateTime';
  }

  @override
  String get masterPasswordDescription =>
      'La contraseña maestra se utiliza para cifrar de forma segura su base de datos. Asegúrese de recordarla, no puede ser restaurada.';

  @override
  String get unsavedChangesWarningTitle => 'Cambios sin guardar';

  @override
  String get unsavedChangesWarningBody =>
      'Todavía hay cambios sin guardar. ¿Desea descartar los cambios?';

  @override
  String get unsavedChangesDiscardActionLabel => 'Descartar cambios';

  @override
  String get deletePermanentlyAction => 'Eliminar Permanentemente';

  @override
  String get restoreFromRecycleBinAction => 'Restaurar';

  @override
  String get deleteAction => 'Eliminar';

  @override
  String get deletedEntry => 'Entrada eliminada.';

  @override
  String get successfullyDeletedGroup => 'Grupo eliminado.';

  @override
  String get undoButtonLabel => 'Deshacer';

  @override
  String get saveButtonLabel => 'Guardar';

  @override
  String get webDavSettings => 'Ajustes WebDAV';

  @override
  String get webDavUrlLabel => 'URL';

  @override
  String get webDavUrlHelperText => 'URL base para su servicio WebDAV.';

  @override
  String get webDavUrlValidatorError => 'Por favor, introduzca una URL';

  @override
  String get webDavUrlValidatorInvalidUrlError =>
      'Por favor, introduzca una URL válida con http:// o https://';

  @override
  String get webDavAuthUser => 'Usuario';

  @override
  String get webDavAuthPassword => 'Contraseña';

  @override
  String get mergeSuccessDialogTitle =>
      'Base de datos de contraseñas combinada con éxito';

  @override
  String mergeSuccessDialogMessage(Object fileName, Object mergeSummary) {
    return 'Conflicto detectado al guardar $fileName, se combinó con éxito con el archivo remoto: \n\n$mergeSummary';
  }

  @override
  String forDetailsVisitUrl(Object url) {
    return 'Para más información, visite $url';
  }

  @override
  String get authPassCloudAuthEmailInputLabel =>
      'Introduzca una dirección de correo para registrarse o iniciar sesión.';

  @override
  String get authPassCloudAuthEmailInvalid =>
      'Por favor, introduzca una dirección de correo válida.';

  @override
  String get authPassCloudAuthConfirmEmailButtonLabel => 'Confirmar dirección';

  @override
  String get authPassCloudAuthConfirmEmail =>
      'Por favor, compruebe su correo para confirmar la dirección.';

  @override
  String get authPassCloudAuthConfirmEmailExplain =>
      'Mantenga esta pantalla abierta hasta que haya visitado el enlace recibido por correo.';

  @override
  String get authPassCloudAuthResendExplain =>
      'Si no has recibido un correo electrónico, por favor revisa tu carpeta de spam. De lo contrario, puedes intentar solicitar un nuevo enlace de confirmación.';

  @override
  String get authPassCloudAuthResendButtonLabel =>
      'Solicitar un nuevo enlace de confirmación';

  @override
  String permanentlyDeleteEntryConfirm(Object title) {
    return 'Esto eliminará permanentemente la entrada $title. Esto no se puede deshacer. ¿Desea continuar?';
  }

  @override
  String get permanentlyDeletedEntrySnackBar =>
      'Entrada eliminada permanentemente.';

  @override
  String get initialNewGroupName => 'Nuevo grupo';

  @override
  String get deleteGroupErrorTitle => 'No se puede eliminar el grupo';

  @override
  String get deleteGroupErrorBodyContainsGroup =>
      'Este grupo aún contiene otros grupos. Actualmente sólo puede eliminar grupos vacíos.';

  @override
  String get deleteGroupErrorBodyContainsEntries =>
      'Este grupo aún contiene entradas de contraseña. Actualmente sólo puede eliminar grupos vacíos.';

  @override
  String get groupListAppBarTitle => 'Grupos';

  @override
  String get groupListFilterAppbarTitle => 'Filtrar por grupos';

  @override
  String get clearQuickUnlock => 'Borrar almacenamiento biométrico';

  @override
  String get clearQuickUnlockSubtitle =>
      'Eliminar contraseñas maestras guardadas';

  @override
  String get unlock => 'Desbloquear archivos';

  @override
  String get closePasswordFiles => 'cerrar archivos de contraseñas';

  @override
  String get clearQuickUnlockSuccess =>
      'Eliminadas las contraseñas maestras guardadas del almacenamiento biométrico.';

  @override
  String get diacOptIn => 'Opte por las noticias en la aplicación, encuestas.';

  @override
  String get diacOptInSubtitle =>
      'Ocasionalmente enviará una solicitud de red para obtener noticias.';

  @override
  String get enableAutofillDebug => 'Autollenado: Habilitar depuración';

  @override
  String get enableAutofillDebugSubtitle =>
      'Muestra capas de información para cada campo de entrada';

  @override
  String get createPasswordDatabase => 'Crear base de datos de contraseñas';

  @override
  String get nameNewPasswordDatabase => 'Nombre de su nueva base de datos';

  @override
  String get validatorNameMissing =>
      'Por favor, introduzca un nombre para su nueva base de datos.';

  @override
  String get masterPasswordHelpText =>
      'Seleccione una contraseña maestra segura. Asegúrese de recordarla.';

  @override
  String get inputMasterPasswordText => 'Contraseña maestra';

  @override
  String get masterPasswordMissingCreate =>
      'Por favor, introduzca una contraseña segura y recordable.';

  @override
  String get createDatabaseAction => 'Crear base de datos';

  @override
  String get databaseExistsError => 'El archivo ya existe';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'Error al intentar crear la base de datos $filePath. El archivo ya existe. Por favor elija otro nombre.';
  }

  @override
  String get databaseCreateDefaultName => 'ContraseñasPersonales';

  @override
  String get preferenceDynamicLoadIcons => 'Cargar iconos dinámicamente';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'Hará solicitudes http con el valor en el campo $urlFieldName para cargar iconos del sitio web.';
  }

  @override
  String passwordScore(Object score) {
    return 'Fortaleza: $score de 4';
  }

  @override
  String get entryInfoFile => 'Archivo:';

  @override
  String get entryInfoGroup => 'Grupo:';

  @override
  String get entryInfoLastModified => 'Última modificación:';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'Entrada movida a $groupName';
  }

  @override
  String sizeBytesStoredAuthPassCloud(Object count) {
    return '$count bytes, almacenados en AuthPass Cloud';
  }

  @override
  String sizeBytes(Object count) {
    return '$count bytes';
  }

  @override
  String get entryAddAttachment => 'Añadir archivo adjunto';

  @override
  String get entryAttachmentSizeWarning =>
      'Los archivos adjuntos serán incorporados en el archivo de contraseñas. Esto puede aumentar significativamente el tiempo necesario para abrir/guardar contraseñas.';

  @override
  String get iconPngSizeWarning =>
      'Los iconos personalizados se incorporarán en el archivo de contraseñas. Esto puede aumentar significativamente el tiempo necesario para abrir/guardar contraseñas.';

  @override
  String get notPngError => 'El archivo elegido no es PNG.';

  @override
  String get entryAddField => 'Añadir campo';

  @override
  String get entryCustomField => 'Campo personalizado';

  @override
  String get entryCustomFieldTitle => 'Añadir nuevo campo personalizado';

  @override
  String get entryCustomFieldInputLabel => 'Ingrese un nombre para el campo';

  @override
  String get swipeCopyField => 'Copiar campo';

  @override
  String get fieldRename => 'Renombrar';

  @override
  String get fieldGeneratePassword => 'Generar contraseña …';

  @override
  String get fieldProtect => 'Proteger Valor';

  @override
  String get fieldUnprotect => 'Desproteger Valor';

  @override
  String get fieldPresent => 'Presentar';

  @override
  String get fieldGenerateEmail => 'Generar Email';

  @override
  String get onboardingBackToOnboarding => 'Tour';

  @override
  String get onboardingBackToOnboardingSubtitle =>
      'Reviva la experiencia de la primera ejecución 😅';

  @override
  String get onboardingHeadline => '¡Hagamos que tus contraseñas sean seguras!';

  @override
  String get onboardingQuestion => '¿Ha usado un gestor de contraseñas antes?';

  @override
  String get onboardingYesOpenPasswords => 'Sí, abrir mis contraseñas';

  @override
  String get onboardingNoCreate => '¡Soy todo nuevo! Empecemos.';

  @override
  String get backupButton => 'GUARDAR EN LA NUBE';

  @override
  String get dismissBackupButton => 'DESCARTAR';

  @override
  String backupWarningMessage(Object databasename) {
    return '¡Tus contraseñas en $databasename solo se guardan localmente!';
  }

  @override
  String get saveAs => 'Guardar en...';

  @override
  String get saving => 'Guardando';

  @override
  String get increaseValue => 'Aumentar';

  @override
  String get decreaseValue => 'Reducir';

  @override
  String get resetValue => 'Reset';

  @override
  String cloudStorageAppBarTitle(Object cloudStorageName) {
    return 'Almacenamiento en la nube - $cloudStorageName';
  }

  @override
  String get cloudStorageLogInCaption =>
      'Será redirigido para autorizar a AuthPass para acceder a sus datos.';

  @override
  String get cloudStorageLogInCode => 'Introducir código';

  @override
  String launchUrlError(Object url) {
    return 'No se puede iniciar la URL. Por favor, visite $url';
  }

  @override
  String cloudStorageLogInActionLabel(Object cloudStorageName) {
    return 'Inicie sesión en $cloudStorageName';
  }

  @override
  String cloudStorageAuthCodeDialogTitle(Object cloudStorageName) {
    return 'Autenticación de $cloudStorageName';
  }

  @override
  String get cloudStorageAuthCodeLabel => 'Código de autenticación';

  @override
  String get cloudStorageAuthErrorTitle => 'Error al autenticar';

  @override
  String cloudStorageAuthErrorMessage(
      Object cloudStorageName, Object errorMessage) {
    return 'Error al intentar autenticar en $cloudStorageName: $errorMessage';
  }

  @override
  String get cloudStorageSearchBoxLabel => 'Búsqueda';

  @override
  String cloudStorageItemsInFolder(Object itemCount) {
    return '$itemCount elementos en esta carpeta.';
  }

  @override
  String get mailSubject => 'Asunto';

  @override
  String get mailFrom => 'De';

  @override
  String get mailDate => 'Fecha';

  @override
  String get mailMailbox => 'Buzón';

  @override
  String get mailNoData => 'Sin datos';

  @override
  String get mailMailboxesTitle => 'Buzones';

  @override
  String get mailboxCreateButtonLabel => 'Crear';

  @override
  String get mailboxNameInputDialogTitle =>
      'Etiqueta opcional para el nuevo buzón';

  @override
  String get mailboxNameInputLabel => '(Interno) Etiqueta';

  @override
  String get mailScreenTitle => 'Correo electrónico de AuthPass';

  @override
  String get mailTabBarTitleMailbox => 'Buzón';

  @override
  String get mailTabBarTitleMail => 'Correo';

  @override
  String get mailMailboxListEmpty => 'Todavía no tiene ningún buzón.';

  @override
  String mailMailboxAddressCopied(Object mailboxAddress) {
    return 'Dirección del buzón copiada al portapapeles: $mailboxAddress';
  }

  @override
  String get errorWhileSavingTitle => 'Error al guardar';

  @override
  String errorWhileSavingBody(Object errorMessage) {
    return 'No es posible guardar el archivo: $errorMessage';
  }

  @override
  String get databaseDoesNotSupportSaving =>
      'Lo sentimos, esta base de datos no se puede guardar. Por favor, abra una base de datos local o utilice \"Guardar como\".';

  @override
  String get otpInvalidKeyTitle => 'Clave inválida';

  @override
  String get otpInvalidKeyBody =>
      'La entrada no es un código TOTP base32 válido. Por favor, verifique lo introducido.';

  @override
  String get otpUnsupportedMigrationTitle => 'Unsupported OTP Migration';

  @override
  String otpUnsupportedMigrationBody(Object uriCount) {
    return 'We currently only support single item migrations. Got $uriCount';
  }

  @override
  String get otpPromptTitle => 'Autenticación basada en el tiempo';

  @override
  String get otpPromptHelperText =>
      'Por favor, introduzca la clave basada en el tiempo.';

  @override
  String otpErrorMessageGeneration(Object errorMessage) {
    return 'Error al generar el código de invitación: $errorMessage';
  }

  @override
  String get otpCopySecretActionLabel => 'Copiar Secreto';

  @override
  String get otpEntryLabel => 'Token de un solo uso';

  @override
  String get entryFieldProtected =>
      'Campo protegido. Haga clic para revelarlo.';

  @override
  String get entryFieldActionRevealField => 'Mostrar campo protegido';

  @override
  String get entryAttachmentOpenActionLabel => 'Abrir';

  @override
  String get entryAttachmentShareActionLabel => 'Compartir';

  @override
  String get entryAttachmentShareSubject => 'Archivo adjunto';

  @override
  String get entryAttachmentSaveActionLabel => 'Guardar en el dispositivo';

  @override
  String get entryAttachmentRemoveActionLabel => 'Eliminar';

  @override
  String entryAttachmentRemoveConfirm(Object attachmentLabel) {
    return '¿Está seguro de que desea eliminar $attachmentLabel?';
  }

  @override
  String get entryRenameFieldPromptTitle => 'Renombrar Campo';

  @override
  String get removerecentfile => 'Ocultar';

  @override
  String get entryRenameFieldPromptLabel =>
      'Introduzca el nuevo nombre para el campo';

  @override
  String get promptDialogPasteActionTooltip => 'Pegar desde el portapapeles';

  @override
  String get promptDialogPasteHint =>
      'Sugerencia: Si necesita pegar, pruebe el botón de la izquierda ;-)';

  @override
  String get genericErrorDialogTitle => 'Error al manejar la acción';

  @override
  String genericErrorDialogBody(Object errorMessage) {
    return 'Se encontró un error inesperado. $errorMessage';
  }

  @override
  String get saveAsEntryLocalFile => 'Archivo local';

  @override
  String get fileTypePngs => 'Imágenes (png)';

  @override
  String get selectIconDialogAction => 'SELECCIONAR ICON';

  @override
  String get retryDialogActionLabel => 'REINTENTAR';

  @override
  String errorDuringNetworkCall(Object errorMessage) {
    return 'Error durante la llamada a la API. $errorMessage';
  }

  @override
  String get passwordFilterHideDeleted => 'Ocultar entradas eliminadas';

  @override
  String get passwordFilterOnlyDeleted => 'Entradas eliminadas';

  @override
  String passwordFilterPrefixForOneGroup(Object groupName) {
    return 'Grupo: $groupName';
  }

  @override
  String passwordFilterPrefixForMultipleGroups(Object groupCount) {
    return 'Filtro personalizado ($groupCount grupos)';
  }

  @override
  String get menuItemAuthPassCloudAuthenticate =>
      'Autenticar con AuthPass Cloud';

  @override
  String get menuItemAuthPassCloudMailboxes => 'Buzones de AuthPass';

  @override
  String changesWithoutSaving(Object fileName) {
    return 'Has realizado cambios en \"$fileName\", que no soporta realizar cambios.';
  }

  @override
  String get changesSaveLocally => 'Guardar localmente';

  @override
  String get clearColor => 'Eliminar color';

  @override
  String get databaseRenameInputLabel =>
      'Introduce el nombre de la base de datos';

  @override
  String get databasePath => 'Ruta';

  @override
  String get databaseColor => 'Color';

  @override
  String get databaseColorChoose =>
      'Seleccione un color para distinguir entre archivos.';

  @override
  String get databaseKdbxVersion => 'Versión del archivo KDBX';

  @override
  String databaseKdbxUpgradeVersion(Object versionName) {
    return 'Actualizar a $versionName';
  }

  @override
  String get databaseKdbxUpgradeSuccessful =>
      'Archivo actualizado y guardado correctamente.';

  @override
  String get databaseReload => 'Recargar y fusionar';

  @override
  String progressStatus(Object statusProgress) {
    return 'Estado: $statusProgress';
  }

  @override
  String finishedMerge(Object status) {
    return 'Fusión finalizada $status';
  }

  @override
  String get closeAndLockFile => 'Cerrar/Bloquear';

  @override
  String get authPassHomeScreenTagline =>
      'gestor de contraseñas, de código abierto, disponible en todas las plataformas.';

  @override
  String get addNewPasswordButtonLabel => 'Añadir nueva contraseña';

  @override
  String get unnamedEntryPlaceholder => '(Sin nombre)';

  @override
  String get unnamedGroupPlaceholder => '(Sin nombre)';

  @override
  String get unnamedFilePlaceholder => '(Sin nombre)';

  @override
  String get editGroupScreenTitle => 'Editar grupo';

  @override
  String get editGroupGroupNameLabel => 'Nombre del grupo';

  @override
  String get files => 'Archivos';

  @override
  String get newGroupDialogTitle => 'Nuevo grupo';

  @override
  String get newGroupDialogInputLabel => 'Nombre para el nuevo grupo';

  @override
  String get groupActionShowPasswords => 'Mostrar contraseñas';

  @override
  String get groupActionDelete => 'Eliminar';

  @override
  String get logoutTooltip => 'Cerrar sesión';

  @override
  String get successfullyDeletedFileCloudStorage =>
      'Archivo eliminado correctamente.';

  @override
  String shareDialogTitle(Object fileName) {
    return 'Opciones para compartir $fileName';
  }

  @override
  String get shareFileActionLabel => 'Compartir …';

  @override
  String get shareTokenListEmptyScreenPlaceholder =>
      'Archivo aún no compartido.';

  @override
  String get shareTokenNoLabel => 'Sin etiqueta/descripción';

  @override
  String get shareTokenReadWrite => 'Lectura/Escritura';

  @override
  String get shareTokenReadOnly => 'Sólo lectura';

  @override
  String get shareCreateTokenDialogTitle => 'Compartir archivo';

  @override
  String get shareCreateTokenReadOnly => 'Sólo lectura';

  @override
  String get shareCreateTokenReadOnlyHelpText => 'No permitir guardar cambios';

  @override
  String get shareCreateTokenLabelText => 'Descripción';

  @override
  String get shareCreateTokenLabelHint => 'Compartir a mi amigo';

  @override
  String get shareCreateTokenLabelHelp =>
      'Etiqueta opcional para diferenciar el código de compartir.';

  @override
  String get shareCreateTokenSuccess =>
      'Código para compartir creado con éxito.';

  @override
  String get sharePresentDialogTitle =>
      'Compartir archivo con código secreto compartido';

  @override
  String get sharePresentDialogHelp =>
      'Usando el siguiente código compartido los usuarios pueden acceder al archivo de contraseñas. Necesitarán la contraseña y/o el archivo de clave para abrirlo.';

  @override
  String get sharePresentToken => 'Código para compartir';

  @override
  String get sharePresentCopied =>
      'El código compartido se copió al portapapeles.';

  @override
  String get authPassCloudOpenWithShareCodeTooltip =>
      'Abrir con Compartir Código';

  @override
  String get authPassCloudShareFileActionLabel => 'Compartir';

  @override
  String get preferenceAuthPassCloudAttachmentTitle =>
      'Usar adjuntos en AuthPass Cloud';

  @override
  String get preferenceAuthPassCloudAttachmentSubtitle =>
      'Almacenar adjuntos encriptados en AuthPass Cloud por separado.';

  @override
  String get shareCodeInputDialogTitle =>
      'Introduzca el Código Secreto Compartido';

  @override
  String get shareCodeInputDialogScan => 'Escanear código QR';

  @override
  String get shareCodeInputLabel => 'Código Secreto Compartido';

  @override
  String get shareCodeInputHelperText =>
      'Si ha recibido un código para compartir, por favor pégalo arriba.';

  @override
  String get shareCodeOpen =>
      '¿Recibió un Código Compartido para AuthPass Cloud?';

  @override
  String get shareCodeOpenScreenTitle =>
      'Cargando archivo con código compartido';

  @override
  String get shareCodeLoadingProgress => 'Cargando archivo …';

  @override
  String get shareCodeOpenFileButtonLabel => 'ABRIR';

  @override
  String get shareCodeOpenInstallAppCaption =>
      '¿Desea abrir este archivo con una de nuestras aplicaciones nativas?';

  @override
  String get shareCodeOpenAnotherAppCaption =>
      '¿Desea abrir este archivo en otro dispositivo?';

  @override
  String get shareCodeOpenInstallAppButtonLabel => 'Instalar Aplicación';

  @override
  String get shareCodeOpenShowCodeButtonLabel => 'Mostrar código compartido';

  @override
  String get changeMasterPasswordActionLabel => 'Cambiar contraseña maestra';

  @override
  String get changeMasterPasswordFormSubmit => 'Guardar con nueva contraseña';

  @override
  String get changeMasterPasswordSuccess =>
      'Contraseña maestra guardada correctamente.';

  @override
  String get changeMasterPasswordScreenTitle => 'Cambiar contraseña maestra';

  @override
  String get authPassCloudAuthClickedLink =>
      'Recibí correo electrónico y he visitado el enlace';

  @override
  String get authPassCloudAuthNotConfirmed =>
      'La dirección de correo electrónico aún no ha sido confirmada. Asegúrate de hacer clic en el enlace del correo electrónico que recibiste y resolver el captcha para confirmar tu dirección de correo electrónico.';

  @override
  String get getHelpButton => 'Obtener ayuda en el foro';

  @override
  String get shortcutCopyUsername => 'Copiar Usuario';

  @override
  String get shortcutCopyPassword => 'Copiar contraseña';

  @override
  String get shortcutCopyTotp => 'Copiar TOTP';

  @override
  String get shortcutMoveUp => 'Seleccione la contraseña anterior';

  @override
  String get shortcutMoveDown => 'Seleccione la siguiente contraseña';

  @override
  String get shortcutGeneratePassword => 'Generar contraseña';

  @override
  String get shortcutCopyUrl => 'Copiar URL';

  @override
  String get shortcutOpenUrl => 'Abrir URL';

  @override
  String get shortcutCancelSearch => 'Cancelar búsqueda';

  @override
  String get shortcutShortcutHelp => 'Ayuda de atajo de teclado';

  @override
  String get shortcutHelpTitle => 'Atajos de teclado';

  @override
  String unexpectedError(String error) {
    return 'Error inesperado: $error';
  }

  @override
  String get googleDriveMorePermissionsRequired =>
      'Additional permissions needed to access Google Drive.';

  @override
  String get googleDriveRequestPermissionButtonLabel => 'Request Permissions';

  @override
  String get scanQrCodeTitle => 'Scan QR Code.';
}
