import 'package:flutter/material.dart';

class BackupBanner extends StatelessWidget {
  const BackupBanner(this.bannerText,
      {@required this.backupWidget, this.dismissText, this.onDismiss})
      : assert(backupWidget != null);
  bool get _dismissable => dismissText != null && onDismiss != null;

  final String bannerText;

  final String dismissText;

  final Widget backupWidget;

  final Function onDismiss;

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(content: Text(bannerText), actions: [
      if (_dismissable)
        FlatButton(
          child: Text(dismissText),
          onPressed: () => onDismiss(),
        ),
      backupWidget
    ]);
  }
}
