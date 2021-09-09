import 'package:authpass/ui/widgets/shortcut/authpass_intents.dart';
import 'package:authpass/ui/widgets/shortcut/shortcuts.dart';
import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';
import 'package:window_manager/window_manager.dart';

final _logger = Logger('keyboard_handler');

class KeyboardHandler extends StatefulWidget {
  const KeyboardHandler({
    Key? key,
    required this.systemWideShortcuts,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final bool systemWideShortcuts;

  static bool get supportsSystemWideShortcuts =>
      AuthPassPlatform.isMacOS ||
      AuthPassPlatform.isWindows ||
      AuthPassPlatform.isLinux;

  @override
  _KeyboardHandlerState createState() => _KeyboardHandlerState();
}

class _KeyboardHandlerState extends State<KeyboardHandler> {
  final _keyboardShortcutEvents = KeyboardShortcutEvents();
  final _actionsKey = GlobalKey();
  late HotKey _hotKey;

  final FocusNode _focusNode = FocusNode(
    debugLabel: nonNls('AuthPassKeyboardFocus'),
//     onKey: (focusNode, rawKeyEvent) {
// //      _logger.info('got onKey: ($focusNode) $rawKeyEvent');
//       return KeyEventResult.ignored;
//     },
  );

  @override
  void initState() {
    super.initState();

    _hotKey = HotKey(
      KeyCode.keyF,
      modifiers: [KeyModifier.control, KeyModifier.alt],
      scope: HotKeyScope.system, // Set as system-wide hotkey.
    );

    if (widget.systemWideShortcuts) {
      _registerSystemWideShortcuts();
    }

    _keyboardShortcutEvents._changeNotifier.addListener(() {
      SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        if (!mounted) {
          _logger.warning(
              'Got keyboard shortcut event, but was no longer mounted.');
          return;
        }
        setState(() {
          _logger.fine('actions changed.');
        });
      });
    });
  }

  @override
  void didUpdateWidget(covariant KeyboardHandler oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.systemWideShortcuts != oldWidget.systemWideShortcuts) {
      if (widget.systemWideShortcuts) {
        _registerSystemWideShortcuts();
      } else {
        _disposeSystemWideShortcuts();
      }
    }
  }

  void _registerSystemWideShortcuts() {
    if (KeyboardHandler.supportsSystemWideShortcuts) {
      HotKeyManager.instance.register(_hotKey, keyDownHandler: (hotKey) {
        _logger.fine('received global hotkey $hotKey');
        WindowManager.instance.show();
        final context = _actionsKey.currentContext;
        if (context == null) {
          _logger.warning('Unable to find context to invoke global action.');
          return;
        }
        Actions.maybeInvoke(context, const SearchIntent());
        // _keyboardShortcutEvents._shortcutEvents.add(searchKeyboardShortcut);
      });
    }
  }

  void _disposeSystemWideShortcuts() {
    if (KeyboardHandler.supportsSystemWideShortcuts) {
      HotKeyManager.instance.unregister(_hotKey);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _logger.info('didChange');
  }

  @override
  Widget build(BuildContext context) {
    final s = defaultAuthPassShortcuts;
    final theme = Theme.of(context);
    final shortcuts = Map.fromEntries(
        s.map((e) => MapEntry(e.triggerForPlatform(theme.platform), e.intent)));
    final loc = AppLocalizations.of(context);
    final showHelpShortcut = <Type, Action<Intent>>{
      KeyboardShortcutHelpIntent: CallbackAction(onInvoke: (_) {
        final descr = s
            .map((e) => [
                  e.triggerForPlatform(theme.platform).debugDescribeKeys(),
                  e.label(loc)
                ].join(CharConstants.colon + CharConstants.space))
            .join(CharConstants.newLine);
        DialogUtils.showSimpleAlertDialog(
          context,
          loc.shortcutHelpTitle,
          descr,
          routeAppend: 'shortcuts',
        );
      })
    };
    return Shortcuts(
      manager: LoggingShortcutManager(),
      shortcuts: shortcuts,
      child: Provider<KeyboardShortcutEvents>.value(
        value: _keyboardShortcutEvents,
        child: Actions(
          key: _actionsKey,
          actions: {
            ..._keyboardShortcutEvents._intentActionsMap,
            ...showHelpShortcut,
          },
          dispatcher: LoggingActionDispatcher(),
          child: Focus(
            focusNode: _focusNode,
            autofocus: true,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _keyboardShortcutEvents.dispose();
    _disposeSystemWideShortcuts();
    super.dispose();
  }
}

class KeyboardShortcutEvents with StreamSubscriberBase {
  KeyboardShortcutEvents();

  final _changeNotifier = ChangeNotifier();
  final List<MapEntry<Type, Action<Intent>>> _intentActions = [];
  Map<Type, Action<Intent>> _intentActionsMap = {};

  IntentActionRegistration registerActions(Map<Type, Action<Intent>> actions) {
    final newEntries = actions.entries.toList();
    _intentActions.addAll(newEntries);
    _intentActionsMap = Map.fromEntries(_intentActions);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    _changeNotifier.notifyListeners();
    return IntentActionRegistration._(this, newEntries);
  }

  void _removeActions(IntentActionRegistration registration) {
    registration._registeredActions.forEach(_intentActions.remove);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    _changeNotifier.notifyListeners();
  }

  void dispose() {
    cancelSubscriptions();
  }
}

class IntentActionRegistration {
  IntentActionRegistration._(this._registrar, this._registeredActions);

  final KeyboardShortcutEvents _registrar;
  final List<MapEntry<Type, Action<Intent>>> _registeredActions;

  void dispose() {
    _registrar._removeActions(this);
  }
}

/// A ShortcutManager that logs all keys that it handles.
class LoggingShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, RawKeyEvent event,
      {LogicalKeySet? keysPressed}) {
    final KeyEventResult result = super.handleKeypress(context, event);
    _logger.info('handleKeyPress($event, $keysPressed) result: $result');
    // if (result == KeyEventResult.handled) {
    //   _logger.fine('Handled shortcut $event in $context');
    // }
    return result;
  }
}

/// An ActionDispatcher that logs all the actions that it invokes.
class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    _logger.fine('Action invoked: $action($intent) from $context');
    return super.invokeAction(action, intent, context);
  }
}
