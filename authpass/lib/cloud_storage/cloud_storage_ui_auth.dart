import 'package:authpass/cloud_storage/authpasscloud/authpass_cloud_provider.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/cloud_storage_ui_adapt.dart';
import 'package:authpass/cloud_storage/cloud_storage_ui_authpass_cloud.dart';
import 'package:authpass/ui/screens/cloud/cloud_auth.dart';
import 'package:authpass/ui/widgets/link_button.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:simple_form_field_validator/simple_form_field_validator.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('cloud_storage_ui_auth');

class CloudStorageAuthentication extends StatelessWidget {
  const CloudStorageAuthentication({
    super.key,
    required this.provider,
    required this.onSuccess,
  });

  final CloudStorageProvider provider;
  final void Function() onSuccess;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final provider = this.provider;
    final defaultLoginWidget = PrimaryButton(
      icon: const Icon(FontAwesomeIcons.rightToBracket),
      onPressed: () async {
        await _startLoginFlow(context);
      },
      child: Text(loc.cloudStorageLogInActionLabel(provider.displayName)),
    );
    final loginWidget = provider is CloudStorageCustomLoginButtonAdapter
        ? provider.getCustomLoginWidget(
            onSuccess: onSuccess, defaultWidget: defaultLoginWidget)
        : defaultLoginWidget;
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          loginWidget,
          const SizedBox(height: 16),
          Text(
            loc.cloudStorageLogInCaption,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (provider is AuthPassCloudProvider) ...[
            const SizedBox(height: 16),
            Text(
              loc.shareCodeOpen,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () {
                ShareCodeInputDialog.show(
                  context,
                  provider: provider,
                );
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(loc.authPassCloudOpenWithShareCodeTooltip),
            )
          ] else ...[
            LinkButton(
              onPressed: () async {
                await _startLoginFlow(context, forceNoOpenUrl: true);
              },
              child: Text(
                loc.cloudStorageLogInCode,
                textScaler: const TextScaler.linear(0.75),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Future<void> _startLoginFlow(BuildContext context,
      {bool forceNoOpenUrl = false}) async {
    final loc = AppLocalizations.of(context);
    try {
      final auth = await provider.startAuth((final prompt) async {
        if (prompt is UserAuthenticationPrompt<OAuthTokenResult,
            OAuthTokenFlowPromptData>) {
          final promptData = prompt.data;
          final uri = promptData.openUri;
          _logger.fine('Launching authentication url $uri');

          if (!forceNoOpenUrl) {
            if (!await DialogUtils.openUrl(uri)) {
              if (!context.mounted) {
                _logger.severe('Widget no longer mounted, not showing dialog.');
                return;
              }
              await DialogUtils.showSimpleAlertDialog(
                context,
                null,
                loc.launchUrlError(uri),
                routeAppend: 'cloudStorageAuthError',
              );
              prompt.result(null);
              return;
            }
          }
          if (!context.mounted) {
            return;
          }
          final code = await SimpleAuthCodePromptDialog(
            title: loc.cloudStorageAuthCodeDialogTitle(provider.displayName),
            labelText: loc.cloudStorageAuthCodeLabel,
          ).show(context);
          prompt.result(OAuthTokenResult(code));
        } else if (prompt is UserAuthenticationPrompt<UrlUsernamePasswordResult,
            UrlUsernamePasswordPromptData>) {
          final result = await UrlUsernamePasswordDialog().show(context);
          prompt.result(result);
        } else if (prompt
            is UserAuthenticationPrompt<S3PromptResult, S3PromptData>) {
          final result = await S3Dialog().show(context);
          prompt.result(result);
        } else if (prompt is UserAuthenticationPrompt<
            DummyUserAuthenticationPromptResult, AuthPassCloudAuthPromptData>) {
          final result = await Navigator.of(context, rootNavigator: true)
              .push(AuthPassCloudAuthScreen.route());
          prompt.result(DummyUserAuthenticationPromptResult(result ?? false));
        } else {
          throw StateError('Unsupported prompt: $prompt');
        }
      });
      _logger.fine('finished launching. $auth');
      onSuccess();
    } catch (e, stackTrace) {
      _logger.severe('Error while authenticating.', e, stackTrace);
      if (!context.mounted) {
        return;
      }
      await DialogUtils.showErrorDialog(context, loc.cloudStorageAuthErrorTitle,
          loc.cloudStorageAuthErrorMessage(provider.displayName, e));
    }
  }
}

class UrlUsernamePasswordDialog extends StatefulWidget {
  Future<UrlUsernamePasswordResult?> show(BuildContext context) =>
      showDialog<UrlUsernamePasswordResult>(
          context: context, builder: (_) => this);

  @override
  _UrlUsernamePasswordDialogState createState() =>
      _UrlUsernamePasswordDialogState();
}

final _urlRegex = RegExp(r'^https?://');

class _UrlUsernamePasswordDialogState extends State<UrlUsernamePasswordDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _url = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final matLoc = MaterialLocalizations.of(context);
    return AlertDialog(
      title: Text(loc.webDavSettings),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _url,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: loc.webDavUrlLabel,
                helperText: loc.webDavUrlHelperText,
                hintText: nonNls('https://my.nextcloud.com/webdav'),
              ),
              autocorrect: false,
              validator:
                  (SValidator.notEmpty(msg: loc.webDavUrlValidatorError) +
                          SValidator.isTrue((str) => _urlRegex.hasMatch(str!),
                              loc.webDavUrlValidatorInvalidUrlError))
                      .call,
            ),
            TextFormField(
              controller: _username,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: loc.webDavAuthUser,
              ),
            ),
            TextFormField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: loc.webDavAuthPassword,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(matLoc.cancelButtonLabel),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(UrlUsernamePasswordResult(
                  _url.text, _username.text, _password.text));
            }
          },
          child: Text(matLoc.okButtonLabel),
        ),
      ],
    );
  }
}

class S3Dialog extends StatefulWidget {
  Future<S3PromptResult?> show(BuildContext context) =>
      showDialog<S3PromptResult>(context: context, builder: (_) => this);

  @override
  _S3DialogState createState() => _S3DialogState();
}

class _S3DialogState extends State<S3Dialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _serviceUrl = TextEditingController();
  final TextEditingController _accessKey = TextEditingController();
  final TextEditingController _secretKey = TextEditingController();
  final TextEditingController _authRegion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final loc = AppLocalizations.of(context);
    final matLoc = MaterialLocalizations.of(context);
    return AlertDialog(
      title: const Text('S3 Settings'),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _serviceUrl,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Service Url',
                helperText: 'S3 service url',
              ),
              autocorrect: false,
              validator: (SValidator.notEmpty(msg: 'Please enter an url') +
                      SValidator.isTrue((str) => _urlRegex.hasMatch(str!),
                          'Please enter a valid url starting with https://'))
                  .call,
            ),
            TextFormField(
              controller: _accessKey,
              decoration: const InputDecoration(
                labelText: 'Access key',
              ),
            ),
            TextFormField(
                controller: _secretKey,
                decoration: const InputDecoration(
                  labelText: 'Secret key',
                )),
            TextFormField(
              controller: _authRegion,
              decoration: const InputDecoration(
                labelText: 'Auth region',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(matLoc.cancelButtonLabel),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(S3PromptResult(_serviceUrl.text,
                  _accessKey.text, _secretKey.text, _authRegion.text));
            }
          },
          child: Text(matLoc.okButtonLabel),
        ),
      ],
    );
  }
}
