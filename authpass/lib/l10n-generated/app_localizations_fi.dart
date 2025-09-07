// ignore_for_file: omit_local_variable_types,unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get fieldUserName => 'Käyttäjä';

  @override
  String get fieldPassword => 'Salasana';

  @override
  String get fieldWebsite => 'Verkkosivusto';

  @override
  String get fieldTitle => 'Otsikko';

  @override
  String get fieldTotp => 'Kertakäyttöinen salasana (Ajan perusteella)';

  @override
  String get english => 'Englanti';

  @override
  String get german => 'Saksa';

  @override
  String get russian => 'Venäjä';

  @override
  String get ukrainian => 'Ukraina';

  @override
  String get lithuanian => 'Liettua';

  @override
  String get french => 'Ranska';

  @override
  String get spanish => 'Espanja';

  @override
  String get indonesian => 'Indonesia';

  @override
  String get turkish => 'Turkki';

  @override
  String get hebrew => 'Heprea';

  @override
  String get italian => 'Italia';

  @override
  String get chineseSimplified => 'Kiina Yksinkertaistettu';

  @override
  String get chineseTraditional => 'Kiina Perinteinen';

  @override
  String get portugueseBrazilian => 'Portugali, Brasilia';

  @override
  String get slovak => 'Slovakia';

  @override
  String get dutch => 'Hollanti';

  @override
  String get selectItem => 'Valitse';

  @override
  String get selectKeepassFile => 'AuthPass - Valitse KeePass tiedosto';

  @override
  String get selectKeepassFileLabel => 'Valitse KeePass (.kdbx) tiedosto.';

  @override
  String get createNewFile => 'Luo uusi tiedosto';

  @override
  String get openLocalFile => 'Avaa\npaikallinen tiedosto';

  @override
  String get openFile => 'Avaa tiedosto';

  @override
  String get loadFromDropdownMenu => 'Lataa osoitteesta …';

  @override
  String get quickUnlockingFiles => 'Nopea tiedostojen lukituksen avaaminen …';

  @override
  String openFileProgress(Object fileName, Object current, Object totalCount) {
    return 'Avataan $fileName … ($current / $totalCount)';
  }

  @override
  String loadFrom(String cloudStorageName) {
    return 'Lataa osoitteesta $cloudStorageName';
  }

  @override
  String get loadFromRemoteUrl => 'Avaa kdbx URL-osoitteesta';

  @override
  String get createNewKeepass =>
      'Uusi KeePass käyttäjä?\nLuo uusi salasanatietokanta';

  @override
  String get labelLastOpenFiles => 'Viimeksi avatut tiedostot:';

  @override
  String get noFilesHaveBeenOpenYet => 'Yhtään tiedostoa ei ole vielä avattu.';

  @override
  String get preferenceSelectLanguage => 'Valitse kieli';

  @override
  String get preferenceLanguage => 'Kieli';

  @override
  String get preferenceTextScaleFactor => 'Tekstin skaalauskerroin';

  @override
  String get preferenceVisualDensity => 'Näkyvä tiheys';

  @override
  String get preferenceTheme => 'Teema';

  @override
  String get preferenceThemeLight => 'Vaalea';

  @override
  String get preferenceThemeDark => 'Tumma';

  @override
  String get preferenceSystemDefault => 'Järjestelmän oletus';

  @override
  String get preferenceDefault => 'Oletus';

  @override
  String get lockAllFiles => 'Lukitse kaikki avoimet tiedostot';

  @override
  String get preferenceAllowScreenshots => 'Salli sovelluksen kuvakaappaukset';

  @override
  String get preferenceEnableAutoFill => 'Käytä automaattista täyttöä';

  @override
  String get enableAutofillSuggestionBanner =>
      'Voit täyttää toisen sovelluksen kentän ottamalla automaattisen täytön käyttöön!';

  @override
  String get dismissAutofillSuggestionBannerButton => 'HYLKÄÄ';

  @override
  String get enableAutofillSuggestionBannerButton => 'OTA KÄYTTÖÖN!';

  @override
  String get preferenceAutoFillDescription =>
      'Tuettu vain Android Oreo (8.0) tai uudempi.';

  @override
  String get preferenceTitle => 'Asetukset';

  @override
  String get preferenceEnableSystemWideShortcuts =>
      'Ota käyttöön järjestelmän leveät pikakuvakkeet';

  @override
  String get preferenceEnableSystemWideShortcutsHelp =>
      'Rekisteröi ctrl+alt+f järjestelmän pikanäppäimenä avoimeen hakuun.';

  @override
  String get preferencesSearchFields => 'Muokkaa hakukenttiä';

  @override
  String get preferencesSearchFieldPromptTitle => 'Haku kentät';

  @override
  String get preferencesSearchFieldPromptLabel =>
      'Pilkulla erotettu luettelo kentistä, joita käytetään salasanaluettelon hakuun.';

  @override
  String preferencesSearchFieldPromptHelp(
    Object wildCardCharacter,
    Object defaultSearchFields,
  ) {
    return 'Käytä $wildCardCharacter kaikille, jätä tyhjäksi oletukseksi ($defaultSearchFields)';
  }

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback =>
      'Toivotamme tervetulleeksi kaikenlaisen palautteen!';

  @override
  String get aboutLinkVisitWebsite => 'Muista myös vierailla sivuillamme';

  @override
  String get aboutLinkGitHub => 'Ja Avoimen Lähdekoodin Projekti';

  @override
  String aboutLogFile(String logFilePath) {
    return 'Lokitiedosto: $logFilePath';
  }

  @override
  String get aboutLinkContributors => 'Näytä Avustajat';

  @override
  String get unableToLaunchUrlTitle => 'Url-osoitetta ei voi avata';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'Ei voida käynnistää $url: $openError';
  }

  @override
  String get unableToLaunchUrlNoHandler =>
      'Url-osoitteelle ei ole saatavilla sovellusta.';

  @override
  String launchedUrl(Object url) {
    return 'Avattu URL-osoite: $url';
  }

  @override
  String get menuItemGeneratePassword => 'Luo Salasana';

  @override
  String get menuItemPreferences => 'Asetukset';

  @override
  String get menuItemOpenAnotherFile => 'Avaa toinen tiedosto';

  @override
  String get menuItemCheckForUpdates => 'Tarkista päivitykset';

  @override
  String get menuItemSupport => 'Lähetä lokitiedot';

  @override
  String get menuItemSupportSubtitle => 'Lähetä lokitiedot sähköpostitse';

  @override
  String get menuItemForum => 'Tuki Foorumi';

  @override
  String get menuItemForumSubtitle => 'Ilmoita ongelmista ja saa apua';

  @override
  String get menuItemHelp => 'Ohje';

  @override
  String get menuItemHelpSubtitle => 'Näytä dokumentaatio';

  @override
  String get menuItemAbout => 'Tietoja';

  @override
  String get actionOpenUrl => 'Avaa URL-osoite';

  @override
  String get passwordPlainText => 'Näytä salasana';

  @override
  String get generatorPassword => 'Salasana';

  @override
  String get generatePassword => 'Luo Salasana';

  @override
  String get doneButtonLabel => 'Valmis';

  @override
  String get useAsDefault => 'Käytä oletuksena';

  @override
  String get characterSetLowerCase => 'Pienet kirjaimet (a-z)';

  @override
  String get characterSetUpperCase => 'Isot kirjaimet (A-Z)';

  @override
  String get characterSetNumeric => 'Numerot (0-9)';

  @override
  String get characterSetUmlauts => 'Umlautit (ä)';

  @override
  String get characterSetSpecial => 'Erikois (@%+)';

  @override
  String get length => 'Pituus';

  @override
  String get customLength => 'Muokattu Pituus';

  @override
  String customLengthHelperText(Object customMinLength) {
    return 'Käytetään vain pituudeltaan > $customMinLength';
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
      other: '$numFilesString tiedostot tallennettu: $files',
      one: 'Yksi tiedosto tallennettu: $files',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => 'Hallitse Ryhmiä';

  @override
  String get lockFiles => 'Lukitse Tiedostot';

  @override
  String get searchHint => 'Etsi';

  @override
  String get searchButtonLabel => 'Etsi';

  @override
  String get filterButtonLabel => 'Suodata ryhmän mukaan';

  @override
  String get clear => 'Tyhjennä';

  @override
  String get autofillFilterPrefix => 'Suodatin:';

  @override
  String get autofillPrompt =>
      'Valitse salasanan syöttö automaattista täyttöä varten.';

  @override
  String get copiedToClipboard => 'Kopioitu leikepöydälle.';

  @override
  String get noTitle => '(ei otsikkoa)';

  @override
  String get noUsername => '(ei käyttäjänimeä)';

  @override
  String get filterCustomize => 'Muokkaa …';

  @override
  String get swipeCopyPassword => 'Kopioi Salasana';

  @override
  String get swipeCopyUsername => 'Kopioi Käyttäjänimi';

  @override
  String get copyUsernameNotExists => 'Käyttäjänimeä ei ole määritelty.';

  @override
  String get copyPasswordNotExists =>
      'Merkinnässä ei ole määritetty salasanaa.';

  @override
  String get doneCopiedPassword => 'Salasana kopioitu leikepöydälle.';

  @override
  String get doneCopiedUsername => 'Käyttäjätunnus kopioitu leikepöydälle.';

  @override
  String get doneCopiedField => 'Kopioitu.';

  @override
  String copiedFieldToClipboard(Object fieldName) {
    return '$fieldName kopioitu.';
  }

  @override
  String copiedFieldEmpty(Object fieldName) {
    return '$fieldName on tyhjä.';
  }

  @override
  String get emptyPasswordVaultPlaceholder =>
      'Sinulla ei ole vielä salasanaa tietokannassasi.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Luo ensimmäinen salasanasi';

  @override
  String get loading => 'Ladataan';

  @override
  String get loadingFile => 'Ladataan tiedostoa…';

  @override
  String get internalFile => 'Sisäinen tiedosto';

  @override
  String get internalFileSubtitle => 'Aiemmin AuthPassilla luotu tietokanta';

  @override
  String get filePicker => 'Tiedoston valitsin';

  @override
  String get filePickerSubtitle => 'Avaa tiedosto laitteesta.';

  @override
  String get credentialsAppBarTitle => 'Valtuustiedot';

  @override
  String get credentialLabel => 'Anna salasana:';

  @override
  String get masterPasswordInputLabel => 'Salasana';

  @override
  String get masterPasswordEmptyValidator => 'Syötä salasanasi.';

  @override
  String get masterPasswordIncorrectValidator => 'Väärä salasana';

  @override
  String get useKeyFile => 'Käytä avaintiedostoa';

  @override
  String get saveMasterPasswordBiometric =>
      'Tallennetaanko salasana biometrisellä avaimella?';

  @override
  String get close => 'Sulje';

  @override
  String get addNewPassword => 'Luo Uusi Salasana';

  @override
  String get errorOpenFileInvalidFileStructureTitle =>
      'Yritettiin avata virheellinen tiedostotyyppi';

  @override
  String errorOpenFileInvalidFileStructureBody(Object fileName) {
    return 'Tiedosto ($fileName) ei näytä olevan kelvollinen KDBX- tiedosto. Valitse joko kelvollinen KDBX-tiedosto tai luo uusi salasanan tietokanta.';
  }

  @override
  String get errorOpenFileAlreadyOpenTitle => 'Tiedosto on jo auki';

  @override
  String errorOpenFileAlreadyOpenBody(
    Object databaseName,
    Object openFileSource,
    Object newFileSource,
  ) {
    return 'Valittu tietokanta $databaseName on jo avoinna $openFileSource (Yritettiin avata $newFileSource)';
  }

  @override
  String get loadFromUrl => 'Lataa osoitteesta Url';

  @override
  String get loadFromUrlEnterUrl => 'Kirjoita URL-osoite';

  @override
  String get loadFromUrlErrorEnterFullUrl =>
      'Anna koko Url-osoite, joka alkaa http:// tai https://';

  @override
  String get loadFromUrlErrorInvalidUrl => 'Anna kelvollinen Url-osoite.';

  @override
  String get linuxAppArmorWarning =>
      'AuthPass vaatii luvan kommunikoida Secret Servicen kanssa, jotta se voi tallentaa valtakirjat pilvitallennusta varten.\nSuorita seuraava komento:';

  @override
  String get cancel => 'Peruuta';

  @override
  String get errorLoadFileFromSourceTitle => 'Virhe tiedostoa avattaessa.';

  @override
  String errorLoadFileFromSourceBody(Object source, Object error) {
    return 'Ei voitu avata $source.\n$error';
  }

  @override
  String get errorUnlockFileTitle => 'Tiedostoa ei voi avata';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Tuntematon virhe avattaessa tiedostoa. $error';
  }

  @override
  String get dialogContinue => 'Jatka';

  @override
  String get dialogSendErrorReport => 'Lähetä Virheraportti';

  @override
  String get dialogReportErrorForum => 'Ilmoita virheestä foorumissa/ohjeessa';

  @override
  String get groupFilterDescription =>
      'Valitse, mitkä ryhmät näytetään (rekursiivisesti)';

  @override
  String get groupFilterSelectAll => 'Valitse kaikki';

  @override
  String get groupFilterDeselectAll => 'Poista kaikki valinnat';

  @override
  String get createSubgroup => 'Luo alaryhmä';

  @override
  String get editAction => 'Muokkaa';

  @override
  String get mailboxEnableLabel => '(uudelleen)käyttöönotto';

  @override
  String get mailboxEnableHint => 'Jatka sähköpostien vastaanottamista';

  @override
  String get mailboxDisableLabel => 'Poista Käytöstä';

  @override
  String get mailboxDisableHint => 'Älä enää vastaanota sähköposteja';

  @override
  String get mailListNoMail => 'Sinulla ei ole vielä yhtään sähköpostia.';

  @override
  String mailboxLabelPrefixForEntry(Object entryLabel) {
    return 'Sisäänkirjautuminen: $entryLabel';
  }

  @override
  String mailboxLabelPrefixUnknownEntry(Object entryUuid) {
    return 'Tuntematon kirjautuminen: $entryUuid';
  }

  @override
  String mailboxLabelPrefixCreatedAt(Object dateTime) {
    return 'Luotu osoitteessa: $dateTime';
  }

  @override
  String get masterPasswordDescription =>
      'Pääsalasanaa käytetään salaamaan turvallisesti salasanatietokantasi. Varmista, että muistat sen, sitä ei voi palauttaa.';

  @override
  String get unsavedChangesWarningTitle => 'Tallentamattomat Muutokset';

  @override
  String get unsavedChangesWarningBody =>
      'Tallentamattomia muutoksia on edelleen. Haluatko hylätä muutokset?';

  @override
  String get unsavedChangesDiscardActionLabel => 'Hylkää Muutokset';

  @override
  String get deletePermanentlyAction => 'Poista Pysyvästi';

  @override
  String get restoreFromRecycleBinAction => 'Palauta';

  @override
  String get deleteAction => 'Poista';

  @override
  String get deletedEntry => 'Poistettu merkintä.';

  @override
  String get successfullyDeletedGroup => 'Poistettu ryhmä.';

  @override
  String get undoButtonLabel => 'Kumoa';

  @override
  String get saveButtonLabel => 'Tallenna';

  @override
  String get webDavSettings => 'WebDAV asetukset';

  @override
  String get webDavUrlLabel => 'URL-osoite';

  @override
  String get webDavUrlHelperText => 'WebDAV palvelun Url-osoite.';

  @override
  String get webDavUrlValidatorError => 'Anna URL-osoite';

  @override
  String get webDavUrlValidatorInvalidUrlError =>
      'Syötä kelvollinen Url-osoite http:// tai http://';

  @override
  String get webDavAuthUser => 'Käyttäjätunnus';

  @override
  String get webDavAuthPassword => 'Salasana';

  @override
  String get mergeSuccessDialogTitle =>
      'Salasanan tietokanta yhdistetty onnistuneesti';

  @override
  String mergeSuccessDialogMessage(Object fileName, Object mergeSummary) {
    return 'Ristiriita havaittu tallennettaessa $fileName, se yhdistettiin onnistuneesti etätiedostoon: \n\n$mergeSummary';
  }

  @override
  String forDetailsVisitUrl(Object url) {
    return 'Tarkemmat tiedot $url';
  }

  @override
  String get authPassCloudAuthEmailInputLabel =>
      'Anna sähköpostiosoite rekisteröityäksesi tai kirjautuaksesi sisään.';

  @override
  String get authPassCloudAuthEmailInvalid =>
      'Ole hyvä ja syötä toimiva sähköpostiosoite.';

  @override
  String get authPassCloudAuthConfirmEmailButtonLabel => 'Vahvista osoite';

  @override
  String get authPassCloudAuthConfirmEmail =>
      'Tarkista sähköpostisi ja vahvista sähköpostiosoitteesi.';

  @override
  String get authPassCloudAuthConfirmEmailExplain =>
      'Pidä tämä näyttö auki, kunnes vierailet sähköpostissa saamassasi linkissä.';

  @override
  String get authPassCloudAuthResendExplain =>
      'Jos et ole saanut sähköpostia, tarkista roskapostikansio. Muussa tapauksessa voit yrittää pyytää uuden vahvistuslinkin.';

  @override
  String get authPassCloudAuthResendButtonLabel => 'Pyydä uusi vahvistuslinkki';

  @override
  String permanentlyDeleteEntryConfirm(Object title) {
    return 'Tämä poistaa salasanan merkinnän $title pysyvästi. Tätä ei voi perua. Haluatko jatkaa?';
  }

  @override
  String get permanentlyDeletedEntrySnackBar => 'Poistettu pysyvästi.';

  @override
  String get initialNewGroupName => 'Uusi Ryhmä';

  @override
  String get deleteGroupErrorTitle => 'Ryhmää ei voi poistaa';

  @override
  String get deleteGroupErrorBodyContainsGroup =>
      'Tämä ryhmä sisältää edelleen muita ryhmiä. Voit tällä hetkellä poistaa vain tyhjiä ryhmiä.';

  @override
  String get deleteGroupErrorBodyContainsEntries =>
      'Tämä ryhmä sisältää edelleen salasanamerkintöjä. Tällä hetkellä voit poistaa vain tyhjiä ryhmiä.';

  @override
  String get groupListAppBarTitle => 'Ryhmät';

  @override
  String get groupListFilterAppbarTitle => 'Suodata ryhmien mukaan';

  @override
  String get clearQuickUnlock => 'Tyhjennä Biometrinen Tallennustila';

  @override
  String get clearQuickUnlockSubtitle => 'Poista tallennetut pääsalasanat';

  @override
  String get unlock => 'Lukitse Tiedostot';

  @override
  String get closePasswordFiles => 'sulje salasanatiedostot';

  @override
  String get clearQuickUnlockSuccess =>
      'Tallennetut pääsalasanat poistettiin biometrisesta tallennustilasta.';

  @override
  String get diacOptIn => 'Valitse sovelluksen sisäiset uutiset, kyselyt.';

  @override
  String get diacOptInSubtitle =>
      'Lähettää toisinaan verkkopyynnön noutaakseen uutisia.';

  @override
  String get enableAutofillDebug =>
      'Automaattinen täyttö: Ota virheenkorjaus käyttöön';

  @override
  String get enableAutofillDebugSubtitle =>
      'Näyttää kaikkien syöttökenttien tiedot';

  @override
  String get createPasswordDatabase => 'Luo salasanatietokanta';

  @override
  String get nameNewPasswordDatabase => 'Uuden tietokannan nimi';

  @override
  String get validatorNameMissing =>
      'Ole hyvä ja syötä nimi uudelle tietokannalle.';

  @override
  String get masterPasswordHelpText =>
      'Valitse turvallinen pääsalasana. Varmista, että muistat sen.';

  @override
  String get inputMasterPasswordText => 'Pääsalasana';

  @override
  String get masterPasswordMissingCreate =>
      'Anna turvallinen, muistettava salasana.';

  @override
  String get createDatabaseAction => 'Luo Tietokanta';

  @override
  String get databaseExistsError => 'Tiedosto On Olemassa';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'Virhe luotaessa tietokantaa $filePath. Tiedosto on jo olemassa. Valitse toinen nimi.';
  }

  @override
  String get databaseCreateDefaultName => 'Henkilökohtaiset salasanat';

  @override
  String get preferenceDynamicLoadIcons => 'Lataa kuvakkeet dynaamisesti';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'Tehdään http pyyntöjä, joiden arvo on $urlFieldName kentässä, ladataksesi verkkosivujen kuvakkeet.';
  }

  @override
  String passwordScore(Object score) {
    return 'Vahvuus: $score / 4';
  }

  @override
  String get entryInfoFile => 'Tiedosto:';

  @override
  String get entryInfoGroup => 'Ryhmä:';

  @override
  String get entryInfoLastModified => 'Viimeksi Muokattu:';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'Siirretty sisäänkirjaus kohteeseen $groupName';
  }

  @override
  String sizeBytesStoredAuthPassCloud(Object count) {
    return '$count tavua, tallennettu Authpass-pilveen';
  }

  @override
  String sizeBytes(Object count) {
    return '$count tavua';
  }

  @override
  String get entryAddAttachment => 'Lisää Liite';

  @override
  String get entryAttachmentSizeWarning =>
      'Liitetiedostot upotetaan salasanatiedostoon. Tämä voi merkittävästi pidentää salasanojen avaamiseen/tallennukseen tarvittavaa aikaa.';

  @override
  String get iconPngSizeWarning =>
      'Mukautetut kuvakkeet upotetaan salasanatiedostoon. Tämä voi merkittävästi pidentää salasanojen avaamiseen/tallennukseen tarvittavaa aikaa.';

  @override
  String get notPngError => 'Valittu tiedosto ei ole PNG.';

  @override
  String get entryAddField => 'Lisää Kenttä';

  @override
  String get entryCustomField => 'Muokattu Kenttä';

  @override
  String get entryCustomFieldTitle => 'Uuden mukautetun kentän lisääminen';

  @override
  String get entryCustomFieldInputLabel => 'Anna kentälle nimi';

  @override
  String get swipeCopyField => 'Kopioi Kenttä';

  @override
  String get fieldRename => 'Uudelleennimeä';

  @override
  String get fieldGeneratePassword => 'Luo Salasana…';

  @override
  String get fieldProtect => 'Suojaa Arvo';

  @override
  String get fieldUnprotect => 'Suojausarvon poistaminen';

  @override
  String get fieldPresent => 'Esittää';

  @override
  String get fieldGenerateEmail => 'Luo sähköpostiosoite';

  @override
  String get onboardingBackToOnboarding => 'Kierros';

  @override
  String get onboardingBackToOnboardingSubtitle =>
      'Koe uudelleen ensimmäinen kokemus: grinning_face_with_hikinen';

  @override
  String get onboardingHeadline => 'Tehdään salasanasi turvallisiksi!';

  @override
  String get onboardingQuestion =>
      'Oletko aiemmin käyttänyt salasanojen hallintaa?';

  @override
  String get onboardingYesOpenPasswords => 'Kyllä, avaa salasanani';

  @override
  String get onboardingNoCreate => 'Olen uusi! Aloita.';

  @override
  String get backupButton => 'TALLENNA PILVEEN';

  @override
  String get dismissBackupButton => 'HYLKÄÄ';

  @override
  String backupWarningMessage(Object databasename) {
    return 'Salasanasi $databasename tallennetaan vain paikallisesti!';
  }

  @override
  String get saveAs => 'Tallenna kohteeseen...';

  @override
  String get saving => 'Tallennetaan';

  @override
  String get increaseValue => 'Lisää';

  @override
  String get decreaseValue => 'Vähennä';

  @override
  String get resetValue => 'Nollaa';

  @override
  String cloudStorageAppBarTitle(Object cloudStorageName) {
    return 'Pilvitallennustila - $cloudStorageName';
  }

  @override
  String get cloudStorageLogInCaption =>
      'Sinut ohjataan uudelleen todentamaan AuthPass jotta voit käyttää tietojasi.';

  @override
  String get cloudStorageLogInCode => 'Syötä koodi';

  @override
  String launchUrlError(Object url) {
    return 'URL-osoitetta ei voitu avata. Käy osoitteessa $url';
  }

  @override
  String cloudStorageLogInActionLabel(Object cloudStorageName) {
    return 'Kirjaudu sisään $cloudStorageName';
  }

  @override
  String cloudStorageAuthCodeDialogTitle(Object cloudStorageName) {
    return '$cloudStorageName Tunnistautuminen';
  }

  @override
  String get cloudStorageAuthCodeLabel => 'Todennuskoodi';

  @override
  String get cloudStorageAuthErrorTitle => 'Virhe todennuksen aikana';

  @override
  String cloudStorageAuthErrorMessage(
    Object cloudStorageName,
    Object errorMessage,
  ) {
    return 'Virhe, kun yritetään tunnistautua $cloudStorageName: $errorMessage';
  }

  @override
  String get cloudStorageSearchBoxLabel => 'Hakukysely';

  @override
  String cloudStorageItemsInFolder(Object itemCount) {
    return '$itemCount kohdetta tässä kansiossa.';
  }

  @override
  String get mailSubject => 'Aihe';

  @override
  String get mailFrom => 'Alkaen';

  @override
  String get mailDate => 'Päivämäärä';

  @override
  String get mailMailbox => 'Sähköpostilaatikko';

  @override
  String get mailNoData => 'Ei Dataa';

  @override
  String get mailMailboxesTitle => 'Sähköpostilaatikko';

  @override
  String get mailboxCreateButtonLabel => 'Luo';

  @override
  String get mailboxNameInputDialogTitle =>
      'Valinnainen merkintä uudelle postilaatikolle';

  @override
  String get mailboxNameInputLabel => '(Sisäinen) Merkki';

  @override
  String get mailScreenTitle => 'AuthPass Sähköposti';

  @override
  String get mailTabBarTitleMailbox => 'Sähköpostilaatikko';

  @override
  String get mailTabBarTitleMail => 'Sähköposti';

  @override
  String get mailMailboxListEmpty =>
      'Sinulla ei ole vielä yhtään sähköpostipostilaatikkoa.';

  @override
  String mailMailboxAddressCopied(Object mailboxAddress) {
    return 'Kopioi postilaatikon osoite leikepöydälle: $mailboxAddress';
  }

  @override
  String get errorWhileSavingTitle => 'Virhe tallennettaessa';

  @override
  String errorWhileSavingBody(Object errorMessage) {
    return 'Tiedostoa ei voi tallentaa: $errorMessage';
  }

  @override
  String get databaseDoesNotSupportSaving =>
      'Valitettavasti tämä tietokanta ei tue tallennusta. Avaa paikallinen tietokantatiedosto. Tai käytä \"Tallenna nimellä\".';

  @override
  String get otpInvalidKeyTitle => 'Virheellinen Avain';

  @override
  String get otpInvalidKeyBody =>
      'Annettu syöte ei ole kelvollinen base32 TOTP koodi. Tarkista syötteesi.';

  @override
  String get otpUnsupportedMigrationTitle => 'Unsupported OTP Migration';

  @override
  String otpUnsupportedMigrationBody(Object uriCount) {
    return 'We currently only support single item migrations. Got $uriCount';
  }

  @override
  String get otpPromptTitle => 'Aikaperusteinen Todennus';

  @override
  String get otpPromptHelperText => 'Ole hyvä ja syötä aikaperusteinen avain.';

  @override
  String otpErrorMessageGeneration(Object errorMessage) {
    return 'Virhe luotaessa kutsukoodia: $errorMessage';
  }

  @override
  String get otpCopySecretActionLabel => 'Kopioi Salaus';

  @override
  String get otpEntryLabel => 'Kertakäyttöinen merkki';

  @override
  String get entryFieldProtected => 'Suojattu kenttä. Napsauta paljastaaksesi.';

  @override
  String get entryFieldActionRevealField => 'Näytä suojattu kenttä';

  @override
  String get entryAttachmentOpenActionLabel => 'Avaa';

  @override
  String get entryAttachmentShareActionLabel => 'Jaa';

  @override
  String get entryAttachmentShareSubject => 'Liite';

  @override
  String get entryAttachmentSaveActionLabel => 'Tallenna laitteeseen';

  @override
  String get entryAttachmentRemoveActionLabel => 'Poista';

  @override
  String entryAttachmentRemoveConfirm(Object attachmentLabel) {
    return 'Haluatko varmasti poistaa $attachmentLabel?';
  }

  @override
  String get entryRenameFieldPromptTitle => 'Nimetään kenttä uudelleen';

  @override
  String get removerecentfile => 'Piilota';

  @override
  String get entryRenameFieldPromptLabel => 'Kirjoita kentälle uusi nimi';

  @override
  String get promptDialogPasteActionTooltip => 'Liitä leikepöydältä';

  @override
  String get promptDialogPasteHint =>
      'Vinkki: Jos haluat liittää, kokeile vasemmalla olevaa painiketta ;-)';

  @override
  String get genericErrorDialogTitle => 'Virhe toimintoa käsiteltäessä';

  @override
  String genericErrorDialogBody(Object errorMessage) {
    return 'Tapahtui odottamaton virhe. $errorMessage';
  }

  @override
  String get saveAsEntryLocalFile => 'Paikallinen Tiedosto';

  @override
  String get fileTypePngs => 'Kuvat (png)';

  @override
  String get selectIconDialogAction => 'VALITSE ICON';

  @override
  String get retryDialogActionLabel => 'PALAUTA';

  @override
  String errorDuringNetworkCall(Object errorMessage) {
    return 'Virhe api puhelun aikana. $errorMessage';
  }

  @override
  String get passwordFilterHideDeleted => 'Piilota Poistetut Merkinnät';

  @override
  String get passwordFilterOnlyDeleted => 'Poistetut Merkinnät';

  @override
  String passwordFilterPrefixForOneGroup(Object groupName) {
    return 'Ryhmä: $groupName';
  }

  @override
  String passwordFilterPrefixForMultipleGroups(Object groupCount) {
    return 'Mukautettu Suodatin ($groupCount Ryhmää)';
  }

  @override
  String get menuItemAuthPassCloudAuthenticate => 'Todennus AuthPass Cloudilla';

  @override
  String get menuItemAuthPassCloudMailboxes => 'AuthPass Postilaatikot';

  @override
  String changesWithoutSaving(Object fileName) {
    return 'Sinulla on muutoksia kohteessa \"$fileName\", joka ei tue muutosten kirjoittamista.';
  }

  @override
  String get changesSaveLocally => 'Tallenna paikallisesti';

  @override
  String get clearColor => 'Tyhjennä Väri';

  @override
  String get databaseRenameInputLabel => 'Anna tietokannan nimi';

  @override
  String get databasePath => 'Polku';

  @override
  String get databaseColor => 'Väri';

  @override
  String get databaseColorChoose =>
      'Valitse väri, joka erottaa tiedostot toisistaan.';

  @override
  String get databaseKdbxVersion => 'Kdbx- Tiedostoversio';

  @override
  String databaseKdbxUpgradeVersion(Object versionName) {
    return 'Päivitä $versionName';
  }

  @override
  String get databaseKdbxUpgradeSuccessful =>
      'Tiedosto päivitettiin onnistuneesti ja tallennettu.';

  @override
  String get databaseReload => 'Päivitä ja yhdistä';

  @override
  String progressStatus(Object statusProgress) {
    return 'Tila: $statusProgress';
  }

  @override
  String finishedMerge(Object status) {
    return 'Yhdistäminen valmis $status';
  }

  @override
  String get closeAndLockFile => 'Sulje/Lukitse';

  @override
  String get authPassHomeScreenTagline =>
      'salasanojen hallinta, avoin lähdekoodi, saatavilla kaikilla alustoilla.';

  @override
  String get addNewPasswordButtonLabel => 'Luo Uusi Salasana';

  @override
  String get unnamedEntryPlaceholder => '(Nimetön)';

  @override
  String get unnamedGroupPlaceholder => '(Nimetön)';

  @override
  String get unnamedFilePlaceholder => '(Nimetön)';

  @override
  String get editGroupScreenTitle => 'Muokkaa Ryhmää';

  @override
  String get editGroupGroupNameLabel => 'Ryhmän Nimi';

  @override
  String get files => 'Tiedostot';

  @override
  String get newGroupDialogTitle => 'Uusi Ryhmä';

  @override
  String get newGroupDialogInputLabel => 'Uuden ryhmän nimi';

  @override
  String get groupActionShowPasswords => 'Näytä salasanat';

  @override
  String get groupActionDelete => 'Poista';

  @override
  String get logoutTooltip => 'Kirjaudu Ulos';

  @override
  String get successfullyDeletedFileCloudStorage =>
      'Tiedosto poistettiin onnistuneesti.';

  @override
  String shareDialogTitle(Object fileName) {
    return 'Jakamisen vaihtoehdot kohteelle $fileName';
  }

  @override
  String get shareFileActionLabel => 'Jaa …';

  @override
  String get shareTokenListEmptyScreenPlaceholder =>
      'Tiedostoa ei ole vielä jaettu.';

  @override
  String get shareTokenNoLabel => 'Ei Tunnusta/Kuvausta';

  @override
  String get shareTokenReadWrite => 'Luettu/Kirjoitettu';

  @override
  String get shareTokenReadOnly => 'Vain luku';

  @override
  String get shareCreateTokenDialogTitle => 'Jaa tiedosto';

  @override
  String get shareCreateTokenReadOnly => 'Vain luku';

  @override
  String get shareCreateTokenReadOnlyHelpText =>
      'Älä salli muutosten tallentamista';

  @override
  String get shareCreateTokenLabelText => 'Kuvaus';

  @override
  String get shareCreateTokenLabelHint => 'Jaa ystäväni kanssa';

  @override
  String get shareCreateTokenLabelHelp =>
      'Valinnainen tunniste jakamiskoodin erottamiseksi.';

  @override
  String get shareCreateTokenSuccess => 'Jakamiskoodin luominen onnistui.';

  @override
  String get sharePresentDialogTitle =>
      'Jaa tiedosto salaisella jakamiskoodilla';

  @override
  String get sharePresentDialogHelp =>
      'Seuraavan jakamiskoodin avulla käyttäjät voivat käyttää salasanatiedostoa. He tarvitsevat salasanan ja/tai avaintiedoston avatakseen sen.';

  @override
  String get sharePresentToken => 'Jaa Koodi';

  @override
  String get sharePresentCopied => 'Jakamiskoodi kopioitu leikepöydälle.';

  @override
  String get authPassCloudOpenWithShareCodeTooltip => 'Avaa jakamiskoodilla';

  @override
  String get authPassCloudShareFileActionLabel => 'Jaa';

  @override
  String get preferenceAuthPassCloudAttachmentTitle =>
      'Käytä AuthPass Cloud -liitteitä';

  @override
  String get preferenceAuthPassCloudAttachmentSubtitle =>
      'Tallenna Liitteet salattuna AuthPass Cloudiin erikseen.';

  @override
  String get shareCodeInputDialogTitle => 'Syötä salainen jakamiskoodi';

  @override
  String get shareCodeInputDialogScan => 'Skannaa QR-koodi';

  @override
  String get shareCodeInputLabel => 'Salainen jakamiskoodi';

  @override
  String get shareCodeInputHelperText =>
      'Jos olet saanut jakamiskoodin, liitä se yllä.';

  @override
  String get shareCodeOpen => 'Saitko AuthPass Cloudin jakamiskoodin?';

  @override
  String get shareCodeOpenScreenTitle => 'Ladataan tiedostoa jakamiskoodilla';

  @override
  String get shareCodeLoadingProgress => 'Ladataan tiedostoa…';

  @override
  String get shareCodeOpenFileButtonLabel => 'AVAA';

  @override
  String get shareCodeOpenInstallAppCaption =>
      'Haluatko avata tämän tiedoston jollakin natiivilla sovelluksellamme?';

  @override
  String get shareCodeOpenAnotherAppCaption =>
      'Haluatko avata tämän tiedoston toisella laitteella?';

  @override
  String get shareCodeOpenInstallAppButtonLabel => 'Asenna Sovellus';

  @override
  String get shareCodeOpenShowCodeButtonLabel => 'Näytä Jakamiskoodi';

  @override
  String get changeMasterPasswordActionLabel => 'Vaihda Pääsalasana';

  @override
  String get changeMasterPasswordFormSubmit => 'Tallenna uudella salasanalla';

  @override
  String get changeMasterPasswordSuccess => 'Pääsalasanan tallennus onnistui.';

  @override
  String get changeMasterPasswordScreenTitle => 'Vaihda Pääsalasana';

  @override
  String get authPassCloudAuthClickedLink =>
      'Sain sähköpostiviestin ja kävin linkistä';

  @override
  String get authPassCloudAuthNotConfirmed =>
      'Sähköpostiosoitetta ei ole vielä vahvistettu. Varmista, että napsautat saamassasi sähköpostissa olevaa linkkiä ja vahvista sähköpostiosoitteesi ratkaisemalla captcha.';

  @override
  String get getHelpButton => 'Hanki apua foorumilla';

  @override
  String get shortcutCopyUsername => 'Kopioi Käyttäjänimi';

  @override
  String get shortcutCopyPassword => 'Kopioi Salasana';

  @override
  String get shortcutCopyTotp => 'Kopioi TOTP';

  @override
  String get shortcutMoveUp => 'Valitse edellinen salasana';

  @override
  String get shortcutMoveDown => 'Valitse seuraava salasana';

  @override
  String get shortcutGeneratePassword => 'Luo Salasana';

  @override
  String get shortcutCopyUrl => 'Kopioi URL-osoite';

  @override
  String get shortcutOpenUrl => 'Avaa URL-osoite';

  @override
  String get shortcutCancelSearch => 'Keskeytä Haku';

  @override
  String get shortcutShortcutHelp => 'Pikanäppäimen Ohje';

  @override
  String get shortcutHelpTitle => 'Pikanäppäimet';

  @override
  String unexpectedError(String error) {
    return 'Odottamaton virhe: $error';
  }

  @override
  String get googleDriveMorePermissionsRequired =>
      'Additional permissions needed to access Google Drive.';

  @override
  String get googleDriveRequestPermissionButtonLabel => 'Request Permissions';

  @override
  String get scanQrCodeTitle => 'Scan QR Code.';
}
