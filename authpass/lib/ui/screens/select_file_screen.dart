import 'dart:io';

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/deps.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_ui.dart';
import 'package:authpass/cloud_storage/dropbox/dropbox_provider.dart';
import 'package:authpass/cloud_storage/google_drive/google_drive_provider.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/ui/screens/about.dart';
import 'package:authpass/ui/screens/create_file.dart';
import 'package:authpass/ui/screens/main_app_scaffold.dart';
import 'package:authpass/ui/widgets/link_button.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:file_chooser/file_chooser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:simple_form_field_validator/simple_form_field_validator.dart';

import '../../theme.dart';

final _logger = Logger('select_file_screen');

class SelectFileScreen extends StatelessWidget {
  static Route<Object> get route => MaterialPageRoute(
        settings: const RouteSettings(name: '/selectFile'),
        builder: (context) => SelectFileScreen(),
      );

  @override
  Widget build(BuildContext context) {
    Provider.of<Analytics>(context).events.trackLaunch();
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthPass - Select KeePass File'),
        actions: <Widget>[
          AuthPassAboutDialog.createAboutPopupAction(context),
        ],
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
  bool _successfulQuickUnlock = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkQuickUnlock();
  }

  @override
  void didUpdateWidget(covariant SelectFileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _logger.finer('didUpdateWidget --- ${oldWidget != widget}');
    if (oldWidget != widget) {
      _checkQuickUnlock();
    }
  }

  Future<void> _checkQuickUnlock() => _fileLoader ??= (() async {
        if (_successfulQuickUnlock) {
          _logger.fine('_checkQuickUnlock already did quick unlock. skipping.');
          return;
        }
        _logger.finer('opening quick unlock. $_successfulQuickUnlock $mounted');
        final kdbxBloc = Provider.of<KdbxBloc>(context);
        final opened = await kdbxBloc.reopenQuickUnlock();
        _logger.info('opened $opened files with quick unlock.');
        _successfulQuickUnlock = true;
        if (opened > 0 && kdbxBloc.openedFiles.isNotEmpty) {
          await Navigator.of(context).push(MainAppScaffold.route());
        }
      })()
          .whenComplete(() {
        setState(() {
          _fileLoader = null;
        });
      });

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final env = Provider.of<Env>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        const Text('Please select a KeePass (.kdbx) file.'),
        const Text('(Currently only kdbx 3 is supported)'),
        ...(!env.featureCloudStorage
            ? []
            : [
                LinkButton(
                  child: const Text('Google Drive'),
                  onPressed: () {
                    Navigator.of(context)
                        .push(CloudStorageSelector.route(GoogleDriveProvider(env: Provider.of<Env>(context))));
                  },
                ),
                LinkButton(
                  child: const Text('Dropbox'),
                  onPressed: () {
                    Navigator.of(context)
                        .push(CloudStorageSelector.route(DropboxProvider(env: Provider.of<Env>(context))));
                  },
                ),
              ]),
        const SizedBox(height: 16),
        _fileLoader != null
            ? const CircularProgressIndicator()
            : PrimaryButton(
                icon: Icon(Icons.file_upload),
                child: const Text('Select File'),
                onPressed: () async {
                  if (Platform.isIOS || Platform.isAndroid) {
                    final path = await FilePicker.getFilePath(type: FileType.ANY);
                    if (path != null) {
                      await Navigator.of(context)
                          .push(CredentialsScreen.route(FileSourceLocal(File(path), uuid: AppDataBloc.createUuid())));
                    }
                  } else {
                    showOpenPanel((result, paths) async {
                      if (result == FileChooserResult.ok) {
                        await Navigator.of(context).push(
                            CredentialsScreen.route(FileSourceLocal(File(paths[0]), uuid: AppDataBloc.createUuid())));
                      }
                    });
                  }
                },
              ),
        const SizedBox(
          height: 4,
        ),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: LinkButton(
                  onPressed: () async {
                    final source =
                        await showDialog<FileSourceUrl>(context: context, builder: (context) => SelectUrlDialog());
                    if (source != null) {
                      _loadAndGoToCredentials(source);
                    }
                  },
                  child: const Text('Download from URL'),
                ),
              ),
              VerticalDivider(
                indent: 8,
                endIndent: 8,
                color: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: LinkButton(
                  onPressed: () {
                    Navigator.of(context).push(CreateFile.route());
                  },
                  icon: Icon(Icons.create_new_folder),
                  child: const Expanded(child: Text('New to KeePass?\nCreate New Password Database', softWrap: true)),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
        IntrinsicWidth(
          stepWidth: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Last opened files:',
                style: Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              ...ListTile.divideTiles(
                  context: context,
                  tiles: appData?.previousFiles?.reversed?.take(5)?.map(
                            (f) => OpenedFileTile(
                              openedFile: f,
                              onPressed: () {
                                final source = f.toFileSource();
                                if (source is FileSourceUrl) {
                                  _loadAndGoToCredentials(source);
                                } else {
                                  Navigator.of(context).push(CredentialsScreen.route(f.toFileSource()));
                                }
                              },
                            ),
                          ) ??
                      [const Text('No files have been opened yet.')]),
            ],
          ),
        ),
      ],
    );
  }

  void _loadAndGoToCredentials(FileSourceUrl source) {
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
}

