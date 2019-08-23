import 'package:authpass/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LinkButton extends StatelessWidget {
  const LinkButton({Key key, @required this.child, this.onPressed, this.icon, this.padding, this.materialTapTargetSize})
      : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final Icon icon;
  final EdgeInsetsGeometry padding;
  final MaterialTapTargetSize materialTapTargetSize;

  @override
  Widget build(BuildContext context) {
    return icon == null
        ? FlatButton(
            child: child,
            onPressed: onPressed,
            textColor: AuthPassTheme.linkColor,
            padding: padding,
            materialTapTargetSize: materialTapTargetSize,
          )
        : FlatButton.icon(
            onPressed: onPressed,
            icon: icon,
            label: child,
            textColor: AuthPassTheme.linkColor,
            padding: padding,
            materialTapTargetSize: materialTapTargetSize,
          );
  }
}
