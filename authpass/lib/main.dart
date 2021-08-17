import 'dart:async';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart' as flushbar_route;
import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/authpass_cloud_bloc.dart';
import 'package:authpass/bloc/deps.dart';
import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx/file_source_local.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/authpasscloud/authpass_cloud_provider.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_ui_authpass_cloud.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/env/fdroid.dart';
import 'package:authpass/theme.dart';
import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/screens/onboarding/onboarding.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/utils/cache_manager.dart';
import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/diac_utils.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/extension_methods.dart';
import 'package:authpass/utils/file_picker_writable_noop.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:authpass/utils/logging_utils.dart';
import 'package:authpass/utils/path_utils.dart';
import 'package:authpass/utils/platform.dart';
import 'package:authpass/utils/winsparkle_init_noop.dart'
    if (dart.library.io) 'package:authpass/utils/winsparkle_init.dart';
import 'package:collection/collection.dart';
import 'package:diac_client/diac_client.dart';
import 'package:file/local.dart';
import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_store_listing/flutter_store_listing.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simple_json_persistence/simple_json_persistence.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('main');

void initIsolate({bool fromMain = false}) {
  LoggingUtils().setupLogging(fromMainIsolate: fromMain);
}

void main() => throw Exception('Run some env/*.dart');

final startupStopwatch = Stopwatch();

Future<void> startApp(Env env) async {
  startupStopwatch
    ..start()
    ..reset();

  StoreBackend.defaultBaseDirectoryBuilder =
      () async => (await PathUtils().getAppDataDirectory()).path;

  initIsolate(fromMain: true);
  _setTargetPlatformForDesktop();
  _logger.info('Initialized logger. '
      '(${AuthPassPlatform.operatingSystem}, ${AuthPassPlatform.operatingSystemVersion}) ${startupStopwatch.elapsedMilliseconds}');
  if (!AuthPassPlatform.isWeb) {
    _logger.info('${AuthPassPlatform.debugInfo()}');
    unawaited(Future<dynamic>.delayed(const Duration(seconds: 10))
        .then((dynamic value) async {
      _logger.info('DeviceInfo: ${await LoggingUtils.getDebugDeviceInfo()}');
    }));
  }

  if (env.overrideFlutterOnError) {
    FlutterError.onError = (errorDetails) {
      _logger.shout(
          'Unhandled Flutter framework (${errorDetails.library}) error.',
          errorDetails.exception,
          errorDetails.stack);
      _logger.fine(errorDetails.summary.toString());
      Analytics.trackError(errorDetails.summary.toString(), true);
    };
  }

  FutureTaskStateMixin.defaultShowErrorDialog = (error) {
    DialogUtils.showErrorDialog(
      error.context,
      error.title,
      error.message,
    );
  };

  final navigatorKey = GlobalKey<NavigatorState>();

  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final deps = Deps(env: env);
    deps.kdbxBloc.delegate = KdbxBlocDelegateHandler(navigatorKey);
    final appData = await deps.appDataBloc.store.load();
    runApp(AuthPassApp(
      env: env,
      deps: deps,
      navigatorKey: navigatorKey,
      isFirstRun: appData.previousFiles.isEmpty,
    ));
  }, (dynamic error, StackTrace stackTrace) {
    _logger.shout('Unhandled error in app.', error, stackTrace);
    Analytics.trackError(error.toString(), true);
    navigatorKey.currentState?.overlay?.context.let((context) {
      String? message = 'Unexpected error: $error'; // NON-NLS
      try {
        message =
            AppLocalizations.of(context).unexpectedError(error.toString());
      } catch (e, stackTrace) {
        _logger.fine('Error while localizing error message', e, stackTrace);
      }
      DialogUtils.showErrorDialog(context, null, message);
    });
  }, zoneSpecification: ZoneSpecification(
    fork: (Zone self, ZoneDelegate parent, Zone zone,
        ZoneSpecification? specification, Map? zoneValues) {
      // ignore: avoid_print
      print('Forking zone.'); // NON-NLS
      return parent.fork(zone, specification, zoneValues);
    },
  ));
}

class KdbxBlocDelegateHandler extends KdbxBlocDelegate {
  KdbxBlocDelegateHandler(this.navigatorKey);

  GlobalKey<NavigatorState> navigatorKey;

