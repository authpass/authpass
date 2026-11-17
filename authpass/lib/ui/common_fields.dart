import 'package:authpass/l10n-generated/app_localizations.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:kdbx/kdbx.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

class CommonField {
  CommonField({
    required this.key,
    required this.displayName,
    this.includeInSearch = false,
    this.protect = false,
    this.keyboardType,
    this.autocorrect = false,
    this.enableSuggestions = false,
    this.textCapitalization = TextCapitalization.none,
    this.icon = Icons.label_outline,
    this.showByDefault = true,
    this.legacy = false,
  });

  final KdbxKey key;
  final String displayName;
  final bool includeInSearch;
  final bool protect;
  final TextInputType? keyboardType;
  final bool autocorrect;
  final bool enableSuggestions;
  final TextCapitalization textCapitalization;
  final IconData icon;
  final bool showByDefault;

  /// Field which is still read and displayed if an entry contains it, but is
  /// not offered when adding a new field (a newer field replaced it).
  final bool legacy;

  String? stringValue(KdbxEntry entry) => entry.getString(key)?.getText();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommonField &&
          runtimeType == other.runtimeType &&
          key == other.key;

  @override
  int get hashCode => key.hashCode;
}

class CommonFields {
  CommonFields(AppLocalizations loc)
    : fields = [
        CommonField(
          key: KdbxKeyCommon.TITLE,
          displayName: loc.fieldTitle,
          includeInSearch: true,
          icon: Icons.label,
          autocorrect: true,
          enableSuggestions: true,
          textCapitalization: TextCapitalization.sentences,
        ),
        CommonField(
          key: KdbxKeyCommon.URL,
          displayName: loc.fieldWebsite,
          includeInSearch: true,
          keyboardType: TextInputType.url,
          icon: Icons.link,
        ),
        CommonField(
          key: KdbxKeyCommon.USER_NAME,
          displayName: loc.fieldUserName,
          includeInSearch: true,
          keyboardType: TextInputType.emailAddress,
          icon: Icons.account_circle,
        ),
        CommonField(
          key: KdbxKeyCommon.PASSWORD,
          displayName: loc.fieldPassword,
          protect: true,
          keyboardType: TextInputType.visiblePassword,
          icon: Icons.lock,
        ),
        CommonField(
          key: KdbxKey(_otpKey),
          displayName: loc.fieldTotp,
          icon: Icons.watch_later,
          protect: true,
          showByDefault: false,
        ),
        CommonField(
          key: KdbxKeyCommon.OTP,
          displayName: loc.fieldTotp,
          icon: Icons.watch_later,
          protect: true,
          showByDefault: false,
          legacy: true,
        ),
      ] {
    assert(fields.map((f) => f.key).toSet().length == fields.length);
  }

  static final defaultSearchFields = {
    KdbxKeyCommon.TITLE,
    KdbxKeyCommon.URL,
    KdbxKeyCommon.USER_NAME,
  };

  CommonField get title => _fieldByKey(KdbxKeyCommon.TITLE);

  CommonField get url => _fieldByKey(KdbxKeyCommon.URL);

  CommonField get userName => _fieldByKey(KdbxKeyCommon.USER_NAME);

  CommonField get password => _fieldByKey(KdbxKeyCommon.PASSWORD);

  /// Standard attribute for TOTP, shared with KeePassXC and others. This is
  /// what newly added TOTP fields are stored in. The content is an
  /// otpauth:// url, modeled after
  /// https://github.com/google/google-authenticator/blob/master/mobile/ios/README
  /// otpauth://TYPE/LABEL?PARAMETERS
  CommonField get otp => _fieldByKeyString(_otpKey);

  /// Attribute AuthPass used before it adopted [otp] (see issue #393).
  /// Same content as [otp]. Existing entries keep working, but new fields are
  /// never written to it, and existing fields are never renamed.
  ///
  /// If an entry has both, both are listed, and copying the TOTP code
  /// prefers [otp].
  CommonField get otpAuthLegacy => _fieldByKey(KdbxKeyCommon.OTP);

  /// Stores the otpauth:// [url] in the standard [otp] field of [entry] and
  /// drops a legacy field, so re-adding TOTP replaces (and migrates) the old
  /// secret instead of leaving a second, stale TOTP field behind.
  void setTotp(KdbxEntry entry, String url) {
    entry.setString(otp.key, ProtectedValue.fromString(url));
    entry.removeString(otpAuthLegacy.key);
  }

  /// compatibility field to look OTP token for, used by TrayTOTP
  /// Contains a base32 encoded secret, parameters are stored in
  /// `TOTP Settings` [otpAuthCompat1Settings].
  CommonField otpAuthCompat1 = _internalCommonField('TOTP Seed');
  CommonField otpAuthCompat1Settings = _internalCommonField('TOTP Settings');

  @NonNls
  static const _otpKey = 'otp';

  final List<CommonField> fields;

  bool isCommon(
    KdbxKey key,
  ) => //fields.firstWhere((f) => f.key == key, orElse: () => null) != null;
      this[key] != null;

  bool isTotp(KdbxKey key) =>
      [otp, otpAuthLegacy, otpAuthCompat1].map((e) => e.key).contains(key);

  CommonField? operator [](KdbxKey key) =>
      fields.firstWhereOrNull((f) => f.key == key);

  CommonField _fieldByKeyString(@NonNls String key) =>
      _fieldByKey(KdbxKey(key));

  CommonField _fieldByKey(KdbxKey key) =>
      fields.firstWhere((f) => f.key == key);

  static CommonField _internalCommonField(@NonNls String key) =>
      CommonField(key: KdbxKey(key), displayName: key);
}
