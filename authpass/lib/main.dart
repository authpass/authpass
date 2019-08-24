import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/deps.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/theme.dart';
import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/l10n/AuthPassLocalizations.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:provider/provider.dart';

final _logger = Logger('main');

void initIsolate() {
  Logger.root.level = Level.ALL;
  PrintAppender().attachToLogger(Logger.root);
  final isolateDebug = '${Isolate.current.debugName} (${Isolate.current.hashCode})';
  _logger.info('Running in isolate $isolateDebug ${Isolate.current.debugName} (${Isolate.current.hashCode})');

  Isolate.current.addOnExitListener(RawReceivePort((dynamic val) {
    print('exiting isolate $isolateDebug');
  }).sendPort);

  final exitPort = ReceivePort();
  exitPort.listen((dynamic data) {
    _logger.info('Exiting isolate $isolateDebug ${Isolate.current.debugName} (${Isolate.current.hashCode}');
  }, onDone: () {
    _logger.info('Done $isolateDebug');
  });
  Isolate.current.addOnExitListener(exitPort.sendPort, response: 'exit');
}

void main() => throw Exception('Run some env/*.dart');

Future<void> startApp(Env env) async {
  initIsolate();
  _setTargetPlatformForDesktop();
  _logger.info('Initialized logger.');
  await runZoned<Future<void>>(() async {
    runApp(AuthPassApp(env: env));
  }, onError: (dynamic error, StackTrace stackTrace) {
    _logger.shout('Unhandled error in app.', error, stackTrace);
  }, zoneSpecification: ZoneSpecification(
    fork: (Zone self, ZoneDelegate parent, Zone zone, ZoneSpecification specification, Map zoneValues) {
      print('Forking zone.');
      return parent.fork(zone, specification, zoneValues);
    },
  ));
}

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  _logger.info('targetPlatform: $targetPlatform');
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

class AuthPassApp extends StatefulWidget {
  const AuthPassApp({Key key, @required this.env}) : super(key: key);

  final Env env;

  @override
  _AuthPassAppState createState() => _AuthPassAppState();
}

class _AuthPassAppState extends State<AuthPassApp> {
  Deps _deps;

  @override
  void initState() {
    super.initState();
    _deps = Deps(env: widget.env);
  }

  @override
  Widget build(BuildContext context) {
    // TODO generate localizations.
    final authPassLocalizations = AuthPassLocalizations();
    return MultiProvider(
      providers: [
        Provider<Deps>.value(value: _deps),
        Provider<AuthPassLocalizations>.value(value: authPassLocalizations),
        Provider<CommonFields>.value(value: CommonFields(authPassLocalizations)),
        StreamProvider<AppData>(
          builder: (context) => _deps.appDataBloc.store.onValueChangedAndLoad,
          initialData: _deps.appDataBloc.store.cachedValue,
        ),
        ListenableProvider.value(value: _deps.kdbxBloc),
      ],
      child: MaterialApp(
        title: 'AuthPass',
        theme: createTheme(),
        home: SelectFileScreen(),
      ),
    );
  }
}
