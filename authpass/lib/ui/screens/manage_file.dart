import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/theme.dart';
import 'package:authpass/ui/screens/master_password_change.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/ui/widgets/savefile/save_file_diag_button.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/logging_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart'
    hide FutureTaskStateMixin;
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('manage_file');

class ManageFileScreen extends StatefulWidget {
  const ManageFileScreen({Key? key, required this.fileSource})
      : super(key: key);

  final FileSource fileSource;

  static Route<void> route(FileSource fileSource) => MaterialPageRoute(
        settings: const RouteSettings(name: '/manageFile'),
        builder: (context) => ManageFileScreen(
          fileSource: fileSource,
        ),
      );

  @override
  _ManageFileScreenState createState() => _ManageFileScreenState();
}

class _ManageFileScreenState extends State<ManageFileScreen>
    with StreamSubscriberMixin {
  FileSource? _currentFileSource;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_currentFileSource == null) {
      _init();
    }
  }

  void _init() {
    // when changing the database name, we have to refresh the file source.
    final kdbxBloc = Provider.of<KdbxBloc>(context);
    _currentFileSource = widget.fileSource;
    handleSubscription(kdbxBloc.openedFilesChanged.listen((event) {
      setState(() {
        final newFile = kdbxBloc.fileForFileSource(widget.fileSource);
        if (newFile != null) {
          _currentFileSource = newFile.fileSource;
        }
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentFileSource!.displayName),
      ),
      body: ManageFile(
        fileSource: _currentFileSource!,
        onFileSourceChanged: (fileSource) => setState(() {
          _currentFileSource = fileSource;
        }),
      ),
    );
  }
}

class ManageFile extends StatefulWidget {
  const ManageFile({
    Key? key,
    required this.fileSource,
    required this.onFileSourceChanged,
  }) : super(key: key);

  final FileSource fileSource;
  final void Function(FileSource newFileSource) onFileSourceChanged;

  @override
  _ManageFileState createState() => _ManageFileState();
}

class _ManageFileState extends State<ManageFile> with FutureTaskStateMixin {
  late KdbxBloc _kdbxBloc;
  KdbxOpenedFile? _file;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_file == null) {
      _init();
    }
  }

  @override
  void didUpdateWidget(ManageFile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fileSource != widget.fileSource) {
      _init();
    }
  }

  void _init() {
    _logger.fine('Updating widget. _init()');
    _kdbxBloc = Provider.of<KdbxBloc>(context);
    _file = _kdbxBloc.fileForFileSource(widget.fileSource);
//    _databaseName.text = _file.kdbxFile.body.meta.databaseName.get();
  }

  @override
  Widget build(BuildContext context) {
    _logger.finest('Is rebuilding with color ${_file!.openedFile.color}');
    final databaseName = _file!.kdbxFile.body.meta.databaseName.get()!;
    final loc = AppLocalizations.of(context);
    final env = Provider.of<Env>(context);
    return ProgressOverlay(
      task: task,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 320),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text(databaseName),
                  trailing: const Icon(Icons.edit),
                  onTap: () async {
                    final newName = await SimplePromptDialog(
                      title: loc.databaseRenameInputLabel,
                      initialValue: databaseName,
                    ).show(context);
                    if (newName == null) {
                      _logger.fine('changing database name was canceled.');
                      return;
                    }
                    setState(() {
                      _file!.kdbxFile.body.meta.databaseName.set(newName);
                    });
                    await asyncRunTask((progress) async {
                      await Future<void>.delayed(
                          const Duration(milliseconds: 100));
                      await _kdbxBloc.saveAs(
                        _file!,
                        _file!.fileSource.copyWithDatabaseName(newName),
                      );
                    }, label: loc.saving);
                  },
                ),
                ListTile(
                  title: Text(loc.databasePath),
                  subtitle: Text(_file!.fileSource.displayPath),
                  trailing: SaveFileAsDialogButton(
                    file: _file!,
                    onSave: (fileSave) {
                      asyncRunTask((progress) async {
                        final f = await fileSave;
                        widget.onFileSourceChanged(f.fileSource);
                      }, label: loc.saving);
                    },
                    includeLocal: true,
                  ),
                ),
                ListTile(
                  title: Text(loc.databaseColor),
                  subtitle: Text(loc.databaseColorChoose),
                  trailing: CircleColor(
                      color: _file!.openedFile.color, circleSize: 24),
                  onTap: () async {
                    final newColor = await ColorPickerDialog(
                      initialColor: _file!.openedFile.color,
                    ).show(context);
                    _logger.fine('Selected color $newColor');
                    _file = await _kdbxBloc.updateOpenedFile(
                        _file!, (b) => b.colorCode = newColor?.value);
                    setState(() {});
                  },
                ),
                ListTile(
                  title: Text(loc.databaseKdbxVersion),
                  subtitle: Text(_file!.kdbxFile.header.version.toString() +
                      nonNls(' (${_debugKdfType(_file!.kdbxFile)})')),
                  trailing: _file!.kdbxFile.header.version < KdbxVersion.V4
                      ? IconButton(
                          icon: const Icon(Icons.upgrade),
                          tooltip:
                              loc.databaseKdbxUpgradeVersion(KdbxVersion.V4),
                          onPressed: asyncTaskCallback((progress) async {
                            _file!.kdbxFile.upgrade(KdbxVersion.V4.major);
                            await _kdbxBloc.saveFile(_file!.kdbxFile);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text(loc.databaseKdbxUpgradeSuccessful)));
                          }),
                        )
                      : null,
                ),
                ButtonBar(
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: Text(loc.databaseReload),
                      onPressed: asyncTaskCallback((progress) async {
                        final appender = MemoryAppender()
                          ..attachToLogger(Logger.root);
                        var lastStatus = ReloadStatus.error;
                        try {
                          await for (final status in _kdbxBloc.reload(_file!)) {
                            lastStatus = status;
                            progress.progressLabel = loc.progressStatus(status);
                          }
                        } catch (e, stackTrace) {
                          lastStatus = ReloadStatus.error;
                          _logger.severe('Error during merge.', e, stackTrace);
                        } finally {
                          // make sure logs are processed
                          await Future<void>.delayed(
                              const Duration(milliseconds: 100));
                          // final log = appender.log.toString();
                          await appender.dispose();
                          await LogViewerDialog(
                            title: loc.finishedMerge(lastStatus),
                            log: appender.log,
                          ).open(context);
                        }
                      }),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                            MasterPasswordChangeScreen.route(
                                fileSource: widget.fileSource));
                      },
                      icon: const Icon(Icons.lock),
                      label: Text(loc.changeMasterPasswordActionLabel),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _kdbxBloc.close(_file!.kdbxFile);
                        Navigator.of(context).pop();
                      },
                      child: Text(loc.closeAndLockFile),
                    ),
                  ],
                ),
                if (env.isDebug) ...[
                  ButtonBar(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(
                              text: _file!.kdbxFile.body
                                  .toXml()
                                  .toXmlString(pretty: true)));
                        },
                        child: Text(nonNls(
                            'DEBUG: Copy XML (${_file!.kdbxFile.dirtyObjects.length} dirty)')),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @NonNls
  String _debugKdfType(KdbxFile file) {
    final cipher = file.header.cipher;
    final cipherName = cipher.toString().split('.').last;
    final innerEncryption =
        file.header.innerRandomStreamEncryption.toString().split('.').last;
    var ret = 'Cipher: $cipherName, Inner: $innerEncryption';
    if (file.header.version < KdbxVersion.V4) {
      return '$ret, Kdf: AES, rounds: ${file.header.v3KdfTransformRounds}';
    } else {
      // kdbx 4
      final kdf = file.header.readKdfParameters;
      final kdfType = KeyEncrypterKdf.kdfTypeFor(kdf);
      switch (kdfType) {
        case KdfType.Aes:
          ret += ', Kdf: AES, rounds: ${KdfField.rounds.read(kdf)}';
          break;
        case KdfType.Argon2:
          final p = KdfField.parallelism.read(kdf);
          final m = KdfField.memory.read(kdf);
          final i = KdfField.iterations.read(kdf);
          ret += ', Kdf: Argon2, parallelism: $p, memory: $m, iterations: $i';
          break;
      }
    }
    return ret;
  }
}

