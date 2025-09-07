// ignore_for_file: omit_local_variable_types,unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get fieldUserName => 'Utilisateur';

  @override
  String get fieldPassword => 'Mot de passe';

  @override
  String get fieldWebsite => 'Site Web';

  @override
  String get fieldTitle => 'Titre';

  @override
  String get fieldTotp => 'Mot de passe à usage unique (basé sur le temps)';

  @override
  String get english => 'Anglais';

  @override
  String get german => 'Allemand';

  @override
  String get russian => 'Russe';

  @override
  String get ukrainian => 'Ukrainien';

  @override
  String get lithuanian => 'Lituanien';

  @override
  String get french => 'Français';

  @override
  String get spanish => 'Espagnol';

  @override
  String get indonesian => 'Indonésie';

  @override
  String get turkish => 'Turc';

  @override
  String get hebrew => 'Hébreu';

  @override
  String get italian => 'Italien';

  @override
  String get chineseSimplified => 'Chinois simplifié';

  @override
  String get chineseTraditional => 'Chinois traditionnel';

  @override
  String get portugueseBrazilian => 'Portugais, Brésilien';

  @override
  String get slovak => 'Slovaque';

  @override
  String get dutch => 'Néerlandais';

  @override
  String get selectItem => 'Sélectionner';

  @override
  String get selectKeepassFile => 'AuthPass - Sélectionnez un fichier KeePass';

  @override
  String get selectKeepassFileLabel =>
      'Veuillez sélectionner un fichier KeePass (.kdbx).';

  @override
  String get createNewFile => 'Créer un nouveau fichier';

  @override
  String get openLocalFile => 'Ouvrir un fichier local';

  @override
  String get openFile => 'Ouvrir un fichier';

  @override
  String get loadFromDropdownMenu => 'Charger depuis …';

  @override
  String get quickUnlockingFiles => 'Déverrouillage rapide des fichiers…';

  @override
  String openFileProgress(Object fileName, Object current, Object totalCount) {
    return 'Ouverture de $fileName … ($current / $totalCount)';
  }

  @override
  String loadFrom(String cloudStorageName) {
    return 'Charger depuis $cloudStorageName';
  }

  @override
  String get loadFromRemoteUrl => 'Ouvrir kdbx à partir d\'une adresse URL';

  @override
  String get createNewKeepass =>
      'Nouveau sur KeePass?\nCréez une nouvelle base de données de mots de passe';

  @override
  String get labelLastOpenFiles => 'Derniers fichiers ouverts :';

  @override
  String get noFilesHaveBeenOpenYet =>
      'Aucun fichier n\'a été ouvert pour le moment.';

  @override
  String get preferenceSelectLanguage => 'Sélectionnez la langue';

  @override
  String get preferenceLanguage => 'Langue';

  @override
  String get preferenceTextScaleFactor => 'Taille du texte';

  @override
  String get preferenceVisualDensity => 'Espacement';

  @override
  String get preferenceTheme => 'Thème';

  @override
  String get preferenceThemeLight => 'Clair';

  @override
  String get preferenceThemeDark => 'Sombre';

  @override
  String get preferenceSystemDefault => 'Paramètre système';

  @override
  String get preferenceDefault => 'Par défaut';

  @override
  String get lockAllFiles => 'Verrouiller tous les fichiers ouverts';

  @override
  String get preferenceAllowScreenshots =>
      'Autoriser les captures d\'écran de l\'application';

  @override
  String get preferenceEnableAutoFill => 'Activer la saisie automatique';

  @override
  String get enableAutofillSuggestionBanner =>
      'Vous pouvez remplir les champs de saisie d\'autres applications en activant la saisie !';

  @override
  String get dismissAutofillSuggestionBannerButton => 'IGNORER';

  @override
  String get enableAutofillSuggestionBannerButton => 'ACTIVER !';

  @override
  String get preferenceAutoFillDescription =>
      'Uniquement supporté par Android Oreo (8.0) ou supérieur.';

  @override
  String get preferenceTitle => 'Paramètres';

  @override
  String get preferenceEnableSystemWideShortcuts =>
      'Activer les raccourcis dans tout le système';

  @override
  String get preferenceEnableSystemWideShortcutsHelp =>
      'Enregistrer ctrl+alt+f dans le système comme un raccourci pour ouvrir la recherche.';

  @override
  String get preferencesSearchFields => 'Personnaliser les champs de recherche';

  @override
  String get preferencesSearchFieldPromptTitle => 'Champs de recherche';

  @override
  String get preferencesSearchFieldPromptLabel =>
      'Liste des champs séparés par des virgules à utiliser dans la recherche de la liste des mots de passe.';

  @override
  String preferencesSearchFieldPromptHelp(
    Object wildCardCharacter,
    Object defaultSearchFields,
  ) {
    return 'Utiliser $wildCardCharacter pour tous, laisser vide pour les valeurs par défaut ($defaultSearchFields)';
  }

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback => 'Tout type de commentaire est le bienvenu !';

  @override
  String get aboutLinkVisitWebsite =>
      'N\'oubliez pas de visiter notre site Web';

  @override
  String get aboutLinkGitHub => 'Et également le projet Open Source';

  @override
  String aboutLogFile(String logFilePath) {
    return 'Fichier Log : $logFilePath';
  }

  @override
  String get aboutLinkContributors => 'Afficher les contributeurs';

  @override
  String get unableToLaunchUrlTitle => 'Impossible d\'ouvrir l\'URL';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'Impossible d\'ouvrir l\'$url : $openError';
  }

  @override
  String get unableToLaunchUrlNoHandler =>
      'Aucune application disponible pour cette URL.';

  @override
  String launchedUrl(Object url) {
    return 'URL $url ouverte :';
  }

  @override
  String get menuItemGeneratePassword => 'Générer un mot de passe';

  @override
  String get menuItemPreferences => 'Paramètres';

  @override
  String get menuItemOpenAnotherFile => 'Ouvrir un autre fichier';

  @override
  String get menuItemCheckForUpdates => 'Rechercher des mises à jour';

  @override
  String get menuItemSupport => 'Envoyer les logs';

  @override
  String get menuItemSupportSubtitle => 'Envoyer les logs par email';

  @override
  String get menuItemForum => 'Forum d’assistance';

  @override
  String get menuItemForumSubtitle =>
      'Signaler des problèmes et obtenir de l\'aide';

  @override
  String get menuItemHelp => 'Aide';

  @override
  String get menuItemHelpSubtitle => 'Afficher la documentation';

  @override
  String get menuItemAbout => 'À propos';

  @override
  String get actionOpenUrl => 'Ouvrir l\'URL';

  @override
  String get passwordPlainText => 'Afficher le mot de passe';

  @override
  String get generatorPassword => 'Mot de passe';

  @override
  String get generatePassword => 'Générer un mot de passe';

  @override
  String get doneButtonLabel => 'Terminé';

  @override
  String get useAsDefault => 'Utiliser comme valeur par défaut';

  @override
  String get characterSetLowerCase => 'Minuscules (a-z)';

  @override
  String get characterSetUpperCase => 'Majuscules (A-Z)';

  @override
  String get characterSetNumeric => 'Chiffres (0-9)';

  @override
  String get characterSetUmlauts => 'Accents (ä)';

  @override
  String get characterSetSpecial => 'Caractères spéciaux (@%+)';

  @override
  String get length => 'Longueur';

  @override
  String get customLength => 'Longueur personnalisée';

  @override
  String customLengthHelperText(Object customMinLength) {
    return 'Utilisé seulement pour une longueur > $customMinLength';
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
      other: '$numFilesString fichiers enregistrés: $files',
      one: 'In fichier enregistré: $files',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => 'Gestion des groupes';

  @override
  String get lockFiles => 'Verrouiller les fichiers';

  @override
  String get searchHint => 'Recherche';

  @override
  String get searchButtonLabel => 'Recherche';

  @override
  String get filterButtonLabel => 'Filtrer par groupe';

  @override
  String get clear => 'Supprimer';

  @override
  String get autofillFilterPrefix => 'Filtre :';

  @override
  String get autofillPrompt =>
      'Sélectionnez le mot de passe pour le remplissage automatique.';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papier.';

  @override
  String get noTitle => '(aucun titre)';

  @override
  String get noUsername => '(aucun nom d\'utilisateur)';

  @override
  String get filterCustomize => 'Personnaliser …';

  @override
  String get swipeCopyPassword => 'Copier le mot de passe';

  @override
  String get swipeCopyUsername => 'Copier le nom d\'utilisateur';

  @override
  String get copyUsernameNotExists =>
      'L\'entrée n\'a pas de nom d\'utilisateur défini.';

  @override
  String get copyPasswordNotExists =>
      'L\'entrée n\'a pas de nom d\'utilisateur défini.';

  @override
  String get doneCopiedPassword => 'Mot de passe copié dans le presse-papier.';

  @override
  String get doneCopiedUsername =>
      'Nom d\'utilisateur copié dans le presse-papier.';

  @override
  String get doneCopiedField => 'Copié.';

  @override
  String copiedFieldToClipboard(Object fieldName) {
    return '$fieldName copié.';
  }

  @override
  String copiedFieldEmpty(Object fieldName) {
    return '$fieldName est vide.';
  }

  @override
  String get emptyPasswordVaultPlaceholder =>
      'Vous n\'avez pas encore de mot de passe dans votre base de données.';

  @override
  String get emptyPasswordVaultButtonLabel =>
      'Créez votre premier mot de passe';

  @override
  String get loading => 'Chargement en cours';

  @override
  String get loadingFile => 'Chargement du fichier …';

  @override
  String get internalFile => 'Fichier interne';

  @override
  String get internalFileSubtitle =>
      'Base de données précédemment créée avec AuthPass';

  @override
  String get filePicker => 'Gestionnaire de fichiers';

  @override
  String get filePickerSubtitle => 'Ouvrir un fichier de l\'appareil.';

  @override
  String get credentialsAppBarTitle => 'Identification';

  @override
  String get credentialLabel => 'Entrez le mot de passe pour :';

  @override
  String get masterPasswordInputLabel => 'Mot de passe';

  @override
  String get masterPasswordEmptyValidator =>
      'Veuillez entrer votre mot de passe.';

  @override
  String get masterPasswordIncorrectValidator => 'Mot de passe incorrect';

  @override
  String get useKeyFile => 'Utiliser un fichier clé';

  @override
  String get saveMasterPasswordBiometric =>
      'Enregistrer le mot de passe dans les données biométriques ?';

  @override
  String get close => 'Fermer';

  @override
  String get addNewPassword => 'Ajouter un nouveau mot de passe';

  @override
  String get errorOpenFileInvalidFileStructureTitle =>
      'Tentative d\'ouverture d\'un type de fichier invalide';

  @override
  String errorOpenFileInvalidFileStructureBody(Object fileName) {
    return 'Le fichier ($fileName) ne partait pas être un fichier KDBX valide. Veuillez choisir un fichier KDBX valide ou créer une nouvelle base de donnée.';
  }

  @override
  String get errorOpenFileAlreadyOpenTitle => 'Fichier déjà ouvert';

  @override
  String errorOpenFileAlreadyOpenBody(
    Object databaseName,
    Object openFileSource,
    Object newFileSource,
  ) {
    return 'La base de données $databaseName sélectionnée est déjà ouverte depuis $openFileSource (tentative d\'ouverture depuis $newFileSource)';
  }

  @override
  String get loadFromUrl => 'Télécharger depuis une URL';

  @override
  String get loadFromUrlEnterUrl => 'Entrez l\'URL';

  @override
  String get loadFromUrlErrorEnterFullUrl =>
      'Veuillez entrer une url complète commençant par http:// ou https://';

  @override
  String get loadFromUrlErrorInvalidUrl => 'Veuillez entrer une URL valide.';

  @override
  String get linuxAppArmorWarning =>
      'AuthPass nécessite les autorisations de communication avec les services secrets pour sauvegarder les identifiants dans le stockage cloud.\nVeuillez exécuter les commandes suivantes:';

  @override
  String get cancel => 'Annuler';

  @override
  String get errorLoadFileFromSourceTitle =>
      'Erreur lors de l\'ouverture du fichier.';

  @override
  String errorLoadFileFromSourceBody(Object source, Object error) {
    return 'Impossible d\'ouvrir $source.\n$error';
  }

  @override
  String get errorUnlockFileTitle => 'Ouverture de fichier impossible';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Erreur inconnue lors de l\'ouverture du fichier. $error';
  }

  @override
  String get dialogContinue => 'Suivant';

  @override
  String get dialogSendErrorReport => 'Envoyer le rapport d\'erreur';

  @override
  String get dialogReportErrorForum => 'Signaler une erreur dans le Forum/Aide';

  @override
  String get groupFilterDescription =>
      'Sélectionnez les groupes à afficher (récursif)';

  @override
  String get groupFilterSelectAll => 'Tout sélectionner';

  @override
  String get groupFilterDeselectAll => 'Tout désélectionner';

  @override
  String get createSubgroup => 'Créer un sous-groupe';

  @override
  String get editAction => 'Modifier';

  @override
  String get mailboxEnableLabel => '(ré)activer';

  @override
  String get mailboxEnableHint => 'Continuer à recevoir des e-mails';

  @override
  String get mailboxDisableLabel => 'Désactiver';

  @override
  String get mailboxDisableHint => 'Ne plus recevoir d\'e-mails';

  @override
  String get mailListNoMail => 'Vous n\'avez pas encore d\'e-mail.';

  @override
  String mailboxLabelPrefixForEntry(Object entryLabel) {
    return 'Saisie : $entryLabel';
  }

  @override
  String mailboxLabelPrefixUnknownEntry(Object entryUuid) {
    return 'Entrée inconnue: $entryUuid';
  }

  @override
  String mailboxLabelPrefixCreatedAt(Object dateTime) {
    return 'Créé le : $dateTime';
  }

  @override
  String get masterPasswordDescription =>
      'Le mot de passe maître est utilisé pour chiffrer de façon sécurisée votre base de données de mot de passe. Assurez-vous de vous en souvenir. Il ne peut pas être restauré.';

  @override
  String get unsavedChangesWarningTitle => 'Modifications non sauvegardées';

  @override
  String get unsavedChangesWarningBody =>
      'Il y a encore des modifications non enregistrées. Voulez-vous annuler les modifications ?';

  @override
  String get unsavedChangesDiscardActionLabel => 'Ignorer les modifications';

  @override
  String get deletePermanentlyAction => 'Supprimer définitivement';

  @override
  String get restoreFromRecycleBinAction => 'Restaurer';

  @override
  String get deleteAction => 'Supprimer';

  @override
  String get deletedEntry => 'Entrée supprimée.';

  @override
  String get successfullyDeletedGroup => 'Groupe supprimé.';

  @override
  String get undoButtonLabel => 'Annuler';

  @override
  String get saveButtonLabel => 'Sauvegarder';

  @override
  String get webDavSettings => 'Configuration WebDAV';

  @override
  String get webDavUrlLabel => 'URL';

  @override
  String get webDavUrlHelperText => 'Url de base de votre service WebDAV.';

  @override
  String get webDavUrlValidatorError => 'Veuillez entrer une URL';

  @override
  String get webDavUrlValidatorInvalidUrlError =>
      'Veuillez entrer une url valide avec http:// ou https://';

  @override
  String get webDavAuthUser => 'Nom d\'utilisateur';

  @override
  String get webDavAuthPassword => 'Mot de passe';

  @override
  String get mergeSuccessDialogTitle =>
      'La base de données de mots de passe a été fusionnée avec succès';

  @override
  String mergeSuccessDialogMessage(Object fileName, Object mergeSummary) {
    return 'Conflit détecté lors de la sauvegarde de $fileName, il a été fusionné avec succès avec le fichier distant : \n\n$mergeSummary';
  }

  @override
  String forDetailsVisitUrl(Object url) {
    return 'Pour plus de détails, consultez $url';
  }

  @override
  String get authPassCloudAuthEmailInputLabel =>
      'Entrez l\'adresse e-mail pour vous inscrire ou vous connecter.';

  @override
  String get authPassCloudAuthEmailInvalid =>
      'Veuillez entrer une adresse e-mail valide.';

  @override
  String get authPassCloudAuthConfirmEmailButtonLabel => 'Confirmer l\'adresse';

  @override
  String get authPassCloudAuthConfirmEmail =>
      'Veuillez vérifier vos e-mails pour confirmer votre adresse e-mail.';

  @override
  String get authPassCloudAuthConfirmEmailExplain =>
      'Gardez cet écran ouvert jusqu\'à ce que vous ayez visité le lien que vous avez reçu par courriel.';

  @override
  String get authPassCloudAuthResendExplain =>
      'Si vous n\'avez pas reçu d\'e-mail, veuillez vérifier votre dossier spam. Sinon, vous pouvez essayer de demander un nouveau lien de confirmation.';

  @override
  String get authPassCloudAuthResendButtonLabel =>
      'Demander un nouveau lien de confirmation';

  @override
  String permanentlyDeleteEntryConfirm(Object title) {
    return 'Cela supprimera définitivement l\'entrée de mot de passe $title. Cela ne peut pas être annulé. Voulez-vous continuer ?';
  }

  @override
  String get permanentlyDeletedEntrySnackBar =>
      'Entrée supprimée définitivement.';

  @override
  String get initialNewGroupName => 'Nouveau groupe';

  @override
  String get deleteGroupErrorTitle => 'Impossible de supprimer le groupe';

  @override
  String get deleteGroupErrorBodyContainsGroup =>
      'Ce groupe contient d\'autres groupes. Vous ne pouvez supprimer que des groupes vides.';

  @override
  String get deleteGroupErrorBodyContainsEntries =>
      'Ce groupe contient des mots de passe. Vous ne pouvez supprimer que des groupes vides.';

  @override
  String get groupListAppBarTitle => 'Groupes';

  @override
  String get groupListFilterAppbarTitle => 'Filtrer par groupes';

  @override
  String get clearQuickUnlock => 'Effacer le stockage des données biométriques';

  @override
  String get clearQuickUnlockSubtitle =>
      'Supprimer les mots de passe principaux enregistrés';

  @override
  String get unlock => 'Déverrouiller les fichiers';

  @override
  String get closePasswordFiles =>
      'fermer les fichiers contenant les mots de passe';

  @override
  String get clearQuickUnlockSuccess =>
      'Supprimer les mots de passe maître sauvegardés dans l’espace de stockage des données biométriques.';

  @override
  String get diacOptIn =>
      'Inscrivez-vous pour les actualités et sondages concernant l\'application.';

  @override
  String get diacOptInSubtitle =>
      'Envoie occasionnellement une requête réseau pour récupérer les actualités.';

  @override
  String get enableAutofillDebug =>
      'Remplissage automatique : Activer le débogage';

  @override
  String get enableAutofillDebugSubtitle =>
      'Affiche des informations supplémentaires pour chaque champ de saisie';

  @override
  String get createPasswordDatabase =>
      'Créer une base de données de mots de passe';

  @override
  String get nameNewPasswordDatabase => 'Nom de votre nouvelle base de données';

  @override
  String get validatorNameMissing =>
      'Veuillez entrer un nom pour votre nouvelle base de données.';

  @override
  String get masterPasswordHelpText =>
      'Sélectionnez un mot de passe principal sécurisé. Assurez-vous de vous en souvenir.';

  @override
  String get inputMasterPasswordText => 'Mot de passe principal';

  @override
  String get masterPasswordMissingCreate =>
      'S’il vous plait entrer un mot de passe sécurisé, que vous pouvez retenir.';

  @override
  String get createDatabaseAction => 'Créer une base de données';

  @override
  String get databaseExistsError => 'Le fichier existe déjà';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'Erreur lors de la création de la base de données $filePath. Le fichier existe déjà. Veuillez choisir un autre nom.';
  }

  @override
  String get databaseCreateDefaultName => 'Mots de passe personnels';

  @override
  String get preferenceDynamicLoadIcons => 'Chargement dynamique des icônes';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'Effectuera des requêtes http avec la valeur du champ $urlFieldName pour charger les icônes du site web.';
  }

  @override
  String passwordScore(Object score) {
    return 'Force : $score sur 4';
  }

  @override
  String get entryInfoFile => 'Fichier :';

  @override
  String get entryInfoGroup => 'Groupe :';

  @override
  String get entryInfoLastModified => 'Dernière modification :';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'Entrée déplacée vers $groupName';
  }

  @override
  String sizeBytesStoredAuthPassCloud(Object count) {
    return '$count octets, stockés dans le AuthPass Cloud';
  }

  @override
  String sizeBytes(Object count) {
    return '$count octets';
  }

  @override
  String get entryAddAttachment => 'Ajouter une pièce jointe';

  @override
  String get entryAttachmentSizeWarning =>
      'Les fichiers joints seront intégrés au fichier de mots de passe. Cela peut considérablement augmenter le temps nécessaire pour ouvrir/enregistrer les mots de passe.';

  @override
  String get iconPngSizeWarning =>
      'Les fichiers joints seront intégrés au fichier de mots de passe. Cela peut considérablement augmenter le temps nécessaire pour ouvrir/enregistrer les mots de passe.';

  @override
  String get notPngError => 'Le fichier choisi n\'est pas un PNG.';

  @override
  String get entryAddField => 'Ajouter un champ';

  @override
  String get entryCustomField => 'Champ personnalisé';

  @override
  String get entryCustomFieldTitle => 'Ajout d\'un nouveau champ personnalisé';

  @override
  String get entryCustomFieldInputLabel => 'Entrez un nom pour le champ';

  @override
  String get swipeCopyField => 'Copier le champ';

  @override
  String get fieldRename => 'Renommer';

  @override
  String get fieldGeneratePassword => 'Générer un mot de passe …';

  @override
  String get fieldProtect => 'Protéger la valeur';

  @override
  String get fieldUnprotect => 'Déprotéger la valeur';

  @override
  String get fieldPresent => 'Afficher';

  @override
  String get fieldGenerateEmail => 'Générer une adresse e-mail';

  @override
  String get onboardingBackToOnboarding => 'Visite guidée';

  @override
  String get onboardingBackToOnboardingSubtitle =>
      'Revivez l\'expérience de la première exécution 😅';

  @override
  String get onboardingHeadline => 'Sécurisons vos mots de passe !';

  @override
  String get onboardingQuestion =>
      'Avez-vous déjà utilisé un gestionnaire de mots de passe ?';

  @override
  String get onboardingYesOpenPasswords => 'Oui, ouvrir mes mots de passe';

  @override
  String get onboardingNoCreate =>
      'Je suis tout nouveau ! Commençons ensemble.';

  @override
  String get backupButton => 'SAUVEGARDER SUR LE CLOUD';

  @override
  String get dismissBackupButton => 'IGNORER';

  @override
  String backupWarningMessage(Object databasename) {
    return 'Vos mots de passe dans $databasename ne sont sauvegardés que localement !';
  }

  @override
  String get saveAs => 'Sauvegarder dans...';

  @override
  String get saving => 'Enregistrement';

  @override
  String get increaseValue => 'Augmenter';

  @override
  String get decreaseValue => 'Diminuer';

  @override
  String get resetValue => 'Réinitialiser';

  @override
  String cloudStorageAppBarTitle(Object cloudStorageName) {
    return 'Stockage cloud - $cloudStorageName';
  }

  @override
  String get cloudStorageLogInCaption =>
      'Vous allez être redirigé vers l\'authentification AuthPass pour accéder à vos données.';

  @override
  String get cloudStorageLogInCode => 'Saisir le code';

  @override
  String launchUrlError(Object url) {
    return 'Impossible d\'ouvrir l’adresse url. Veuillez visiter $url';
  }

  @override
  String cloudStorageLogInActionLabel(Object cloudStorageName) {
    return 'Se connecter à $cloudStorageName';
  }

  @override
  String cloudStorageAuthCodeDialogTitle(Object cloudStorageName) {
    return 'Authentification $cloudStorageName';
  }

  @override
  String get cloudStorageAuthCodeLabel => 'Code d\'authentification';

  @override
  String get cloudStorageAuthErrorTitle => 'Erreur lors de l\'authentification';

  @override
  String cloudStorageAuthErrorMessage(
    Object cloudStorageName,
    Object errorMessage,
  ) {
    return 'Erreur lors de l\'authentification à $cloudStorageName: $errorMessage';
  }

  @override
  String get cloudStorageSearchBoxLabel => 'Rechercher';

  @override
  String cloudStorageItemsInFolder(Object itemCount) {
    return '$itemCount éléments dans le dossier.';
  }

  @override
  String get mailSubject => 'Objet';

  @override
  String get mailFrom => 'De';

  @override
  String get mailDate => 'Date';

  @override
  String get mailMailbox => 'Boite mail';

  @override
  String get mailNoData => 'Aucune donnée';

  @override
  String get mailMailboxesTitle => 'Boîtes aux lettres';

  @override
  String get mailboxCreateButtonLabel => 'Créer';

  @override
  String get mailboxNameInputDialogTitle =>
      'Étiquette facultative pour la nouvelle boîte mail';

  @override
  String get mailboxNameInputLabel => 'Libellé (interne)';

  @override
  String get mailScreenTitle => 'Addresses mails AuthPass';

  @override
  String get mailTabBarTitleMailbox => 'Boite mail';

  @override
  String get mailTabBarTitleMail => 'Email';

  @override
  String get mailMailboxListEmpty => 'Vous n\'avez pas encore d\'e-mail.';

  @override
  String mailMailboxAddressCopied(Object mailboxAddress) {
    return 'Adresse e-mail copiée dans le presse-papiers: $mailboxAddress';
  }

  @override
  String get errorWhileSavingTitle => 'Erreur lors de l\'enregistrement';

  @override
  String errorWhileSavingBody(Object errorMessage) {
    return 'Impossible d\'enregistrer le fichier : $errorMessage';
  }

  @override
  String get databaseDoesNotSupportSaving =>
      'Désolé, cette base de données ne prend pas en charge l\'enregistrement. Veuillez ouvrir un fichier de base de données locale. Ou utilisez \"Enregistrer sous\".';

  @override
  String get otpInvalidKeyTitle => 'Clé invalide';

  @override
  String get otpInvalidKeyBody =>
      'L\'entrée donnée n\'est pas un code TOTP valide en base32. Veuillez vérifier votre entrée.';

  @override
  String get otpUnsupportedMigrationTitle => 'Unsupported OTP Migration';

  @override
  String otpUnsupportedMigrationBody(Object uriCount) {
    return 'We currently only support single item migrations. Got $uriCount';
  }

  @override
  String get otpPromptTitle => 'Authentification basée sur le temps';

  @override
  String get otpPromptHelperText =>
      'Veuillez entrer une clé basée sur le temps.';

  @override
  String otpErrorMessageGeneration(Object errorMessage) {
    return 'Erreur lors de la génération du code d\'invitation : $errorMessage';
  }

  @override
  String get otpCopySecretActionLabel => 'Copier le secret';

  @override
  String get otpEntryLabel => 'Jeton à usage unique';

  @override
  String get entryFieldProtected => 'Champ protégé. Cliquez pour révéler.';

  @override
  String get entryFieldActionRevealField => 'Afficher le champ protégé';

  @override
  String get entryAttachmentOpenActionLabel => 'Ouvrir';

  @override
  String get entryAttachmentShareActionLabel => 'Partager';

  @override
  String get entryAttachmentShareSubject => 'Pièce jointe';

  @override
  String get entryAttachmentSaveActionLabel => 'Enregistrer sur l\'appareil';

  @override
  String get entryAttachmentRemoveActionLabel => 'Supprimer';

  @override
  String entryAttachmentRemoveConfirm(Object attachmentLabel) {
    return 'Souhaitez vous réellement supprimer $attachmentLabel ?';
  }

  @override
  String get entryRenameFieldPromptTitle => 'Renommer le champ';

  @override
  String get removerecentfile => 'Masquer';

  @override
  String get entryRenameFieldPromptLabel => 'Entrez le nouveau nom du champ';

  @override
  String get promptDialogPasteActionTooltip => 'Coller depuis le presse-papier';

  @override
  String get promptDialogPasteHint =>
      'Astuce : si vous avez besoin de coller, essayez le bouton à gauche ;-)';

  @override
  String get genericErrorDialogTitle =>
      'Erreur lors du traitement de l\'action';

  @override
  String genericErrorDialogBody(Object errorMessage) {
    return 'Une erreur inattendue est survenue. $errorMessage';
  }

  @override
  String get saveAsEntryLocalFile => 'Fichier local';

  @override
  String get fileTypePngs => 'Images (png)';

  @override
  String get selectIconDialogAction => 'SÉLECTIONNER L\'ICÔNE';

  @override
  String get retryDialogActionLabel => 'RÉESSAYER';

  @override
  String errorDuringNetworkCall(Object errorMessage) {
    return 'Erreur pendant la requête API. $errorMessage';
  }

  @override
  String get passwordFilterHideDeleted => 'Masquer les entrées supprimées';

  @override
  String get passwordFilterOnlyDeleted => 'Entrées supprimées';

  @override
  String passwordFilterPrefixForOneGroup(Object groupName) {
    return 'Groupe: $groupName';
  }

  @override
  String passwordFilterPrefixForMultipleGroups(Object groupCount) {
    return 'Filtre personnalisé ($groupCount Groupes )';
  }

  @override
  String get menuItemAuthPassCloudAuthenticate =>
      'S\'authentifier avec AuthPass Cloud';

  @override
  String get menuItemAuthPassCloudMailboxes => 'Addresses mails AuthPass';

  @override
  String changesWithoutSaving(Object fileName) {
    return 'Vous avez des modifications dans \"$fileName\", qui ne prennent pas en charge l\'écriture des modifications.';
  }

  @override
  String get changesSaveLocally => 'Enregistrer localement';

  @override
  String get clearColor => 'Effacer la couleur';

  @override
  String get databaseRenameInputLabel => 'Entrez le nom de la base de données';

  @override
  String get databasePath => 'Chemin d\'accès';

  @override
  String get databaseColor => 'Couleur';

  @override
  String get databaseColorChoose =>
      'Sélectionnez une couleur pour distinguer les fichiers.';

  @override
  String get databaseKdbxVersion => 'Version du fichier KDBX';

  @override
  String databaseKdbxUpgradeVersion(Object versionName) {
    return 'Mettre à jour vers $versionName';
  }

  @override
  String get databaseKdbxUpgradeSuccessful =>
      'Fichier mis à jour et enregistré avec succès.';

  @override
  String get databaseReload => 'Recharger et fusionner';

  @override
  String progressStatus(Object statusProgress) {
    return 'Statut : $statusProgress';
  }

  @override
  String finishedMerge(Object status) {
    return 'Fusion terminée $status';
  }

  @override
  String get closeAndLockFile => 'Fermer/Verrouiller';

  @override
  String get authPassHomeScreenTagline =>
      'gestionnaire de mots de passe, open source, disponible sur toutes les plateformes.';

  @override
  String get addNewPasswordButtonLabel => 'Ajouter un nouveau mot de passe';

  @override
  String get unnamedEntryPlaceholder => '(Sans nom)';

  @override
  String get unnamedGroupPlaceholder => '(Sans nom)';

  @override
  String get unnamedFilePlaceholder => '(Sans nom)';

  @override
  String get editGroupScreenTitle => 'Modifier le groupe';

  @override
  String get editGroupGroupNameLabel => 'Nom du groupe';

  @override
  String get files => 'Fichiers';

  @override
  String get newGroupDialogTitle => 'Nouveau groupe';

  @override
  String get newGroupDialogInputLabel => 'Nom du nouveau groupe';

  @override
  String get groupActionShowPasswords => 'Afficher les mots de passe';

  @override
  String get groupActionDelete => 'Supprimer';

  @override
  String get logoutTooltip => 'Déconnexion';

  @override
  String get successfullyDeletedFileCloudStorage =>
      'Fichier supprimé avec succès.';

  @override
  String shareDialogTitle(Object fileName) {
    return 'Options de partage pour $fileName';
  }

  @override
  String get shareFileActionLabel => 'Partager …';

  @override
  String get shareTokenListEmptyScreenPlaceholder =>
      'Fichier pas encore partagé.';

  @override
  String get shareTokenNoLabel => 'Aucune étiquette/description';

  @override
  String get shareTokenReadWrite => 'Lire/Écrire';

  @override
  String get shareTokenReadOnly => 'Lecture seulement';

  @override
  String get shareCreateTokenDialogTitle => 'Partager le fichier';

  @override
  String get shareCreateTokenReadOnly => 'Lecture seulement';

  @override
  String get shareCreateTokenReadOnlyHelpText =>
      'Ne pas autoriser la sauvegarde des modifications';

  @override
  String get shareCreateTokenLabelText => 'Description';

  @override
  String get shareCreateTokenLabelHint => 'Partager pour mon ami';

  @override
  String get shareCreateTokenLabelHelp =>
      'Libellé facultatif pour différencier le code de partage.';

  @override
  String get shareCreateTokenSuccess => 'Code de partage créé avec succès.';

  @override
  String get sharePresentDialogTitle =>
      'Partager un fichier avec un code secret de partage';

  @override
  String get sharePresentDialogHelp =>
      'En utilisant le code de partage suivant, les utilisateurs peuvent accéder au fichier de mot de passe. Ils auront besoin du mot de passe et/ou du fichier clé pour l\'ouvrir.';

  @override
  String get sharePresentToken => 'Partager le Code';

  @override
  String get sharePresentCopied =>
      'Code de partage copié dans le presse-papiers.';

  @override
  String get authPassCloudOpenWithShareCodeTooltip =>
      'Ouvrir avec le Code de Partage';

  @override
  String get authPassCloudShareFileActionLabel => 'Partager';

  @override
  String get preferenceAuthPassCloudAttachmentTitle =>
      'Utiliser les pièces jointes AuthPass Cloud';

  @override
  String get preferenceAuthPassCloudAttachmentSubtitle =>
      'Stocker séparément les pièces jointes chiffrées sur AuthPass Cloud.';

  @override
  String get shareCodeInputDialogTitle => 'Saisir le code de partage secret';

  @override
  String get shareCodeInputDialogScan => 'Scanner le Code QR';

  @override
  String get shareCodeInputLabel => 'Partager le Code Secret';

  @override
  String get shareCodeInputHelperText =>
      'Si vous avez reçu un code de partage, veuillez le coller ci-dessus.';

  @override
  String get shareCodeOpen =>
      'Vous avez reçu un code de partage pour AuthPass Cloud ?';

  @override
  String get shareCodeOpenScreenTitle =>
      'Chargement du fichier avec le code de partage';

  @override
  String get shareCodeLoadingProgress => 'Chargement du fichier …';

  @override
  String get shareCodeOpenFileButtonLabel => 'OUVRIR';

  @override
  String get shareCodeOpenInstallAppCaption =>
      'Voulez-vous ouvrir ce fichier avec l\'une de nos applications natives à la place ?';

  @override
  String get shareCodeOpenAnotherAppCaption =>
      'Voulez-vous ouvrir ce fichier sur un autre appareil ?';

  @override
  String get shareCodeOpenInstallAppButtonLabel => 'Installer l\'app';

  @override
  String get shareCodeOpenShowCodeButtonLabel => 'Afficher le Code de Partage';

  @override
  String get changeMasterPasswordActionLabel =>
      'Changer le mot de passe maître';

  @override
  String get changeMasterPasswordFormSubmit =>
      'Sauvegarder avec un nouveau mot de passe';

  @override
  String get changeMasterPasswordSuccess =>
      'Mot de passe maître sauvegardé avec succès.';

  @override
  String get changeMasterPasswordScreenTitle =>
      'Changer le mot de passe maître';

  @override
  String get authPassCloudAuthClickedLink =>
      'J\'ai reçu un e-mail et j\'ai visité le lien';

  @override
  String get authPassCloudAuthNotConfirmed =>
      'L\'adresse e-mail n\'a pas encore été confirmée. Assurez-vous de cliquer sur le lien dans l\'e-mail que vous avez reçu et de résoudre le captcha pour confirmer votre adresse e-mail.';

  @override
  String get getHelpButton => 'Obtenir de l\'aide dans le forum';

  @override
  String get shortcutCopyUsername => 'Copier le nom d\'utilisateur';

  @override
  String get shortcutCopyPassword => 'Copier le mot de passe';

  @override
  String get shortcutCopyTotp => 'Copier le TOTP';

  @override
  String get shortcutMoveUp => 'Sélectionner le mot de passe précédent';

  @override
  String get shortcutMoveDown => 'Sélectionner le mot de passe suivant';

  @override
  String get shortcutGeneratePassword => 'Générer un mot de passe';

  @override
  String get shortcutCopyUrl => 'Copier l\'URL';

  @override
  String get shortcutOpenUrl => 'Ouvrir l\'URL';

  @override
  String get shortcutCancelSearch => 'Annuler la recherche';

  @override
  String get shortcutShortcutHelp => 'Aide pour les Raccourcis clavier';

  @override
  String get shortcutHelpTitle => 'Raccourcis clavier';

  @override
  String unexpectedError(String error) {
    return 'Erreur inattendue : $error';
  }

  @override
  String get googleDriveMorePermissionsRequired =>
      'Additional permissions needed to access Google Drive.';

  @override
  String get googleDriveRequestPermissionButtonLabel => 'Request Permissions';

  @override
  String get scanQrCodeTitle => 'Scan QR Code.';
}
