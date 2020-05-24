import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/ui/screens/group_edit.dart';
import 'package:authpass/ui/widgets/link_button.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/extension_methods.dart';
import 'package:authpass/utils/predefined_icons.dart';
import 'package:authpass/utils/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

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
      (isRoot ? file.body.meta.databaseName.get() : group.name.get())
          ?.nullIfBlank() ??
      '(Unnamed)';
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
                  icon: const Icon(FontAwesomeIcons.folderPlus),
                  onPressed: () async {
                    final newName = await const SimplePromptDialog(
                      title: 'New Group',
                      labelText: 'Name for the new group',
                    ).show(context);
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
//                  trailing: IconButton(
//                    icon: Icon(FontAwesomeIcons.solidArrowAltCircleRight),
//                    onPressed: () async {
//                      final result = await Navigator.of(context)
//                          .push(GroupList.route(group.group));
//                      if (result != null) {
//                        Navigator.pop(context, result);
//                      }
//                    },
//                  ),
                  onTap: () async {
                    final result = await Navigator.of(context)
                        .push(GroupList.route(group.group));
                    if (result != null) {
                      Navigator.of(context).pop(result);
                    }
                  },
                  onLongPress: () async {
//                    showModalBottomSheet(context: null, builder: () => )
                    final action = await showDialog<String>(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: Text(group.name),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () =>
                                Navigator.of(context).pop('filter'),
                            child: const ListTile(
                              leading: Icon(FontAwesomeIcons.filter),
                              title: Text('Show passwords'),
                            ),
                          ),
                          SimpleDialogOption(
                            onPressed: () =>
                                Navigator.of(context).pop('delete'),
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
                    } else if (action == 'filter') {
                      Navigator.of(context).pop(group.group);
                    } else if (action != null) {
                      throw StateError('Invalid action $action');
                    }
                  },
                );
              },
            );
          }),
    );
  }

  List<GroupViewModel> _createViewModel(KdbxBloc kdbxBloc) {
    final ret = parent == null
        ? kdbxBloc.openedFilesKdbx
            .map((e) => GroupViewModel(e.body.rootGroup, e, kdbxBloc))
            .toList()
        : parent.groups
            .map((e) => GroupViewModel(e, e.file, kdbxBloc))
            .toList();
    ret.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return ret;
  }
}

class _GroupViewModel {
  _GroupViewModel(this.kdbxBloc, this.file, this.group, this.level);

  final KdbxBloc kdbxBloc;
  final KdbxOpenedFile file;
  final KdbxGroup group;
  final int level;

  bool get isRoot => group.parent == null;

  IconData get icon => isRoot
      ? file.fileSource.displayIcon
      : PredefinedIcons.iconForGroup(group.icon.get());

  String get name =>
      (isRoot ? file.kdbxFile.body.meta.databaseName.get() : group.name.get())
          ?.nullIfBlank() ??
      '(Unnamed)';

  Color get color => file.openedFile.color;

  @override
  bool operator ==(dynamic other) {
    return other is _GroupViewModel && other.group == group;
  }

  @override
  int get hashCode => group.hashCode;
}

enum GroupListMode {
  multiSelectForFilter,
  singleSelect,
  manage,
}

extension on GroupListMode {
  bool get isSelection =>
      this == GroupListMode.multiSelectForFilter ||
      this == GroupListMode.singleSelect;
}

class GroupListFlat extends StatelessWidget {
  const GroupListFlat({
    Key key,
    this.initialSelection,
    this.groupListMode = GroupListMode.multiSelectForFilter,
    this.rootGroup,
  }) : super(key: key);

  static MaterialPageRoute<Set<KdbxGroup>> route(
    Set<KdbxGroup> selection, {
    GroupListMode groupListMode = GroupListMode.multiSelectForFilter,
    KdbxGroup rootGroup,
  }) =>
      MaterialPageRoute<Set<KdbxGroup>>(
        settings: const RouteSettings(name: '/group_list_flat/}'),
        builder: (_) => GroupListFlat(
          initialSelection: selection,
          groupListMode: groupListMode,
          rootGroup: rootGroup,
        ),
      );

