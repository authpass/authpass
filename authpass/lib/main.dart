import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/deps.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:provider/provider.dart';

final _logger = Logger('main');

void main() {
  Logger.root.level = Level.ALL;
  PrintAppender().attachToLogger(Logger.root);
  _logger.info('Initialized logger.');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deps = Deps();
    return MultiProvider(
      providers: [
        Provider<Deps>.value(value: deps),
        StreamProvider<AppData>(
          builder: (context) => deps.appDataBloc.store.onValueChangedAndLoad,
          initialData: deps.appDataBloc.store.cachedValue,
        ),
        ListenableProvider.value(value: deps.kdbxBloc),
      ],
      child: MaterialApp(
        title: 'AuthPass',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: SelectFileScreen(),
      ),
    );
  }
}
