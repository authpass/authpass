import 'package:authpass/ui/widgets/shortcut/authpass_intents.dart';
import 'package:authpass/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef LabelProvider = String Function(AppLocalizations loc);

late final defaultAuthPassShortcuts = [
  AuthPassShortcut.def(
    key: LogicalKeyboardKey.keyF,
    intent: const SearchIntent(),
    label: (loc) => loc.searchButtonLabel,
  ),
  AuthPassShortcut.def(
    key: LogicalKeyboardKey.keyB,
    intent: CopyUsernameIntent(),
    label: (loc) => loc.shortcutCopyUsername,
  ),
  AuthPassShortcut.def(
    key: LogicalKeyboardKey.keyC,
    intent: CopyPasswordIntent(),
    label: (loc) => loc.shortcutCopyPassword,
  ),
  AuthPassShortcut.def(
    key: LogicalKeyboardKey.keyT,
    intent: CopyTotpIntent(),
    label: (loc) => loc.shortcutCopyTotp,
  ),
  AuthPassShortcut.all(
    key: const SingleActivator(LogicalKeyboardKey.arrowUp),
    intent: MoveUpIntent(),
    label: (loc) => loc.shortcutMoveUp,
  ),
  AuthPassShortcut.all(
    key: const SingleActivator(LogicalKeyboardKey.keyP, control: true),
    intent: MoveUpIntent(),
    label: (loc) => loc.shortcutMoveUp,
  ),
  AuthPassShortcut.all(
    key: const SingleActivator(LogicalKeyboardKey.arrowDown),
    intent: MoveDownIntent(),
    label: (loc) => loc.shortcutMoveDown,
  ),
  AuthPassShortcut.all(
    key: const SingleActivator(LogicalKeyboardKey.keyN, control: true),
    intent: MoveDownIntent(),
    label: (loc) => loc.shortcutMoveDown,
  ),
  AuthPassShortcut.def(
    key: LogicalKeyboardKey.keyG,
    intent: GeneratePasswordIntent(),
    label: (loc) => loc.shortcutGeneratePassword,
  ),
  AuthPassShortcut.def(
    key: LogicalKeyboardKey.keyU,
    intent: CopyUrlIntent(),
    label: (loc) => loc.shortcutCopyUrl,
  ),
  AuthPassShortcut.def(
    key: LogicalKeyboardKey.keyO,
    intent: OpenUrlIntent(),
    label: (loc) => loc.shortcutOpenUrl,
  ),
  AuthPassShortcut.all(
    key: const SingleActivator(LogicalKeyboardKey.escape),
    intent: CancelSearchFilterIntent(),
    label: (loc) => loc.shortcutCancelSearch,
  ),
  AuthPassShortcut.all(
    key: const CharacterActivator(CharConstants.questionMark),
    intent: KeyboardShortcutHelpIntent(),
    label: (loc) => loc.shortcutShortcutHelp,
  ),
];

class AuthPassShortcut {
  const AuthPassShortcut({
    required this.mac,
    required this.linux,
    required this.windows,
    required this.intent,
    required this.label,
  });
  AuthPassShortcut.def({
    required LogicalKeyboardKey key,
    required Intent intent,
    required LabelProvider label,
  }) : this(
          mac: SingleActivator(key, meta: true),
          linux: SingleActivator(key, control: true),
          windows: SingleActivator(key, control: true),
          intent: intent,
          label: label,
        );
  AuthPassShortcut.all({
    required ShortcutActivator key,
    required Intent intent,
    required LabelProvider label,
  }) : this(
          mac: key,
          linux: key,
          windows: key,
          intent: intent,
          label: label,
        );

  final ShortcutActivator mac;
  final ShortcutActivator linux;
  final ShortcutActivator windows;
  final Intent intent;
  final LabelProvider label;

  ShortcutActivator triggerForPlatform(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
        return linux;
      case TargetPlatform.iOS:
        return mac;
      case TargetPlatform.macOS:
        return mac;
      case TargetPlatform.windows:
        return windows;
    }
  }
}
