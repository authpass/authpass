// ignore_for_file: omit_local_variable_types,unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get fieldUserName => 'Pengguna';

  @override
  String get fieldPassword => 'Kata Sandi';

  @override
  String get fieldWebsite => 'Situs Web';

  @override
  String get fieldTitle => 'Judul';

  @override
  String get fieldTotp => 'Kata Sandi sekali pakai (Berbasis Waktu)';

  @override
  String get english => 'Inggris';

  @override
  String get german => 'Jerman';

  @override
  String get russian => 'Rusia';

  @override
  String get ukrainian => 'Ukraina';

  @override
  String get lithuanian => 'Lituania';

  @override
  String get french => 'Prancis';

  @override
  String get spanish => 'Spanyol';

  @override
  String get indonesian => 'Indonesia';

  @override
  String get turkish => 'Turki';

  @override
  String get hebrew => 'Ibrani';

  @override
  String get italian => 'italia';

  @override
  String get chineseSimplified => 'Cina (sederhana)';

  @override
  String get chineseTraditional => 'Cina (Tradisional)';

  @override
  String get portugueseBrazilian => 'Portugis, Brazil';

  @override
  String get slovak => 'Sovakia';

  @override
  String get dutch => 'Belanda';

  @override
  String get selectItem => 'Pilih';

  @override
  String get selectKeepassFile => 'AuthPass - Pilih file KeePass';

  @override
  String get selectKeepassFileLabel => 'Silahkan pilih file KeePass (.kdbx).';

  @override
  String get createNewFile => 'Pilih File Baru';

  @override
  String get openLocalFile => 'Buka\nFile Lokal';

  @override
  String get openFile => 'Buka File';

  @override
  String get loadFromDropdownMenu => 'Muat dari…';

  @override
  String get quickUnlockingFiles => 'Membuka file cepat …';

  @override
  String openFileProgress(Object fileName, Object current, Object totalCount) {
    return 'Membuka $fileName … ($current / $totalCount)';
  }

  @override
  String loadFrom(String cloudStorageName) {
    return 'Muat dari $cloudStorageName';
  }

  @override
  String get loadFromRemoteUrl => 'Buka kdbx dari URL';

  @override
  String get createNewKeepass =>
      'Pengguna baru di KeePass?\nBuat Database Kata Sandi Baru';

  @override
  String get labelLastOpenFiles => 'File terakhir dibuka:';

  @override
  String get noFilesHaveBeenOpenYet => 'Belum ada file yang dibuka.';

  @override
  String get preferenceSelectLanguage => 'Pilih Bahasa';

  @override
  String get preferenceLanguage => 'Bahasa';

  @override
  String get preferenceTextScaleFactor => 'Faktor Skala Teks';

  @override
  String get preferenceVisualDensity => 'Kepadatan Visual';

  @override
  String get preferenceTheme => 'Tema';

  @override
  String get preferenceThemeLight => 'Terang';

  @override
  String get preferenceThemeDark => 'Gelap';

  @override
  String get preferenceSystemDefault => 'Bawaan Sistem';

  @override
  String get preferenceDefault => 'Bawaan';

  @override
  String get lockAllFiles => 'Kunci Semua file terbuka';

  @override
  String get preferenceAllowScreenshots =>
      'Izinkan Menangkap Layar di aplikasi ini';

  @override
  String get preferenceEnableAutoFill => 'Izinkan Isi Otomatis';

  @override
  String get enableAutofillSuggestionBanner =>
      'You can you can fill field of other application by enabling autofill!';

  @override
  String get dismissAutofillSuggestionBannerButton => 'ABAIKAN';

  @override
  String get enableAutofillSuggestionBannerButton => 'AKTIFKAN!';

  @override
  String get preferenceAutoFillDescription =>
      'Hanya didukung di Android Oreo (8.0) atau keatas.';

  @override
  String get preferenceTitle => 'Preferensi';

  @override
  String get preferenceEnableSystemWideShortcuts =>
      'Enable system wide shortcuts';

  @override
  String get preferenceEnableSystemWideShortcutsHelp =>
      'Registers ctrl+alt+f as system wide shortcut to open search.';

  @override
  String get preferencesSearchFields => 'Customize Search fields';

  @override
  String get preferencesSearchFieldPromptTitle => 'Search fields';

  @override
  String get preferencesSearchFieldPromptLabel =>
      'Comma separated list of fields to use in the password list search.';

  @override
  String preferencesSearchFieldPromptHelp(
      Object wildCardCharacter, Object defaultSearchFields) {
    return 'Use $wildCardCharacter for all, leave empty for default ($defaultSearchFields)';
  }

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback => 'Kami menerima semua jenis masukan!';

  @override
  String get aboutLinkVisitWebsite => 'Jangan lupa cek situs web kami';

  @override
  String get aboutLinkGitHub => 'Dan proyek Open Source kami';

  @override
  String aboutLogFile(String logFilePath) {
    return 'File Log: $logFilePath';
  }

  @override
  String get aboutLinkContributors => 'Tampilkan Kontributor';

  @override
  String get unableToLaunchUrlTitle => 'Tidak dapat membuka alamat Url';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'Tidak dapat menjalankan $url: $openError';
  }

  @override
  String get unableToLaunchUrlNoHandler =>
      'Tidak ada aplikasi yang tersedia untuk alamat url tersebut.';

  @override
  String launchedUrl(Object url) {
    return 'URL yang dibuka: $url';
  }

  @override
  String get menuItemGeneratePassword => 'Penghasil Kata Sandi';

  @override
  String get menuItemPreferences => 'Preferensi';

  @override
  String get menuItemOpenAnotherFile => 'Buka File lain';

  @override
  String get menuItemCheckForUpdates => 'Cek pembaruan';

  @override
  String get menuItemSupport => 'Kirim logs';

  @override
  String get menuItemSupportSubtitle => 'Kirim logs lewat email';

  @override
  String get menuItemForum => 'Forum Dukungan';

  @override
  String get menuItemForumSubtitle => 'Report Problems and get help';

  @override
  String get menuItemHelp => 'Bantuan';

  @override
  String get menuItemHelpSubtitle => 'Tampilkan dokumentasi';

  @override
  String get menuItemAbout => 'Tentang';

  @override
  String get actionOpenUrl => 'Buka URL';

  @override
  String get passwordPlainText => 'Ungkap Kata Sandi';

  @override
  String get generatorPassword => 'Kata Sandi';

  @override
  String get generatePassword => 'Penghasil Kata Sandi';

  @override
  String get doneButtonLabel => 'Selesai';

  @override
  String get useAsDefault => 'Gunakan sebagai bawaan';

  @override
  String get characterSetLowerCase => 'Huruf Kecil (a-z)';

  @override
  String get characterSetUpperCase => 'Huruf besar (A-Z)';

  @override
  String get characterSetNumeric => 'Numerik (0-9)';

  @override
  String get characterSetUmlauts => 'Aksen (ä)';

  @override
  String get characterSetSpecial => 'Spesial (@%+)';

  @override
  String get length => 'Panjang';

  @override
  String get customLength => 'Panjang Khusus';

  @override
  String customLengthHelperText(Object customMinLength) {
    return 'Hanya digunakan untuk panjang > $customMinLength';
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
      other: '$numFilesString berkas tersimpan: $files',
      one: 'Satu berkas tersimpan: $files',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => 'Kelola Grup';

  @override
  String get lockFiles => 'Kunci File';

  @override
  String get searchHint => 'Cari';

  @override
  String get searchButtonLabel => 'Cari';

  @override
  String get filterButtonLabel => 'Saring berdasarkan grup';

  @override
  String get clear => 'Bersihkan';

  @override
  String get autofillFilterPrefix => 'Saring:';

  @override
  String get autofillPrompt => 'Pilih entri kata sandi untuk isi otomatis.';

  @override
  String get copiedToClipboard => 'Disalin ke papan klip.';

  @override
  String get noTitle => '(tanpa judul)';

  @override
  String get noUsername => '(Tanpa nama pengguna)';

  @override
  String get filterCustomize => 'Sesuaikan…';

  @override
  String get swipeCopyPassword => 'Salin Kata Sandi';

  @override
  String get swipeCopyUsername => 'Salin Nama Pengguna';

  @override
  String get copyUsernameNotExists => 'Entry has no username defined.';

  @override
  String get copyPasswordNotExists => 'Entry has no password defined.';

  @override
  String get doneCopiedPassword => 'Kata Sandi disalin ke papan klip.';

  @override
  String get doneCopiedUsername => 'Kata nama pengguna ke papan klip.';

  @override
  String get doneCopiedField => 'Disalin.';

  @override
  String copiedFieldToClipboard(Object fieldName) {
    return '$fieldName disalin.';
  }

  @override
  String copiedFieldEmpty(Object fieldName) {
    return '$fieldName kosong.';
  }

  @override
  String get emptyPasswordVaultPlaceholder =>
      'Anda belum memiliki kata sandi di database anda.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Buat Kata Sandi pertama anda';

  @override
  String get loading => 'Memuat';

  @override
  String get loadingFile => 'Memuat file…';

  @override
  String get internalFile => 'File internal';

  @override
  String get internalFileSubtitle =>
      'Database yang dibuat sebelumnya menggunakan AuthPass';

  @override
  String get filePicker => 'Pemilih file';

  @override
  String get filePickerSubtitle => 'Buka file dari perangkat.';

  @override
  String get credentialsAppBarTitle => 'Kredensial';

  @override
  String get credentialLabel => 'Masukkan kata sandi untuk:';

  @override
  String get masterPasswordInputLabel => 'Kata Sandi';

  @override
  String get masterPasswordEmptyValidator => 'Mohon masukkan kata sandi anda.';

  @override
  String get masterPasswordIncorrectValidator => 'Kata sandi salah';

  @override
  String get useKeyFile => 'Gunakan Kunci File';

  @override
  String get saveMasterPasswordBiometric =>
      'Simpan kata sandi dengan kunci biometri tersimpan?';

  @override
  String get close => 'Tutup';

  @override
  String get addNewPassword => 'Tambah kata sandi baru';

  @override
  String get errorOpenFileInvalidFileStructureTitle =>
      'Tried to open invalid file type';

  @override
  String errorOpenFileInvalidFileStructureBody(Object fileName) {
    return 'The file ($fileName) does not appear to be a valid KDBX file. Please either choose a valid KDBX file or create a new password database.';
  }

  @override
  String get errorOpenFileAlreadyOpenTitle => 'File telah terbuka';

  @override
  String errorOpenFileAlreadyOpenBody(
      Object databaseName, Object openFileSource, Object newFileSource) {
    return 'Database terpilih $databaseName telah terbuka dari $openFileSource (mencoba memuat dari$newFileSource)';
  }

  @override
  String get loadFromUrl => 'Unduh dari Url';

  @override
  String get loadFromUrlEnterUrl => 'Masukkan URL';

  @override
  String get loadFromUrlErrorEnterFullUrl =>
      'Please enter full url starting with http:// or https://';

  @override
  String get loadFromUrlErrorInvalidUrl => 'Please enter a valid url.';

  @override
  String get linuxAppArmorWarning =>
      'AuthPass requires permission to communicate with Secret Service to store credentials for cloud storage.\nPlease run the following command:';

  @override
  String get cancel => 'Batal';

  @override
  String get errorLoadFileFromSourceTitle => 'Galat saat membuka file.';

  @override
  String errorLoadFileFromSourceBody(Object source, Object error) {
    return 'Unable to open $source.\n$error';
  }

  @override
  String get errorUnlockFileTitle => 'Tidak dapat membuka file';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Kesalahan tidak diketahui saat mencoba membuka file. $error';
  }

  @override
  String get dialogContinue => 'Lanjutkan';

  @override
  String get dialogSendErrorReport => 'Kirim laporan galat';

  @override
  String get dialogReportErrorForum => 'Laporkaan galat di Forum/Bantuan';

  @override
  String get groupFilterDescription =>
      'Pilih grup yang akan ditampilkan (rekursif)';

  @override
  String get groupFilterSelectAll => 'Pilih semua';

  @override
  String get groupFilterDeselectAll => 'Hapus semua';

  @override
  String get createSubgroup => 'Buat Subgrup';

  @override
  String get editAction => 'Sunting';

  @override
  String get mailboxEnableLabel => '(re)enable';

  @override
  String get mailboxEnableHint => 'Continue receiving emails';

  @override
  String get mailboxDisableLabel => 'Nonaktifkan';

  @override
  String get mailboxDisableHint => 'Receive no more emails';

  @override
  String get mailListNoMail => 'You do not have any emails yet.';

  @override
  String mailboxLabelPrefixForEntry(Object entryLabel) {
    return 'Entri: $entryLabel';
  }

  @override
  String mailboxLabelPrefixUnknownEntry(Object entryUuid) {
    return 'Entri tidak diketahui: $entryUuid';
  }

  @override
  String mailboxLabelPrefixCreatedAt(Object dateTime) {
    return 'Dibuat pada: $dateTime';
  }

  @override
  String get masterPasswordDescription =>
      'The master password is used to securely encrypt your password database. Make sure to remember it, it can not be restored.';

  @override
  String get unsavedChangesWarningTitle => 'Perubahan belum disimpan';

  @override
  String get unsavedChangesWarningBody =>
      'There are still unsaved changes. Do you want to discard changes?';

  @override
  String get unsavedChangesDiscardActionLabel => 'Batalkan perubahan';

  @override
  String get deletePermanentlyAction => 'Hapus Permanen';

  @override
  String get restoreFromRecycleBinAction => 'Pulihkan';

  @override
  String get deleteAction => 'Hapus';

  @override
  String get deletedEntry => 'Hapus entri.';

  @override
  String get successfullyDeletedGroup => 'Grup terhapus.';

  @override
  String get undoButtonLabel => 'Batalkan';

  @override
  String get saveButtonLabel => 'Simpan';

  @override
  String get webDavSettings => 'Pengaturan WebDAV';

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
  String get webDavAuthUser => 'Nama pengguna';

  @override
  String get webDavAuthPassword => 'Kata Sandi';

  @override
  String get mergeSuccessDialogTitle => 'Successfully merged password database';

  @override
  String mergeSuccessDialogMessage(Object fileName, Object mergeSummary) {
    return 'Conflict detected while saving $fileName, it was merged successfully with the remote file: \n\n$mergeSummary';
  }

  @override
  String forDetailsVisitUrl(Object url) {
    return 'Informasi lebih lanjut kunjungi $url';
  }

  @override
  String get authPassCloudAuthEmailInputLabel =>
      'Enter email address to register or sign in.';

  @override
  String get authPassCloudAuthEmailInvalid =>
      'Harap masukkan alamat email yang valid.';

  @override
  String get authPassCloudAuthConfirmEmailButtonLabel => 'Konfirmasi alamat';

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
      'Minta tautan konfirmasi baru';

  @override
  String permanentlyDeleteEntryConfirm(Object title) {
    return 'This will permanently delete the password entry $title. This can not be undone. Do you want to continue?';
  }

  @override
  String get permanentlyDeletedEntrySnackBar => 'Entri dihapus permanen.';

  @override
  String get initialNewGroupName => 'Grup baru';

  @override
  String get deleteGroupErrorTitle => 'Tidak dapat menghapus grup';

  @override
  String get deleteGroupErrorBodyContainsGroup =>
      'Grup ini masih berisi grup lain. Anda hanya dapat menghapus grup kosong.';

  @override
  String get deleteGroupErrorBodyContainsEntries =>
      'Grup ini masih berisi entri kata sandi. Anda hanya dapat menghapus grup kosong.';

  @override
  String get groupListAppBarTitle => 'Grup';

  @override
  String get groupListFilterAppbarTitle => 'Saring berdasarkan grup';

  @override
  String get clearQuickUnlock => 'Hapus Penyimpanan biometrik';

  @override
  String get clearQuickUnlockSubtitle =>
      'Hapus kata sandi utama yang tersimpan';

  @override
  String get unlock => 'Buka file';

  @override
  String get closePasswordFiles => 'tutup file kata sandi';

  @override
  String get clearQuickUnlockSuccess =>
      'Hapus Kata Sandi utama yang tersimpan dari penyimpanan biometrik.';

  @override
  String get diacOptIn => 'Ikut program tentang berita aplikasi dan survei.';

  @override
  String get diacOptInSubtitle =>
      'Akan sesekali mengirim permintaan ke internet untuk memperoleh berita.';

  @override
  String get enableAutofillDebug => 'Isi otomatis: Hidupkan debug';

  @override
  String get enableAutofillDebugSubtitle =>
      'Menunjukkan hamparan informasi untuk semua kolom masukan';

  @override
  String get createPasswordDatabase => 'Buat Database Kata Sandi';

  @override
  String get nameNewPasswordDatabase => 'Nama Database baru anda';

  @override
  String get validatorNameMissing =>
      'Mohon beri nama pada database baru kata sandi anda.';

  @override
  String get masterPasswordHelpText =>
      'Buatlah master Kata Sandi anda. Pastikan anda mengingatnya.';

  @override
  String get inputMasterPasswordText => 'Master Kata Sandi';

  @override
  String get masterPasswordMissingCreate =>
      'Mohon masukkan kata sandi yang aman dan mudah anda diingat.';

  @override
  String get createDatabaseAction => 'Buat Database';

  @override
  String get databaseExistsError => 'File Sudah Ada';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'Kesalahan saat mencoba membuat database pada $filePath. File sudah ada. Mohon pilih nama lain untuk database anda.';
  }

  @override
  String get databaseCreateDefaultName => 'KataSandiPribadi';

  @override
  String get preferenceDynamicLoadIcons => 'Muat ikon secara Otomatis';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'Akan membuat permintaan http dari kolom nilai $urlFieldName untuk memuat ikon situs web.';
  }

  @override
  String passwordScore(Object score) {
    return 'Skor Keamanan: $score dari 4';
  }

  @override
  String get entryInfoFile => 'File:';

  @override
  String get entryInfoGroup => 'Grup:';

  @override
  String get entryInfoLastModified => 'Terakhir di ubah:';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'Entri dipindah ke $groupName';
  }

  @override
  String sizeBytesStoredAuthPassCloud(Object count) {
    return '$count bytes, stored on AuthPass Cloud';
  }

  @override
  String sizeBytes(Object count) {
    return '$count bita';
  }

  @override
  String get entryAddAttachment => 'Tambah Lampiran';

  @override
  String get entryAttachmentSizeWarning =>
      'File yang dilampirkan akan disematkan dalam file kata sandi. Ini dapat meningkatkan waktu yang dibutuhkan untuk membuka/menyimpan kata sandi.';

  @override
  String get iconPngSizeWarning =>
      'Ikon kustom akan disematkan dalam berkas kata sandi. Ini dapat meningkatkan waktu yang dibutuhkan untuk membuka/menyimpan kata sandi.';

  @override
  String get notPngError => 'Berkas yang dipilih bukan sebuah berkas PNG.';

  @override
  String get entryAddField => 'Tambah Kolom Baru';

  @override
  String get entryCustomField => 'Kolom Khusus';

  @override
  String get entryCustomFieldTitle => 'Menambahkan kolom khusus baru';

  @override
  String get entryCustomFieldInputLabel =>
      'Masukkan nama untuk kolom khusus anda';

  @override
  String get swipeCopyField => 'Salin Kolom';

  @override
  String get fieldRename => 'Ubah nama';

  @override
  String get fieldGeneratePassword => 'Hasilkan Kata Sandi …';

  @override
  String get fieldProtect => 'Sembunyikan nilai masukan';

  @override
  String get fieldUnprotect => 'Sembunyikan Nilai Entri';

  @override
  String get fieldPresent => 'Kode QR';

  @override
  String get fieldGenerateEmail => 'Penghasil Email';

  @override
  String get onboardingBackToOnboarding => 'Tur';

  @override
  String get onboardingBackToOnboardingSubtitle =>
      'Menghidupkan kembali pengalaman pertama. 😅️';

  @override
  String get onboardingHeadline => 'Ayo buat Kata Sandi anda Aman!';

  @override
  String get onboardingQuestion =>
      'Pernahkah anda menggunakan pengelola kata sandi lain sebelumnya?';

  @override
  String get onboardingYesOpenPasswords => 'Ya, buka Kata Sandi tersimpan';

  @override
  String get onboardingNoCreate => 'Saya pengguna baru, bantu saya!';

  @override
  String get backupButton => 'SIMPAN KE CLOUD';

  @override
  String get dismissBackupButton => 'ABAIKAN';

  @override
  String backupWarningMessage(Object databasename) {
    return 'Kata sandi Anda dalam $databasename hanya disimpan secara lokal!';
  }

  @override
  String get saveAs => 'Simpan Dalam...';

  @override
  String get saving => 'Menyimpan';

  @override
  String get increaseValue => 'Tambah';

  @override
  String get decreaseValue => 'Kurangi';

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
  String get cloudStorageLogInCode => 'Masukkan kode';

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
  String get cloudStorageAuthCodeLabel => 'Kode Otentikasi';

  @override
  String get cloudStorageAuthErrorTitle => 'Galat ketika mengotentikasi';

  @override
  String cloudStorageAuthErrorMessage(
      Object cloudStorageName, Object errorMessage) {
    return 'Error while trying to authenticate to $cloudStorageName: $errorMessage';
  }

  @override
  String get cloudStorageSearchBoxLabel => 'Cari Kueri';

  @override
  String cloudStorageItemsInFolder(Object itemCount) {
    return '$itemCount item di folder ini.';
  }

  @override
  String get mailSubject => 'Subjek';

  @override
  String get mailFrom => 'Dari';

  @override
  String get mailDate => 'Tanggal';

  @override
  String get mailMailbox => 'Kotak surat';

  @override
  String get mailNoData => 'Tidak ada Data';

  @override
  String get mailMailboxesTitle => 'Kotak surat';

  @override
  String get mailboxCreateButtonLabel => 'Buat';

  @override
  String get mailboxNameInputDialogTitle => 'Optionally label for new mailbox';

  @override
  String get mailboxNameInputLabel => 'Label (Internal)';

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
  String get errorWhileSavingTitle => 'Galat ketika menyimpan';

  @override
  String errorWhileSavingBody(Object errorMessage) {
    return 'Tidak dapat menyimpan file: $errorMessage';
  }

  @override
  String get databaseDoesNotSupportSaving =>
      'Sorry this database does not support saving. Please open a local database file. Or use \"Save As\".';

  @override
  String get otpInvalidKeyTitle => 'Kunci tidak valid';

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
  String get otpCopySecretActionLabel => 'Salin rahasia';

  @override
  String get otpEntryLabel => 'Token sekali pakai';

  @override
  String get entryFieldProtected => 'Protected field. Click to reveal.';

  @override
  String get entryFieldActionRevealField => 'Tampilkan bidang yang dilindungi';

  @override
  String get entryAttachmentOpenActionLabel => 'Buka';

  @override
  String get entryAttachmentShareActionLabel => 'Bagikan';

  @override
  String get entryAttachmentShareSubject => 'Lampiran';

  @override
  String get entryAttachmentSaveActionLabel => 'Simpan ke perangkat';

  @override
  String get entryAttachmentRemoveActionLabel => 'Hapus';

  @override
  String entryAttachmentRemoveConfirm(Object attachmentLabel) {
    return 'Do you really want to delete $attachmentLabel?';
  }

  @override
  String get entryRenameFieldPromptTitle => 'Ubah nama bidang';

  @override
  String get removerecentfile => 'Hide';

  @override
  String get entryRenameFieldPromptLabel => 'Enter the new name for the field';

  @override
  String get promptDialogPasteActionTooltip => 'Tempel dari papan klip';

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
  String get saveAsEntryLocalFile => 'File lokal';

  @override
  String get fileTypePngs => 'Gambar (png)';

  @override
  String get selectIconDialogAction => 'PILIH IKON';

  @override
  String get retryDialogActionLabel => 'COBA LAGI';

  @override
  String errorDuringNetworkCall(Object errorMessage) {
    return 'Galat saat memanggil api. $errorMessage';
  }

  @override
  String get passwordFilterHideDeleted => 'Sembunyikan entri yang dihapus';

  @override
  String get passwordFilterOnlyDeleted => 'Entri yang dihapus';

  @override
  String passwordFilterPrefixForOneGroup(Object groupName) {
    return 'Grup: $groupName';
  }

  @override
  String passwordFilterPrefixForMultipleGroups(Object groupCount) {
    return 'Filter kustom ($groupCount Grup)';
  }

  @override
  String get menuItemAuthPassCloudAuthenticate =>
      'Otentikasi dengan AuthPass Cloud';

  @override
  String get menuItemAuthPassCloudMailboxes => 'AuthPass Mailboxes';

  @override
  String changesWithoutSaving(Object fileName) {
    return 'You have changes in \"$fileName\", which does not support writing of changes.';
  }

  @override
  String get changesSaveLocally => 'Simpan secara lokal';

  @override
  String get clearColor => 'Hapus Warna';

  @override
  String get databaseRenameInputLabel => 'Masukkan nama basisdata';

  @override
  String get databasePath => 'Jalur';

  @override
  String get databaseColor => 'Warna';

  @override
  String get databaseColorChoose => 'Pilih warna untuk membedakan file.';

  @override
  String get databaseKdbxVersion => 'Versi file KDBX';

  @override
  String databaseKdbxUpgradeVersion(Object versionName) {
    return 'Perbarui ke $versionName';
  }

  @override
  String get databaseKdbxUpgradeSuccessful =>
      'File berhasil diperbarui dan disimpan.';

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
  String get closeAndLockFile => 'Tutup/Kunci';

  @override
  String get authPassHomeScreenTagline =>
      'pengelola kata sandi, open source, tersedia di berbagai platform.';

  @override
  String get addNewPasswordButtonLabel => 'Tambah kata sandi baru';

  @override
  String get unnamedEntryPlaceholder => '(belum dinamai)';

  @override
  String get unnamedGroupPlaceholder => '(belum dinamai)';

  @override
  String get unnamedFilePlaceholder => '(belum dinamai)';

  @override
  String get editGroupScreenTitle => 'Sunting grup';

  @override
  String get editGroupGroupNameLabel => 'Nama grup';

  @override
  String get files => 'Berkas';

  @override
  String get newGroupDialogTitle => 'Grup baru';

  @override
  String get newGroupDialogInputLabel => 'Nama untuk grup baru';

  @override
  String get groupActionShowPasswords => 'Tampilkan kata sandi';

  @override
  String get groupActionDelete => 'Hapus';

  @override
  String get logoutTooltip => 'Keluar';

  @override
  String get successfullyDeletedFileCloudStorage => 'File berhasil dihapus.';

  @override
  String shareDialogTitle(Object fileName) {
    return 'Opsi berbagi untuk $fileName';
  }

  @override
  String get shareFileActionLabel => 'Bagikan …';

  @override
  String get shareTokenListEmptyScreenPlaceholder =>
      'Belum ada file yang dibagikan.';

  @override
  String get shareTokenNoLabel => 'Tidak ada label/deskripsi';

  @override
  String get shareTokenReadWrite => 'Baca/Tulis';

  @override
  String get shareTokenReadOnly => 'Baca saja';

  @override
  String get shareCreateTokenDialogTitle => 'Bagikan file';

  @override
  String get shareCreateTokenReadOnly => 'Baca saja';

  @override
  String get shareCreateTokenReadOnlyHelpText =>
      'Jangan perbolehkan menyimpan perubahan';

  @override
  String get shareCreateTokenLabelText => 'Deskripsi';

  @override
  String get shareCreateTokenLabelHint => 'Bagikan ke teman';

  @override
  String get shareCreateTokenLabelHelp =>
      'Label opsional untuk membedakan share code.';

  @override
  String get shareCreateTokenSuccess => 'Share Code berhasil dibuat.';

  @override
  String get sharePresentDialogTitle =>
      'Bagikan file dengan share code rahasia';

  @override
  String get sharePresentDialogHelp =>
      'Using the following share code users can access the password file. They will need the password and/or key file to open it.';

  @override
  String get sharePresentToken => 'Bagikan kode';

  @override
  String get sharePresentCopied => 'Share code disalin ke papan klip.';

  @override
  String get authPassCloudOpenWithShareCodeTooltip => 'Buka dengan share code';

  @override
  String get authPassCloudShareFileActionLabel => 'Bagikan';

  @override
  String get preferenceAuthPassCloudAttachmentTitle =>
      'Use AuthPass Cloud Attachments';

  @override
  String get preferenceAuthPassCloudAttachmentSubtitle =>
      'Store Attachments encrypted on AuthPass Cloud separately.';

  @override
  String get shareCodeInputDialogTitle => 'Masukkan share code rahasia';

  @override
  String get shareCodeInputDialogScan => 'Pindai Kode QR';

  @override
  String get shareCodeInputLabel => 'Bagikan Kode Rahasia';

  @override
  String get shareCodeInputHelperText =>
      'Jika anda memiliki share code, silakan tempel di atas.';

  @override
  String get shareCodeOpen => 'Terima Share Code untuk AuthPass Cloud?';

  @override
  String get shareCodeOpenScreenTitle => 'Memuat file dengan share code';

  @override
  String get shareCodeLoadingProgress => 'Memuat file…';

  @override
  String get shareCodeOpenFileButtonLabel => 'BUKA';

  @override
  String get shareCodeOpenInstallAppCaption =>
      'Buka file ini dengan aplikasi kami?';

  @override
  String get shareCodeOpenAnotherAppCaption =>
      'Buka file ini di perangkat lain?';

  @override
  String get shareCodeOpenInstallAppButtonLabel => 'Pasang aplikasi';

  @override
  String get shareCodeOpenShowCodeButtonLabel => 'Tampilkan Kode Berbagi';

  @override
  String get changeMasterPasswordActionLabel => 'Ganti kata sandi utama';

  @override
  String get changeMasterPasswordFormSubmit => 'Simpan dengan kata sandi baru';

  @override
  String get changeMasterPasswordSuccess =>
      'Kata sandi utama berhasil disimpan.';

  @override
  String get changeMasterPasswordScreenTitle => 'Ganti kata sandi utama';

  @override
  String get authPassCloudAuthClickedLink =>
      'I received email and visited link';

  @override
  String get authPassCloudAuthNotConfirmed =>
      'Email address was not yet confirmed. Make sure to click the link in the email you received and solve the captcha to confirm your email address.';

  @override
  String get getHelpButton => 'Get help in the forum';

  @override
  String get shortcutCopyUsername => 'Salin Nama Pengguna';

  @override
  String get shortcutCopyPassword => 'Salin Kata Sandi';

  @override
  String get shortcutCopyTotp => 'Copy TOTP';

  @override
  String get shortcutMoveUp => 'Select the previous password';

  @override
  String get shortcutMoveDown => 'Select the next password';

  @override
  String get shortcutGeneratePassword => 'Penghasil Kata Sandi';

  @override
  String get shortcutCopyUrl => 'Copy URL';

  @override
  String get shortcutOpenUrl => 'Buka URL';

  @override
  String get shortcutCancelSearch => 'Cancel Search';

  @override
  String get shortcutShortcutHelp => 'Keyboard Shortcut Help';

  @override
  String get shortcutHelpTitle => 'Keyboard Shortcuts';

  @override
  String unexpectedError(String error) {
    return 'Kesalahan tak terduga: $error';
  }

  @override
  String get googleDriveMorePermissionsRequired =>
      'Additional permissions needed to access Google Drive.';

  @override
  String get googleDriveRequestPermissionButtonLabel => 'Request Permissions';

  @override
  String get scanQrCodeTitle => 'Scan QR Code.';
}
