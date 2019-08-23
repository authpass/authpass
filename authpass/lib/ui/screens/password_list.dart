import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthPass'),
      ),
      body: ListView.builder(
        itemCount: allEntries.length,
        itemBuilder: (context, index) {
          final entry = allEntries[index];
          return ListTile(
            title: Text(entry.label),
          );
        },
      ),
    );
  }
}
