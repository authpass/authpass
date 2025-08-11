import 'package:flutter/widgets.dart';

/// Wraps a navigator to send pop signals from the parent navigator to the child navigator.
class BackButtonNavigatorDelegate extends StatefulWidget {
  const BackButtonNavigatorDelegate({
    super.key,
    this.observers,
    required this.onGenerateRoute,
    this.onGenerateInitialRoutes,
  });

  /// A list of observers for this navigator.
  final List<NavigatorObserver>? observers;

  /// Called to generate a route for a given [RouteSettings].
  final RouteFactory? onGenerateRoute;

  final RouteListFactory? onGenerateInitialRoutes;

  @override
  _BackButtonNavigatorDelegateState createState() =>
      _BackButtonNavigatorDelegateState();
}

class _BackButtonNavigatorDelegateState
    extends State<BackButtonNavigatorDelegate> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler(
      onPopWithResult: (result) async {
        return _navigatorKey.currentState!.pop(result);
      },
      child: Navigator(
        key: _navigatorKey,
        observers: widget.observers!,
        onGenerateRoute: widget.onGenerateRoute,
        onGenerateInitialRoutes: widget.onGenerateInitialRoutes!,
      ),
    );
  }
}
