import 'package:authpass/ui/l10n/AuthPassLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kdbx/kdbx.dart';
import 'package:meta/meta.dart';

class CommonField {
  CommonField({
    @required String key,
    @required this.displayName,
    this.includeInSearch = false,
    this.protect = false,
    this.keyboardType,
    this.icon = Icons.label_outline,
    this.showByDefault = true,
  }) : key = KdbxKey(key);

  final KdbxKey key;
  final String displayName;
  final bool includeInSearch;
  final bool protect;
  final TextInputType keyboardType;
  final IconData icon;
  final bool showByDefault;

  String stringValue(KdbxEntry entry) => entry.getString(key)?.getText();

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
  CommonFields(AuthPassLocalizations loc)
      : fields = [
          CommonField(
            key: 'Title',
            displayName: loc.fieldTitle,
            includeInSearch: true,
            icon: Icons.label,
          ),
          CommonField(
            key: 'UserName',
            displayName: loc.fieldUserName,
            includeInSearch: true,
            keyboardType: TextInputType.emailAddress,
            icon: Icons.account_circle,
          ),
          CommonField(
            key: 'Password',
            displayName: loc.fieldPassword,
            protect: true,
            icon: Icons.lock,
          ),
          CommonField(
            key: 'URL',
            displayName: loc.fieldWebsite,
            includeInSearch: true,
            keyboardType: TextInputType.url,
            icon: Icons.link,
          ),
          CommonField(
            key: 'OTPAuth',
            displayName: 'One Time Password (Time Based)',
            icon: Icons.watch_later,
            protect: true,
            showByDefault: false,
          )
        ] {
    assert(fields.map((f) => f.key).toSet().length == fields.length);
  }

  CommonField get title => _fieldByKeyString('Title');

  CommonField get url => _fieldByKeyString('URL');

  CommonField get userName => _fieldByKeyString('UserName');

  CommonField get password => _fieldByKeyString('Password');

  /// Secret for TOTP -- content is modeled after
  /// https://github.com/google/google-authenticator/blob/master/mobile/ios/README
  /// otpauth://TYPE/LABEL?PARAMETERS
  CommonField get otpAuth => _fieldByKeyString('OTPAuth');

  final List<CommonField> fields;

  bool isCommon(
          KdbxKey
              key) => //fields.firstWhere((f) => f.key == key, orElse: () => null) != null;
      this[key] != null;

  CommonField operator [](KdbxKey key) =>
      fields.firstWhere((f) => f.key == key, orElse: () => null);

  CommonField _fieldByKeyString(String key) => _fieldByKey(KdbxKey(key));

  CommonField _fieldByKey(KdbxKey key) =>
      fields.firstWhere((f) => f.key == key);
}
