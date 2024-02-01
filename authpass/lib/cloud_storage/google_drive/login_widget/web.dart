import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

/// Renders a web-only SIGN IN button.
Widget? buildGoogleSignInButton() {
  return web.renderButton(
    configuration: web.GSIButtonConfiguration(
      type: web.GSIButtonType.standard,
      theme: web.GSIButtonTheme.outline,
      size: web.GSIButtonSize.large,
      text: web.GSIButtonText.continueWith,
    ),
  );
}