  @override
  void conflictMerged(
      FileSource fileSource, KdbxFile file, MergeContext merge) {
    final context = navigatorKey.currentContext;
    if (context == null) {
      return;
    }
    final loc = AppLocalizations.of(context);
    DialogUtils.showSimpleAlertDialog(
      context,
      loc.mergeSuccessDialogTitle,
      loc.mergeSuccessDialogMessage(
          fileSource.displayName, merge.debugSummary()),
      routeAppend: 'merged',
    );
  }
}

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  // this is no longer needed.

  // TargetPlatform? targetPlatform;
  // /*if (AuthPassPlatform.isMacOS) {
  //   targetPlatform = TargetPlatform.iOS;
  // } else */
  // if (AuthPassPlatform.isLinux || AuthPassPlatform.isWindows) {
  //   targetPlatform = TargetPlatform.android;
  // }
  // _logger.info('targetPlatform: $targetPlatform');
  // if (targetPlatform != null) {
  //   debugDefaultTargetPlatformOverride = targetPlatform;
  // }
}

class AuthPassApp extends StatefulWidget {
  const AuthPassApp({
    Key? key,
    required this.env,
    this.navigatorKey,
    required this.deps,
    required this.isFirstRun,
  }) : super(key: key);

  final Env env;
  final Deps deps;
  final GlobalKey<NavigatorState>? navigatorKey;
  final bool isFirstRun;
  @visibleForTesting
  static GlobalKey<NavigatorState>? currentNavigatorKey;

  @override
  // ignore: no_logic_in_create_state
  _AuthPassAppState createState() {
    currentNavigatorKey = navigatorKey;
    return _AuthPassAppState();
  }
}

class _AuthPassAppState extends State<AuthPassApp> with StreamSubscriberMixin {
  late final Deps _deps = widget.deps;
  AppData? _appData;
  late final FilePickerState _filePickerState = _initFilePickerState();

  GlobalKey<NavigatorState>? get _navigatorKey => widget.navigatorKey;

  @override
  void initState() {
    super.initState();
    PathUtils.runAppFinished.complete(true);
    _appData = _deps.appDataBloc.store.cachedValue;
    handleSubscription(
        _deps.appDataBloc.store.onValueChangedAndLoad.listen((appData) {
      if (_appData != appData) {
        setState(() {
          _appData = appData;
        });
        if (AuthPassPlatform.isAndroid) {
          if (appData.secureWindowOrDefault) {
            FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
          } else {
            FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
          }
        }
      }
    }));
    if (AuthPassPlatform.isWindows) {
      if (AuthPassPlatform.isWindowsWinAutoUpdate) {
        _logger.info('Initializing winsparkle.');
        initWinSparkle(widget.env);
      } else {
        _logger.info('Disabled winsparkle.');
      }
    }
  }

