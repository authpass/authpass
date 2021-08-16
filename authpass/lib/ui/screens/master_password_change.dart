import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/ui/screens/create_file.dart';
import 'package:authpass/ui/widgets/password_input_field.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kdbx/kdbx.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:zxcvbn/zxcvbn.dart';

class MasterPasswordChangeScreen extends StatelessWidget {
  const MasterPasswordChangeScreen({
    Key? key,
    required this.fileSource,
  }) : super(key: key);

  static Route<void> route({
    required FileSource fileSource,
  }) =>
      MaterialPageRoute(
        builder: (context) =>
            MasterPasswordChangeScreen(fileSource: fileSource),
        settings: const RouteSettings(name: 'masterPasswordChange'),
      );

  final FileSource fileSource;

  @override
  Widget build(BuildContext context) {
    final kdbxBloc = Provider.of<KdbxBloc>(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.changeMasterPasswordScreenTitle),
      ),
      body: MasterPasswordChangeForm(
        fileSource: fileSource,
        file: kdbxBloc.fileForFileSource(fileSource)!.kdbxFile,
      ),
    );
  }
}

class MasterPasswordChangeForm extends StatefulWidget {
  const MasterPasswordChangeForm({
    Key? key,
    required this.fileSource,
    required this.file,
  }) : super(key: key);

  final FileSource fileSource;
  final KdbxFile file;

  @override
  _MasterPasswordChangeFormState createState() =>
      _MasterPasswordChangeFormState();
}

class _MasterPasswordChangeFormState extends State<MasterPasswordChangeForm>
    with FutureTaskStateMixin {
  static late final _zxcvbn = Zxcvbn();

  final _databaseName = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final FocusNode _passwordFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey();
  Result? _strength;

  @override
  void initState() {
    super.initState();
    _databaseName.text = widget.file.body.rootGroup.name.get()!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
        child: Theme(
          data: theme.copyWith(
              inputDecorationTheme:
                  theme.inputDecorationTheme.copyWith(filled: true)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _databaseName,
                decoration: InputDecoration(
                  labelText: loc.nameNewPasswordDatabase,
                  suffixText: '.kdbx', // NON-NLS
                  filled: true,
                ),
                readOnly: true,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (val) => _passwordFocus.requestFocus(),
                validator: (val) {
                  if (val!.isEmpty) {
                    return loc.validatorNameMissing;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              PasswordInputField(
                labelText: loc.inputMasterPasswordText,
                controller: _password,
                focusNode: _passwordFocus,
                autofocus: true,
                onFieldSubmitted: (val) => _submitCallback()!(),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  final userInput =
                      _databaseName.text.pathCase.split(CharConstants.slash);
                  setState(() {
                    if (value.isEmpty) {
                      _strength = null;
                    } else {
                      _strength =
                          _zxcvbn.evaluate(value, userInputs: userInput);
                    }
                  });
                },
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return loc.masterPasswordMissingCreate;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              PasswordStrengthDisplay(strength: _strength),
              const SizedBox(height: 8),
              Text(
                loc.masterPasswordDescription,
                style: Theme.of(context).textTheme.caption,
              ),
              Container(
                padding: const EdgeInsets.only(top: 8),
                alignment: Alignment.centerRight,
                child: task != null
                    ? const CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      )
                    : PrimaryButton(
                        large: false,
                        onPressed: _submitCallback(),
                        child: Text(loc.changeMasterPasswordFormSubmit),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  VoidCallback? _submitCallback() => asyncTaskCallback((progress) async {
        if (_formKey.currentState!.validate()) {
          final kdbxBloc = Provider.of<KdbxBloc>(context, listen: false);
          await kdbxBloc.saveFile(
            widget.file,
            updateCredentials: Credentials.composite(
              ProtectedValue.fromString(_password.text),
              null,
            ),
          );
          final loc = AppLocalizations.of(context);
          context.showSnackBar(loc.changeMasterPasswordSuccess);
          Navigator.of(context).pop();
        }
      });
}
