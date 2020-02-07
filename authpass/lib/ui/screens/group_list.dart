import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kdbx/kdbx.dart';
import 'package:provider/provider.dart';

class GroupViewModel {
  GroupViewModel(this.group, this.file, this.kdbxBloc);

  final KdbxGroup group;
  final KdbxFile file;
  final KdbxBloc kdbxBloc;

  bool get isRoot => group.parent == null;

  IconData get icon => isRoot
      ? kdbxBloc.fileForKdbxFile(file).fileSource.displayIcon
      : Icons.folder;

  String get name =>
      isRoot ? file.body.meta.databaseName.get() : group.name.get();
}

class GroupList extends StatelessWidget {
  const GroupList({Key key, this.parent}) : super(key: key);

  static Route<KdbxGroup> route(KdbxGroup parent) => MaterialPageRoute(
        settings:
            RouteSettings(name: '/groupList${parent == null ? '' : 'Child'}'),
        builder: (context) => GroupList(
          parent: parent,
        ),
      );

  final KdbxGroup parent;

  @override
  Widget build(BuildContext context) {
    final kdbxBloc = Provider.of<KdbxBloc>(context);
    final rootGroups = _createViewModel(kdbxBloc);
    return Scaffold(
      appBar: AppBar(
        title: Text(parent == null ? 'Files' : parent.name.get()),
      ),
      body: ListView.builder(
        itemCount: rootGroups.length,
        itemBuilder: (context, index) {
          final group = rootGroups[index];
          return ListTile(
            leading: Icon(group.icon),
            title: Text(group.name),
            trailing: IconButton(
              icon: Icon(FontAwesomeIcons.solidArrowAltCircleRight),
              onPressed: () async {
                final result = await Navigator.of(context)
                    .push(GroupList.route(group.group));
                if (result != null) {
                  Navigator.pop(context, result);
                }
              },
            ),
            onTap: () {
              Navigator.pop(context, group.group);
            },
          );
        },
      ),
    );
  }

  List<GroupViewModel> _createViewModel(KdbxBloc kdbxBloc) {
    if (parent == null) {
      return kdbxBloc.openedFilesKdbx
          .map((e) => GroupViewModel(e.body.rootGroup, e, kdbxBloc))
          .toList();
    } else {
      return parent.groups
          .map((e) => GroupViewModel(e, e.file, kdbxBloc))
          .toList();
    }
  }
}
