import 'package:authpass/theme.dart';
import 'package:authpass/ui/screens/entry_details.dart';
import 'package:authpass/ui/screens/password_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

final _logger = Logger('main_app_scaffold');

class MainAppScaffold extends StatelessWidget {
  static MaterialPageRoute<void> route() => MaterialPageRoute(builder: (context) => MainAppScaffold());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _logger.finer('size.width: ${mediaQuery.size.width}');
    if (mediaQuery.size.width >= Breakpoints.TABLET_WIDTH) {
      return MainAppTabletScaffold();
    }
    return Navigator(
      onGenerateRoute: _onGenerateRoute,
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 256,
          child: PasswordList(
            onEntrySelected: (entry) {
              _navigatorKey.currentState.pushAndRemoveUntil(
                EntryDetailsScreen.route(entry: entry),
                (route) => route.isFirst,
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
      body: Center(
        child: const Text('Select a password.'),
      ),
    );
  }
}
