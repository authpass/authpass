import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Password input field which by default is obscured, but displays
/// a suffix icon to change it to make it visible.
class PasswordInputField extends StatefulWidget {
  const PasswordInputField({
    Key? key,
    required this.labelText,
    this.autofocus = true,
    this.focusNode,
    this.validator,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onChanged,
    this.controller,
    this.autovalidateMode,
  }) : super(key: key);

  final FocusNode? focusNode;
  final bool autofocus;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final AutovalidateMode? autovalidateMode;

  @override
  _PasswordInputFieldState createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscureText = true;

  @override
  void didUpdateWidget(PasswordInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _obscureText = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return TextFormField(
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      controller: widget.controller,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
          labelText: widget.labelText,
          suffixIcon: IconButton(
            icon: _obscureText
                ? const Icon(FontAwesomeIcons.eye)
                : const Icon(FontAwesomeIcons.eyeSlash),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            tooltip: loc.passwordPlainText,
          )),
      autocorrect: false,
      autovalidateMode: widget.autovalidateMode,
      obscureText: _obscureText,
      validator: widget.validator,
      onEditingComplete: widget.onEditingComplete,
      onChanged: widget.onChanged,
    );
  }
}
