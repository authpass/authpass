import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/predefined_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

final _logger = Logger('group_list');

class GroupViewModel {
  GroupViewModel(this.group, this.file, this.kdbxBloc);

  final KdbxGroup group;
  final KdbxFile file;
  final KdbxBloc kdbxBloc;

  bool get isRoot => group.parent == null;

  IconData get icon => isRoot
      ? kdbxBloc.fileForKdbxFile(file).fileSource.displayIcon
      : PredefinedIcons.iconForGroup(group.icon.get());

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
    return Scaffold(
      appBar: AppBar(
        title: Text(parent == null ? 'Files' : parent.name.get()),
        actions: parent == null
            ? null
            : <Widget>[
                IconButton(
                  icon: Icon(FontAwesomeIcons.folderPlus),
                  onPressed: () async {
                    final newName = await SimplePromptDialog.showPrompt(
                      context,
                      const SimplePromptDialog(
                        title: 'New Group',
                        labelText: 'Name for the new group',
                      ),
                    );
                    if (newName != null) {
                      parent.file.createGroup(parent: parent, name: newName);
                    }
                  },
                ),
              ],
      ),
      body: StreamBuilder<ChangeEvent<KdbxNode>>(
          stream: parent?.changes,
          builder: (context, snapshot) {
            _logger.finer('snapshot: $snapshot ${parent?.groups?.length}');
            final rootGroups = _createViewModel(kdbxBloc);
            return ListView.builder(
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
                  onLongPress: () async {
//                    showModalBottomSheet(context: null, builder: () => )
                    final action = await showDialog<String>(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: Text(group.name),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () => Navigator.pop(context, 'delete'),
                            child: const ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (action == 'delete') {
                      _logger.fine('We should delete ${group.name}');
                      final oldParent = group.group.parent;
                      group.file.deleteGroup(group.group);
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Deleted group.'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              oldParent.file.move(group.group, oldParent);
                            },
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }),
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
