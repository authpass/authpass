import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({Key key, this.child, this.onPressed, this.icon}) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    final childWidget = icon == null
        ? Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: child)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              icon,
              const SizedBox(width: 8.0),
              child,
            ],
          );
    return Theme(
      data: _createMainButtonTheme(Theme.of(context)),
      child: RaisedButton(
//                    color: Theme.of(context).primaryColor,
        elevation: 0,
        child: childWidget,
        onPressed: onPressed,
      ),
    );
  }
}

ThemeData _createMainButtonTheme(ThemeData themeData) => themeData.copyWith(
      buttonTheme: themeData.buttonTheme.copyWith(
        buttonColor: themeData.primaryColor,
        textTheme: ButtonTextTheme.primary,
//      disabledColor: AuthPassTheme.disabledPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      textTheme: themeData.textTheme.apply(fontSizeFactor: 1.4),
    );
