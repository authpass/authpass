import 'dart:io';

import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/cloud_storage_ui.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/utils/async_utils.dart';
import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

final _logger = Logger('manage_file');

class ManageFileScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fileSource.displayName),
      ),
      body: ManageFile(fileSource: fileSource),
    );
  }
}

class ManageFile extends StatefulWidget {
  const ManageFile({Key key, this.fileSource}) : super(key: key);

  final FileSource fileSource;

  @override
  _ManageFileState createState() => _ManageFileState();
}

class _ManageFileState extends State<ManageFile> with FutureTaskStateMixin {
  KdbxBloc _kdbxBloc;
  KdbxOpenedFile _file;
  final TextEditingController _databaseName = TextEditingController();

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
    _databaseName.text = _file.kdbxFile.body.meta.databaseName.get();
  }

  @override
  Widget build(BuildContext context) {
    _logger.finest('Is rebuilding with color ${_file.openedFile.color}');
    final cloudStorageBloc = Provider.of<CloudStorageBloc>(context);
    return ProgressOverlay(
      task: task,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 320),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: TextField(
                  decoration: const InputDecoration(labelText: 'Database Name'),
                  controller: _databaseName,
                ),
              ),
              ListTile(
                title: const Text('Path'),
                subtitle: Text(_file.fileSource.displayPath),
                trailing: PopupMenuButton<VoidCallback>(
                  onSelected: (action) => action(),
                  itemBuilder: (context) => [
                    ...?(Platform.isIOS || Platform.isAndroid
                        ? null
                        : [
                            PopupMenuItem(
                              child: const ListTile(
                                leading: Icon(FontAwesomeIcons.hdd),
                                title: Text('Save As...'),
                                subtitle: Text('Local File'),
                              ),
                              value: () {
                                _saveAsLocalFile();
                              },
                            )
                          ]),
                    ...cloudStorageBloc.availableCloudStorage.map(
                      (cs) => PopupMenuItem(
                        child: ListTile(
                          leading: Icon(cs.displayIcon),
                          title: const Text('Save As...'),
                          subtitle: Text('${cs.displayName}'),
                        ),
                        value: () {
                          _saveAsCloudStorage(cs);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Color'),
                subtitle: const Text('Select a color to distinguish beween files.'),
                trailing: CircleColor(color: _file.openedFile.color, circleSize: 24),
                onTap: () async {
                  final newColor = await ColorPickerDialog(
                    initialColor: _file.openedFile.color,
                  ).show(context);
                  _logger.fine('Selected color $newColor');
                  await _kdbxBloc.updateOpenedFile(_file, (b) => b.colorCode = newColor?.value);
                },
              ),
              ButtonBar(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    child: const Text('Close/Lock'),
                    onPressed: () async {
                      await _kdbxBloc.close(_file.kdbxFile);
                      Navigator.of(context).pop();
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _saveAsLocalFile() {
    if (Platform.isIOS || Platform.isAndroid) {
      // not yet supported.
      return;
    }
    showSavePanel(
      (result, paths) async {
        if (result == FileChooserResult.ok) {
          final path = paths.first;
          final outputFile = File(path);
          String macOsBookmark;
          if (Platform.isMacOS) {
            macOsBookmark = await SecureBookmarks().bookmark(outputFile);
          }
          final newFile = await _kdbxBloc.saveAs(
            _file,
            FileSourceLocal(
              outputFile,
              uuid: AppDataBloc.createUuid(),
              macOsSecureBookmark: macOsBookmark,
            ),
          );
          setState(() {
            _file = newFile;
          });
        }
      },
      suggestedFileName: path.basename(widget.fileSource.displayPath),
      confirmButtonText: 'Save',
    );
  }

  Future<void> _saveAsCloudStorage(CloudStorageProvider cs) async {
    final createFileInfo = await Navigator.of(context).push(CloudStorageSelector.route(
      cs,
      CloudStorageBrowserConfig(defaultFileName: path.basename(_file.fileSource.displayPath), isSave: true),
    ));
    if (createFileInfo != null) {
      await asyncRunTask((progress) async {
        final newFile = await _kdbxBloc.saveAsNewFile(_file, createFileInfo, cs);
        setState(() {
          _file = newFile;
        });
      });
//      cs.saveEntity(, bytes, previousMetadata)
    }
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

  Future<Color> show(BuildContext context) => showDialog<Color>(context: context, builder: (context) => this);

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
    _selectedColor = _defaultColors.firstWhere((color) => color.value == widget.initialColor?.value,
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
              availableColors: _defaultColors,
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

const _defaultColors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black,
];
