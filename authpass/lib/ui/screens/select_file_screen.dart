import 'dart:io';

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/deps.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_ui.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/ui/screens/about.dart';
import 'package:authpass/ui/screens/create_file.dart';
import 'package:authpass/ui/screens/main_app_scaffold.dart';
import 'package:authpass/ui/widgets/link_button.dart';
import 'package:authpass/utils/async_utils.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:file_chooser/file_chooser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';
import 'package:simple_form_field_validator/simple_form_field_validator.dart';
import 'package:path/path.dart' as path;

import '../../theme.dart';

final _logger = Logger('authpass.select_file_screen');

class SelectFileScreen extends StatelessWidget {
  const SelectFileScreen({Key key, this.skipQuickUnlock = false})
      : assert(skipQuickUnlock != null),
        super(key: key);

  static Route<Object> route({bool skipQuickUnlock = false}) =>
      MaterialPageRoute(
        settings: const RouteSettings(name: '/selectFile'),
        builder: (context) => SelectFileScreen(
          skipQuickUnlock: skipQuickUnlock,
        ),
      );

  final bool skipQuickUnlock;

  @override
  Widget build(BuildContext context) {
    Provider.of<Analytics>(context).events.trackLaunch();
    final cloudBloc = CloudStorageBloc(Provider.of<Env>(context));
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthPass - Select KeePass File'),
        actions: <Widget>[
          AuthPassAboutDialog.createAboutPopupAction(context),
        ],
      ),
      body: Provider<CloudStorageBloc>.value(
        value: cloudBloc,
        child: Container(
          alignment: Alignment.center,
          child: SelectFileWidget(
            skipQuickUnlock: skipQuickUnlock,
          ),
        ),
      ),
    );
  }
}

class ProgressOverlay extends StatelessWidget {
  const ProgressOverlay({Key key, @required this.child, this.task})
      : super(key: key);

  final FutureTask task;
  final Widget child;

  bool get _hasProgress => task != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: <Widget>[
        child,
        Positioned.fill(
          child: AnimatedCrossFade(
            firstChild: task == null
                ? Container()
                : Container(
                    color: Colors.black12,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor
                              .withAlpha(250), //Color(0xefffffff),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        padding: const EdgeInsets.all(32),
                        child: ValueListenableBuilder<FutureTask>(
                          valueListenable: task,
                          builder: (context, value, child) {
                            _logger.info(
                                'Generating progress dialog with label ${value?.progressLabel}');
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const CircularProgressIndicator(),
                                ...?(value.progressLabel == null
                                    ? null
                                    : [
                                        const SizedBox(height: 16),
                                        Text(value.progressLabel),
                                      ]),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
            secondChild: Container(),
            crossFadeState: _hasProgress
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 200),
          ),
        )
      ],
    );
  }
}

class SelectFileWidget extends StatefulWidget {
  const SelectFileWidget({
    Key key,
    this.skipQuickUnlock = false,
  }) : super(key: key);

  final bool skipQuickUnlock;

  @override
  _SelectFileWidgetState createState() => _SelectFileWidgetState();
}

class _SelectFileWidgetState extends State<SelectFileWidget>
    with FutureTaskStateMixin {
  bool _quickUnlockAttempted = false;
  int counter = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _logger.finer('didChangeDependencies ${widget.skipQuickUnlock}');
    if (!widget.skipQuickUnlock) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _checkQuickUnlock();
      });
    }
