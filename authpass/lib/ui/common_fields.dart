import 'package:authpass/ui/l10n/AuthPassLocalizations.dart';
import 'package:kdbx/kdbx.dart';
import 'package:meta/meta.dart';

class CommonField {
  const CommonField({
    @required this.key,
    @required this.displayName,
    this.includeInSearch = false,
    this.protect = false,
  });

  final String key;
  final String displayName;
  final bool includeInSearch;
  final bool protect;

  String stringValue(KdbxEntry entry) => entry.strings[key]?.getText();
}

class CommonFields {
  CommonFields(AuthPassLocalizations loc)
      : fields = [
          CommonField(key: 'Title', displayName: loc.fieldTitle, includeInSearch: true),
          CommonField(key: 'UserName', displayName: loc.fieldUserName, includeInSearch: true),
          CommonField(key: 'Password', displayName: loc.fieldPassword, protect: true),
          CommonField(key: 'URL', displayName: loc.fieldWebsite, includeInSearch: true),
        ];

  CommonField get title => _fieldByKey('Title');
  CommonField get url => _fieldByKey('URL');
  CommonField get userName => _fieldByKey('UserName');

  final List<CommonField> fields;

  CommonField _fieldByKey(String key) => fields.firstWhere((f) => f.key == key);
}
