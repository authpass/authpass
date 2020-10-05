import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/l10n/app_localizations.dart';
import 'package:authpass/theme.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/ui/widgets/savefile/save_file.dart';
import 'package:authpass/ui/widgets/savefile/save_file_helper.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/logging_utils.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart'
    hide FutureTaskStateMixin;
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:kdbx/kdbx.dart';

final _logger = Logger('manage_file');

class ManageFileScreen extends StatefulWidget {
  const ManageFileScreen({Key key, @required this.fileSource})
      : assert(fileSource != null),
        super(key: key);

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
  FileSource _currentFileSource;

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
        title: Text(_currentFileSource.displayName),
      ),
      body: ManageFile(
        fileSource: _currentFileSource,
        onFileSourceChanged: (fileSource) => setState(() {
          _currentFileSource = fileSource;
        }),
      ),
    );
  }
}

class ManageFile extends StatefulWidget {
  const ManageFile({
    Key key,
    @required this.fileSource,
    @required this.onFileSourceChanged,
  })  : assert(fileSource != null),
        assert(onFileSourceChanged != null),
        super(key: key);

  final FileSource fileSource;
  final void Function(FileSource newFileSource) onFileSourceChanged;

  @override
  _ManageFileState createState() => _ManageFileState();
}

class _ManageFileState extends State<ManageFile> with FutureTaskStateMixin {
  KdbxBloc _kdbxBloc;
  KdbxOpenedFile _file;

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
    _logger.finest('Is rebuilding with color ${_file.openedFile.color}');
    final databaseName = _file.kdbxFile.body.meta.databaseName.get();
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
                      title: 'Enter database name',
                      initialValue: databaseName,
                    ).show(context);
                    if (newName == null) {
                      _logger.fine('changing database name was canceled.');
                      return;
                    }
                    setState(() {
                      _file.kdbxFile.body.meta.databaseName.set(newName);
                    });
                    await asyncRunTask((progress) async {
                      await Future<int>.delayed(
                          const Duration(milliseconds: 100));
                      await _kdbxBloc.saveAs(
                        _file,
                        _file.fileSource.copyWithDatabaseName(newName),
                      );
                    }, label: loc.saving);
                  },
                ),
                ListTile(
                  title: const Text('Path'),
                  subtitle: Text(_file.fileSource.displayPath),
                  trailing: SaveFileAsDialogButton(_file,
                      onSave: (Future<void> fileSave) {
                    asyncRunTask((progress) async {
                      await fileSave;
                    }, label: loc.saving);
                  }, onFileSourceChanged: widget.onFileSourceChanged, local: true),
                ),
                ListTile(
                  title: const Text('Color'),
                  subtitle:
                      const Text('Select a color to distinguish beween files.'),
                  trailing: CircleColor(
                      color: _file.openedFile.color, circleSize: 24),
                  onTap: () async {
                    final newColor = await ColorPickerDialog(
                      initialColor: _file.openedFile.color,
                    ).show(context);
                    _logger.fine('Selected color $newColor');
                    _file = await _kdbxBloc.updateOpenedFile(
                        _file, (b) => b.colorCode = newColor?.value);
                    setState(() {});
                  },
                ),
                ListTile(
                  title: const Text('Kdbx File Version'),
                  subtitle: Text('${_file.kdbxFile.header.version} '
                      '(${_debugKdfType(_file.kdbxFile)})'),
                  trailing: _file.kdbxFile.header.version < KdbxVersion.V4
                      ? IconButton(
                          icon: const Icon(Icons.upgrade),
                          tooltip: 'Upgrade to ${KdbxVersion.V4}',
                          onPressed: asyncTaskCallback((progress) async {
                            _file.kdbxFile.upgrade(KdbxVersion.V4.major);
                            await _kdbxBloc.saveFile(_file.kdbxFile);
                            Scaffold.of(context).showSnackBar(const SnackBar(
                                content: Text(
                                    'Successfully upgraded file and saved.')));
                          }),
                        )
                      : null,
                ),
                ButtonBar(
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reload'),
                      onPressed: asyncTaskCallback((progress) async {
                        final appender = MemoryAppender()
                          ..attachToLogger(Logger.root);
                        var lastStatus = ReloadStatus.error;
                        try {
                          await for (final status in _kdbxBloc.reload(_file)) {
                            lastStatus = status;
                            progress.progressLabel = 'Status: $status';
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
                            title: 'Finished Merge $lastStatus',
                            log: appender.log,
                          ).open(context);
                        }
                      }),
                    ),
                    FlatButton(
                      child: const Text('Close/Lock'),
                      onPressed: () async {
                        await _kdbxBloc.close(_file.kdbxFile);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                if (env.isDebug) ...[
                  ButtonBar(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      FlatButton(
                        child: Text(
                            'DEBUG: Copy XML (${_file.kdbxFile.dirtyObjects?.length} dirty)'),
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(
                              text: _file.kdbxFile.body
                                  .toXml()
                                  .toXmlString(pretty: true)));
                        },
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
    Key key,
    this.color,
    this.elevation,
    this.circleSize,
  }) : super(key: key);

  static const double _kColorElevation = 4.0;
  final Color color;
  final double elevation;
  final double circleSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation ?? _kColorElevation,
      shape: const CircleBorder(),
      child: CircleAvatar(
        radius: circleSize / 2,
        backgroundColor: color,
        child: null,
      ),
    );
  }
}

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({Key key, this.initialColor}) : super(key: key);

  final Color initialColor;

  Future<Color> show(BuildContext context) =>
      showDialog<Color>(context: context, builder: (context) => this);

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color _selectedColor;

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
    _selectedColor = AuthPassTheme.defaultFileColors.firstWhere(
        (color) => color.value == widget.initialColor?.value,
        orElse: () => widget.initialColor);
  }

  @override
  Widget build(BuildContext context) {
    _logger.finest('selectedColor:$_selectedColor');
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
            RadioListTile<Color>(
              value: null,
              groupValue: _selectedColor,
              onChanged: (value) {
                _selectedColor = null;
              },
              title: const Text('Clear Color'),
              dense: true,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedColor);
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
