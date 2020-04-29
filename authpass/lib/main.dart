import 'dart:async';
import 'dart:io';

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/deps.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/theme.dart';
import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/l10n/AuthPassLocalizations.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:authpass/utils/logging_utils.dart';
import 'package:authpass/utils/path_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

final _logger = Logger('main');

void initIsolate({bool fromMain = false}) {
  LoggingUtils().setupLogging(fromMainIsolate: fromMain);
}

void main() => throw Exception('Run some env/*.dart');

Future<void> startApp(Env env) async {
  initIsolate(fromMain: true);
  _setTargetPlatformForDesktop();
  _logger.info(
      'Initialized logger. (${Platform.operatingSystem}, ${Platform.operatingSystemVersion}');

  FlutterError.onError = (errorDetails) {
    _logger.shout(
        'Unhandled Flutter framework (${errorDetails.library}) error.',
        errorDetails.exception,
        errorDetails.stack);
    _logger.fine(errorDetails.summary.toString());
    Analytics.trackError(errorDetails.summary.toString(), true);
  };

  await runZonedGuarded<Future<void>>(() async {
    runApp(AuthPassApp(env: env));
  }, (dynamic error, StackTrace stackTrace) {
    _logger.shout('Unhandled error in app.', error, stackTrace);
    Analytics.trackError(error.toString(), true);
  }, zoneSpecification: ZoneSpecification(
    fork: (Zone self, ZoneDelegate parent, Zone zone,
        ZoneSpecification specification, Map zoneValues) {
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
  /*if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else */
  if (Platform.isLinux || Platform.isWindows) {
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

class _AuthPassAppState extends State<AuthPassApp> with StreamSubscriberMixin {
  Deps _deps;
  AppData _appData;

  @override
  void initState() {
    super.initState();
    _deps = Deps(env: widget.env);
    PathUtils.runAppFinished.complete(true);
    _appData = _deps.appDataBloc.store.cachedValue;
    handleSubscription(
        _deps.appDataBloc.store.onValueChangedAndLoad.listen((appData) {
      if (_appData != appData) {
        setState(() {
          _appData = appData;
        });
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO generate localizations.
    _logger.fine(
        'Building AuthPass App state. route: ${WidgetsBinding.instance.window.defaultRouteName}');
    final authPassLocalizations = AuthPassLocalizations();
    return MultiProvider(
      providers: [
        Provider<Env>.value(value: _deps.env),
        Provider<Deps>.value(value: _deps),
        Provider<Analytics>.value(value: _deps.analytics),
        Provider<AuthPassLocalizations>.value(value: authPassLocalizations),
        Provider<CommonFields>.value(
            value: CommonFields(authPassLocalizations)),
        Provider<CloudStorageBloc>.value(value: _deps.cloudStorageBloc),
        Provider<AppDataBloc>.value(value: _deps.appDataBloc),
        StreamProvider<AppData>(
          create: (context) => _deps.appDataBloc.store.onValueChangedAndLoad,
          initialData: _deps.appDataBloc.store.cachedValue,
        ),
        StreamProvider<KdbxBloc>(
          create: (context) => _deps.kdbxBloc.openedFilesChanged
              .map((_) => _deps.kdbxBloc)
              .doOnData((data) {
            _logger.info('KdbxBloc updated.');
          }),
          updateShouldNotify: (a, b) => true,
          initialData: _deps.kdbxBloc,
        ),
        StreamProvider<OpenedKdbxFiles>.value(
          value: _deps.kdbxBloc.openedFilesChanged,
          initialData: _deps.kdbxBloc.openedFilesChanged.value,
        )
      ],
      child: MaterialApp(
        navigatorObservers: [AnalyticsNavigatorObserver(_deps.analytics)],
        title: 'AuthPass',
        debugShowCheckedModeBanner: false,
        theme: authPassLightTheme,
        darkTheme: authPassDarkTheme,
        themeMode: _toThemeMode(_appData?.theme),
//        themeMode: ThemeMode.light,
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          _deps.analytics.updateSizes(
            viewportSize: mq.size,
            displaySize: WidgetsBinding.instance.window.physicalSize,
            devicePixelRatio: WidgetsBinding.instance.window.devicePixelRatio,
          );
          final locale = Localizations.localeOf(context);
          return Provider.value(
            value: FormatUtils(locale: locale.toString()),
            child: child,
          );
        },
        onGenerateInitialRoutes: (initialRoute) {
          _logger.fine('initialRoute: $initialRoute');
          _deps.analytics.trackScreen(initialRoute);
          if (initialRoute.startsWith('/openFile')) {
            final uri = Uri.parse(initialRoute);
            final file = uri.queryParameters['file'];
            _logger.finer('uri: $uri /// file: $file');
            return [
//              MaterialPageRoute<void>(
//                  builder: (context) => const SelectFileScreen()),
              CredentialsScreen.route(
                  FileSourceLocal(File(file), uuid: AppDataBloc.createUuid())),
            ];
          }
          return [
            MaterialPageRoute<void>(
                builder: (context) => const SelectFileScreen())
          ];
        },
//        home: const SelectFileScreen(),
      ),
    );
  }

  ThemeMode _toThemeMode(AppDataTheme theme) {
    if (theme == null) {
      return null;
    }
    switch (theme) {
      case AppDataTheme.light:
        return ThemeMode.light;
      case AppDataTheme.dark:
        return ThemeMode.dark;
    }
    throw StateError('Invalid theme $theme');
  }
}

class AnalyticsNavigatorObserver extends NavigatorObserver {
  AnalyticsNavigatorObserver(this.analytics);

  final Analytics analytics;

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    _logger.finest('didPush');
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
