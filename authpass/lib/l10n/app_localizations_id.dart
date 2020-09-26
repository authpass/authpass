// ignore_for_file: omit_local_variable_types,unused_local_variable
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get fieldUserName => 'Nama Pengguna';

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
  String get selectKeepassFile => 'AuthPass - Pilih file KeePass';

  @override
  String get quickUnlockingFiles => 'Buka cepat file';

  @override
  String get selectKeepassFileLabel => 'Silahkan pilih file KeePass (.kdbx).';

  @override
  String get createNewFile => 'Pilih File Baru';

  @override
  String get openLocalFile => 'Buka\nFile Lokal';

  @override
  String get openFile => 'Buka File';

  @override
  String loadFrom(String cloudStorageName) {
    return 'Muat dari ${cloudStorageName}';
  }

  @override
  String get loadFromUrl => 'Download dari URL';

  @override
  String get loadFromRemoteUrl => 'Buka kdbx dari URL';

  @override
  String get createNewKeepass => 'Pengguna baru di KeePass?\nBuat Database Kata Sandi Baru';

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
  String get preferenceAllowScreenshots => 'Izinkan Menangkap Layar di aplikasi ini';

  @override
  String get preferenceEnableAutoFill => 'Izinkan Isi Otomatis';

  @override
  String get preferenceAutoFillDescription => 'Hanya didukung di Android Oreo (8.0) atau keatas.';

  @override
  String get preferenceTitle => 'Preferensi';

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
    return 'File Log: ${logFilePath}';
  }

  @override
  String get unableToLaunchUrlTitle => 'Unable to open Url';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return 'Unable to launch ${url}: ${openError}';
  }

  @override
  String get unableToLaunchUrlNoHandler => 'No application available for url.';

  @override
  String launchedUrl(Object url) {
    return 'Opened URL: ${url}';
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
  String get menuItemSupport => 'Dukungan Email';

  @override
  String get menuItemSupportSubtitle => 'Mengirim log melalui email / minta bantuan';

  @override
  String get menuItemHelp => 'Bantuan';

  @override
  String get menuItemHelpSubtitle => 'Tampilkan dokumentasi';

  @override
  String get menuItemAbout => 'Tentang';

  @override
  String get actionOpenUrl => 'Open URL';

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
    return 'Hanya digunakan untuk panjang > ${customMinLength}';
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
      other: '${numFiles} file tersimpan: ${files}',
    );
  }

  @override
  String get manageGroups => 'Kelola Grup';

  @override
  String get lockFiles => 'Kunci File';

  @override
  String get searchHint => 'Cari';

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
  String get doneCopiedPassword => 'Kata Sandi disalin ke papan klip.';

  @override
  String get doneCopiedUsername => 'Kata nama pengguna ke papan klip.';

  @override
  String get doneCopiedField => 'Disalin.';

  @override
  String get emptyPasswordVaultPlaceholder => 'Anda belum memiliki kata sandi di database anda.';

  @override
  String get emptyPasswordVaultButtonLabel => 'Buat Kata Sandi pertama anda';

  @override
  String get loadingFile => 'Memuat file…';

  @override
  String get internalFile => 'File internal';

  @override
  String get internalFileSubtitle => 'Database yang dibuat sebelumnya menggunakan AuthPass';

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
  String get saveMasterPasswordBiometric => 'Simpan kata sandi dengan kunci biometri tersimpan?';

  @override
  String get errorOpenFileAlreadyOpenTitle => 'File telah terbuka';

  @override
  String errorOpenFileAlreadyOpenBody(Object databaseName, Object openFileSource, Object newFileSource) {
    return 'Database terpilih ${databaseName} telah terbuka dari ${openFileSource} (mencoba memuat dari${newFileSource})';
  }

  @override
  String get errorUnlockFileTitle => 'Tidak dapat membuka file';

  @override
  String errorUnlockFileBody(Object error) {
    return 'Kesalahan tidak diketahui saat mencoba membuka file. ${error}';
  }

  @override
  String get dialogContinue => 'Lanjutkan';

  @override
  String get dialogSendErrorReport => 'Kirimkan Laporan Kesalahan / Bantuan';

  @override
  String get groupFilterDescription => 'Pilih grup yang akan ditampilkan (rekursif)';

  @override
  String get groupFilterSelectAll => 'Pilih semua';

  @override
  String get groupFilterDeselectAll => 'Hapus semua';

  @override
  String get createSubgroup => 'Buat Subgrup';

  @override
  String get editAction => 'Sunting';

  @override
  String get deleteAction => 'Hapus';

  @override
  String get successfullyDeletedGroup => 'Grup terhapus.';

  @override
  String get undoButtonLabel => 'Batalkan';

  @override
  String get saveButtonLabel => 'Simpan';

  @override
  String get initialNewGroupName => 'Grup baru';

  @override
  String get deleteGroupErrorTitle => 'Tidak dapat menghapus grup';

  @override
  String get deleteGroupErrorBodyContainsGroup => 'Grup ini masih berisi grup lain. Anda hanya dapat menghapus grup kosong.';

  @override
  String get deleteGroupErrorBodyContainsEntries => 'Grup ini masih berisi entri kata sandi. Anda hanya dapat menghapus grup kosong.';

  @override
  String get groupListAppBarTitle => 'Grup';

  @override
  String get groupListFilterAppbarTitle => 'Saring berdasarkan grup';

  @override
  String get clearQuickUnlock => 'Hapus Penyimpanan biometrik';

  @override
  String get clearQuickUnlockSubtitle => 'Hapus kata sandi utama yang tersimpan';

  @override
  String get unlock => 'Buka file';

  @override
  String get closePasswordFiles => 'tutup file kata sandi';

  @override
  String get clearQuickUnlockSuccess => 'Hapus Kata Sandi utama yang tersimpan dari penyimpanan biometrik.';

  @override
  String get diacOptIn => 'Ikut program tentang berita aplikasi dan survei.';

  @override
  String get diacOptInSubtitle => 'Akan sesekali mengirim permintaan ke internet untuk memperoleh berita.';

  @override
  String get enableAutofillDebug => 'Isi otomatis: Hidupkan debug';

  @override
  String get enableAutofillDebugSubtitle => 'Menunjukkan hamparan informasi untuk semua kolom masukan';

  @override
  String get createPasswordDatabase => 'Buat Database Kata Sandi';

  @override
  String get nameNewPasswordDatabase => 'Nama Database baru anda';

  @override
  String get validatorNameMissing => 'Mohon beri nama pada database baru kata sandi anda.';

  @override
  String get masterPasswordHelpText => 'Buatlah master Kata Sandi anda. Pastikan anda mengingatnya.';

  @override
  String get inputMasterPasswordText => 'Master Kata Sandi';

  @override
  String get masterPasswordMissingCreate => 'Mohon masukkan kata sandi yang aman dan mudah anda diingat.';

  @override
  String get createDatabaseAction => 'Buat Database';

  @override
  String get databaseExistsError => 'File Sudah Ada';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return 'Kesalahan saat mencoba membuat database pada ${filePath}. File sudah ada. Mohon pilih nama lain untuk database anda.';
  }

  @override
  String get databaseCreateDefaultName => 'KataSandiPribadi';

  @override
  String get preferenceDynamicLoadIcons => 'Muat ikon secara Otomatis';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return 'Akan membuat permintaan http dari kolom nilai ${urlFieldName} untuk memuat ikon situs web.';
  }

  @override
  String passwordScore(Object score) {
    return 'Skor Keamanan: ${score} dari 4';
  }

  @override
  String get entryInfoFile => 'File:';

  @override
  String get entryInfoGroup => 'Grup:';

  @override
  String get entryInfoLastModified => 'Terakhir di ubah:';

  @override
  String movedEntryToGroup(Object groupName) {
    return 'Entri dipindah ke ${groupName}';
  }

  @override
  String sizeBytes(Object bytes) {
    return '{count} bita';
  }

  @override
  String get entryAddAttachment => 'Tambah Lampiran';

  @override
  String get entryAttachmentSizeWarning => 'File yang dilampirkan akan disematkan dalam file kata sandi. Ini dapat meningkatkan waktu yang dibutuhkan untuk membuka/menyimpan kata sandi.';

  @override
  String get entryAddField => 'Tambah Kolom Baru';

  @override
  String get entryCustomField => 'Kolom Khusus';

  @override
  String get entryCustomFieldTitle => 'Menambahkan kolom khusus baru';

  @override
  String get entryCustomFieldInputLabel => 'Masukkan nama untuk kolom khusus anda';

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
  String get onboardingBackToOnboardingSubtitle => 'Menghidupkan kembali pengalaman pertama. 😅️';

  @override
  String get onboardingHeadline => 'Ayo buat Kata Sandi anda Aman!';

  @override
  String get onboardingQuestion => 'Pernahkah anda menggunakan pengelola kata sandi lain sebelumnya?';

  @override
  String get onboardingYesOpenPasswords => 'Ya, buka Kata Sandi tersimpan';

  @override
  String get onboardingNoCreate => 'Saya pengguna baru, bantu saya!';

  @override
  String unexpectedError(String error) {
    return 'Kesalahan tak terduga: ${error}';
  }
}
