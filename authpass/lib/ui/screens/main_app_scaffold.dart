import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/main.dart';
import 'package:authpass/theme.dart';
import 'package:authpass/ui/screens/entry_details.dart';
import 'package:authpass/ui/screens/password_list.dart';
import 'package:authpass/ui/widgets/keyboard_handler.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/ui/widgets/utils/back_button_navigator_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

final _logger = Logger('main_app_scaffold');

class MainAppScaffold extends StatelessWidget {
  static MaterialPageRoute<void> route() =>
      MaterialPageRoute(builder: (context) => MainAppScaffold());

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
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    if (settings.name == Navigator.defaultRouteName) {
      return PasswordList.route();
//      return MaterialPageRoute<void>(settings: settings, builder: (context) => PasswordList.);
    }
    return null;
  }
}

class MainAppTabletScaffold extends StatefulWidget {
  @override
  _MainAppTabletScaffoldState createState() => _MainAppTabletScaffoldState();
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
          width: 256,
          child: PasswordList(
            selectedEntry: _selectedEntry,
            onEntrySelected: (entry, type) {
              if (_selectedEntry != entry) {
                _navigatorKey.currentState.pushAndRemoveUntil(
                  EntryDetailsScreen.route(entry: entry),
                  (route) => route.isFirst,
                );
                setState(() {
                  _selectedEntry = entry;
                });
              }
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
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo_with_text.png'),
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