  /// if defined only groups within this group will be shown,
  /// otherwise all groups in all files are shown.
  final KdbxGroup rootGroup;
  final Set<KdbxGroup> initialSelection;
  final GroupListMode groupListMode;

  @override
  Widget build(BuildContext context) {
    final kdbxBloc = Provider.of<KdbxBloc>(context);
    final file =
        rootGroup == null ? null : kdbxBloc.fileForKdbxFile(rootGroup.file);

    final streams =
        kdbxBloc.openedFilesKdbx.map((file) => file.dirtyObjectsChanged);
    return StreamBuilder<bool>(
        stream: Rx.merge(streams).map((x) => true),
        builder: (context, snapshot) {
          _logger.info('Rebuilding flat group list.');
          final groups = _createViewModel(kdbxBloc, file, rootGroup, 0);
          return GroupListFlatContent(
            groups: groups,
            initialSelection: initialSelection ?? {},
            groupListMode: groupListMode,
          );
        });
  }

  List<_GroupViewModel> _createViewModel(
      KdbxBloc kdbxBloc, KdbxOpenedFile file, KdbxGroup group, int depth) {
    if (file == null || group == null) {
      return kdbxBloc.openedFiles.values
          .expand((file) => _createViewModel(
              kdbxBloc, file, file.kdbxFile.body.rootGroup, depth))
          .toList();
    } else {
      return [
        _GroupViewModel(kdbxBloc, file, group, depth),
        ...group.groups
            // for now simply hide all trash groups.
            .where((element) => element.file.recycleBin != element)
            .expand((g) => _createViewModel(kdbxBloc, file, g, depth + 1)),
      ];
    }
  }
}

class GroupListFlatContent extends StatefulWidget {
  const GroupListFlatContent({
    Key key,
    this.groups,
    @required this.initialSelection,
    @required this.groupListMode,
  })  : assert(initialSelection != null),
        assert(groupListMode != null),
        super(key: key);

  final Set<KdbxGroup> initialSelection;
  final List<_GroupViewModel> groups;
  final GroupListMode groupListMode;

  @override
  _GroupListFlatContentState createState() => _GroupListFlatContentState();
}

class _GroupListFlatContentState extends State<GroupListFlatContent> {
  final Set<_GroupViewModel> _groupFilter = {};

  @override
  void initState() {
    super.initState();
    _initSelection();
  }

  @override
  void didUpdateWidget(GroupListFlatContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelection != widget.initialSelection) {
      _initSelection();
    }
  }

  void _initSelection() {
    _groupFilter.clear();
    _groupFilter.addAll(widget.groups
        .where((element) => widget.initialSelection.contains(element.group)));
  }

  bool get _allSelected => _groupFilter.length == widget.groups.length;

  @override
  Widget build(BuildContext context) {
    final kdbxBloc = Provider.of<KdbxBloc>(context);
    final isDirty = kdbxBloc.openedFiles.entries.any((element) =>
        element.key.supportsWrite &&
        element.value.kdbxFile.dirtyObjects.isNotEmpty);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.groupListMode == GroupListMode.multiSelectForFilter
            ? 'Filter Groups'
            : 'Groups'),
        actions: <Widget>[
          ...?!isDirty
              ? null
              : [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () async {
                        final scaffold = Scaffold.of(context);
                        final savedFiles = <String>[];
                        for (final entry in kdbxBloc.openedFiles.entries) {
                          if (entry.key.supportsWrite &&
                              entry.value.kdbxFile.dirtyObjects.isNotEmpty) {
                            await kdbxBloc.saveFile(entry.value.kdbxFile);
                            savedFiles.add(entry.key.displayName);
                          }
                        }
                        scaffold.showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Saved files into: ${savedFiles.join(', ')}')),
                        );
                      },
                    ),
                  ),
                ],
          ...?widget.groupListMode.isSelection
              ? [
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      Navigator.of(context)
                          .pop(_groupFilter.map((e) => e.group).toSet());
                    },
                  ),
                ]
              : null,
        ],
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (index == 0) {
              return _listHeader();
            }
            final group = widget.groups[index - 1];
            return GroupListTile(
              group: group,
              isSelected: _groupFilter.contains(group),
              groupListMode: widget.groupListMode,
              onChanged: (value) {
                setState(() {
                  if (value &&
                      widget.groupListMode == GroupListMode.singleSelect) {
                    _groupFilter.clear();
                  }
                  if (value) {
                    _groupFilter.add(group);
                  } else {
                    _groupFilter.remove(group);
                  }
                });
              },
              onLongPress: () async {
                final action = await showDialog<String>(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: Text(group.name),
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () => Navigator.of(context).pop('create'),
                        child: const ListTile(
                          leading: Icon(Icons.create_new_folder),
                          title: Text('Create Subgroup'),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.of(context).pop('edit'),
                        child: const ListTile(
                          leading: Icon(FontAwesomeIcons.edit),
                          title: Text('Edit'),
                        ),
                      ),
                      ...?group.isRoot
                          ? null
                          : [
                              SimpleDialogOption(
                                onPressed: () =>
                                    Navigator.of(context).pop('delete'),
                                child: const ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                ),
                              ),
                            ],
                    ],
                  ),
                );
                if (action == 'create') {
                  _logger.fine('Creating folder.');
                  final newGroup = group.file.kdbxFile
                      .createGroup(parent: group.group, name: 'New Group');
                  await Navigator.of(context)
                      .push(GroupEditScreen.route(newGroup));
                } else if (action == 'delete') {
                  _logger.fine('We should delete ${group.name}');
                  final oldParent = group.group.parent;
                  group.file.kdbxFile.deleteGroup(group.group);
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
                } else if (action == 'edit') {
                  await Navigator.of(context)
                      .push(GroupEditScreen.route(group.group));
                } else if (action != null) {
                  throw StateError('Invalid action $action');
                }
              },
            );
