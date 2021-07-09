import 'package:flutter/material.dart';

class BackupBanner extends StatelessWidget {
  const BackupBanner(
    this.bannerText, {
    required this.backupWidget,
    required this.dismissText,
    this.onDismiss,
  });

  final String bannerText;

  final String dismissText;

  final Widget backupWidget;

  final Function? onDismiss;

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      content: Text(bannerText),
      actions: [
        TextButton(
          onPressed: () => onDismiss!(),
          child: Text(dismissText),
        ),
        backupWidget,
      ],
    );
  }
}
