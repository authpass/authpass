import 'package:authpass/bloc/deps.dart';
import 'package:authpass/ui/screens/about.dart';
import 'package:authpass/ui/screens/preferences.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PlatformMenuBarWrapper extends StatelessWidget {
  const PlatformMenuBarWrapper({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final deps = context.read<Deps>();
    final loc = AppLocalizations.of(context);
    return PlatformMenuBar(
      menus: [
        PlatformMenu(
          label: loc.aboutAppName,
          menus: [
            PlatformMenuItemGroup(
              members: <PlatformMenuItem>[
                PlatformMenuItem(
                  label: loc.menuItemAbout,
                  onSelected: () {
                    AuthPassAboutDialog.openDialog(
                        navigatorKey.currentContext!);
                  },
                )
              ],
            ),
            PlatformMenuItemGroup(
              members: <PlatformMenuItem>[
                PlatformMenuItem(
                  label: loc.menuItemPreferences,
                  onSelected: () {
                    navigatorKey.currentState?.push(PreferencesScreen.route());
                  },
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.comma,
                    meta: true,
                  ),
                ),
              ],
            ),
            if (PlatformProvidedMenuItem.hasMenu(
                PlatformProvidedMenuItemType.quit)) ...[
              const PlatformProvidedMenuItem(
                  type: PlatformProvidedMenuItemType.quit),
            ],
          ],
        ),
        PlatformMenu(
          label: loc.menuItemHelp,
          menus: [
            PlatformMenuItemGroup(
              members: <PlatformMenuItem>[
                PlatformMenuItem(
                  label: loc.menuItemForum,
                  onSelected: () {
                    DialogUtils.openUrl(deps.env.forumUrl);
                  },
                )
              ],
            ),
          ],
        ),
      ],
      child: child,
    );
  }
}
