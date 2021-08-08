import 'dart:ui';

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/deps.dart';
import 'package:authpass/bloc/kdbx/file_source_ui.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/ui/screens/about.dart';
import 'package:authpass/ui/screens/manage_file.dart';
import 'package:authpass/ui/screens/password_generator.dart';
import 'package:authpass/ui/screens/preferences.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/logging_utils.dart';
import 'package:authpass/utils/platform.dart';
import 'package:authpass/utils/winsparkle_init_noop.dart'
    if (dart.library.io) 'package:authpass/utils/winsparkle_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

late final _logger = Logger('app_bar_menu');

class AppBarMenu {
  static Iterable<PopupMenuEntry<VoidCallback>> createDefaultPopupMenuItems(
    BuildContext context,
    OpenedKdbxFiles openedKdbxFiles, {
    List<PopupMenuItem<VoidCallback>> Function(BuildContext context)?
        secondaryBuilder,
    bool isOnOpenFileScreen = false,
  }) {
    final deps = context.read<Deps>();
    final openedFiles = openedKdbxFiles.values;
    final analytics = Provider.of<Analytics>(context, listen: false);
    final loc = AppLocalizations.of(context);
    return [
      PopupMenuItem(
        value: () {
          analytics.events.trackActionPressed(action: 'generatePassword');
          Navigator.of(context).push(PasswordGeneratorScreen.route(
              finishButton: FinishButtonStyle.save));
        },
        child: ListTile(
          key: const ValueKey('openPasswordGenerator'),
          leading: const Icon(FontAwesomeIcons.random),
          title: Text(loc.menuItemGeneratePassword),
        ),
      ),
      PopupMenuItem(
        value: () {
          analytics.events.trackActionPressed(action: 'preferences');
          Navigator.of(context).push(PreferencesScreen.route());
        },
        child: ListTile(
          leading: const Icon(FontAwesomeIcons.cogs),
          title: Text(loc.menuItemPreferences),
        ),
      ),
      ...?(openedFiles.isNotEmpty != true
          ? null
          : (<PopupMenuEntry<VoidCallback>>[const PopupMenuDivider()])
              .followedBy(
              openedFiles.map(
                (file) => PopupMenuItem(
                  value: () {
                    analytics.events.trackActionPressed(action: 'manageFile');
                    Navigator.of(context, rootNavigator: true)
                        .push(ManageFileScreen.route(file.fileSource));
                  },
                  child: ListTile(
                    leading: Icon(file.fileSource.displayIcon.iconData,
                        color: file.openedFile.color),
                    title: Text(file.fileSource.displayName),
                    subtitle: Text(
                      file.fileSource.displayPath,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            )),
      if (!isOnOpenFileScreen) ...[
        PopupMenuItem(
          value: () {
            analytics.events.trackActionPressed(action: 'openFile');
            Navigator.of(context, rootNavigator: true)
                .push(SelectFileScreen.route());
          },
          child: ListTile(
            key: const ValueKey('openAnotherFile'),
            leading: const Icon(FontAwesomeIcons.folderPlus),
            title: Text(loc.menuItemOpenAnotherFile),
          ),
        ),
      ],
      if (secondaryBuilder != null) ...secondaryBuilder(context),
      const PopupMenuDivider(),
      ...?!AuthPassPlatform.isWindowsWinAutoUpdate
          ? null
          : [
              PopupMenuItem(
                value: () {
                  winSparkleCheckUpdate();
                },
                child: ListTile(
                  leading: const Icon(Icons.update),
                  title: Text(loc.menuItemCheckForUpdates),
                ),
              ),
            ],
      if (DialogUtils.sendLogsSupported()) ...[
        PopupMenuItem(
          value: () {
            analytics.events.trackActionPressed(action: 'emailSupport');
            DialogUtils.sendLogs(context);
          },
          child: ListTile(
            leading: const Icon(Icons.email),
            title: Text(loc.menuItemSupport),
            subtitle: Text(loc.menuItemSupportSubtitle),
          ),
        )
      ],
      PopupMenuItem(
        onTap: () async {
          analytics.events.trackActionPressed(action: 'forum');
          final url = deps.env.forumUrlNewTopic(
            body: nonNls('\n\n\n'
                'OS: ${AuthPassPlatform.operatingSystem} '
                '${AuthPassPlatform.operatingSystemVersion}\n'
                'App: ${(await deps.env.getAppInfo()).longString}\n'
                '${await LoggingUtils.getDebugDeviceInfo()}'),
            tags: [nonNls('fromapp')],
          );
          _logger.finer('opening url (${url.length}): $url');
          await DialogUtils.openUrl(url);
        },
        child: ListTile(
          leading: const Icon(Icons.support),
          title: Text(loc.menuItemForum),
          subtitle: Text(loc.menuItemForumSubtitle),
        ),
      ),
      PopupMenuItem(
        value: () async {
          analytics.events.trackActionPressed(action: 'help');
          await DialogUtils.openUrl('https://authpass.app/docs/?utm_source=app'
              '&utm_medium=app_help&utm_campaign=app_help#documentation');
        },
        child: ListTile(
          leading: const Icon(Icons.help),
          title: Text(loc.menuItemHelp),
          subtitle: Text(loc.menuItemHelpSubtitle),
        ),
      ),
      AuthPassAboutDialog.createAboutMenuItem(context),
    ];
  }

  static PopupMenuButton createOverflowMenuButton(
    BuildContext context, {
    List<PopupMenuItem<VoidCallback>> Function(BuildContext context)? builder,
    List<PopupMenuItem<VoidCallback>> Function(BuildContext context)?
        secondaryBuilder,
    bool isOnOpenFileScreen = false,
  }) {
    final openedFiles = Provider.of<OpenedKdbxFiles>(context);
    return PopupMenuButton<VoidCallback>(
      key: const ValueKey('appBarOverflowMenu'),
      onSelected: (val) => val(),
      itemBuilder: (context) => [
        ...?(builder == null ? null : builder(context)),
        ...AppBarMenu.createDefaultPopupMenuItems(
          context,
          openedFiles,
          secondaryBuilder: secondaryBuilder,
          isOnOpenFileScreen: isOnOpenFileScreen,
        ),
      ],
    );
  }
}
