import 'package:flutter/widgets.dart';

/// Workaround for centered icons. see https://github.com/flutter/flutter/issues/24054#issuecomment-439167235
class CenteredIcon extends StatelessWidget {
  const CenteredIcon({
    Key? key,
    required this.icon,
    this.color,
    this.size,
  }) : super(key: key);

  final IconData icon;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Text(
      String.fromCharCode(icon.codePoint),
      style: TextStyle(
        inherit: false,
        fontSize: size,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: color,
      ),
    );
  }
}
