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
  String get spanish => 'Español';

  @override
  String get indonesian => 'Indonesio';

  @override
  String get selectKeepassFile => 'AuthPass - Seleccionar archivo KeePass';

  @override
  String get quickUnlockingFiles => 'Desbloqueo rápido de archivos';

  @override
  String get selectKeepassFileLabel => 'Por favor seleccione un archivo KeePass (.kdbx).';

  @override
  String get createNewFile => 'Crear nuevo archivo';

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
  String get loadFromRemoteUrl => 'Abrir kdbx desde URL';

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
  String get unableToLaunchUrlTitle => 'No se pudo abrir la Url';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'No se puede abrir ${url}: ${openError}';
  }

  @override
  String get unableToLaunchUrlNoHandler => 'Ninguna aplicación disponible para la url.';

  @override
  String launchedUrl(Object url) {
    return 'URL abierta: ${url}';
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
  String get autofillPrompt => 'Seleccione campo de contraseña para autollenado.';

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
  String get internalFileSubtitle => 'Base de datos previamente creada con AuthPass';

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
  String get masterPasswordEmptyValidator => 'Por favor, introduzca su contraseña.';

  @override
  String get masterPasswordIncorrectValidator => 'Contraseña inválida';

  @override
  String get useKeyFile => 'Usar archivo clave';

  @override
  String get saveMasterPasswordBiometric => '¿Guardar contraseña con clave biométrica?';

  @override
  String get errorOpenFileAlreadyOpenTitle => 'Archivo ya abierto';

  @override
  String errorOpenFileAlreadyOpenBody(Object databaseName, Object openFileSource, Object newFileSource) {
    return 'La base de datos seleccionada ${databaseName} ya está abierta desde ${openFileSource} (Se intentó abrir desde ${newFileSource})';
  }

  @override
  String get errorUnlockFileTitle => 'No se puede abrir el archivo';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Error desconocido al intentar abrir el archivo. ${error}';
  }

  @override
  String get dialogContinue => 'Continuar';

  @override
  String get dialogSendErrorReport => 'Enviar informe de errores/Ayuda';

  @override
  String get groupFilterDescription => 'Seleccione qué grupos mostrar (recursivamente)';

  @override
  String get groupFilterSelectAll => 'Seleccionar todo';

  @override
  String get groupFilterDeselectAll => 'Deseleccionar todo';

  @override
  String get createSubgroup => 'Crear subgrupo';

  @override
  String get editAction => 'Editar';

  @override
  String get deleteAction => 'Eliminar';

  @override
  String get successfullyDeletedGroup => 'Grupo eliminado.';

  @override
  String get undoButtonLabel => 'Deshacer';

  @override
  String get saveButtonLabel => 'Guardar';

  @override
  String get initialNewGroupName => 'Nuevo grupo';

  @override
  String get deleteGroupErrorTitle => 'No se puede eliminar el grupo';

  @override
  String get deleteGroupErrorBodyContainsGroup => 'Este grupo aún contiene otros grupos. Actualmente sólo puede eliminar grupos vacíos.';

  @override
  String get deleteGroupErrorBodyContainsEntries => 'Este grupo aún contiene entradas de contraseña. Actualmente sólo puede eliminar grupos vacíos.';

  @override
  String get groupListAppBarTitle => 'Grupos';

  @override
  String get groupListFilterAppbarTitle => 'Filtrar por grupos';

  @override
  String get clearQuickUnlock => 'Borrar almacenamiento biométrico';

  @override
  String get clearQuickUnlockSubtitle => 'Eliminar contraseñas maestras guardadas';

  @override
  String get unlock => 'Desbloquear archivos';

  @override
  String get closePasswordFiles => 'cerrar archivos de contraseñas';

  @override
  String get clearQuickUnlockSuccess => 'Eliminadas las contraseñas maestras guardadas del almacenamiento biométrico.';

  @override
  String get diacOptIn => 'Opte por las noticias en la aplicación, encuestas.';

  @override
  String get diacOptInSubtitle => 'Ocasionalmente enviará una solicitud de red para obtener noticias.';

  @override
  String get enableAutofillDebug => 'Autollenado: Habilitar depuración';

  @override
  String get enableAutofillDebugSubtitle => 'Muestra capas de información para cada campo de entrada';

  @override
  String get createPasswordDatabase => 'Crear base de datos de contraseñas';

  @override
  String get nameNewPasswordDatabase => 'Nombre de su nueva base de datos';

  @override
  String get validatorNameMissing => 'Por favor, introduzca un nombre para su nueva base de datos.';

  @override
  String get masterPasswordHelpText => 'Seleccione una contraseña maestra segura. Asegúrese de recordarla.';

  @override
  String get inputMasterPasswordText => 'Contraseña maestra';

  @override
  String get masterPasswordMissingCreate => 'Por favor, introduzca una contraseña segura y recordable.';

  @override
  String get createDatabaseAction => 'Crear base de datos';

  @override
  String get databaseExistsError => 'El archivo ya existe';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'Error al intentar crear la base de datos ${filePath}. El archivo ya existe. Por favor elija otro nombre.';
  }

  @override
  String get databaseCreateDefaultName => 'ContraseñasPersonales';

  @override
  String get preferenceDynamicLoadIcons => 'Cargar iconos dinámicamente';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'Hará solicitudes http con el valor en el campo ${urlFieldName} para cargar iconos del sitio web.';
  }

  @override
  String passwordScore(Object score) {
    return 'Fortaleza: ${score} de 4';
  }

  @override
  String get entryInfoFile => 'Archivo:';

  @override
  String get entryInfoGroup => 'Grupo:';

  @override
  String get entryInfoLastModified => 'Última modificación:';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'Entrada movida a ${groupName}';
  }

  @override
  String sizeBytes(Object bytes) {
    return '{count} bytes';
  }

  @override
  String get entryAddAttachment => 'Añadir archivo adjunto';

  @override
  String get entryAttachmentSizeWarning => 'Los archivos adjuntos serán incorporados en el archivo de contraseñas. Esto puede aumentar significativamente el tiempo necesario para abrir/guardar contraseñas.';

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
  String get onboardingBackToOnboardingSubtitle => 'Reviva la experiencia de la primera ejecución 😅';

  @override
  String get onboardingHeadline => '¡Hagamos que tus contraseñas sean seguras!';

  @override
  String get onboardingQuestion => '¿Ha usado un gestor de contraseñas antes?';

  @override
  String get onboardingYesOpenPasswords => 'Sí, abrir mis contraseñas';

  @override
  String get onboardingNoCreate => '¡Soy todo nuevo! Empecemos.';

  @override
  String unexpectedError(String error) {
    return 'Error inesperado: ${error}';
  }
}
