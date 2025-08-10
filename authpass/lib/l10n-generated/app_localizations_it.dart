// ignore_for_file: omit_local_variable_types,unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get fieldUserName => 'Nome Utente';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldWebsite => 'Sito web';

  @override
  String get fieldTitle => 'Nome';

  @override
  String get fieldTotp => 'Password monouso (varia nel tempo)';

  @override
  String get english => 'Inglese';

  @override
  String get german => 'Tedesco';

  @override
  String get russian => 'Russo';

  @override
  String get ukrainian => 'Ucraino';

  @override
  String get lithuanian => 'Lituano';

  @override
  String get french => 'Francese';

  @override
  String get spanish => 'Spagnolo';

  @override
  String get indonesian => 'Indonesiano';

  @override
  String get turkish => 'Turco';

  @override
  String get hebrew => 'Ebraico';

  @override
  String get italian => 'italiano';

  @override
  String get chineseSimplified => 'Cinese Semplificato';

  @override
  String get chineseTraditional => 'Cinese Tradizionale';

  @override
  String get portugueseBrazilian => 'Portoghese, Brasiliano';

  @override
  String get slovak => 'Slovacco';

  @override
  String get dutch => 'Olandese';

  @override
  String get selectItem => 'Seleziona';

  @override
  String get selectKeepassFile => 'AuthPass - Seleziona il File KeePass';

  @override
  String get selectKeepassFileLabel => 'Seleziona un file KeePass ( .kdbx).';

  @override
  String get createNewFile => 'Crea un Nuovo File';

  @override
  String get openLocalFile => 'Apri\nFile Locale';

  @override
  String get openFile => 'Apri File';

  @override
  String get loadFromDropdownMenu => 'Carica da …';

  @override
  String get quickUnlockingFiles => 'Sblocco rapido dei file…';

  @override
  String openFileProgress(Object fileName, Object current, Object totalCount) {
    return 'Apertura $fileName … ($current / $totalCount)';
  }

  @override
  String loadFrom(String cloudStorageName) {
    return 'Carica da $cloudStorageName';
  }

  @override
  String get loadFromRemoteUrl => 'Apri kdbx da URL';

  @override
  String get createNewKeepass =>
      'Nuovo su KeePass?\nCrea un Nuovo Database per le tue Password';

  @override
  String get labelLastOpenFiles => 'File recenti:';

  @override
  String get noFilesHaveBeenOpenYet => 'Nessun file è stato ancora aperto.';

  @override
  String get preferenceSelectLanguage => 'Seleziona la lingua';

  @override
  String get preferenceLanguage => 'Linguaggio';

  @override
  String get preferenceTextScaleFactor => 'Dimensione Testo';

  @override
  String get preferenceVisualDensity => 'Densità Testo';

  @override
  String get preferenceTheme => 'Tema';

  @override
  String get preferenceThemeLight => 'Chiaro';

  @override
  String get preferenceThemeDark => 'Scuro';

  @override
  String get preferenceSystemDefault => 'Predefinito Di Sistema';

  @override
  String get preferenceDefault => 'Predefinito';

  @override
  String get lockAllFiles => 'Blocca tutti i file aperti';

  @override
  String get preferenceAllowScreenshots => 'Consenti screenshot dell\'app';

  @override
  String get preferenceEnableAutoFill => 'Abilita riempimento automatico';

  @override
  String get enableAutofillSuggestionBanner =>
      'Puoi riempire il campo di altre applicazioni abilitando l\'auto-riempimento!';

  @override
  String get dismissAutofillSuggestionBannerButton => 'NASCONDI';

  @override
  String get enableAutofillSuggestionBannerButton => 'ABILITA!';

  @override
  String get preferenceAutoFillDescription =>
      'Supportato solo su Android Oreo (8.0) o versioni successive.';

  @override
  String get preferenceTitle => 'Impostazioni';

  @override
  String get preferenceEnableSystemWideShortcuts =>
      'Abilita le scorciatoie di sistema';

  @override
  String get preferenceEnableSystemWideShortcutsHelp =>
      'Registra ctrl+alt+f come scorciatoia di sistema per aprire la ricerca.';

  @override
  String get preferencesSearchFields => 'Personalizza i campi di ricerca';

  @override
  String get preferencesSearchFieldPromptTitle => 'Cerca i campi';

  @override
  String get preferencesSearchFieldPromptLabel =>
      'Elenco di campi separati da virgole da usare nella ricerca di una lista di password.';

  @override
  String preferencesSearchFieldPromptHelp(
      Object wildCardCharacter, Object defaultSearchFields) {
    return 'Usa $wildCardCharacter per tutti, lascia vuoto per impostazione predefinita ($defaultSearchFields)';
  }

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback => 'Siamo aperti a qualsiasi suggerimento!';

  @override
  String get aboutLinkVisitWebsite => 'Assicurati di visitare il nostro sito';

  @override
  String get aboutLinkGitHub => 'E supportare il progetto su GitHub';

  @override
  String aboutLogFile(String logFilePath) {
    return 'File di log: $logFilePath';
  }

  @override
  String get aboutLinkContributors => 'Mostra collaboratori';

  @override
  String get unableToLaunchUrlTitle => 'Impossibile aprire l\'URL';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'Impossibile aprire $url: $openError';
  }

  @override
  String get unableToLaunchUrlNoHandler =>
      'Nessuna applicazione disponibile per l\'URL.';

  @override
  String launchedUrl(Object url) {
    return 'URL aperto: $url';
  }

  @override
  String get menuItemGeneratePassword => 'Genera una Password';

  @override
  String get menuItemPreferences => 'Impostazioni';

  @override
  String get menuItemOpenAnotherFile => 'Apri un altro file';

  @override
  String get menuItemCheckForUpdates => 'Verifica aggiornamenti';

  @override
  String get menuItemSupport => 'Invia i log';

  @override
  String get menuItemSupportSubtitle => 'Invia i log via email';

  @override
  String get menuItemForum => 'Forum di supporto';

  @override
  String get menuItemForumSubtitle => 'Segnala problemi e ottieni assistenza';

  @override
  String get menuItemHelp => 'Aiuto';

  @override
  String get menuItemHelpSubtitle => 'Visualizza la documentazione';

  @override
  String get menuItemAbout => 'Informazioni';

  @override
  String get actionOpenUrl => 'Apri URL';

  @override
  String get passwordPlainText => 'Mostra password';

  @override
  String get generatorPassword => 'Password';

  @override
  String get generatePassword => 'Genera una Password';

  @override
  String get doneButtonLabel => 'Fatto';

  @override
  String get useAsDefault => 'Usa come Predefinito';

  @override
  String get characterSetLowerCase => 'Minuscole (a-z)';

  @override
  String get characterSetUpperCase => 'Maiuscole (A-Z)';

  @override
  String get characterSetNumeric => 'Numerici (0-9)';

  @override
  String get characterSetUmlauts => 'Accenti (ä)';

  @override
  String get characterSetSpecial => 'Speciali (@%+)';

  @override
  String get length => 'Lunghezza';

  @override
  String get customLength => 'Lunghezza Personalizzata';

  @override
  String customLengthHelperText(Object customMinLength) {
    return 'Valore utilizzato solo se la lunghezza è > $customMinLength';
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
      other: '$numFilesString file salvati: $files',
      one: 'Un file salvato: $files',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => 'Gestisci I Gruppi';

  @override
  String get lockFiles => 'Nascondi i file';

  @override
  String get searchHint => 'Cerca';

  @override
  String get searchButtonLabel => 'Cerca';

  @override
  String get filterButtonLabel => 'Filtra per gruppo';

  @override
  String get clear => 'Rimuovi';

  @override
  String get autofillFilterPrefix => 'Filtro:';

  @override
  String get autofillPrompt => 'Seleziona la password per l\'auto-riempimento.';

  @override
  String get copiedToClipboard => 'Copiato negli appunti.';

  @override
  String get noTitle => '(nome password)';

  @override
  String get noUsername => '(nome utente)';

  @override
  String get filterCustomize => 'Personalizza …';

  @override
  String get swipeCopyPassword => 'Copia la Password';

  @override
  String get swipeCopyUsername => 'Copia il Nome Utente';

  @override
  String get copyUsernameNotExists =>
      'La voce non ha alcun nome utente definito.';

  @override
  String get copyPasswordNotExists =>
      'La voce non ha alcuna password definita.';

  @override
  String get doneCopiedPassword => 'Password copiata negli appunti.';

  @override
  String get doneCopiedUsername => 'Nome utente copiato negli appunti.';

  @override
  String get doneCopiedField => 'Copiato.';

  @override
  String copiedFieldToClipboard(Object fieldName) {
    return '$fieldName copiato.';
  }

  @override
  String copiedFieldEmpty(Object fieldName) {
    return '$fieldName è vuoto.';
  }

  @override
  String get emptyPasswordVaultPlaceholder =>
      'Non hai alcuna password nel tuo database.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Crea la tua prima password';

  @override
  String get loading => 'Caricamento';

  @override
  String get loadingFile => 'Caricamento del file …';

  @override
  String get internalFile => 'File interno';

  @override
  String get internalFileSubtitle =>
      'Database creato in precedenza con AuthPass';

  @override
  String get filePicker => 'Sfoglia';

  @override
  String get filePickerSubtitle => 'Apri il file dal dispositivo.';

  @override
  String get credentialsAppBarTitle => 'Credenziali';

  @override
  String get credentialLabel => 'Inserisci la password per:';

  @override
  String get masterPasswordInputLabel => 'Password';

  @override
  String get masterPasswordEmptyValidator => 'Inserisci la password.';

  @override
  String get masterPasswordIncorrectValidator => 'Password errata';

  @override
  String get useKeyFile => 'Usa file autenticazione';

  @override
  String get saveMasterPasswordBiometric =>
      'Salvare la password nella memoria ad accesso biometrico?';

  @override
  String get close => 'Chiudi';

  @override
  String get addNewPassword => 'Aggiungi nuova password';

  @override
  String get errorOpenFileInvalidFileStructureTitle =>
      'Tentato di aprire un tipo di file non valido';

  @override
  String errorOpenFileInvalidFileStructureBody(Object fileName) {
    return 'Il file ($fileName) non sembra essere un file KDBX valido. Scegliere un file KDBX valido o creare un nuovo database di password.';
  }

  @override
  String get errorOpenFileAlreadyOpenTitle => 'File già aperto';

  @override
  String errorOpenFileAlreadyOpenBody(
      Object databaseName, Object openFileSource, Object newFileSource) {
    return 'Il database selezionato $databaseName è già aperto da $openFileSource (Si è tentato di aprire da $newFileSource)';
  }

  @override
  String get loadFromUrl => 'Scarica da Url';

  @override
  String get loadFromUrlEnterUrl => 'Inserisci URL';

  @override
  String get loadFromUrlErrorEnterFullUrl =>
      'Per favore inserisci l\'Url completo, a partire da http:// o https://';

  @override
  String get loadFromUrlErrorInvalidUrl =>
      'Per favore inserisci un Url valido.';

  @override
  String get linuxAppArmorWarning =>
      'AuthPass richiede il permesso di comunicare con il Servizio Segreto e di memorizzare le credenziali per l\'archiviazione cloud.\nPer favore, esegui il seguente comando:';

  @override
  String get cancel => 'Elimina';

  @override
  String get errorLoadFileFromSourceTitle => 'Errore nell\'apertura del file.';

  @override
  String errorLoadFileFromSourceBody(Object source, Object error) {
    return 'Impossibile aprire $source.\n$error';
  }

  @override
  String get errorUnlockFileTitle => 'Impossibile aprire il File';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Errore sconosciuto durante l\'apertura del file. $error';
  }

  @override
  String get dialogContinue => 'Continua';

  @override
  String get dialogSendErrorReport => 'Invia Report Errore';

  @override
  String get dialogReportErrorForum => 'Segnala errore nel Forum/Aiuto';

  @override
  String get groupFilterDescription =>
      'Seleziona quali Gruppi mostrare (e relativi sottogruppi)';

  @override
  String get groupFilterSelectAll => 'Seleziona tutto';

  @override
  String get groupFilterDeselectAll => 'Deseleziona tutto';

  @override
  String get createSubgroup => 'Crea Un Sottogruppo';

  @override
  String get editAction => 'Modifica';

  @override
  String get mailboxEnableLabel => '(ri)abilita';

  @override
  String get mailboxEnableHint => 'Continua a ricevere e-mail';

  @override
  String get mailboxDisableLabel => 'Disabilita';

  @override
  String get mailboxDisableHint => 'Non ricevere più email';

  @override
  String get mailListNoMail => 'Non hai ancora nessuna email.';

  @override
  String mailboxLabelPrefixForEntry(Object entryLabel) {
    return 'Voce: $entryLabel';
  }

  @override
  String mailboxLabelPrefixUnknownEntry(Object entryUuid) {
    return 'Voce sconosciuta: $entryUuid';
  }

  @override
  String mailboxLabelPrefixCreatedAt(Object dateTime) {
    return 'Creato il: $dateTime';
  }

  @override
  String get masterPasswordDescription =>
      'La password principale viene utilizzata per crittografare in modo sicuro il tuo database delle password. Assicurati di ricordarla, non può essere ripristinata.';

  @override
  String get unsavedChangesWarningTitle => 'Modifiche Non Salvate';

  @override
  String get unsavedChangesWarningBody =>
      'Ci sono ancora modifiche non salvate. Vuoi annullare le modifiche?';

  @override
  String get unsavedChangesDiscardActionLabel => 'Annulla Modifiche';

  @override
  String get deletePermanentlyAction => 'Elimina definitivamente';

  @override
  String get restoreFromRecycleBinAction => 'Ripristina';

  @override
  String get deleteAction => 'Elimina';

  @override
  String get deletedEntry => 'Voce eliminata.';

  @override
  String get successfullyDeletedGroup => 'Gruppo eliminato.';

  @override
  String get undoButtonLabel => 'Annulla';

  @override
  String get saveButtonLabel => 'Salva';

  @override
  String get webDavSettings => 'Impostazioni WebDAV';

  @override
  String get webDavUrlLabel => 'URL';

  @override
  String get webDavUrlHelperText => 'Base Url al tuo servizio WebDAV.';

  @override
  String get webDavUrlValidatorError => 'Per favore inserisci un URL';

  @override
  String get webDavUrlValidatorInvalidUrlError =>
      'Per favore inserisci un Url valido con http:// o https://';

  @override
  String get webDavAuthUser => 'Nome Utente';

  @override
  String get webDavAuthPassword => 'Password';

  @override
  String get mergeSuccessDialogTitle =>
      'Database di password unito con successo';

  @override
  String mergeSuccessDialogMessage(Object fileName, Object mergeSummary) {
    return 'Conflitto rilevato durante il salvataggio di $fileName, è stato unito con successo con il file remoto: \n\n$mergeSummary';
  }

  @override
  String forDetailsVisitUrl(Object url) {
    return 'Per i dettagli visita $url';
  }

  @override
  String get authPassCloudAuthEmailInputLabel =>
      'Inserisci l\'indirizzo email per registrarti o accedere.';

  @override
  String get authPassCloudAuthEmailInvalid =>
      'Inserisci un indirizzo email valido.';

  @override
  String get authPassCloudAuthConfirmEmailButtonLabel =>
      'Conferma l\'indirizzo';

  @override
  String get authPassCloudAuthConfirmEmail =>
      'Controlla le tue email per confermare il tuo indirizzo email.';

  @override
  String get authPassCloudAuthConfirmEmailExplain =>
      'Mantieni aperta questa schermata finché non avrai visitato il link che hai ricevuto via email.';

  @override
  String get authPassCloudAuthResendExplain =>
      'Se non hai ricevuto un\'email, controlla la cartella spam. Altrimenti puoi provare a richiedere un nuovo link di conferma.';

  @override
  String get authPassCloudAuthResendButtonLabel =>
      'Richiedi un nuovo link di conferma';

  @override
  String permanentlyDeleteEntryConfirm(Object title) {
    return 'Questo eliminerà definitivamente la voce di password $title. Questo non può essere annullato. Vuoi continuare?';
  }

  @override
  String get permanentlyDeletedEntrySnackBar =>
      'Voce eliminata definitivamente.';

  @override
  String get initialNewGroupName => 'Crea Gruppo';

  @override
  String get deleteGroupErrorTitle => 'Impossibile eliminare il gruppo';

  @override
  String get deleteGroupErrorBodyContainsGroup =>
      'Questo gruppo contiene ancora altri gruppi. Al momento puoi eliminare solo gruppi vuoti.';

  @override
  String get deleteGroupErrorBodyContainsEntries =>
      'Questo gruppo contiene delle password. Al momento puoi eliminare solo gruppi vuoti.';

  @override
  String get groupListAppBarTitle => 'Gruppi';

  @override
  String get groupListFilterAppbarTitle => 'Filtra per gruppi';

  @override
  String get clearQuickUnlock => 'Cancella Archivio Biometrico';

  @override
  String get clearQuickUnlockSubtitle => 'Rimuovi la Master Password salvata';

  @override
  String get unlock => 'Mostra i file';

  @override
  String get closePasswordFiles => 'chiudi i file contenenti le password';

  @override
  String get clearQuickUnlockSuccess =>
      'Password principale rimossa dalla memoria biometrica.';

  @override
  String get diacOptIn => 'Attiva per News e Sondaggi In-App.';

  @override
  String get diacOptInSubtitle =>
      'Periodicamente verrà inviata una richiesta alla rete per recuperare notizie.';

  @override
  String get enableAutofillDebug => 'Autocompletamento: Abilita il debug';

  @override
  String get enableAutofillDebugSubtitle =>
      'Mostra informazioni in sovrimpressione per ogni campo';

  @override
  String get createPasswordDatabase => 'Crea un Nuovo Database';

  @override
  String get nameNewPasswordDatabase => 'Dai un Nome al tuo Database';

  @override
  String get validatorNameMissing =>
      'Inserisci un nome per il tuo nuovo database.';

  @override
  String get masterPasswordHelpText =>
      'Inserisci una Master Password. ASSICURATI DI RICORDARLA.';

  @override
  String get inputMasterPasswordText => 'Master Password';

  @override
  String get masterPasswordMissingCreate =>
      'Inserisci una password sicura che puoi ricordarti.';

  @override
  String get createDatabaseAction => 'Crea Un Database';

  @override
  String get databaseExistsError => 'Il File è già Esistente';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'Errore durante la creazione del database $filePath. Il file esiste già. scegliere un altro nome.';
  }

  @override
  String get databaseCreateDefaultName => 'MiePassword';

  @override
  String get preferenceDynamicLoadIcons => 'Carica Icone dal Web';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'L\'applicazione farà una richiesta http tramite i valori nell\'Url del $urlFieldName per caricare le icone dai siti.';
  }

  @override
  String passwordScore(Object score) {
    return 'Sicurezza: $score su 4';
  }

  @override
  String get entryInfoFile => 'File:';

  @override
  String get entryInfoGroup => 'Gruppo:';

  @override
  String get entryInfoLastModified => 'Ultima Modifica:';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'Elemento spostato in $groupName';
  }

  @override
  String sizeBytesStoredAuthPassCloud(Object count) {
    return '$count byte, archiviati su AuthPass Cloud';
  }

  @override
  String sizeBytes(Object count) {
    return '$count byte';
  }

  @override
  String get entryAddAttachment => 'Aggiungi Allegato';

  @override
  String get entryAttachmentSizeWarning =>
      'I file allegati saranno incorporati nel file di password. Questo può aumentare significativamente il tempo necessario per aprire/salvare le password.';

  @override
  String get iconPngSizeWarning =>
      'Le icone personalizzate saranno incorporate nel file delle password. Questo può aumentare significativamente il tempo necessario per aprire/salvare le password.';

  @override
  String get notPngError => 'Il file scelto non è nel formato PNG.';

  @override
  String get entryAddField => 'Aggiungi Campo';

  @override
  String get entryCustomField => 'Campo Personalizzato';

  @override
  String get entryCustomFieldTitle => 'Aggiungi un campo personalizzato';

  @override
  String get entryCustomFieldInputLabel => 'Inserisci un nome per il campo';

  @override
  String get swipeCopyField => 'Copia';

  @override
  String get fieldRename => 'Rinomina';

  @override
  String get fieldGeneratePassword => 'Genera una Password…';

  @override
  String get fieldProtect => 'Valore protetto';

  @override
  String get fieldUnprotect => 'Valore non protetto';

  @override
  String get fieldPresent => 'Mostra (QR Code)';

  @override
  String get fieldGenerateEmail => 'Genera Email';

  @override
  String get onboardingBackToOnboarding => 'Tour';

  @override
  String get onboardingBackToOnboardingSubtitle => 'Rivivi i primi passi 😅️';

  @override
  String get onboardingHeadline => 'Rendi sicure le tue Password!';

  @override
  String get onboardingQuestion => 'Hai mai usato un Password Manager?';

  @override
  String get onboardingYesOpenPasswords => 'Si, accedi alle mie password';

  @override
  String get onboardingNoCreate => 'Sono nuovo! guidami.';

  @override
  String get backupButton => 'SALVA IN UN CLOUD';

  @override
  String get dismissBackupButton => 'NASCONDI';

  @override
  String backupWarningMessage(Object databasename) {
    return 'Le tue password in $databasename sono salvate solo sul dispositivo!';
  }

  @override
  String get saveAs => 'Salva In...';

  @override
  String get saving => 'Salvataggio in Corso';

  @override
  String get increaseValue => 'Aumenta';

  @override
  String get decreaseValue => 'Riduci';

  @override
  String get resetValue => 'Reset';

  @override
  String cloudStorageAppBarTitle(Object cloudStorageName) {
    return 'CloudStorage - $cloudStorageName';
  }

  @override
  String get cloudStorageLogInCaption =>
      'Sarai reindirizzato all\'autenticazione AuthPass per accedere ai tuoi dati.';

  @override
  String get cloudStorageLogInCode => 'Inserisci il codice';

  @override
  String launchUrlError(Object url) {
    return 'Impossibile lanciare l\'url. Visita $url';
  }

  @override
  String cloudStorageLogInActionLabel(Object cloudStorageName) {
    return 'Accedi a $cloudStorageName';
  }

  @override
  String cloudStorageAuthCodeDialogTitle(Object cloudStorageName) {
    return '$cloudStorageName Autenticazione';
  }

  @override
  String get cloudStorageAuthCodeLabel => 'Codice Di Autenticazione';

  @override
  String get cloudStorageAuthErrorTitle => 'Errore durante l\'autenticazione';

  @override
  String cloudStorageAuthErrorMessage(
      Object cloudStorageName, Object errorMessage) {
    return 'Errore durante il tentativo di autenticazione su $cloudStorageName: $errorMessage';
  }

  @override
  String get cloudStorageSearchBoxLabel => 'Query di ricerca';

  @override
  String cloudStorageItemsInFolder(Object itemCount) {
    return '$itemCount oggetti in questa cartella.';
  }

  @override
  String get mailSubject => 'Oggetto';

  @override
  String get mailFrom => 'Da';

  @override
  String get mailDate => 'Data';

  @override
  String get mailMailbox => 'Casella postale';

  @override
  String get mailNoData => 'Nessun Dato';

  @override
  String get mailMailboxesTitle => 'Caselle postali';

  @override
  String get mailboxCreateButtonLabel => 'Crea';

  @override
  String get mailboxNameInputDialogTitle =>
      'Etichetta opzionale per la nuova casella';

  @override
  String get mailboxNameInputLabel => 'Etichetta (Interna)';

  @override
  String get mailScreenTitle => 'Mail AuthPass';

  @override
  String get mailTabBarTitleMailbox => 'Casella postale';

  @override
  String get mailTabBarTitleMail => 'Mail';

  @override
  String get mailMailboxListEmpty => 'Non hai ancora nessuna casella di posta.';

  @override
  String mailMailboxAddressCopied(Object mailboxAddress) {
    return 'Indirizzo della casella postale copiato negli appunti: $mailboxAddress';
  }

  @override
  String get errorWhileSavingTitle => 'Errore durante il salvataggio';

  @override
  String errorWhileSavingBody(Object errorMessage) {
    return 'Impossibile salvare il file: $errorMessage';
  }

  @override
  String get databaseDoesNotSupportSaving =>
      'Spiacenti, questo database non supporta il salvataggio. Apri un file di database locale. Oppure usa \"Salva come\".';

  @override
  String get otpInvalidKeyTitle => 'Chiave Non Valida';

  @override
  String get otpInvalidKeyBody =>
      'L\'input inserito non è un codice TOTP base32 valido. Verifica il tuo input.';

  @override
  String get otpUnsupportedMigrationTitle => 'Unsupported OTP Migration';

  @override
  String otpUnsupportedMigrationBody(Object uriCount) {
    return 'We currently only support single item migrations. Got $uriCount';
  }

  @override
  String get otpPromptTitle => 'Autenticazione A Tempo';

  @override
  String get otpPromptHelperText => 'Inserisci la chiave a tempo.';

  @override
  String otpErrorMessageGeneration(Object errorMessage) {
    return 'Errore nella generazione del codice di invito: $errorMessage';
  }

  @override
  String get otpCopySecretActionLabel => 'Copia Segreto';

  @override
  String get otpEntryLabel => 'Token monouso';

  @override
  String get entryFieldProtected => 'Campo protetto. Clicca per rivelare.';

  @override
  String get entryFieldActionRevealField => 'Mostra il campo protetto';

  @override
  String get entryAttachmentOpenActionLabel => 'Apri';

  @override
  String get entryAttachmentShareActionLabel => 'Condividi';

  @override
  String get entryAttachmentShareSubject => 'Allegato';

  @override
  String get entryAttachmentSaveActionLabel => 'Salva sul dispositivo';

  @override
  String get entryAttachmentRemoveActionLabel => 'Rimuovi';

  @override
  String entryAttachmentRemoveConfirm(Object attachmentLabel) {
    return 'Vuoi davvero rimuovere $attachmentLabel?';
  }

  @override
  String get entryRenameFieldPromptTitle => 'Rinomina il campo';

  @override
  String get removerecentfile => 'Nascondi';

  @override
  String get entryRenameFieldPromptLabel => 'Inserisci il nuovo nome del campo';

  @override
  String get promptDialogPasteActionTooltip => 'Incolla dagli appunti';

  @override
  String get promptDialogPasteHint =>
      'Suggerimento: Se hai bisogno di incollare, prova il pulsante a sinistra ;-)';

  @override
  String get genericErrorDialogTitle => 'Errore nella gestione dell\'azione';

  @override
  String genericErrorDialogBody(Object errorMessage) {
    return 'Hai riscontrato un errore imprevisto. $errorMessage';
  }

  @override
  String get saveAsEntryLocalFile => 'File Locale';

  @override
  String get fileTypePngs => 'Immagini (png)';

  @override
  String get selectIconDialogAction => 'SELEZIONA ICONA';

  @override
  String get retryDialogActionLabel => 'RIPROVA';

  @override
  String errorDuringNetworkCall(Object errorMessage) {
    return 'Errore durante la chiamata Api. $errorMessage';
  }

  @override
  String get passwordFilterHideDeleted => 'Nascondi Voci Eliminate';

  @override
  String get passwordFilterOnlyDeleted => 'Voci Eliminate';

  @override
  String passwordFilterPrefixForOneGroup(Object groupName) {
    return 'Gruppo: $groupName';
  }

  @override
  String passwordFilterPrefixForMultipleGroups(Object groupCount) {
    return 'Filtro Personalizzato ($groupCount Gruppi)';
  }

  @override
  String get menuItemAuthPassCloudAuthenticate =>
      'Autenticati con AuthPass Cloud';

  @override
  String get menuItemAuthPassCloudMailboxes => 'Mailbox AuthPass';

  @override
  String changesWithoutSaving(Object fileName) {
    return 'Sono presenti modifiche in \"$fileName\", che non supporta la scrittura delle modifiche.';
  }

  @override
  String get changesSaveLocally => 'Salva in locale';

  @override
  String get clearColor => 'Elimina Colore';

  @override
  String get databaseRenameInputLabel => 'Inserisci il nome del database';

  @override
  String get databasePath => 'Percorso';

  @override
  String get databaseColor => 'Colore';

  @override
  String get databaseColorChoose =>
      'Selezionare un colore per distinguere i file.';

  @override
  String get databaseKdbxVersion => 'Versione File KDBX';

  @override
  String databaseKdbxUpgradeVersion(Object versionName) {
    return 'Aggiorna a $versionName';
  }

  @override
  String get databaseKdbxUpgradeSuccessful =>
      'File aggiornato e salvato con successo.';

  @override
  String get databaseReload => 'Ricarica e unisci';

  @override
  String progressStatus(Object statusProgress) {
    return 'Stato: $statusProgress';
  }

  @override
  String finishedMerge(Object status) {
    return 'Unione completata $status';
  }

  @override
  String get closeAndLockFile => 'Chiudi/Blocca';

  @override
  String get authPassHomeScreenTagline =>
      'password manager, open source, disponibile su tutte le piattaforme.';

  @override
  String get addNewPasswordButtonLabel => 'Aggiungi una nuova password';

  @override
  String get unnamedEntryPlaceholder => '(Senza Nome)';

  @override
  String get unnamedGroupPlaceholder => '(Senza Nome)';

  @override
  String get unnamedFilePlaceholder => '(Senza Nome)';

  @override
  String get editGroupScreenTitle => 'Modifica Gruppo';

  @override
  String get editGroupGroupNameLabel => 'Nome Del Gruppo';

  @override
  String get files => 'File';

  @override
  String get newGroupDialogTitle => 'Crea Gruppo';

  @override
  String get newGroupDialogInputLabel => 'Nome del nuovo gruppo';

  @override
  String get groupActionShowPasswords => 'Mostra le password';

  @override
  String get groupActionDelete => 'Elimina';

  @override
  String get logoutTooltip => 'Disconnetti';

  @override
  String get successfullyDeletedFileCloudStorage =>
      'File eliminato con successo.';

  @override
  String shareDialogTitle(Object fileName) {
    return 'Opzioni di condivisione di $fileName';
  }

  @override
  String get shareFileActionLabel => 'Condividi …';

  @override
  String get shareTokenListEmptyScreenPlaceholder =>
      'File non ancora condiviso.';

  @override
  String get shareTokenNoLabel => 'Nessuna Etichetta/Descrizione';

  @override
  String get shareTokenReadWrite => 'Lettura/Scrittura';

  @override
  String get shareTokenReadOnly => 'Sola lettura';

  @override
  String get shareCreateTokenDialogTitle => 'Condividi file';

  @override
  String get shareCreateTokenReadOnly => 'Sola lettura';

  @override
  String get shareCreateTokenReadOnlyHelpText =>
      'Non consentire il salvataggio delle modifiche';

  @override
  String get shareCreateTokenLabelText => 'Descrizione';

  @override
  String get shareCreateTokenLabelHint => 'Condividi con il mio amico';

  @override
  String get shareCreateTokenLabelHelp =>
      'Etichetta facoltativa per differenziare il codice di condivisione.';

  @override
  String get shareCreateTokenSuccess =>
      'Codice di condivisione creato con successo.';

  @override
  String get sharePresentDialogTitle =>
      'Condividi il file con il codice di condivisione segreto';

  @override
  String get sharePresentDialogHelp =>
      'Utilizzando il seguente codice di condivisione gli utenti possono accedere al file di password. Avranno bisogno della password e/o del file chiave per aprirlo.';

  @override
  String get sharePresentToken => 'Condividi Il Codice';

  @override
  String get sharePresentCopied =>
      'Codice di condivisione copiato negli appunti.';

  @override
  String get authPassCloudOpenWithShareCodeTooltip =>
      'Apri con il codice di condivisione';

  @override
  String get authPassCloudShareFileActionLabel => 'Condividi';

  @override
  String get preferenceAuthPassCloudAttachmentTitle =>
      'Usa Gli Allegati Cloud AuthPass';

  @override
  String get preferenceAuthPassCloudAttachmentSubtitle =>
      'Memorizza gli allegati crittografati separatamente su AuthPass Cloud.';

  @override
  String get shareCodeInputDialogTitle =>
      'Inserisci Codice Segreto Di Condivisione';

  @override
  String get shareCodeInputDialogScan => 'Scansiona il codice QR';

  @override
  String get shareCodeInputLabel => 'Codice Di Condivisione Segreto';

  @override
  String get shareCodeInputHelperText =>
      'Se hai ricevuto un codice di condivisione, incollalo sopra.';

  @override
  String get shareCodeOpen =>
      'Hai ricevuto un codice di condivisione per AuthPass Cloud?';

  @override
  String get shareCodeOpenScreenTitle =>
      'Caricamento file con codice di condivisione';

  @override
  String get shareCodeLoadingProgress => 'Caricamento del file …';

  @override
  String get shareCodeOpenFileButtonLabel => 'APRI';

  @override
  String get shareCodeOpenInstallAppCaption =>
      'Vuoi aprire questo file con una delle nostre applicazioni native?';

  @override
  String get shareCodeOpenAnotherAppCaption =>
      'Vuoi aprire questo file su un altro dispositivo?';

  @override
  String get shareCodeOpenInstallAppButtonLabel => 'Installa App';

  @override
  String get shareCodeOpenShowCodeButtonLabel =>
      'Mostra Codice Di Condivisione';

  @override
  String get changeMasterPasswordActionLabel => 'Cambia Password Principale';

  @override
  String get changeMasterPasswordFormSubmit => 'Salva con nuova password';

  @override
  String get changeMasterPasswordSuccess =>
      'Password principale salvata con successo.';

  @override
  String get changeMasterPasswordScreenTitle => 'Cambia Password Principale';

  @override
  String get authPassCloudAuthClickedLink =>
      'Ho ricevuto l\'email e visitato il link';

  @override
  String get authPassCloudAuthNotConfirmed =>
      'L\'indirizzo email non è stato ancora confermato. Assicurati di fare clic sul link nell\'email che hai ricevuto e di risolvere il captcha per confermare il tuo indirizzo email.';

  @override
  String get getHelpButton => 'Ottieni aiuto nel forum';

  @override
  String get shortcutCopyUsername => 'Copia il Nome Utente';

  @override
  String get shortcutCopyPassword => 'Copia la Password';

  @override
  String get shortcutCopyTotp => 'Copia TOTP';

  @override
  String get shortcutMoveUp => 'Seleziona la password precedente';

  @override
  String get shortcutMoveDown => 'Seleziona la password successiva';

  @override
  String get shortcutGeneratePassword => 'Genera una Password';

  @override
  String get shortcutCopyUrl => 'Copia URL';

  @override
  String get shortcutOpenUrl => 'Apri URL';

  @override
  String get shortcutCancelSearch => 'Annulla Ricerca';

  @override
  String get shortcutShortcutHelp => 'Guida Scorciatoia Tastiera';

  @override
  String get shortcutHelpTitle => 'Scorciatoie da tastiera';

  @override
  String unexpectedError(String error) {
    return 'Errore imprevisto: $error';
  }

  @override
  String get googleDriveMorePermissionsRequired =>
      'Additional permissions needed to access Google Drive.';

  @override
  String get googleDriveRequestPermissionButtonLabel => 'Request Permissions';

  @override
  String get scanQrCodeTitle => 'Scan QR Code.';
}
