import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/deps.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/ui/screens/manage_file.dart';
import 'package:authpass/ui/screens/password_generator.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AuthPassAboutDialog extends StatelessWidget {
  const AuthPassAboutDialog({Key key, this.env}) : super(key: key);

  final Env env;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppInfo>(
        future: env.getAppInfo(),
        builder: (context, snapshot) {
          final appInfo = snapshot.data;
          return AboutDialog(
            applicationIcon: GestureDetector(
              onLongPress: () async {
                final deps = Provider.of<Deps>(context);
                final appData = await deps.appDataBloc.store.load();
                final newData = await SimplePromptDialog.showPrompt(
                    context,
                    SimplePromptDialog(
                      labelText: 'debug usertype',
                      initialValue: appData?.manualUserType ?? '',
                    ));
                if (newData != null) {
                  await deps.appDataBloc.update((b, _) => b..manualUserType = newData);
                  deps.analytics.events.trackUserType(userType: newData);
                }
              },
              child: ImageIcon(
                const AssetImage('assets/images/logo_icon.png'),
                color: Theme.of(context).primaryColor,
              ),
            ),
            applicationName: 'AuthPass',
            applicationVersion: appInfo?.versionLabel,
            applicationLegalese: '© by Herbert Poul, 2019',
            children: const <Widget>[
              SizedBox(height: 32),
              UrlLink(
                caption: 'We welcome any kind of feedback!',
                url: 'mailto:hello@authpass.app',
              ),
              UrlLink(
                caption: 'Also make sure to visit our website',
                url: 'https://authpass.app/',
              ),
              UrlLink(
                caption: 'And Open Source Project',
                url: 'https://github.com/authpass/authpass/',
              ),
            ],
          );
        });
  }

  static void openDialog(BuildContext context) {
    final env = Provider.of<Env>(context);
    Provider.of<Analytics>(context).trackScreen('/about');
    showDialog<void>(
      context: context,
      builder: (context) => AuthPassAboutDialog(env: env),
    );
  }

  static PopupMenuButton createAboutPopupAction(BuildContext context,
      {List<PopupMenuItem<VoidCallback>> Function(BuildContext context) builder}) {
    return PopupMenuButton<VoidCallback>(
      onSelected: (val) => val(),
      itemBuilder: (context) => [
        ...?(builder == null ? null : builder(context)),
        ...createDefaultPopupMenuItems(context),
      ],
    );
  }

  static Iterable<PopupMenuEntry<VoidCallback>> createDefaultPopupMenuItems(BuildContext context) {
    final openedFiles = Provider.of<KdbxBloc>(context)?.openedFilesWithSources;
    return [
      PopupMenuItem(
        child: ListTile(
          leading: Icon(FontAwesomeIcons.random),
          title: const Text('Generate Password'),
        ),
        value: () {
          Navigator.of(context).push(PasswordGeneratorScreen.route());
        },
      ),
      ...?(openedFiles?.isNotEmpty != true
          ? null
          : (<PopupMenuEntry<VoidCallback>>[const PopupMenuDivider()]).followedBy(
              openedFiles.map(
                (file) => PopupMenuItem(
                  child: ListTile(
                    leading: Icon(file.key.displayIcon),
                    title: Text(file.key.displayName),
                    subtitle: Text(
                      file.key.displayPath,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 1,
                    ),
                  ),
                  value: () {
                    Navigator.of(context, rootNavigator: true).push(ManageFileScreen.route(file.key));
                  },
                ),
              ),
            )),
      PopupMenuItem(
        child: const ListTile(
          leading: Icon(FontAwesomeIcons.folderPlus),
          title: Text('Open another File'),
        ),
        value: () {
          Navigator.of(context, rootNavigator: true).push(SelectFileScreen.route());
        },
      ),
      const PopupMenuDivider(),
      createAboutMenuItem(context)
    ];
  }

  static PopupMenuItem<VoidCallback> createAboutMenuItem(BuildContext context) {
    return PopupMenuItem<VoidCallback>(
      child: const ListTile(
        leading: ImageIcon(AssetImage('assets/images/logo_icon.png')),
        title: Text('About'),
      ),
      value: () {
        AuthPassAboutDialog.openDialog(context);
      },
    );
  }
}

class UrlLink extends StatelessWidget {
  const UrlLink({Key key, this.caption, this.url}) : super(key: key);

  final String caption;
  final String url;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(border: Border(bottom: Divider.createBorderSide(context))),
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
                style: theme.textTheme.body1
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
