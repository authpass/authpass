import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/main.dart';
import 'package:authpass/theme.dart';
import 'package:authpass/ui/screens/entry_details.dart';
import 'package:authpass/ui/screens/password_list.dart';
import 'package:authpass/ui/widgets/keyboard_handler.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/ui/widgets/utils/back_button_navigator_delegate.dart';
import 'package:authpass/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

final _logger = Logger('main_app_scaffold');

class MainAppScaffold extends StatelessWidget {
  static MaterialPageRoute<void> route() => MaterialPageRoute(
        settings: const RouteSettings(name: '/main'),
        builder: (context) => MainAppScaffold(),
      );

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _logger.finer('size.width: ${mediaQuery.size.width}');
    if (mediaQuery.size.width >= Breakpoints.TABLET_WIDTH) {
      return KeyboardHandler(child: MainAppTabletScaffold());
    }
    return KeyboardHandler(
      child: BackButtonNavigatorDelegate(
        observers: [
          AnalyticsNavigatorObserver(Provider.of<Analytics>(context))
        ],
        onGenerateRoute: null,
        onGenerateInitialRoutes: (navigator, initialRoute) => [
          PasswordList.route(),
        ],
      ),
    );
  }
}

class MainAppTabletScaffold extends StatefulWidget {
  @override
  _MainAppTabletScaffoldState createState() => _MainAppTabletScaffoldState();
}

/// Workaround for the search text field losing focus when pushing
/// a second route.
/// https://github.com/flutter/flutter/issues/53441
class FocusWorkaroundPageRoute<T> extends MaterialPageRoute<T> {
  FocusWorkaroundPageRoute({
    RouteSettings settings,
    @required WidgetBuilder builder,
    this.focusNode,
  }) : super(
          settings: settings,
          builder: builder,
        );

  final FocusNode focusNode;

  @override
  void install() {
    super.install();
    _logger.fine('focusNode: $focusNode');
    focusNode.addListener(_changedFocus);
  }

  void _changedFocus() {
    _logger.finest(
        'Changed focus. ${focusNode.hasFocus} --- isCurrent:$isCurrent');
    if (!focusNode.hasFocus) {
      focusNode.requestFocus();
    }
  }

  @override
  TickerFuture didPush() {
    final ret = super.didPush();
    ret.then((value) {
      focusNode.removeListener(_changedFocus);
    }); // focusNode.requestFocus());
    return ret;
  }
}

class _MainAppTabletScaffoldState extends State<MainAppTabletScaffold> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  KdbxEntry _selectedEntry;

  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_debugEvent);
  }

  void _debugEvent(RawKeyEvent ev) {
//    final keys = RawKeyboard.instance.keysPressed.map((k) => '${k.keyId} (${k.keyLabel})');
//    _logger.fine('Got key event. $keys');
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_debugEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 384,
          child: Navigator(
            onGenerateRoute: (settings) {
              assert(settings.name == Navigator.defaultRouteName);
              return MaterialPageRoute<void>(
                settings: settings,
                builder: (context) => PasswordList(
                  selectedEntry: _selectedEntry,
                  onEntrySelected: (entry, type) {
                    if (_selectedEntry != entry) {
                      if (type == EntrySelectionType.passiveHighlight) {
                        _navigatorKey.currentState.pushAndRemoveUntil(
                          FocusWorkaroundPageRoute<void>(
                              focusNode: WidgetsBinding
                                  .instance.focusManager.primaryFocus,
                              settings: const RouteSettings(name: '/entry'),
                              builder: (context) => EntryDetailsScreen(
                                    entry: entry,
                                  )),
                          (route) => route.isFirst,
                        );
                      } else {
                        _navigatorKey.currentState.pushAndRemoveUntil(
                          EntryDetailsScreen.route(entry: entry),
                          (route) => route.isFirst,
                        );
                      }
                      setState(() {
                        _selectedEntry = entry;
                      });
                    }
                  },
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Navigator(
            key: _navigatorKey,
            onGenerateRoute: (settings) {
              assert(settings.name == Navigator.defaultRouteName);
              return MaterialPageRoute<void>(
                settings: settings,
                builder: (context) => EmptyStateInitialRoute(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class EmptyStateInitialRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Ink(
        color: Theme.of(context).cardColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...Theme.of(context).brightness == Brightness.light
                  ? [
                      Image.asset('assets/images/logo_with_text.png'),
                    ]
                  : [
                      const SizedBox(height: 64),
                      Image.asset('assets/images/logo_icon.png'),
                      Text(Env.AuthPass,
                          style: Theme.of(context).textTheme.headline3),
                      Text(
                          'password manager, open source, available on all platforms.',
                          style: Theme.of(context).textTheme.caption),
                      const SizedBox(height: 64),
                    ],
              const Text('Select a password.'),
              const SizedBox(height: 32),
              PrimaryButton(
                child: const Text('Add new Password'),
                onPressed: () {
                  final newEntry = Provider.of<KdbxBloc>(context).createEntry();
                  Navigator.of(context)
                      .push(EntryDetailsScreen.route(entry: newEntry));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
