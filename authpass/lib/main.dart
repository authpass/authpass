import 'dart:async';
import 'dart:io';

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/deps.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/theme.dart';
import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/l10n/AuthPassLocalizations.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/utils/logging_utils.dart';
import 'package:authpass/utils/path_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

final _logger = Logger('main');

void initIsolate({bool fromMain = false}) {
  LoggingUtils().setupLogging(fromMainIsolate: fromMain);
}

void main() => throw Exception('Run some env/*.dart');

Future<void> startApp(Env env) async {
  initIsolate(fromMain: true);
  _setTargetPlatformForDesktop();
  _logger.info('Initialized logger. (${Platform.operatingSystem}, ${Platform.operatingSystemVersion}');

  FlutterError.onError = (errorDetails) {
    _logger.shout(
        'Unhandled Flutter framework (${errorDetails.library}) error.', errorDetails.exception, errorDetails.stack);
    _logger.fine(errorDetails.summary.toString());
    Analytics.trackError(errorDetails.summary.toString(), true);
  };

  await runZoned<Future<void>>(() async {
    runApp(AuthPassApp(env: env));
  }, onError: (dynamic error, StackTrace stackTrace) {
    _logger.shout('Unhandled error in app.', error, stackTrace);
    Analytics.trackError(error.toString(), true);
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
    PathUtils.runAppFinished.complete(true);
  }

  @override
  Widget build(BuildContext context) {
    // TODO generate localizations.
    final authPassLocalizations = AuthPassLocalizations();
    return MultiProvider(
      providers: [
        Provider<Env>.value(value: _deps.env),
        Provider<Deps>.value(value: _deps),
        Provider<Analytics>.value(value: _deps.analytics),
        Provider<AuthPassLocalizations>.value(value: authPassLocalizations),
        Provider<CommonFields>.value(value: CommonFields(authPassLocalizations)),
        Provider<CloudStorageBloc>.value(value: _deps.cloudStorageBloc),
        StreamProvider<AppData>(
          builder: (context) => _deps.appDataBloc.store.onValueChangedAndLoad,
          initialData: _deps.appDataBloc.store.cachedValue,
        ),
        StreamProvider(
          builder: (context) => _deps.kdbxBloc.openedFilesChanged.map((_) => _deps.kdbxBloc),
          initialData: _deps.kdbxBloc,
        ),
      ],
      child: MaterialApp(
        navigatorObservers: [AnalyticsNavigatorObserver(_deps.analytics)],
        title: 'AuthPass',
        theme: createTheme(),
        home: SelectFileScreen(),
      ),
    );
  }
}

class AnalyticsNavigatorObserver extends NavigatorObserver {
  AnalyticsNavigatorObserver(this.analytics);

  final Analytics analytics;

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    _sendScreenView(route);
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _sendScreenView(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    _sendScreenView(previousRoute);
  }

  String _screenNameFor(Route route) {
    return route?.settings?.name;
  }

  void _sendScreenView(Route route) {
    final screenName = _screenNameFor(route);
    if (screenName != null) {
      analytics.trackScreen(route.settings.name);
    }
  }
}
