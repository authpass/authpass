import 'package:authpass/cloud_storage/google_drive/google_drive_provider.dart';
import 'package:authpass/l10n-generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:logging/logging.dart';

import 'login_widget/stub.dart'
    if (dart.library.js_util) 'login_widget/web.dart';

final _logger = Logger('login_widget');

class GoogleLoginWidget extends StatefulWidget {
  const GoogleLoginWidget({
    super.key,
    required this.onSuccess,
    required this.googleDriveProvider,
    required this.defaultWidget,
  });

  final GoogleDriveProvider googleDriveProvider;
  final VoidCallback onSuccess;
  final Widget defaultWidget;

  @override
  State<GoogleLoginWidget> createState() => _GoogleLoginWidgetState();
}

class _GoogleLoginWidgetState extends State<GoogleLoginWidget>
    with StreamSubscriberMixin {
  GoogleSignInWrapper get googleSignIn =>
      widget.googleDriveProvider.googleSignIn;

  bool? _canAccessScopes;

  @override
  void initState() {
    super.initState();
    handleSubscription(
      googleSignIn.onCurrentUserChanged.listen((event) async {
        _logger.fine('onCurrentUserChanged: ${event?.id}');
        if (event != null) {
          final auth = await event.authorizationClient.authorizationForScopes(
            googleSignIn.scopes,
          );
          _canAccessScopes = auth != null;
        }
        if (_canAccessScopes == true) {
          widget.onSuccess();
        } else {
          setState(() {});
        }
      }),
    );
  }

  Future<void> _checkAuthorization() async {
    final c = await googleSignIn.authenticatedClient();
    if (c != null) {
      widget.onSuccess();
    }
    setState(() {
      _canAccessScopes = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (googleSignIn.currentUser == null) {
      final signInButton = buildGoogleSignInButton();
      if (signInButton != null) {
        return signInButton;
      }
      return widget.defaultWidget;
    }
    final loc = AppLocalizations.of(context);
    if (_canAccessScopes == false) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The user has NOT Authorized all required scopes.
          // (Mobile users may never see this button!)
          Text(loc.googleDriveMorePermissionsRequired),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final c = await googleSignIn.authenticatedClient();
              setState(() {
                if (c != null) {
                  widget.onSuccess();
                }
              });
              _logger.fine('Requested scopes. result: $c');
            },
            child: Text(loc.googleDriveRequestPermissionButtonLabel),
          ),
        ],
      );
    } else {
      // something is pretty broken.. this state should not happen;
      _logger.severe(
        'curent user is not null but _canAccessScopes is $_canAccessScopes',
      );
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _checkAuthorization();
      });
      return widget.defaultWidget;
    }
  }
}