class OpenedFileTile extends StatelessWidget {
  const OpenedFileTile({Key key, @required this.openedFile, this.onPressed}) : super(key: key);

  final OpenedFile openedFile;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final subtitleStyle =
        TextStyle(color: ListTileTheme.of(context).textColor ?? Theme.of(context).textTheme.caption.color);
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
//        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(Icons.lock),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  openedFile.name,
                  style: TextStyle(color: AuthPassTheme.linkColor),
                ),
                ...(openedFile.sourceType == OpenedFilesSourceType.Url
                    ? [
                        Text(
                          '${FormatUtils.anonymizeUrl(openedFile.sourcePath)}',
                          style: subtitleStyle,
                        ),
                      ]
                    : openedFile.sourceType == OpenedFilesSourceType.Local
                        ? [
                            Text(
                              '${path.basename(openedFile.sourcePath)}',
                              style: subtitleStyle,
                            ),
                          ]
                        : []),
//              Divider(),
              ],
            ),
          ],
        ),
      ),
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
              Navigator.of(context).pop(FileSourceUrl(_enteredUrl, uuid: AppDataBloc.createUuid()));
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
  Future<void> _loadingFile;

  KdbxBloc _kdbxBloc;
  bool _biometricQuickUnlockSupported = false;
  bool _biometricQuickUnlockActivated;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _kdbxBloc = Provider.of<KdbxBloc>(context);
    _kdbxBloc.quickUnlockStorage.supportsBiometricKeyStore().then((bool biometricQuickUnlock) => setState(() {
          _biometricQuickUnlockSupported = biometricQuickUnlock;
          _biometricQuickUnlockActivated ??= true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthPass - Credentials'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Enter the password for:'),
                  Text(widget.kdbxFilePath.displayName, style: theme.textTheme.display1),
                  Text(
                    widget.kdbxFilePath.displayPath,
                    style: theme.textTheme.caption,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 32, right: 32, left: 32),
//              constraints: BoxConstraints.expand(),
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Password'),
                autocorrect: false,
                autofocus: true,
                autovalidate: _invalidPassword != null,
                obscureText: true,
                validator: SValidator.notEmpty(msg: 'Please enter your password.') +
                    SValidator.invalidValue(invalidValue: _invalidPassword, message: 'Invalid password'),
                onEditingComplete: () {
                  _tryUnlock();
                },
              ),
            ),
            ...(_biometricQuickUnlockSupported
                ? [
                    Container(
                      child: CheckboxListTile(
                        value: _biometricQuickUnlockActivated,
                        dense: true,
                        title: const Text(
                          'Save Password with biometric key store?',
                          textAlign: TextAlign.right,
                        ),
                        onChanged: (value) => setState(() {
                          _biometricQuickUnlockActivated = value;
                        }),
                      ),
                    ),
                  ]
                : []),
            Container(
              alignment: Alignment.centerRight,
              child: _loadingFile != null
                  ? const Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())
                  : LinkButton(
                      child: const Text('Continue'),
                      onPressed: () async {
                        await _tryUnlock();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _tryUnlock() async {
    if (_formKey.currentState.validate()) {
      final kdbxBloc = Provider.of<Deps>(context).kdbxBloc;
      final pw = _controller.text;
      try {
        _loadingFile = kdbxBloc.openFile(widget.kdbxFilePath, Credentials(ProtectedValue.fromString(pw)),
            addToQuickUnlock: _biometricQuickUnlockActivated ?? false);
        setState(() {});
        await _loadingFile;
        await Navigator.of(context).pushAndRemoveUntil(MainAppScaffold.route(), (route) => false);
      } on KdbxInvalidKeyException catch (e, stackTrace) {
        _logger.fine('Invalid credentials. ($pw)', e, stackTrace);
        setState(() {
          _invalidPassword = pw;
          _formKey.currentState.validate();
        });
      } catch (e, stackTrace) {
        _logger.fine('Unable to open kdbx file. ', e, stackTrace);
        await DialogUtils.showSimpleAlertDialog(
          context,
          'Unable to open File',
          'Unknown error while trying to open file. $e',
        );
      } finally {
        setState(() {
          _loadingFile = null;
        });
      }
    }
  }
}
