import 'package:authpass/l10n-generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Validator which reports [message] for the value which was just rejected as
/// the master password ([invalidValue]).
///
/// An empty password is a valid candidate too (a database can be locked with an
/// empty password), so unlike `SValidator.invalidValue` this does not skip
/// empty input. Otherwise a rejected empty password shows no error at all.
FormFieldValidator<String> invalidPasswordValidator({
  required String? Function() invalidValue,
  required String message,
}) => (value) {
  final invalid = invalidValue();
  return invalid != null && (value ?? '') == invalid ? message : null;
};

/// Password input field which by default is obscured, but displays
/// a suffix icon to change it to make it visible.
class PasswordInputField extends StatefulWidget {
  const PasswordInputField({
    super.key,
    required this.labelText,
    this.autofocus = true,
    this.focusNode,
    this.validator,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onChanged,
    this.controller,
    this.autovalidateMode,
  });

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
              ? const FaIcon(FontAwesomeIcons.eye)
              : const FaIcon(FontAwesomeIcons.eyeSlash),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          tooltip: loc.passwordPlainText,
        ),
      ),
      autocorrect: false,
      autovalidateMode: widget.autovalidateMode,
      obscureText: _obscureText,
      validator: widget.validator,
      onEditingComplete: widget.onEditingComplete,
      onChanged: widget.onChanged,
    );
  }
}
