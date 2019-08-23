import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kdbx/kdbx.dart';
import 'package:provider/provider.dart';

class PasswordList extends StatelessWidget {
  static Route<void> route() => MaterialPageRoute(
        settings: const RouteSettings(name: '/passwordList'),
        builder: (context) => PasswordList(),
      );

  @override
  Widget build(BuildContext context) {
    final kdbxBloc = Provider.of<KdbxBloc>(context);
    final allEntries = kdbxBloc.openedFiles.expand((f) => f.body.rootGroup.getAllEntries()).toList(growable: false);
    return PasswordListContent(
      entries: allEntries,
    );
  }
}

enum OverFlowMenuItems {
  lock,
}

class PasswordListContent extends StatelessWidget {
  const PasswordListContent({Key key, this.entries}) : super(key: key);

  final List<KdbxEntry> entries;

  @override
  Widget build(BuildContext context) {
    final commonFields = Provider.of<CommonFields>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthPass'),
        actions: <Widget>[
          PopupMenuButton<OverFlowMenuItems>(
            onSelected: (item) {
              switch (item) {
                case OverFlowMenuItems.lock:
                  Provider.of<KdbxBloc>(context).closeAllFiles();
                  Navigator.of(context).pushAndRemoveUntil(SelectFileScreen.route, (_) => false);
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: OverFlowMenuItems.lock, child: Text('Lock Files')),
            ],
          )
        ],
      ),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return ListTile(
            leading: Icon(Icons.lock_open),
            title: Text(commonFields.title.stringValue(entry) ?? '(no title)'),
//            subtitle: Text(commonFields.url.stringValue(entry) ?? '(no website)'),
            subtitle: Text(commonFields.userName.stringValue(entry) ?? '(no website)'),
          );
        },
      ),
    );
  }
}