  FilePickerState _initFilePickerState() {
    // file picker writable currently has only ios, android, macos support.
    if (AuthPassPlatform.isIOS ||
        AuthPassPlatform.isAndroid ||
        AuthPassPlatform.isMacOS) {
      return FilePickerWritable().init()
        ..registerFileOpenHandler((fileInfo, file) async {
          _logger.fine('got a new fileInfo: $fileInfo');
          Future<void> openRoute() async {
            var i = 0;
            while (_navigatorKey?.currentState == null) {
              _logger.finest('No navigator yet. waiting. $i');
              await Future<void>.delayed(const Duration(milliseconds: 100));
              if (i++ > 100) {
                _logger.warning('Giving up $fileInfo');
                return;
              }
            }
            await _navigatorKey!.currentState!
                .push(CredentialsScreen.route(FileSourceLocal(
              (const LocalFileSystem()).file(file.path),
              uuid: AppDataBloc.createUuid(),
              filePickerIdentifier: fileInfo.toJsonString(),
              initialCachedContent: FileContent(await file.readAsBytes()),
            )));
          }

          await openRoute();
          return true;
        })
        ..registerErrorEventHandler((errorEvent) async {
          _logger.severe('Error received from file picker. $errorEvent');
          Analytics.trackError('FilePickerWritable: $errorEvent', false);
          return true;
        });
    } else {
      return FilePickerStateNoop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO generate localizations.
    _logger.fine('Building AuthPass App state. route: '
        '${WidgetsBinding.instance!.window.defaultRouteName}');
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
        Provider<CloudStorageBloc>.value(value: _deps.cloudStorageBloc),
        Provider<AppDataBloc>.value(value: _deps.appDataBloc),
        Provider<AuthPassCacheManager>(
          create: (context) => AuthPassCacheManager(
            pathUtils: PathUtils(),
            env: _deps.env,
          ),
          dispose: (context, obj) => obj.store.dispose(),
        ),
        StreamProvider<AppData>(
          create: (context) => _deps.appDataBloc.store.onValueChangedAndLoad,
          initialData: _deps.appDataBloc.store.cachedValue ?? AppData(),
        ),
        ProxyProvider2<AppData, Env, FeatureFlags>(
          update: (_, appData, env, __) {
            if (appData.manualUserType == AppData.manualUserTypeAdmin) {
              return (env.featureFlags.toBuilder()..authpassCloud = true)
                  .build();
            }
            return env.featureFlags;
          },
        ),
        ListenableProxyProvider<FeatureFlags, AuthPassCloudBloc>(
          create: (_) => AuthPassCloudBlocDummy(),
          update: (_, featureFlags, previous) {
            _logger.info('creating AuthPassCloudBloc.');
            if (previous != null &&
                previous is! AuthPassCloudBlocDummy &&
                previous.featureFlags == featureFlags) {
              return previous;
            }
//            previous?.dispose();
            final bloc = AuthPassCloudBloc(
              env: _deps.env,
              featureFlags: featureFlags,
            );

            _deps.cloudStorageBloc.availableCloudStorage
                .whereType<AuthPassCloudProvider>()
                .firstOrNull
                ?.let((that) => that.authPassCloudBloc = bloc);
            return bloc;
          },
          dispose: (_, prev) {
            prev.dispose();
          },
          // eagerly create bloc so everything is loaded once we
          // get into the context menu
          lazy: false,
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
        title: AppConstants.authPass,
        navigatorKey: widget.navigatorKey,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        theme: _customizeTheme(authPassLightTheme, _appData),
        darkTheme: _customizeTheme(authPassDarkTheme, _appData),
        themeMode: _toThemeMode(_appData?.theme),
        locale: _parseLocale(_appData?.localeOverride),
//        themeMode: ThemeMode.light,
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          _deps.analytics.updateSizes(
            viewportSizeWidth: mq.size.width,
            viewportSizeHeight: mq.size.height,
            displaySizeWidth:
                WidgetsBinding.instance!.window.physicalSize.width,
            displaySizeHeight:
                WidgetsBinding.instance!.window.physicalSize.height,
            devicePixelRatio: WidgetsBinding.instance!.window.devicePixelRatio,
          );
          final locale = Localizations.localeOf(context);
          final localizations = AppLocalizations.of(context);
          final Widget ret = MultiProvider(
            providers: [
              Provider.value(value: FormatUtils(locale: locale.toString())),
              Provider<CommonFields>.value(value: CommonFields(localizations)),
            ],
            child: child,
          );
          if (_appData?.themeFontSizeFactor != null) {
            return TweenAnimationBuilder<double>(
                tween: Tween<double>(
                    begin: _appData!.themeFontSizeFactor,
                    end: _appData!.themeFontSizeFactor),
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
          _deps.analytics.events.trackLaunch(
              systemBrightness:
                  WidgetsBinding.instance!.window.platformBrightness);
          if (startupStopwatch.isRunning) {
            startupStopwatch.stop();
            _deps.analytics.trackTiming(
              'startup',
              startupStopwatch.elapsedMilliseconds,
              category: 'startup',
              label: widget.isFirstRun ? 'startup firstRun' : 'startup run',
            );
          }
          if (initialRoute.startsWith(AppConstants.routeOpenFile)) {
            final uri = Uri.parse(initialRoute);
            final token =
                uri.queryParameters[AppConstants.routeOpenFileParamToken];
            if (token != null) {
              return [
                AuthPassCloudLoadFileLaunch.route(token: token),
              ];
            }
            final file =
                uri.queryParameters[AppConstants.routeOpenFileParamFile];
            _logger.finer('uri: $uri /// file: $file');
            return [
//              MaterialPageRoute<void>(
//                  builder: (context) => const SelectFileScreen()),
              CredentialsScreen.route(FileSourceLocal(
                  (const LocalFileSystem().file(file)),
                  uuid: AppDataBloc.createUuid())),
            ];
          }
          return [
            (widget.isFirstRun && widget.env.featureOnboarding
                ? OnboardingScreen.route()
                : SelectFileScreen.route()) as Route<dynamic>,
          ];
        },
        // this is actually never used. But i still have to define it,
        // because of https://github.com/flutter/flutter/blob/f64f6e2b6bf5802f23d6a0e3896541b213be490a/packages/flutter/lib/src/widgets/app.dart#L226-L243
        // (defining a navigatorKey requires defining a `routes`)
        routes: {
          AppConstants.routeOpen: (context) => const SelectFileScreen(),
        },
//        home: const SelectFileScreen(),
      ),
    );
  }

  // TODO maybe support more than language code?
  Locale? _parseLocale(String? localeString) {
    if (localeString == null) {
      return null;
    }
    final parts = localeString.split(CharConstants.underScore);
    if (parts.length == 1) {
      return Locale(parts[0]);
    }
    return Locale(parts[0], parts[1]);
  }

  ThemeMode? _toThemeMode(AppDataTheme? theme) {
    if (theme == null) {
      return null;
    }
    switch (theme) {
      case AppDataTheme.light:
        return ThemeMode.light;
      case AppDataTheme.dark:
        return ThemeMode.dark;
    }
  }

  ThemeData _customizeTheme(ThemeData theme, AppData? appData) {
    if (appData == null) {
      return theme;
    }

    final visualDensity = appData.themeVisualDensity != null
        ? VisualDensity(
            horizontal: appData.themeVisualDensity!,
            vertical: appData.themeVisualDensity!)
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
        _deps.env.diacDefaultDisabled && _appData!.diacOptIn != true;
    _logger.finest('_createDiacBloc: $disableOnlineMessages = '
        '${_deps.env.diacDefaultDisabled} && ${_appData!.diacOptIn}');
    return DiacBloc(
      opts: DiacOpts(
          endpointUrl: _deps.env.diacEndpoint,
          disableConfigFetch: disableOnlineMessages,
          // always reload after a new start.
          refetchIntervalCold: Duration.zero,
          initialConfig: !disableOnlineMessages || _deps.env.diacHidden
              ? null
              : DiacConfig(
                  updatedAt: DateTime(2020, 5, 18),
                  messages: nonNls([
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
                  ]),
                ),
          packageInfo: () async =>
              (await _deps.env.getAppInfo()).toDiacPackageInfo()),
      contextBuilder: () async => nonNls({
        'env': <String, Object>{
          'isDebug': _deps.env.isDebug,
          'isGoogleStore': (await _deps.env.getAppInfo()).packageName ==
                  'design.codeux.authpass' &&
              AuthPassPlatform.isAndroid,
          'isIOS': AuthPassPlatform.isIOS,
          'isAndroid': AuthPassPlatform.isAndroid,
          'operatingSystem': AuthPassPlatform.operatingSystem,
        },
        'appData': {
          'manualUserType': _appData?.manualUserType,
        },
      }),
      // TODO: This should probably be translated. Although right now all
      //       messages are english anyway..
      customActions: nonNls({
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
          unawaited(widget.navigatorKey!.currentState?.push<void>(route));
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
          await widget.navigatorKey!.currentState?.push<void>(route);
          return true;
        }
      }),
    )..events.listen((event) {
        _deps.analytics.trackGenericEvent(
          'diac',
          event is DiacEventWithAction
              ? '${event.type.toStringBare()}:${event.action?.key}'
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
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logger.finest('didPush');
    _sendScreenView(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _sendScreenView(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _sendScreenView(previousRoute);
  }

  String _screenNameFor(Route? route) {
    final name = route?.settings.name;
    if (name != null) {
      return name;
    }
    assert((() {
      if (route is PopupRoute) {
        return true;
      }
      _logger.severe('Route does not have a named RouteSettings! $route', null,
          StackTrace.current);
      return true;
    })());
    return (route?.runtimeType).toString(); // NON-NLS
  }

  void _sendScreenView(Route? route) {
    final screenName = _screenNameFor(route);
    analytics.trackScreen(screenName);
  }
}
