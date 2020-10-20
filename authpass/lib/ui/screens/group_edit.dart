import 'package:authpass/ui/screens/app_bar_menu.dart';
import 'package:authpass/ui/screens/entry_details.dart';
import 'package:authpass/ui/screens/group_list.dart';
import 'package:authpass/ui/widgets/icon_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:kdbx/kdbx.dart';

class GroupEditScreen extends StatefulWidget {
  const GroupEditScreen({Key key, this.group}) : super(key: key);

  static MaterialPageRoute<void> route(KdbxGroup group) =>
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/group_edit/'),
        builder: (_) => GroupEditScreen(group: group),
      );

  final KdbxGroup group;

  @override
  _GroupEditScreenState createState() => _GroupEditScreenState();
}

class _GroupEditScreenState extends State<GroupEditScreen>
    with
        StreamSubscriberMixin<GroupEditScreen>,
        TaskStateMixin<GroupEditScreen>,
        KdbxObjectSavableStateMixin<GroupEditScreen> {
  @override
  final formKey = GlobalKey<FormState>();

  @override
  KdbxFile get file => widget.group.file;

  @override
  Changeable get kdbxObject => widget.group;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Group'),
        actions: [
          ...?!isDirty
              ? null
              : [
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: saveCallback,
                  ),
                ],
          AppBarMenu.createOverflowMenuButton(context),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          top: false,
          child: GroupEdit(group: widget.group, formKey: formKey),
        ),
      ),
    );
  }
}

class GroupEdit extends StatefulWidget {
  const GroupEdit({Key key, this.group, this.formKey}) : super(key: key);

  final KdbxGroup group;
  final GlobalKey<FormState> formKey;

  @override
  _GroupEditState createState() => _GroupEditState();
}

class _GroupEditState extends State<GroupEdit> {
  Iterable<String> _breadcrumbNames() =>
      widget.group.breadcrumbs.map((e) => e.name.get());

  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.group.name.get();
    _nameController.selection =
        TextSelection(baseOffset: 0, extentOffset: _nameController.text.length);
  }

  void _saveIcon(SelectedIcon icon) {
    icon.when(predefined: (predefined) {
      widget.group.customIcon = null;
      widget.group.icon.set(predefined);
    }, custom: (custom) {
      widget.group.customIcon = custom;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconSelectorFormField(
              initialValue: SelectedIcon.fromObject(widget.group),
              onSaved: _saveIcon,
              onChanged: _saveIcon,
              kdbxFile: widget.group.file,
            ),
            const SizedBox(height: 8),
            EntryMetaInfo(
              label: 'Group:',
              value: _breadcrumbNames().join(' » '),
              onTap: widget.group.parent == null
                  ? null
                  : () async {
                      // TODO
                      final file = widget.group.file;
                      final newGroupList = await Navigator.of(context).push(
                          GroupListFlat.route({widget.group.parent},
                              groupListMode: GroupListMode.singleSelect,
                              rootGroup: file.body.rootGroup));
                      final newGroup = newGroupList?.first;
                      if (newGroup != null) {
                        final oldGroup = widget.group.parent;
                        file.move(widget.group, newGroup);
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Moved entry into ${newGroup.name.get()}'),
                            action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  file.move(widget.group, oldGroup);
                                }),
                          ),
                        );
                      }
                    },
            ),
            const SizedBox(height: 8),
            TextFormField(
              maxLines: null,
              controller: _nameController,
              decoration: const InputDecoration(
//        fillColor: const Color(0xfff0f0f0),
                filled: true,
                prefixIcon: Icon(Icons.label),
                labelText: 'Group Name',
              ),
              keyboardType: TextInputType.text,
//    controller: controller,
//    onSaved: onSaved,
              autofocus: true,
              onSaved: (value) {
                widget.group.name.set(value);
              },
              onChanged: (value) {
                widget.group.name.set(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
