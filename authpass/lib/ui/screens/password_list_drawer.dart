import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/ui/screens/group_list.dart';
import 'package:authpass/utils/extension_methods.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kdbx/kdbx.dart';
import 'package:provider/provider.dart';

class PasswordListDrawer extends StatefulWidget {
  const PasswordListDrawer({
    Key? key,
    required this.initialSelection,
    required this.selectionChanged,
  }) : super(key: key);

  final Set<KdbxGroup?> initialSelection;
  final void Function(Set<KdbxGroup> selection) selectionChanged;

  @override
  _PasswordListDrawerState createState() => _PasswordListDrawerState();
}

class _PasswordListDrawerState extends State<PasswordListDrawer> {
  bool initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      context.read<Analytics>().events.trackDrawerOpen();
      initialized = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: theme.primaryColor,
          elevation: 2,
//          decoration: BoxDecoration(color: theme.primaryColor),
//          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16) +
                MediaQuery.of(context).padding.onlyTop,
            alignment: Alignment.bottomLeft,
            child: Text(
              Env.AuthPass,
              style: theme.primaryTextTheme.headline3,
            ),
          ),
        ),
        Expanded(
          child: GroupListBuilder(
            rootGroup: null,
            builder: (context, groups) => GroupFilterFlatList(
              groups: groups,
              initialSelection: widget.initialSelection,
              selectionChanged: widget.selectionChanged,
            ),
          ),
        ),
      ],
    );
  }
}
