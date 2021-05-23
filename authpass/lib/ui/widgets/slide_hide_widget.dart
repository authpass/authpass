import 'package:flutter/widgets.dart';

class SlideHideWidget extends StatelessWidget {
  const SlideHideWidget({
    Key? key,
    required this.hide,
    this.padding,
    required this.child,
  }) : super(key: key);

  final bool hide;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
//      firstChild: child,
//      secondChild: Container(
//        height: 0,
//      ),
      child: hide
          ? Container(
              height: 0,
            )
          : padding != null
              ? Padding(
                  padding: padding!,
                  child: child,
                )
              : child,
    );
  }
}
