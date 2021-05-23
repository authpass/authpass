import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LinkButton extends StatelessWidget {
  const LinkButton(
      {Key? key,
      required this.child,
      this.onPressed,
      this.icon,
      this.padding,
      this.materialTapTargetSize})
      : super(key: key);

  final Widget child;
  final VoidCallback? onPressed;
  final Icon? icon;
  final EdgeInsetsGeometry? padding;
  final MaterialTapTargetSize? materialTapTargetSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return icon == null
        ? TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              primary: theme.primaryColor,
              padding: padding,
              tapTargetSize: materialTapTargetSize,
            ),
            child: child,
          )
        : TextButton.icon(
            onPressed: onPressed,
            icon: icon!,
            label: child,
            style: TextButton.styleFrom(
              primary: theme.primaryColor,
              padding: padding,
              tapTargetSize: materialTapTargetSize,
            ),
          );
  }
}
