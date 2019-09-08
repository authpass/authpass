import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/ui/screens/main_app_scaffold.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/utils/async_utils.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CreateFile extends StatefulWidget {
  static PageRoute<void> route() => MaterialPageRoute(
        settings: const RouteSettings(name: '/createFile'),
        builder: (context) => CreateFile(),
      );

  @override
  _CreateFileState createState() => _CreateFileState();
}

class _CreateFileState extends State<CreateFile> with TaskStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _databaseName = TextEditingController(text: 'PersonalPasswords');
  final TextEditingController _password = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  bool _passwordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Password Database'),
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
                  labelText: 'Name of your new Database',
                  suffixText: '.kdbx',
                  filled: true,
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (val) => _passwordFocus.requestFocus(),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please enter a name for your new database.';
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
                  labelText: 'Select a secure master Password. Make sure to remember it.',
                  filled: true,
                  suffix: InkWell(
                    child: _passwordObscured ? Icon(Icons.lock) : Icon(Icons.lock_open),
                    onTap: () {
                      setState(() {
                        _passwordObscured = !_passwordObscured;
                      });
                    },
                  ),
                ),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please enter a secure, rememberable password.';
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
                        child: const Text('Create Database'),
                        onPressed: _submitCallback(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  VoidCallback _submitCallback() => asyncTaskCallback(() async {
        if (_formKey.currentState.validate()) {
          final kdbxBloc = Provider.of<KdbxBloc>(context);
          try {
            final created = await kdbxBloc.createFile(
              password: _password.text,
              databaseName: _databaseName.text,
              openAfterCreate: true,
            );
            assert(created != null);
            await Navigator.of(context).pushAndRemoveUntil(MainAppScaffold.route(), (route) => false);
          } on FileExistsException catch (_) {
            await DialogUtils.showSimpleAlertDialog(
              context,
              'File Exists',
              'Error while trying to create database. '
                  'File already exists. Please choose another name',
            );
            rethrow;
          }
        }
      });
}
