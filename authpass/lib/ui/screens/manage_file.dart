import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import 'package:logging/logging.dart';
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
      body: Center(child: ManageFile(fileSource: fileSource)),
    );
  }
}

class ManageFile extends StatefulWidget {
  const ManageFile({Key key, this.fileSource}) : super(key: key);

  final FileSource fileSource;

  @override
  _ManageFileState createState() => _ManageFileState();
}

class _ManageFileState extends State<ManageFile> {
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
    _init();
  }

  @override
  void didUpdateWidget(ManageFile oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
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
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 320),
//      alignment: Alignment.center,
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
            subtitle: Text(widget.fileSource.displayPath),
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
    );
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