//      Future<int>.delayed(const Duration(seconds: 5))
//        .then((value) => _checkQuickUnlock());
//    _checkQuickUnlock();
  }

  @override
  void didUpdateWidget(covariant SelectFileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _logger.finer('didUpdateWidget --- ${oldWidget != widget}');
    if (oldWidget != widget && !widget.skipQuickUnlock) {
      _checkQuickUnlock();
    }
  }

  Future<void> _checkQuickUnlock() => asyncRunTask((progress) async {
        if (_quickUnlockAttempted) {
          _logger.fine('_checkQuickUnlock already did quick unlock. skipping.');
          return;
        }
        _quickUnlockAttempted = true;
        progress.progressLabel = 'Quick unlocking files ...';
        final kdbxBloc = Provider.of<KdbxBloc>(context, listen: false);
        if (kdbxBloc.openedFilesWithSources.isNotEmpty) {
          _logger
              .fine('We already have files open. Not attempting quick unlock.');
          return;
        }
        _logger.finer(
            'opening quick unlock. ${++counter} $_quickUnlockAttempted $mounted');
        final opened = await kdbxBloc.reopenQuickUnlock(progress);
        _logger.info(
            'opened $opened files with quick unlock. ${kdbxBloc.openedFilesKdbx.isNotEmpty}');
        if (opened > 0 && kdbxBloc.openedFilesKdbx.isNotEmpty) {
//          if (Platform.isMacOS) {
//            _logger.fine('Lets chill for a second.');
//            await Future<int>.delayed(const Duration(seconds: 3));
//            _logger.fine('calling setState');
//            setState(() {});
//            _logger.fine('Lets chill for a second.');
//            await Future<int>.delayed(const Duration(seconds: 3));
//          }
          _logger.finer('Pushing main app scaffold. (mounted: $mounted)');
          unawaited(
              Navigator.of(context).pushReplacement(MainAppScaffold.route()));
//          WidgetsBinding.instance.scheduleFrameCallback((timeStamp) {
//            _logger.fine('Frame Callback. adding post frame callback.');
//            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//              _logger
//                  .finer('post frame callback. $timeStamp / mounted:$mounted');
//              if (mounted) {
//                unawaited(Navigator.of(context)
//                    .pushReplacement(MainAppScaffold.route()));
//              }
//            });
//          });
        }
      }, label: 'Quick unlocking files');

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final cloudStorageBloc = Provider.of<CloudStorageBloc>(context);
    return ProgressOverlay(
      task: task,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const SizedBox(height: 16),
            const Text('Please select a KeePass (.kdbx) file.'),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: <Widget>[
                SelectFileAction(
                  icon: FontAwesomeIcons.hdd,
                  label: 'Open\nLocal File',
                  onPressed: () async {
                    if (Platform.isIOS || Platform.isAndroid) {
                      final fileInfo =
                          await FilePickerWritable().openFilePicker();
                      if (fileInfo != null) {
                        await Navigator.of(context)
                            .push(CredentialsScreen.route(
                          FileSourceLocal(
                            fileInfo.file,
                            uuid: AppDataBloc.createUuid(),
                            filePickerIdentifier: fileInfo.identifier,
                          ),
                        ));
                      }
                    } else if (Platform.isIOS || Platform.isAndroid) {
                      final path =
                          await FilePicker.getFilePath(type: FileType.any);
                      if (path != null) {
                        await Navigator.of(context).push(
                            CredentialsScreen.route(FileSourceLocal(File(path),
                                uuid: AppDataBloc.createUuid())));
                      }
                    } else {
                      showOpenPanel((result, paths) async {
                        if (result == FileChooserResult.ok) {
                          String macOsBookmark;
                          if (Platform.isMacOS) {
                            macOsBookmark = await SecureBookmarks()
                                .bookmark(File(paths[0]));
                          }
                          await Navigator.of(context)
                              .push(CredentialsScreen.route(FileSourceLocal(
                            File(paths[0]),
                            uuid: AppDataBloc.createUuid(),
                            macOsSecureBookmark: macOsBookmark,
                            filePickerIdentifier: null,
                          )));
                        }
                      });
                    }
                  },
                ),
                ...cloudStorageBloc.availableCloudStorage.map(
                  (cs) => SelectFileAction(
                    icon: cs.displayIcon,
                    label: 'Load from ${cs.displayName}',
                    onPressed: () async {
                      final source = await Navigator.of(context).push(
                          CloudStorageSelector.route(
                              cs, CloudStorageOpenConfig()));
                      if (source != null) {
                        await Navigator.of(context)
                            .push(CredentialsScreen.route(source.fileSource));
                      }
                    },
                  ),
                ),
              ],
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
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: LinkButton(
                        onPressed: () async {
                          final source = await showDialog<FileSourceUrl>(
                              context: context,
                              builder: (context) => SelectUrlDialog());
                          if (source != null) {
                            _loadAndGoToCredentials(source);
                          }
                        },
                        child: const Text(
                          'Download from URL',
                          textAlign: TextAlign.right,
                        ),
                      ),
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
                      child: const Expanded(
                          child: Text(
                              'New to KeePass?\nCreate New Password Database',
                              softWrap: true)),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            IntrinsicWidth(
              stepWidth: 100,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Last opened files:',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    ...ListTile.divideTiles(
                        context: context,
                        tiles: appData?.previousFiles?.reversed?.take(5)?.map(
                                  (f) => OpenedFileTile(
                                    openedFile:
                                        f.toFileSource(cloudStorageBloc),
                                    onPressed: () {
                                      final source =
                                          f.toFileSource(cloudStorageBloc);
                                      _loadAndGoToCredentials(source);
                                    },
                                  ),
                                ) ??
                            [const Text('No files have been opened yet.')]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadAndGoToCredentials(FileSource source) {
    asyncRunTask((progress) {
      return source.content().then((value) {
        return Navigator.of(context).push(CredentialsScreen.route(source));
      }).catchError((dynamic error, StackTrace stackTrace) {
        _logger.fine('Error while trying to load file source $source');
        DialogUtils.showErrorDialog(context, 'Error while opening file.',
            'Unable to open $source.\n$error');
        return Future<dynamic>.error(error, stackTrace);
      });
    }, label: 'Loading file ...');
    setState(() {});
  }
}

class OpenedFileTile extends StatelessWidget {
  const OpenedFileTile({Key key, @required this.openedFile, this.onPressed})
      : super(key: key);

  final FileSource openedFile;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final subtitleStyle = TextStyle(
        color: ListTileTheme.of(context).textColor ??
            Theme.of(context).textTheme.caption.color);
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
//        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(openedFile.displayIcon),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    openedFile.displayName,
                    style: TextStyle(color: AuthPassTheme.linkColor),
                  ),
                  Text(
                    '${openedFile.displayPath}',
                    style: subtitleStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
//              Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectFileAction extends StatelessWidget {
  const SelectFileAction({Key key, this.icon, this.label, this.onPressed})
      : super(key: key);

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 120,
      height: 96,
      child: Material(
//      shape: Border.all(),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: theme.primaryColor,
        elevation: 4,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DefaultTextStyle(
              style: theme.primaryTextTheme.bodyText2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    icon,
                    color:
                        theme.primaryTextTheme.bodyText2.color.withOpacity(0.8),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: theme.primaryTextTheme.bodyText2
                        .copyWith(letterSpacing: 0.9),
                    strutStyle: const StrutStyle(leading: 0.2),
//                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
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
        _logger.fine(
            'User entered url with invalid schema ${FormatUtils.anonymizeUrl(urlString)}');
        return 'Please enter full url starting with http:// or https://';
      }
      _enteredUrl = uri;
      return null;
    } on FormatException catch (e) {
      _logger.fine(
          'User entered invalid url ${FormatUtils.anonymizeUrl(urlString)}', e);
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
              Navigator.of(context).pop(
                  FileSourceUrl(_enteredUrl, uuid: AppDataBloc.createUuid()));
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

  File _keyFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _kdbxBloc = Provider.of<KdbxBloc>(context);
    _kdbxBloc.quickUnlockStorage
        .supportsBiometricKeyStore()
        .then((bool biometricQuickUnlock) => setState(() {
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
      body: SingleChildScrollView(
        child: Form(
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
                    Text(widget.kdbxFilePath.displayName,
                        style: theme.textTheme.headline4),
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
                  decoration: const InputDecoration(labelText: 'Password'),
                  autocorrect: false,
                  autofocus: true,
                  autovalidate: _invalidPassword != null,
                  obscureText: true,
                  validator: (_keyFile == null || _invalidPassword != null
                          ? SValidator.notEmpty(
                              msg: 'Please enter your password.')
                          : SValidator<String>([])) +
                      SValidator.invalidValue(
                          invalidValue: _invalidPassword,
                          message: 'Invalid password'),
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();

                    _tryUnlock();
                  },
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(right: 32, left: 32),
                child: FlatButton.icon(
//                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  icon: Icon(_keyFile == null
                      ? FontAwesomeIcons.folderOpen
                      : FontAwesomeIcons.edit),
                  label: Text(_keyFile == null
                      ? 'Use Key File'
                      : path.basename(_keyFile.path)),
                  onPressed: () async {
                    _invalidPassword = null;
                    if (Platform.isIOS || Platform.isAndroid) {
                      final path =
                          await FilePicker.getFilePath(type: FileType.any);
                      setState(() {
                        _keyFile = path == null ? null : File(path);
                      });
                    } else {
                      showOpenPanel((result, paths) async {
                        if (result == FileChooserResult.ok) {
                          setState(() {
                            _keyFile = File(paths[0]);
                          });
                        } else if (result == FileChooserResult.cancel) {
                          setState(() {
                            _keyFile = null;
                          });
                        }
                      });
                    }
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
                    ? const Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator())
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
      ),
    );
  }

  Future<void> _tryUnlock() async {
    if (_formKey.currentState.validate()) {
      final kdbxBloc = Provider.of<Deps>(context, listen: false).kdbxBloc;
      final pw = _controller.text;
      final keyFileContents = await _keyFile?.readAsBytes();
      try {
        _loadingFile = kdbxBloc.openFile(
          widget.kdbxFilePath,
          Credentials.composite(
              pw == '' ? null : ProtectedValue.fromString(pw), keyFileContents),
          addToQuickUnlock: _biometricQuickUnlockActivated ?? false,
        );
        setState(() {});
        await _loadingFile;
        await Navigator.of(context)
            .pushAndRemoveUntil(MainAppScaffold.route(), (route) => false);
      } on KdbxInvalidKeyException catch (e, stackTrace) {
        _logger.fine('Invalid credentials.', e, stackTrace);
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
