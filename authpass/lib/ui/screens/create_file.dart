import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/ui/screens/main_app_scaffold.dart';
import 'package:authpass/ui/widgets/password_input_field.dart';
import 'package:authpass/ui/widgets/password_strength_display.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
// ignore: implementation_imports
import 'package:zxcvbn/src/result.dart';
import 'package:zxcvbn/zxcvbn.dart';

final _logger = Logger('create_file');

class CreateFile extends StatefulWidget {
  static PageRoute<void> route() => MaterialPageRoute(
        settings: const RouteSettings(name: '/createFile'),
        builder: (context) => CreateFile(),
      );

  @override
  _CreateFileState createState() => _CreateFileState();
}

class _CreateFileState extends State<CreateFile> with FutureTaskStateMixin {
  static final _zxcvbn = Zxcvbn();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _databaseName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  Result? _strength;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = AppLocalizations.of(context);
    if (_databaseName.text.isEmpty) {
      _databaseName.text = loc!.databaseCreateDefaultName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.createPasswordDatabase),
      ),
      body: Form(
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
                    final userInput = _databaseName.text.pathCase.split('/');
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
                  'The master password is used to securely encrypt your password database. Make sure to remember it, it can not be restored.',
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
                          child: Text(loc.createDatabaseAction),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  VoidCallback? _submitCallback() => asyncTaskCallback((progress) async {
        if (_formKey.currentState!.validate()) {
          final kdbxBloc = Provider.of<KdbxBloc>(context, listen: false);
          try {
            final created = await kdbxBloc.createFile(
              password: _password.text,
              databaseName: _databaseName.text,
              openAfterCreate: true,
            );
            _logger.finest('Created file $created');
            await Navigator.of(context)
                .pushAndRemoveUntil(MainAppScaffold.route(), (route) => false);
          } on FileExistsException catch (e, stackTrace) {
            _logger.warning('Showing file exists error dialog.', e, stackTrace);
            final loc = AppLocalizations.of(context)!;
            await DialogUtils.showSimpleAlertDialog(
              context,
              loc.databaseExistsError,
              loc.databaseExistsErrorDescription(e.path),
              routeAppend: 'createFileExists',
            );
          } catch (e, stackTrace) {
            _logger.severe('Error while creating file.', e, stackTrace);
            rethrow;
          }
        }
      });
}
