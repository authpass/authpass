import 'package:authpass/utils/extension_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: implementation_imports
import 'package:zxcvbn/src/result.dart';
import 'package:zxcvbn/zxcvbn.dart';

class PasswordStrengthDisplay extends ImplicitlyAnimatedWidget {
  const PasswordStrengthDisplay({Key? key, this.strength})
      : super(key: key, duration: const Duration(milliseconds: 500));

  final Result? strength;

  @override
  _PasswordStrengthDisplayState createState() =>
      _PasswordStrengthDisplayState();
}

class _PasswordStrengthDisplayState
    extends AnimatedWidgetBaseState<PasswordStrengthDisplay> {
  static final _strengthColors = [
    Colors.redAccent,
    Colors.deepOrange,
    Colors.orange,
    Colors.yellow,
    Colors.lightGreenAccent
  ];

  Tween<double?>? _scoreTween;
  ColorTween? _colorTween;
  ColorTween? _backgroundColorTween;

  @override
  void forEachTween(visitor) {
    _scoreTween = visitor(
        _scoreTween,
        widget.strength?.score?.let((val) => val + 1) ?? 0.0,
            (dynamic value) => Tween<double>(begin: value as double?))
    as Tween<double?>?;
    _colorTween = visitor(
        _colorTween,
        _strengthColors[widget.strength?.score?.toInt() ?? 0],
            (dynamic value) => ColorTween(begin: value as Color?)) as ColorTween?;
    _backgroundColorTween = visitor(
        _backgroundColorTween,
        widget.strength == null ? Colors.redAccent : Colors.grey,
            (dynamic value) => ColorTween(begin: value as Color?)) as ColorTween?;
  }

  @override
  Widget build(BuildContext context) {
    final _strength = widget.strength;
    // final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final feedback = _strength?.feedback.warning.takeUnlessBlank() ??
        // _strength?.feedback?.suggestions?.firstOrNull ??
        ''; // NON-NLS

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_strength != null) ...[
          LinearProgressIndicator(
            value: _scoreTween!.evaluate(animation)! / 5.0,
            valueColor: AlwaysStoppedAnimation(
              _colorTween!.evaluate(animation),
            ),
            backgroundColor: _backgroundColorTween!.evaluate(animation),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Expanded(
              //   child: Text(
              //     loc.passwordScore(_strength.score.toInt()),
              //     style: theme.textTheme.caption,
              //     overflow: TextOverflow.ellipsis,
              //     maxLines: 1,
              //   ),
              // ),
              Text(
                feedback,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: theme.textTheme.caption,
              ),
            ],
          ),
        ] else ...[
          LinearProgressIndicator(
            value: _scoreTween!.evaluate(animation)! / 5.0,
            valueColor:
            AlwaysStoppedAnimation(_colorTween!.evaluate(animation)),
            backgroundColor: _backgroundColorTween!.evaluate(animation),
          ),
          const SizedBox(height: 4),
          const Text(' '), // NON-NLS
        ],
      ],
    );
  }
}
