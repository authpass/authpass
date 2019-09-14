import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
            applicationIcon: ImageIcon(
              const AssetImage('assets/images/logo_icon.png'),
              color: Theme.of(context).primaryColor,
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

  static PopupMenuButton createAboutPopupAction(BuildContext context) {
    return PopupMenuButton<VoidCallback>(
        onSelected: (val) => val(),
        itemBuilder: (context) => [createAboutMenuItem(context)]);
  }

  static PopupMenuItem<VoidCallback> createAboutMenuItem(BuildContext context) {
    return PopupMenuItem<VoidCallback>(
      child: ListTile(
        leading: const ImageIcon(AssetImage('assets/images/logo_icon.png')),
        title: const Text('About'),
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