class CircleColor extends StatelessWidget {
  const CircleColor({
    Key? key,
    this.color,
    this.elevation,
    this.circleSize,
  }) : super(key: key);

  static const double _kColorElevation = 4.0;
  final Color? color;
  final double? elevation;
  final double? circleSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation ?? _kColorElevation,
      shape: const CircleBorder(),
      child: CircleAvatar(
        radius: circleSize! / 2,
        backgroundColor: color,
        child: null,
      ),
    );
  }
}

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({Key? key, this.initialColor}) : super(key: key);

  final Color? initialColor;

  Future<Color?> show(BuildContext context) =>
      showDialog<Color>(context: context, builder: (context) => this);

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(ColorPickerDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialColor != widget.initialColor) {
      _init();
    }
  }

  void _init() {
    _selectedColor = AuthPassTheme.defaultFileColors.firstWhereOrNull(
            (color) => color.value == widget.initialColor?.value) ??
        widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    _logger.finest('selectedColor:$_selectedColor');
    final loc = AppLocalizations.of(context);
    final matLoc = MaterialLocalizations.of(context);
    return AlertDialog(
      contentPadding: const EdgeInsets.all(6.0),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BlockPicker(
              availableColors: AuthPassTheme.defaultFileColors,
              pickerColor: _selectedColor ?? Colors.white,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
            RadioListTile<Color?>(
              value: null,
              groupValue: _selectedColor,
              onChanged: (value) {
                _selectedColor = null;
              },
              title: Text(loc.clearColor),
              dense: true,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedColor);
          },
          child: Text(matLoc.okButtonLabel),
        ),
      ],
    );
  }
}