//        return CheckboxListTile(
//          value: _groupFilter.contains(group),
//          controlAffinity: ListTileControlAffinity.leading,
//          onChanged: (value) {},
//        );
          },
          itemCount: widget.groups.length + 1,
        ),
      ),
    );
  }

  Widget _listHeader() {
    if (widget.groupListMode != GroupListMode.multiSelectForFilter) {
      return const SizedBox();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text('Select which Groups to show (recursively)'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LinkButton(
            child: _allSelected
                ? const Text('Deselect all')
                : const Text('Select All'),
            onPressed: () {
              setState(() {
                if (_allSelected) {
                  _groupFilter.clear();
                } else {
                  _groupFilter.addAll(widget.groups.map((e) => e));
                }
              });
            },
          ),
        ),
      ],
    );
  }
}

class GroupListTile extends StatelessWidget {
  const GroupListTile({
    Key key,
    @required this.group,
    @required this.isSelected,
    @required this.groupListMode,
    @required this.onChanged,
    this.onLongPress,
  })  : assert(group != null),
        assert(onChanged != null),
//        assert(isSelected != null),
        super(key: key);

  static const _levelIndent = 16.0;

  final _GroupViewModel group;
  final bool isSelected;
  final void Function(bool selected) onChanged;
  final GroupListMode groupListMode;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        if (groupListMode == GroupListMode.multiSelectForFilter) {
          onChanged(!isSelected);
        } else {
          onChanged(true);
        }
      },
      onLongPress: onLongPress,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: group.level * _levelIndent,
                  maxWidth: group.level * _levelIndent,
                  minHeight: 4,
                  maxHeight: double.infinity,
                ),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: ThemeUtil.iconColor(theme, group.color)))),
            ...?_buildSelectWidget(),
            Icon(
              group.icon,
              size: 24,
              color: ThemeUtil.iconColor(theme, group.color),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(group.name, style: theme.textTheme.subtitle1),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(icon: Icon(Icons.more_vert), onPressed: onLongPress),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSelectWidget() {
    switch (groupListMode) {
      case GroupListMode.multiSelectForFilter:
        return [Checkbox(value: isSelected, onChanged: onChanged)];
      case GroupListMode.singleSelect:
        return [
          Radio<_GroupViewModel>(
              value: group,
              groupValue: isSelected ? group : null,
              onChanged: (val) {
                onChanged(true);
              })
        ];
      case GroupListMode.manage:
        return [const SizedBox(width: 16)];
    }
    throw StateError('Invalid groupListMode $groupListMode');
  }
}
