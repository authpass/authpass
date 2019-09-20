import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kdbx/kdbx.dart';
import 'package:provider/provider.dart';

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

class _ManageFileState extends State<ManageFile> {
  KdbxBloc _kdbxBloc;
  KdbxFile _file;

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
    _kdbxBloc = Provider.of<KdbxBloc>(context);
    _file = _kdbxBloc.fileForFileSource(widget.fileSource);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Database Name'),
            initialValue: _file.body.meta.databaseName.get(),
          ),
          InputDecorator(
            decoration: const InputDecoration(labelText: 'Path'),
            child: Text(widget.fileSource.displayPath),
          ),
          ButtonBar(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                child: const Text('Close/Lock'),
                onPressed: () async {
                  await _kdbxBloc.close(_file);
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
