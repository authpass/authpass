import 'dart:io';

import 'package:authpass/bloc/deps.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/ui/screens/password_list.dart';
import 'package:authpass/ui/widgets/link_button.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:simple_form_field_validator/simple_form_field_validator.dart';

final _logger = Logger('select_file_screen');

class SelectFileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthPass - Select KeePass File'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: const SelectFileWidget(),
      ),
    );
  }
}

class SelectFileWidget extends StatefulWidget {
  const SelectFileWidget({
    Key key,
  }) : super(key: key);

  @override
  _SelectFileWidgetState createState() => _SelectFileWidgetState();
}

class _SelectFileWidgetState extends State<SelectFileWidget> {
  Future<dynamic> _fileLoader;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        const Text('Please select a KeePass (.kdbx) file.'),
        const Text('(Currently only kdbx 3 is supported)'),
        const SizedBox(height: 16),
        _fileLoader != null
            ? const CircularProgressIndicator()
            : RaisedButton(
                child: const Text('Select File'),
                onPressed: () async {
                  final path = await FilePicker.getFilePath(type: FileType.ANY);
                  if (path != null) {
                    await Navigator.of(context).push(CredentialsScreen.route(FileSourceLocal(File(path))));
                  }
                },
              ),
        const SizedBox(
          height: 4,
        ),
        LinkButton(
          onPressed: () async {
            final source = await showDialog<FileSourceUrl>(context: context, builder: (context) => SelectUrlDialog());
            if (source != null) {
              setState(() {
                _fileLoader = source.load().then((value) {
                  return Navigator.of(context).push(CredentialsScreen.route(source));
                }).catchError((dynamic error, StackTrace stackTrace) {
                  _logger.fine('Error while trying to download from '
                      '${FormatUtils.anonymizeUrl(source.url.toString())}');
                  return Future<dynamic>.error(error, stackTrace);
                }).whenComplete(() {
                  setState(() {
                    _fileLoader = null;
                  });
                });
              });
            }
          },
          child: const Text('Download from URL'),
        ),
      ],
    );
  }
}

class SelectUrlDialog extends StatefulWidget {
  @override
  _SelectUrlDialogState createState() => _SelectUrlDialogState();
}

class _SelectUrlDialogState extends State<SelectUrlDialog> {
  final _formKey = GlobalKey<FormState>();
  Uri _enteredUrl;

  String _parseUrl(String urlString) {
    try {
      final uri = Uri.parse(urlString);
      if (!uri.scheme.startsWith('http')) {
        _logger.fine('User entered url with invalid schema ${FormatUtils.anonymizeUrl(urlString)}');
        return 'Please enter full url starting with http:// or https://';
      }
      _enteredUrl = uri;
      return null;
    } on FormatException catch (e) {
      _logger.fine('User entered invalid url ${FormatUtils.anonymizeUrl(urlString)}', e);
      return 'Please enter a valid url.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Download from Url'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          validator: _parseUrl,
          onSaved: _parseUrl,
          decoration: InputDecoration(
            icon: Icon(Icons.cloud_download),
            labelText: 'Enter URL',
            hintText: 'https://',
          ),
          keyboardType: TextInputType.url,
          autofocus: true,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        FlatButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              Navigator.of(context).pop(FileSourceUrl(_enteredUrl));
            } else {
              Navigator.of(context).pop();
            }
          },
          child: const Text('Ok'),
        )
      ],
    );
  }
}

class CredentialsScreen extends StatefulWidget {
  const CredentialsScreen({Key key, this.kdbxFilePath}) : super(key: key);

  static Route<void> route(FileSource kdbxFilePath) => MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/credentials'),
        builder: (context) => CredentialsScreen(
          kdbxFilePath: kdbxFilePath,
        ),
      );

  final FileSource kdbxFilePath;

  @override
  _CredentialsScreenState createState() => _CredentialsScreenState();
}

class _CredentialsScreenState extends State<CredentialsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _invalidPassword;

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthPass - Credentials'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
//              constraints: BoxConstraints.expand(),
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Password'),
                autocorrect: false,
                autofocus: true,
                autovalidate: true,
                obscureText: true,
                validator: SValidator.notEmpty(msg: 'Please enter your password.') +
                    SValidator.invalidValue(invalidValue: _invalidPassword, message: 'Invalid password'),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: LinkButton(
                child: const Text('Continue'),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    final kdbxBloc = Provider.of<Deps>(context).kdbxBloc;
                    final pw = _controller.text;
                    try {
                      await kdbxBloc.openFile(widget.kdbxFilePath, Credentials(ProtectedValue.fromString(pw)));
                      await Navigator.of(context).pushAndRemoveUntil(PasswordList.route(), (route) => false);
                    } on KdbxInvalidKeyException catch (e, stackTrace) {
                      _logger.fine('Invalid credentials. ($pw)', e, stackTrace);
                      setState(() {
                        _invalidPassword = pw;
                        _formKey.currentState.validate();
                      });
                    } catch (e, stackTrace) {
                      _logger.fine('Unable to open kdbx file.', e, stackTrace);
                      DialogUtils.showSimpleAlertDialog(
                        context,
                        'Unable to open File',
                        'Unknown error while trying to open file. $e',
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
