import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    this.child,
    this.onPressed,
    this.icon,
    this.large = true,
  }) : super(key: key);

  final Widget? child;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final childWidget = icon == null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8), child: child)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              icon!,
              const SizedBox(width: 8.0),
              child!,
            ],
          );
    return Theme(
      data: _createMainButtonTheme(
        Theme.of(context),
        large: large,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: large
                ? const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  )
                : null),
        onPressed: onPressed,
//                    color: Theme.of(context).primaryColor,
        child: childWidget,
      ),
    );
  }
}

ThemeData _createMainButtonTheme(ThemeData themeData, {bool large = true}) =>
    themeData.copyWith(
//       elevatedButtonTheme: themeData.elevatedButtonTheme.style(
//         // buttonColor: themeData.primaryColor,
//         // textTheme: ButtonTextTheme.primary,
// //      disabledColor: AuthPassTheme.disabledPrimaryColor,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
// //         padding: large
// //             ? const EdgeInsets.symmetric(
// //                 vertical: 16,
// //                 horizontal: 16,
// //               )
// //             : null,
//       ),
      textTheme: large
          ? themeData.textTheme.apply(fontSizeFactor: 1.4)
          : themeData.textTheme,
    );
