import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/deps.dart';
import 'package:authpass/bloc/kdbx/file_source_ui.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/l10n/app_localizations.dart';
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
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

class AuthPassAboutDialog extends StatelessWidget {
  const AuthPassAboutDialog({Key key, this.env}) : super(key: key);

  final Env env;

  @override
  Widget build(BuildContext context) {
    final loggingUtil = LoggingUtils();
    final logFiles = loggingUtil.rotatingFileLoggerFiles;
    final loc = AppLocalizations.of(context);
    return FutureBuilder<AppInfo>(
        future: env.getAppInfo(),
        builder: (context, snapshot) {
          final appInfo = snapshot.data;
          return AboutDialog(
            applicationIcon: GestureDetector(
              onLongPress: () async {
                final deps = context.read<Deps>();
                final appData = await deps.appDataBloc.store.load();
                final newData = await SimplePromptDialog(
                  labelText: 'debug usertype', // NON-NLS
                  initialValue: appData?.manualUserType ?? '', // NON-NLS
                ).show(context);
                if (newData != null) {
                  await deps.appDataBloc
                      .update((b, _) => b..manualUserType = newData);
                  deps.analytics.events.trackUserType(userType: newData);
                }
              },
              child: ImageIcon(
                const AssetImage('assets/images/logo_icon.png'),
                color: Theme.of(context).primaryColor,
              ),
            ),
            applicationName: loc.aboutAppName,
            applicationVersion: appInfo?.versionLabel,
            applicationLegalese: '© by Herbert Poul, 2019-2020', // NON-NLS
            children: <Widget>[
              const SizedBox(height: 32),
              UrlLink(
                caption: loc.aboutLinkFeedback,
                url: 'mailto:hello@authpass.app',
              ),
              UrlLink(
                caption: loc.aboutLinkVisitWebsite,
                url: 'https://authpass.app/',
              ),
              UrlLink(
                caption: loc.aboutLinkGitHub,
                url: 'https://github.com/authpass/authpass/',
              ),
              const SizedBox(height: 32),
              Text(
                loc.aboutLogFile(logFiles.isEmpty
                    ? 'No Log File?!'
                    : logFiles.first.absolute.path),
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          );
        });
  }

  static void openDialog(BuildContext context) {
    final env = Provider.of<Env>(context, listen: false);
    Provider.of<Analytics>(context, listen: false).trackScreen('/about');
    showDialog<void>(
      context: context,
      builder: (context) => AuthPassAboutDialog(env: env),
    );
  }

  static PopupMenuButton createAboutPopupAction(BuildContext context,
      {List<PopupMenuItem<VoidCallback>> Function(BuildContext context)
          builder}) {
    final openedFiles = Provider.of<OpenedKdbxFiles>(context);
    return PopupMenuButton<VoidCallback>(
      onSelected: (val) => val(),
      itemBuilder: (context) => [
        ...?(builder == null ? null : builder(context)),
        ...createDefaultPopupMenuItems(context, openedFiles),
      ],
    );
  }

  static Iterable<PopupMenuEntry<VoidCallback>> createDefaultPopupMenuItems(
      BuildContext context, OpenedKdbxFiles openedKdbxFiles) {
    final openedFiles = openedKdbxFiles.values;
    final analytics = Provider.of<Analytics>(context, listen: false);
    final loc = AppLocalizations.of(context);
    return [
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(FontAwesomeIcons.random),
          title: Text(loc.menuItemGeneratePassword),
        ),
        value: () {
          analytics.events.trackActionPressed(action: 'generatePassword');
          Navigator.of(context).push(PasswordGeneratorScreen.route());
        },
      ),
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(FontAwesomeIcons.cogs),
          title: Text(loc.menuItemPreferences),
        ),
        value: () {
          analytics.events.trackActionPressed(action: 'preferences');
          Navigator.of(context).push(PreferencesScreen.route());
        },
      ),
      ...?(openedFiles?.isNotEmpty != true
          ? null
          : (<PopupMenuEntry<VoidCallback>>[const PopupMenuDivider()])
              .followedBy(
              openedFiles.map(
                (file) => PopupMenuItem(
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
                  value: () {
                    analytics.events.trackActionPressed(action: 'manageFile');
                    Navigator.of(context, rootNavigator: true)
                        .push(ManageFileScreen.route(file.fileSource));
                  },
                ),
              ),
            )),
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(FontAwesomeIcons.folderPlus),
          title: Text(loc.menuItemOpenAnotherFile),
        ),
        value: () {
          analytics.events.trackActionPressed(action: 'openFile');
          Navigator.of(context, rootNavigator: true)
              .push(SelectFileScreen.route());
        },
      ),
      const PopupMenuDivider(),
      ...?!AuthPassPlatform.isWindows
          ? null
          : [
              PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.update),
                    title: Text(loc.menuItemCheckForUpdates),
                  ),
                  value: () {
                    winSparkleCheckUpdate();
                  }),
            ],
      ...?!DialogUtils.sendLogsSupported()
          ? null
          : [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(loc.menuItemSupport),
                  subtitle: Text(loc.menuItemSupportSubtitle),
                ),
                value: () {
                  analytics.events.trackActionPressed(action: 'emailSupport');
                  DialogUtils.sendLogs(context);
                },
              )
            ],
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.help),
          title: Text(loc.menuItemHelp),
          subtitle: Text(loc.menuItemHelpSubtitle),
        ),
        value: () async {
          analytics.events.trackActionPressed(action: 'help');
          await DialogUtils.openUrl('https://authpass.app/docs/?utm_source=app'
              '&utm_medium=app_help&utm_campaign=app_help#documentation');
        },
      ),
      createAboutMenuItem(context)
    ];
  }

  static PopupMenuItem<VoidCallback> createAboutMenuItem(BuildContext context) {
    final analytics = Provider.of<Analytics>(context, listen: false);
    final loc = AppLocalizations.of(context);
    return PopupMenuItem<VoidCallback>(
      child: ListTile(
        leading: const ImageIcon(AssetImage('assets/images/logo_icon.png')),
        title: Text(loc.menuItemAbout),
      ),
      value: () {
        analytics.events.trackActionPressed(action: 'about');
        AuthPassAboutDialog.openDialog(context);
      },
    );
  }
}

class UrlLink extends StatelessWidget {
  const UrlLink({Key key, this.caption, @NonNls this.url}) : super(key: key);

  final String caption;
  final String url;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border(bottom: Divider.createBorderSide(context))),
      child: InkWell(
        onTap: () {
          DialogUtils.openUrl(url);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                caption,
                style: theme.textTheme.caption,
              ),
              const SizedBox(height: 4),
              Text(
                url,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyText2
                    .apply(color: theme.primaryColor, fontSizeFactor: 0.95)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
//            const Divider(),
//        const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
