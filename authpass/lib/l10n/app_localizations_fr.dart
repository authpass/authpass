// ignore_for_file: omit_local_variable_types,unused_local_variable
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

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
  String get fieldTotp => 'Mot de passe à usage unique (base de temps)';

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
  String get selectKeepassFile => 'AuthPass - Sélectionnez un fichier KeePass';

  @override
  String get quickUnlockingFiles => 'Déverrouillage rapide des fichiers';

  @override
  String get selectKeepassFileLabel => 'Veuillez sélectionner un fichier KeePass (.kdbx).';

  @override
  String get openLocalFile => 'Ouvrir un fichier local';

  @override
  String get openFile => 'Ouvrir un fichier';

  @override
  String loadFrom(String cloudStorageName) {
    return 'Charger depuis ${cloudStorageName}';
  }

  @override
  String get loadFromUrl => 'Télécharger depuis une adresse Web';

  @override
  String get createNewKeepass => 'Nouveau sur KeePass?\nCréez une nouvelle base de données de mots de passe';

  @override
  String get labelLastOpenFiles => 'Derniers fichiers ouverts :';

  @override
  String get noFilesHaveBeenOpenYet => 'Aucun fichier n\'a été ouvert pour le moment.';

  @override
  String get preferenceSelectLanguage => 'Sélectionnez la langue';

  @override
  String get preferenceLanguage => 'Langue';

  @override
  String get preferenceTextScaleFactor => 'Facteur d\'échelle du texte';

  @override
  String get preferenceVisualDensity => 'Densité visuelle';

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
  String get preferenceAllowScreenshots => 'Autoriser les captures d\'écran de l\'appli';

  @override
  String get preferenceEnableAutoFill => 'Activer la saisie automatique';

  @override
  String get preferenceAutoFillDescription => 'Uniquement supporté par Android Oreo (8.0) ou supérieur.';

  @override
  String get preferenceTitle => 'Paramètres';

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback => 'Tout type de commentaire est le bienvenu !';

  @override
  String get aboutLinkVisitWebsite => 'N\'oubliez pas de visiter notre site Web';

  @override
  String get aboutLinkGitHub => 'Et le projet Open Source';

  @override
  String aboutLogFile(String logFilePath) {
    return 'Fichier Log : ${logFilePath}';
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
  String get menuItemSupport => 'Assistance par e-mail';

  @override
  String get menuItemSupportSubtitle => 'Envoyer les logs par e-mail/demander de l\'aide.';

  @override
  String get menuItemHelp => 'Aide';

  @override
  String get menuItemHelpSubtitle => 'Afficher la documentation';

  @override
  String get menuItemAbout => 'À propos';

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
    return 'Utilisé seulement pour une longueur > ${customMinLength}';
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
      other: '${numFiles} fichiers sauvegardés : ${files}',
    );
  }

  @override
  String get manageGroups => 'Gestion des groupes';

  @override
  String get lockFiles => 'Verrouiller les fichiers';

  @override
  String get searchHint => 'Recherche';

  @override
  String get clear => 'Supprimer';

  @override
  String get autofillFilterPrefix => 'Filtre :';

  @override
  String get autofillPrompt => 'Sélectionnez le mot de passe pour le remplissage automatique.';

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
  String get doneCopiedPassword => 'Mot de passe copié dans le presse-papier.';

  @override
  String get doneCopiedUsername => 'Nom d\'utilisateur copié dans le presse-papier.';

  @override
  String get emptyPasswordVaultPlaceholder => 'Vous n\'avez pas encore de mot de passe dans votre base de données.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Créez votre premier mot de passe';

  @override
  String get loadingFile => 'Chargement du fichier …';

  @override
  String get internalFile => 'Fichier interne';

  @override
  String get internalFileSubtitle => 'Base de données précédemment créée avec AuthPass';

  @override
  String get filePicker => 'Sélecteur de fichier';

  @override
  String get filePickerSubtitle => 'Ouvrir un fichier de l\'appareil.';

  @override
  String get credentialsAppBarTitle => 'Identification';

  @override
  String get credentialLabel => 'Entrez le mot de passe pour :';

  @override
  String get masterPasswordInputLabel => 'Mot de passe';

  @override
  String get masterPasswordEmptyValidator => 'Veuillez entrer votre mot de passe.';

  @override
  String get masterPasswordIncorrectValidator => 'Mot de passe incorrect';

  @override
  String get useKeyFile => 'Utiliser un fichier clé';

  @override
  String get saveMasterPasswordBiometric => 'Enregistrer le mot de passe dans les clés biométriques ?';

  @override
  String get errorOpenFileAlreadyOpenTitle => 'Fichier déjà ouvert';

  @override
  String errorOpenFileAlreadyOpenBody(Object databaseName, Object openFileSource, Object newFileSource) {
    return 'La base de données ${databaseName} sélectionnée est déjà ouverte depuis ${openFileSource} (tentative d\'ouverture depuis ${newFileSource})';
  }

  @override
  String get errorUnlockFileTitle => 'Ouverture de fichier impossible';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Erreur inconnue lors de l\'ouverture du fichier. ${error}';
  }

  @override
  String get dialogContinue => 'Suivant';

  @override
  String get dialogSendErrorReport => 'Envoyer un rapport d\'erreur/aide';

  @override
  String get groupFilterDescription => 'Sélectionnez les groupes à afficher (récursif)';

  @override
  String get groupFilterSelectAll => 'Tout sélectionner';

  @override
  String get groupFilterDeselectAll => 'Tout désélectionner';

  @override
  String get createSubgroup => 'Créer un sous-groupe';

  @override
  String get editAction => 'Modifier';

  @override
  String get deleteAction => 'Supprimer';

  @override
  String get successfullyDeletedGroup => 'Groupe supprimé.';

  @override
  String get undoButtonLabel => 'Annuler';

  @override
  String get initialNewGroupName => 'Nouveau groupe';

  @override
  String get deleteGroupErrorTitle => 'Impossible de supprimer le groupe';

  @override
  String get deleteGroupErrorBodyContainsGroup => 'Ce groupe contient d\'autres groupes. Vous ne pouvez supprimer que des groupes vides.';

  @override
  String get deleteGroupErrorBodyContainsEntries => 'Ce groupe contient des mots de passe. Vous ne pouvez supprimer que des groupes vides.';

  @override
  String get groupListAppBarTitle => 'Groupes';

  @override
  String get groupListFilterAppbarTitle => 'Filtrer par groupes';

  @override
  String get clearQuickUnlock => 'Clear Biometric Storage';

  @override
  String get clearQuickUnlockSubtitle => 'Remove saved master passwords';

  @override
  String get unlock => 'Unlock Files';

  @override
  String get clearQuickUnlockSuccess => 'Removed saved master passwords from biometric storage.';

  @override
  String unexpectedError(String error) {
    return 'Erreur inattendue : ${error}';
  }
}
