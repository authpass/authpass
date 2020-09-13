import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/l10n/app_localizations.dart';
import 'package:authpass/ui/screens/main_app_scaffold.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:provider/provider.dart';

import 'package:logging/logging.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _databaseName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  bool _passwordObscured = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = AppLocalizations.of(context);
    if (_databaseName.text.isEmpty) {
      _databaseName.text = loc.databaseCreateDefaultName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.createPasswordDatabase),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                  if (val.isEmpty) {
                    return loc.validatorNameMissing;
                  }
                  return null;
                },
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                obscureText: _passwordObscured,
                focusNode: _passwordFocus,
                onFieldSubmitted: (val) => _submitCallback()(),
                decoration: InputDecoration(
                  labelText: loc.masterPasswordHelpText,
                  filled: true,
                  suffix: InkWell(
                    child: _passwordObscured
                        ? const Icon(Icons.lock)
                        : const Icon(Icons.lock_open),
                    onTap: () {
                      setState(() {
                        _passwordObscured = !_passwordObscured;
                      });
                    },
                  ),
                ),
                validator: (val) {
                  if (val.isEmpty) {
                    return loc.masterPasswordMissingCreate;
                  }
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.only(top: 8),
                alignment: Alignment.centerRight,
                child: task != null
                    ? const CircularProgressIndicator()
                    : PrimaryButton(
                        large: false,
                        child: Text(loc.createDatabaseAction),
                        onPressed: _submitCallback(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  VoidCallback _submitCallback() => asyncTaskCallback((progress) async {
        if (_formKey.currentState.validate()) {
          final kdbxBloc = Provider.of<KdbxBloc>(context, listen: false);
          try {
            final created = await kdbxBloc.createFile(
              password: _password.text,
              databaseName: _databaseName.text,
              openAfterCreate: true,
            );
            assert(created != null);
            await Navigator.of(context)
                .pushAndRemoveUntil(MainAppScaffold.route(), (route) => false);
          } on FileExistsException catch (e, stackTrace) {
            _logger.warning('Showing file exists error dialog.', e, stackTrace);
            final loc = AppLocalizations.of(context);
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
