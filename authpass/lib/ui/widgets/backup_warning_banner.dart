import 'package:flutter/material.dart';

class BackupBanner extends StatelessWidget {
  BackupBanner(this.bannerText,
      {@required this.backupText,
      @required this.onBackup,
      this.dismissText,
      this.onDismiss})
      : assert(backupText != null && onBackup != null) {
    _dismissable = dismissText != null && onDismiss != null;
  }
  bool _dismissable;

  ///Text of the banner
  String bannerText;

  ///Text of the dismiss button
  String dismissText;

  ///Text of the backup button
  String backupText;

  ///Called when dismissed
  Function onDismiss;

  ///Called when backup is pressed
  Function onBackup;

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
        content: Text(backupText),
        actions: [
          FlatButton(
            child: Text(backupText),
            onPressed: () =>onBackup(),
          ),
          if (_dismissable)
            FlatButton(
              child: Text(dismissText),
              onPressed: () => onDismiss(),
            ),
        ]);
  }
}
