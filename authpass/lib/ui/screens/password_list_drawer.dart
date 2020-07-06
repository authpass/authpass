import 'package:authpass/ui/screens/group_list.dart';
import 'package:authpass/ui/screens/password_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kdbx/kdbx.dart';

class PasswordListDrawer extends StatelessWidget {
  const PasswordListDrawer({
    Key key,
    @required this.initialSelection,
    @required this.selectionChanged,
  }) : super(key: key);

  final Set<KdbxGroup> initialSelection;
  final void Function(Set<KdbxGroup> selection) selectionChanged;

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
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomLeft,
            child: Text(
              'AuthPass',
              style: theme.primaryTextTheme.headline3,
            ),
          ),
        ),
        Expanded(
          child: GroupFilterFlatList(
            initialSelection: initialSelection,
            selectionChanged: selectionChanged,
          ),
        ),
      ],
    );
  }
}
