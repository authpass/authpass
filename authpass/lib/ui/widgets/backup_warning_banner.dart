import 'package:flutter/material.dart';

class BackupBanner extends StatelessWidget {
  BackupBanner(this.bannerText,
      {@required this.backupText,
      @required this.onBackup,
      this.dismissText,
      this.onDismiss})
      : assert(backupText != null && onBackup != null);
  bool get _dismissable => dismissText != null && onDismiss != null;

  final String bannerText;

  final String dismissText;

  final String backupText;

  final Function onDismiss;

  final Function(RelativeRect position) onBackup;

  final GlobalKey _backupButton = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(content: Text(bannerText), actions: [
      if (_dismissable)
        FlatButton(
          child: Text(dismissText),
          onPressed: () => onDismiss(),
        ),
      FlatButton(
          key: _backupButton,
          child: Text(backupText),
          onPressed: () {
            final renderBox =
                _backupButton.currentContext.findRenderObject() as RenderBox;

            onBackup(RelativeRect.fromSize(
                /*Rect.fromLTRB(
                renderBox.localToGlobal(const Offset(0, 0)).dx,
                  renderBox.localToGlobal(const Offset(0, 0)).dy, 0,0 ),*/
                Rect.fromPoints(
                    renderBox.localToGlobal(const Offset(0, 0)),
                    renderBox.localToGlobal(
                        renderBox.size.bottomRight(Offset.zero))),
                renderBox.size));
          }),
    ]);
  }
}
