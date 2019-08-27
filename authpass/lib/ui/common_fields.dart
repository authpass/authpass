import 'package:authpass/ui/l10n/AuthPassLocalizations.dart';
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
  }) : key = KdbxKey(key);

  final KdbxKey key;
  final String displayName;
  final bool includeInSearch;
  final bool protect;
  final TextInputType keyboardType;

  String stringValue(KdbxEntry entry) => entry.getString(key)?.getText();
}

class CommonFields {
  CommonFields(AuthPassLocalizations loc)
      : fields = [
          CommonField(
            key: 'Title',
            displayName: loc.fieldTitle,
            includeInSearch: true,
          ),
          CommonField(
            key: 'UserName',
            displayName: loc.fieldUserName,
            includeInSearch: true,
            keyboardType: TextInputType.emailAddress,
          ),
          CommonField(
            key: 'Password',
            displayName: loc.fieldPassword,
            protect: true,
          ),
          CommonField(
            key: 'URL',
            displayName: loc.fieldWebsite,
            includeInSearch: true,
            keyboardType: TextInputType.url,
          ),
        ];

  CommonField get title => _fieldByKeyString('Title');

  CommonField get url => _fieldByKeyString('URL');

  CommonField get userName => _fieldByKeyString('UserName');

  CommonField get password => _fieldByKeyString('Password');

  final List<CommonField> fields;

  bool isCommon(KdbxKey key) => fields.firstWhere((f) => f.key == key, orElse: () => null) != null;

  CommonField _fieldByKeyString(String key) => _fieldByKey(KdbxKey(key));

  CommonField _fieldByKey(KdbxKey key) => fields.firstWhere((f) => f.key == key);
}
