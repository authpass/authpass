import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/deps.dart';
import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx/file_source_local.dart';
import 'package:authpass/bloc/kdbx/file_source_ui.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_ui.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/l10n/app_localizations.dart';
import 'package:authpass/ui/screens/app_bar_menu.dart';
import 'package:authpass/ui/screens/create_file.dart';
import 'package:authpass/ui/screens/main_app_scaffold.dart';
import 'package:authpass/ui/screens/onboarding/onboarding.dart';
import 'package:authpass/ui/widgets/link_button.dart';
import 'package:authpass/ui/widgets/password_input_field.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/extension_methods.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:authpass/utils/path_utils.dart';
import 'package:authpass/utils/platform.dart';
import 'package:authpass/utils/theme_utils.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:file_chooser/file_chooser.dart';
import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';
import 'package:path/path.dart' as path;
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';
import 'package:simple_form_field_validator/simple_form_field_validator.dart';
import 'package:tinycolor/color_extension.dart';

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
  static Future<void> navigate(BuildContext context) =>
      Navigator.of(context, rootNavigator: true, nullOk: true)
          .pushAndRemoveUntil(SelectFileScreen.route(), (_) => false);

  final bool skipQuickUnlock;

  @override
  Widget build(BuildContext context) {
    final cloudBloc = CloudStorageBloc(Provider.of<Env>(context), PathUtils());
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.selectKeepassFile),
        actions: <Widget>[
          AppBarMenu.createOverflowMenuButton(context,
              secondaryBuilder: (context) {
            return [
              PopupMenuItem(
                child: ListTile(
                  leading: const FaIcon(FontAwesomeIcons.route),
                  title: Text(loc.onboardingBackToOnboarding),
                  subtitle: Text(loc.onboardingBackToOnboardingSubtitle),
                ),
                value: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      OnboardingScreen.route(), (route) => false);
                },
              ),
              PopupMenuItem(
                  child: ListTile(
                    key: const ValueKey('downloadFromUrl'),
                    leading: const FaIcon(FontAwesomeIcons.fileCode),
                    title: Text(loc.loadFromRemoteUrl),
                  ),
                  value: () async {
                    final source = await showDialog<FileSourceUrl>(
                        context: context,
                        builder: (context) => SelectUrlDialog());
                    if (source != null) {
                      // _loadAndGoToCredentials(source);
                      await Navigator.of(context)
                          .push(CredentialsScreen.route(source));
                    }
                  }),
            ];
          }),
        ],
      ),
      body: Provider<CloudStorageBloc>.value(
        value: cloudBloc,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
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
            firstChild: !_hasProgress
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
                            _logger.fine('Generating progress dialog'
                                ' with label ${value?.progressLabel}');
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
  bool _showLinuxAppArmorMessage = false;
  static const _linuxAppArmorCommand =
      'snap connect authpass:password-manager-service';
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
    _linuxAppArmorCheck();
//      Future<int>.delayed(const Duration(seconds: 5))
//        .then((value) => _checkQuickUnlock());
//    _checkQuickUnlock();
  }

  Future<bool> _linuxAppArmorCheck() async {
    if (!AuthPassPlatform.isLinux) {
      return true;
    }
    final isError = await BiometricStorage().linuxCheckAppArmorError();
    if (isError != _showLinuxAppArmorMessage) {
      setState(() {
        _showLinuxAppArmorMessage = isError;
      });
    }
    return !isError;
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
//          if (AuthPassPlatform.isMacOS) {
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
      }, label: AppLocalizations.of(context).quickUnlockingFiles);

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final cloudStorageBloc = Provider.of<CloudStorageBloc>(context);
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return ProgressOverlay(
      task: task,
      child: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ...?(_showLinuxAppArmorMessage
                  ? [
                      const SizedBox(height: 16),
                      Text(
                        'AuthPass requires permission to communicate with '
                        'Secret Service to store credentials for cloud storage.\n'
                        'Please run the following command:',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.errorColor,
                        ),
                      ),
                      LinkButton(
                          icon: const Icon(Icons.content_copy),
                          child: const Text(
                            _linuxAppArmorCommand,
                            style: TextStyle(
                                fontFamily: AuthPassTheme.monoFontFamily),
                            maxLines: null,
                          ),
                          onPressed: () async {
                            await Clipboard.setData(const ClipboardData(
                                text: _linuxAppArmorCommand));
                            Scaffold.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(loc.copiedToClipboard),
                                ),
                              );
                            await _linuxAppArmorCheck();
                          }),
                    ]
                  : null),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  loc.selectKeepassFileLabel,
                  style: theme.textTheme.caption,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  SelectFileAction(
                    icon: FontAwesomeIcons.hdd,
                    label: loc.openLocalFile,
                    onPressed: () async {
                      if (AuthPassPlatform.isIOS ||
                          AuthPassPlatform.isAndroid) {
                        await _openIosAndAndroidLocalFilePicker();
                      } else {
                        final result = await showOpenPanel();
                        if (!result.canceled) {
                          String macOsBookmark;
                          if (AuthPassPlatform.isMacOS) {
                            macOsBookmark = await SecureBookmarks()
                                .bookmark(File(result.paths[0]));
                          }
                          await Navigator.of(context)
                              .push(CredentialsScreen.route(FileSourceLocal(
                            File(result.paths[0]),
                            uuid: AppDataBloc.createUuid(),
                            macOsSecureBookmark: macOsBookmark,
                            filePickerIdentifier: null,
                          )));
                        }
                      }
                    },
                  ),
                  ...cloudStorageBloc.availableCloudStorage.map(
                    (cs) => SelectFileAction(
                      icon: cs.displayIcon.iconData,
                      label: loc.loadFrom(cs.displayName),
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
                  SelectFileAction(
                    icon: Icons.create_new_folder,
                    label: loc.createNewFile,
                    backgroundColor: theme.primaryColor.darken(),
                    onPressed: () {
                      Navigator.of(context).push(CreateFile.route());
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              IntrinsicWidth(
                stepWidth: 100,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        loc.labelLastOpenFiles,
                        style: theme.textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
                      ...ListTile.divideTiles(
                        context: context,
                        tiles: appData?.previousFiles?.reversed
                                ?.take(5)
                                ?.takeIfNotEmpty()
                                ?.map(
                                  (f) => OpenedFileTile(
                                    openedFile:
                                        f.toFileSource(cloudStorageBloc),
                                    color: f.color,
                                    onPressed: () {
                                      final source =
                                          f.toFileSource(cloudStorageBloc);
                                      _loadAndGoToCredentials(source);
                                    },
                                  ),
                                ) ??
                            [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  loc.noFilesHaveBeenOpenYet,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openIosAndAndroidLocalFilePicker() async {
    final openFilePickerWritable = () async {
      await FilePickerWritable().openFile((fileInfo, file) async {
        await Navigator.of(context).push(CredentialsScreen.route(
          FileSourceLocal(
            file,
            uuid: AppDataBloc.createUuid(),
            filePickerIdentifier: fileInfo.toJsonString(),
            initialCachedContent: FileContent(await file.readAsBytes()),
          ),
        ));
      });
    };

    final kdbxFiles = await _containsKdbxFiles(
        await PathUtils().getAppDocDirectory(ensureCreated: false));
    if (kdbxFiles) {
      await showModalBottomSheet<void>(
        context: context,
        routeSettings: const RouteSettings(name: '/openfileLocal/chooser'),
        builder: (context) => OpenFileBottomSheet(
          openFilePickerWritable: openFilePickerWritable,
        ),
      );
    } else {
      _logger.fine('No kdbx files found, open FilePickerWritable');
      await openFilePickerWritable();
    }
  }

  Future<bool> _containsKdbxFiles(Directory dir) async {
    if (!dir.existsSync()) {
      return false;
    }
    await for (final f in dir.list(recursive: true)) {
      if (f is Directory) {
        continue;
      }
      _logger.finest('contains: ${dir.path}');
      if (f.path.endsWith(Env.KeePassExtension)) {
        // NON-NLS
        return true;
      }
    }
    return false;
  }

  void _loadAndGoToCredentials(FileSource source) {
    final loc = AppLocalizations.of(context);
    asyncRunTask((progress) {
      return source.content().last.then((value) {
        return Navigator.of(context).push(CredentialsScreen.route(source));
      }).catchError((dynamic error, StackTrace stackTrace) {
        _logger.fine('Error while trying to load file source $source');
        DialogUtils.showErrorDialog(context, 'Error while opening file.',
            'Unable to open $source.\n$error');
        return Future<dynamic>.error(error, stackTrace);
      });
    }, label: loc.loadingFile);
    setState(() {});
  }
}

class OpenFileBottomSheet extends StatelessWidget {
  const OpenFileBottomSheet({
    Key key,
    @required this.openFilePickerWritable,
  }) : super(key: key);

  final Future<void> Function() openFilePickerWritable;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const ImageIcon(AssetImage('assets/images/logo_icon.png')),
            title: Text(loc.internalFile),
            subtitle: Text(loc.internalFileSubtitle),
            onTap: () async {
              final filePath = await FilesystemPicker.open(
                context: context,
                rootDirectory:
                    await PathUtils().getAppDocDirectory(ensureCreated: true),
                fsType: FilesystemType.file,
                allowedExtensions: ['.kdbx'],
                fileTileSelectMode: FileTileSelectMode.wholeTile,
              );
              if (filePath == null) {
                _logger.fine('User canceled FilesystemPicker.');
                return;
              }
              final file = File(filePath);
              await Navigator.of(context).push(CredentialsScreen.route(
                  FileSourceLocal(file, uuid: AppDataBloc.createUuid())));
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.hdd),
            title: Text(loc.filePicker),
            subtitle: Text(loc.filePickerSubtitle),
            onTap: () async {
              await openFilePickerWritable();
            },
          )
        ],
      ),
    );
  }
}

class OpenedFileTile extends StatelessWidget {
  const OpenedFileTile({
    Key key,
    @required this.openedFile,
    this.onPressed,
    this.onLongPressed,
    @required this.color,
  }) : super(key: key);

  final FileSource openedFile;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitleStyle = TextStyle(
        color: ListTileTheme.of(context).textColor ??
            theme.textTheme.caption.color);
    return InkWell(
      onTap: onPressed,
      onLongPress: onLongPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
//        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(
              openedFile.displayIcon.iconData,
              color: ThemeUtil.iconColor(theme, color),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    openedFile.displayName,
                    style: const TextStyle(color: AuthPassTheme.linkColor),
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
  const SelectFileAction({
    Key key,
    this.icon,
    this.label,
    this.onPressed,
    this.backgroundColor,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 120,
        maxWidth: 120,
        minHeight: 96,
      ),
      // width: 120,
      // height: 96,
      child: Material(
//      shape: Border.all(),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: backgroundColor ?? theme.primaryColor,
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
          decoration: const InputDecoration(
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

abstract class KeyFile {
  Future<Uint8List> readAsBytes();

  String get displayName;
}

class KeyFileFile implements KeyFile {
  KeyFileFile(this.file);

  final File file;

  @override
  Future<Uint8List> readAsBytes() async {
    return await file.readAsBytes();
  }

  @override
  String get displayName => file.path;
}

class KeyFileInfo implements KeyFile {
  KeyFileInfo({@required this.fileInfo, @required this.bytes});

  final FileInfo fileInfo;
  final Uint8List bytes;

  @override
  Future<Uint8List> readAsBytes() async => bytes;

  @override
  String get displayName => fileInfo.fileName;
}

class _CredentialsScreenState extends State<CredentialsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _invalidPassword;

  final _controller = TextEditingController();
  Future<void> _loadingFile;

  KdbxBloc _kdbxBloc;
  bool _biometricQuickUnlockSupported = false;
  bool _biometricQuickUnlockActivated;

  KeyFile _keyFile;

  @override
  void initState() {
    super.initState();
    unawaited((() async {
      _logger.finest('Precaching...');
      await widget.kdbxFilePath.contentPreCache();
    })());
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
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.credentialsAppBarTitle),
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
                    Text(loc.credentialLabel),
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
                child: PasswordInputField(
                  controller: _controller,
                  labelText: loc.masterPasswordInputLabel,
                  autovalidateMode: _invalidPassword != null
                      ? AutovalidateMode.always
                      : AutovalidateMode.onUserInteraction,
                  validator: (_keyFile == null || _invalidPassword != null
                          ? SValidator.notEmpty(
                              msg: loc.masterPasswordEmptyValidator)
                          : SValidator<String>([])) +
                      SValidator.invalidValue(
                          invalidValue: _invalidPassword,
                          message: loc.masterPasswordIncorrectValidator),
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
                      ? loc.useKeyFile
                      : path.basename(_keyFile.displayName)),
                  onPressed: () async {
                    _invalidPassword = null;
                    if (AuthPassPlatform.isIOS || AuthPassPlatform.isAndroid) {
                      final fileInfo = await FilePickerWritable()
                          .openFile((fileInfo, file) async {
                        final keyFile = KeyFileInfo(
                            fileInfo: fileInfo,
                            bytes: await file.readAsBytes());
                        setState(() {
//                          writeTe
                          _keyFile = keyFile;
                        });
                        return fileInfo;
                      });
                      if (fileInfo == null) {
                        setState(() => _keyFile = null);
                      }
                    } else {
                      final result = await showOpenPanel();
                      if (!result.canceled) {
                        setState(() {
                          _keyFile = KeyFileFile(File(result.paths[0]));
                        });
                      } else {
                        setState(() {
                          _keyFile = null;
                        });
                      }
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
                          title: Text(
                            loc.saveMasterPasswordBiometric,
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
                        key: const ValueKey('continue'),
                        child: Text(loc.dialogContinue),
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

  String _fileExtension() {
    final filePath = widget.kdbxFilePath.displayPath;
    if (filePath == null) {
      return '';
    }
    return path.extension(filePath);
  }

  Future<void> _tryUnlock() async {
    if (_formKey.currentState.validate()) {
      final deps = Provider.of<Deps>(context, listen: false);
      final loc = AppLocalizations.of(context);
      final analytics = deps.analytics;
      final kdbxBloc = deps.kdbxBloc;
      final pw = _controller.text;
      final keyFileContents = await _keyFile?.readAsBytes();
      final stopWatch = Stopwatch();
      try {
        stopWatch.start();
        final openFileStream = kdbxBloc.openFile(
          widget.kdbxFilePath,
          Credentials.composite(
              pw == '' ? null : ProtectedValue.fromString(pw), keyFileContents),
          addToQuickUnlock: _biometricQuickUnlockActivated ?? false,
        );
        // TODO handle subsequent errors.
        final openIt = StreamIterator(openFileStream);
        _loadingFile = openIt.moveNext();
        setState(() {});
        await _loadingFile;
        final fileResult = openIt.current;
        analytics.trackTiming(
          'tryUnlockFile',
          fileResult.unlockStopwatch.elapsedMilliseconds,
          category: 'unlock',
          label: 'successfully unlocked (${fileResult.fileContent.source})',
        );
        analytics.events.trackTryUnlock(
          action: TryUnlockResult.success,
          ext: _fileExtension(),
          source: widget.kdbxFilePath.typeDebug,
        );
        final fileSource = fileResult.kdbxOpenedFile.fileSource;
        unawaited(kdbxBloc.continueLoadInBackground(openIt,
            debugName: '${fileSource.displayName}', fileSource: fileSource));
        await Navigator.of(context)
            .pushAndRemoveUntil(MainAppScaffold.route(), (route) => false);
      } on KdbxInvalidKeyException catch (e, stackTrace) {
        _logger.fine('Invalid credentials.', e, stackTrace);
        analytics.trackTiming(
          'tryUnlockFile',
          stopWatch.elapsedMilliseconds,
          category: 'unlock',
          label: 'invalid credentials',
        );
        analytics.events.trackTryUnlock(
          action: TryUnlockResult.invalidCredential,
          ext: _fileExtension(),
          source: widget.kdbxFilePath.typeDebug,
        );
        setState(() {
          _invalidPassword = pw;
          _formKey.currentState.validate();
        });
      } on FileAlreadyOpenException catch (e, stackTrace) {
        _logger.fine('File already open.', e, stackTrace);
        await _handleOpenError(
          analytics: analytics,
          result: TryUnlockResult.alreadyOpen,
          errorTitle: loc.errorOpenFileAlreadyOpenTitle,
          errorBody: loc.errorOpenFileAlreadyOpenBody(
            e.newFile.body.meta.databaseName.get(),
            e.openFileSource.displayPath,
            e.newFileSource.displayPath,
          ),
          stopWatch: stopWatch,
        );
      } catch (e, stackTrace) {
        _logger.fine('Unable to open kdbx file. ', e, stackTrace);
        await _handleOpenError(
          analytics: analytics,
          result: TryUnlockResult.failure,
          errorTitle: loc.errorUnlockFileTitle,
          errorBody: loc.errorUnlockFileBody(e),
          stopWatch: stopWatch,
        );
      } finally {
        if (mounted) {
          setState(() {
            _loadingFile = null;
          });
        } else {
          _logger.warning('User navigated away from $runtimeType, '
              'not updating UI.');
        }
      }
    }
  }

  Future<void> _handleOpenError({
    @required Analytics analytics,
    @required TryUnlockResult result,
    @required String errorTitle,
    @required String errorBody,
    @required Stopwatch stopWatch,
  }) async {
    analytics.trackTiming(
      'tryUnlockFile',
      stopWatch.elapsedMilliseconds,
      category: 'unlock',
      label: 'error: $result',
    );
    analytics.events.trackTryUnlock(
      action: TryUnlockResult.alreadyOpen,
      ext: _fileExtension(),
      source: widget.kdbxFilePath.typeDebug,
    );
    await DialogUtils.showErrorDialog(
      context,
      errorTitle,
      errorBody,
      routeAppend: 'errorOpenFile',
    );
  }
}
