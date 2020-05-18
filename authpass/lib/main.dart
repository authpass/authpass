import 'dart:async';
import 'dart:io';

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/deps.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/env/fdroid.dart';
import 'package:authpass/theme.dart';
import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/l10n/AuthPassLocalizations.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:authpass/utils/logging_utils.dart';
import 'package:authpass/utils/path_utils.dart';
import 'package:diac_client/diac_client.dart';
import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flushbar/flushbar_route.dart' as flushbar_route;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:flutter_store_listing/flutter_store_listing.dart';
import 'package:logging/logging.dart';
import 'package:package_info/package_info.dart';
import 'package:pedantic/pedantic.dart';
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
      'Initialized logger. (${Platform.operatingSystem}, ${Platform.operatingSystemVersion})');

  FlutterError.onError = (errorDetails) {
    _logger.shout(
        'Unhandled Flutter framework (${errorDetails.library}) error.',
        errorDetails.exception,
        errorDetails.stack);
    _logger.fine(errorDetails.summary.toString());
    Analytics.trackError(errorDetails.summary.toString(), true);
  };

  FutureTaskStateMixin.defaultShowErrorDialog = (error) {
    DialogUtils.showErrorDialog(
      error.context,
      error.title,
      error.message,
    );
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
  final _navigatorKey = GlobalKey<NavigatorState>();
  FilePickerState _filePickerState;

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
    _filePickerState = FilePickerWritable().init()
      ..registerFileInfoHandler((fileInfo) {
        _logger.fine('got a new fileInfo: $fileInfo');
        final openRoute = () async {
          var i = 0;
          while (_navigatorKey.currentState == null) {
            _logger.finest('No navigator yet. waiting. $i');
            await Future<void>.delayed(const Duration(milliseconds: 100));
            if (i++ > 100) {
              _logger.warning('Giving up $fileInfo');
              return;
            }
          }
          await _navigatorKey.currentState
              .push(CredentialsScreen.route(FileSourceLocal(
            fileInfo.file,
            uuid: AppDataBloc.createUuid(),
            filePickerIdentifier: fileInfo.toJsonString(),
          )));
        };
        openRoute();
        return true;
      });
  }

  @override
  Widget build(BuildContext context) {
    // TODO generate localizations.
    _logger.fine('Building AuthPass App state. route: '
        '${WidgetsBinding.instance.window.defaultRouteName}');
    final authPassLocalizations = AuthPassLocalizations();
    return MultiProvider(
      providers: [
        Provider<DiacBloc>(
          create: (context) => _createDiacBloc(),
          dispose: (context, diac) => diac.dispose(),
        ),
        Provider<FilePickerState>.value(value: _filePickerState),
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
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: _customizeTheme(authPassLightTheme, _appData),
        darkTheme: _customizeTheme(authPassDarkTheme, _appData),
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
          final ret = Provider.value(
            value: FormatUtils(locale: locale.toString()),
            child: child,
          );
          if (_appData?.themeFontSizeFactor != null) {
            return TweenAnimationBuilder<double>(
                tween: Tween<double>(
                    begin: _appData.themeFontSizeFactor,
                    end: _appData.themeFontSizeFactor),
                duration: const Duration(milliseconds: 100),
                builder: (context, value, child) {
                  return MediaQuery(
                    data: mq.copyWith(textScaleFactor: value),
                    child: ret,
                  );
                });
          }
          return ret;
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
        // this is actually never used. But i still have to define it,
        // because of https://github.com/flutter/flutter/blob/f64f6e2b6bf5802f23d6a0e3896541b213be490a/packages/flutter/lib/src/widgets/app.dart#L226-L243
        // (defining a navigatorKey requires defining a `routes`)
        routes: {'/open': (context) => const SelectFileScreen()},
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

  ThemeData _customizeTheme(ThemeData theme, AppData appData) {
    if (appData == null) {
      return theme;
    }

    final visualDensity = appData.themeVisualDensity != null
        ? VisualDensity(
            horizontal: appData.themeVisualDensity,
            vertical: appData.themeVisualDensity)
        : theme.visualDensity;
    _logger.fine('appData.themeFontSizeFactor: ${appData.themeFontSizeFactor}');
//    final textTheme = appData.themeFontSizeFactor != null
//        ? theme.textTheme.apply(fontSizeFactor: appData.themeFontSizeFactor)
//        : theme.textTheme;
    return theme.copyWith(
      visualDensity: visualDensity,
//      textTheme: textTheme,
    );
  }

  DiacBloc _createDiacBloc() {
    final disableOnlineMessages =
        _deps.env.diacDefaultDisabled && _appData.diacOptIn != true;
    _logger.finest('_createDiacBloc: $disableOnlineMessages = '
        '${_deps.env.diacDefaultDisabled} && ${_appData.diacOptIn}');
    return DiacBloc(
      opts: DiacOpts(
          endpointUrl: _deps.env.diacEndpoint,
          disableConfigFetch: disableOnlineMessages,
          // always reload after a new start.
          refetchIntervalCold: Duration.zero,
          initialConfig: !disableOnlineMessages
              ? null
              : DiacConfig(updatedAt: DateTime(2020, 5, 18), messages: [
                  DiacMessage(
                    uuid: 'e7373fa7-a793-4ed5-a2d1-d0a037ad778a',
                    body:
                        'Hello ${widget.env is FDroid ? 'F-Droid user' : 'there'}, thanks for using AuthPass! '
                        'I would love to occasionally display relevant news, surveys, etc (like this one ;), '
                        'no ads, spam, etc). You can disable it anytime.',
                    key: 'ask-opt-in',
                    expression: 'user.days > 0',
                    actions: const [
                      DiacMessageAction(
                        key: 'yes',
                        label: '👍️ Yes, Opt In',
                        url: 'diac:diacOptIn',
                      ),
                      DiacMessageAction(
                        key: 'no',
                        label: 'No, Sorry',
                        url: 'diac:diacNoOptIn',
                      ),
                    ],
                  ),
                ])),
      contextBuilder: () async => {
        'env': <String, Object>{
          'isDebug': _deps.env.isDebug,
          'isGoogleStore': (await PackageInfo.fromPlatform()).packageName ==
                  'design.codeux.authpass' &&
              Platform.isAndroid,
          'isIOS': Platform.isIOS,
          'isAndroid': Platform.isAndroid,
          'operatingSystem': Platform.operatingSystem,
        },
      },
      customActions: {
        'launchReview': (event) async {
          _deps.analytics.trackGenericEvent('review', 'reviewLaunch');
          return await FlutterStoreListing().launchStoreListing();
        },
        'requestReview': (event) async {
          _deps.analytics.trackGenericEvent('review', 'reviewRequest');
          return await FlutterStoreListing()
              .launchRequestReview(onlyNative: true);
        },
        'diacOptIn': (event) async {
          final flushbar = FlushbarHelper.createSuccess(message: 'Thanks! 🎉️');
          final route = flushbar_route.showFlushbar<void>(
              context: context, flushbar: flushbar);
          unawaited(_navigatorKey.currentState?.push<void>(route));
          await _deps.appDataBloc
              .update((builder, data) => builder.diacOptIn = true);
          return true;
        },
        'diacNoOptIn': (event) async {
          final flushbar = FlushbarHelper.createInformation(
              message: '😢️ Too bad, if you ever change your mind, '
                  'check out the preferences 🙏️.');
          final route = flushbar_route.showFlushbar<void>(
              context: context, flushbar: flushbar);
          await _navigatorKey.currentState?.push<void>(route);
          return true;
        }
      },
    )..events.listen((event) {
        _deps.analytics.trackGenericEvent(
          'diac',
          event is DiacEventWithAction
              ? 'dismissed:${event.action?.key}'
              : event.type.toStringBare(),
          label: event.message.key,
        );
      });
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
    return route?.settings?.name ?? '${route?.runtimeType}';
  }

  void _sendScreenView(Route route) {
    final screenName = _screenNameFor(route);
    if (screenName != null) {
      analytics.trackScreen(screenName);
    }
  }
}
