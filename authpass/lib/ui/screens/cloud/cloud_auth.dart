import 'dart:async';

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/authpass_cloud_bloc.dart';
import 'package:authpass/ui/widgets/link_button.dart';
import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';
import 'package:simple_form_field_validator/simple_form_field_validator.dart';

final _logger = Logger('cloud_auth');

const _authPassCloudUrlInfo = AppConstants.authPassCloudInfoUrl;
const _authPassCloudUrlInfoOpen =
    '$_authPassCloudUrlInfo?utm_source=app&utm_campaign=cloud_login'; // NON-NLS

class AuthPassCloudAuthScreen extends StatelessWidget {
  static MaterialPageRoute<bool?> route() => MaterialPageRoute<bool?>(
        settings: const RouteSettings(name: '/auth_pass_cloud_auth/'),
        builder: (_) => AuthPassCloudAuthScreen(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.authPassCloud),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 500),
          child: AuthPassCloudAuth(),
        ),
      ),
    );
  }
}

class AuthPassCloudAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AuthPassCloudBloc>();

    switch (bloc.tokenStatus) {
      case TokenStatus.none:
        return _EnterEmailAddress(bloc: bloc);
      case TokenStatus.created:
        return _ConfirmEmailAddress(bloc: bloc);
      case TokenStatus.confirmed:
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pop(true);
        });
        break;
    }
    return Container();
  }
}

class _EnterEmailAddress extends StatefulWidget {
  const _EnterEmailAddress({Key? key, required this.bloc}) : super(key: key);
  final AuthPassCloudBloc bloc;

  @override
  __EnterEmailAddressState createState() => __EnterEmailAddressState();
}

class __EnterEmailAddressState extends State<_EnterEmailAddress>
    with FutureTaskStateMixin {
  final _form = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          LinkButton(
            onPressed: () async {
              await DialogUtils.openUrl(_authPassCloudUrlInfoOpen);
            },
            child: Text(
              [
                AppConstants.authPassCloud,
                CharConstants.newLine,
                loc.forDetailsVisitUrl(_authPassCloudUrlInfo)
              ].join(),
              textAlign: TextAlign.center,
            ),
          ),
          TextFormField(
            controller: _email,
            decoration: InputDecoration(
              labelText: loc.authPassCloudAuthEmailInputLabel,
              hintMaxLines: 2,
            ),
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.send,
            autocorrect: false,
            onEditingComplete: () {
              _submitCallback()?.call();
            },
            validator:
                SValidator.notEmpty(msg: loc.authPassCloudAuthEmailInvalid) +
                    SValidator.email(msg: loc.authPassCloudAuthEmailInvalid),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _submitCallback(),
            child: Text(loc.authPassCloudAuthConfirmEmailButtonLabel),
          ),
        ],
      ),
    );
  }

  VoidCallback? _submitCallback() => asyncTaskCallback((progress) async {
        if (_form.currentState!.validate()) {
          context
              .read<Analytics>()
              .events
              .trackCloudAuth(CloudAuthAction.authSend);
          await widget.bloc.authenticate(_email.text);
        }
      });
}

class _ConfirmEmailAddress extends StatefulWidget {
  const _ConfirmEmailAddress({Key? key, required this.bloc}) : super(key: key);

  final AuthPassCloudBloc bloc;

  @override
  __ConfirmEmailAddressState createState() => __ConfirmEmailAddressState();
}

class __ConfirmEmailAddressState extends State<_ConfirmEmailAddress>
    with FutureTaskStateMixin {
  Timer? _timer;
  bool _showResendButton = false;
  late Analytics _analytics;
  late DateTime _tokenCreatedAt;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tokenCreatedAt = widget.bloc.tokenCreatedAt ?? clock.now();
    if (_timer == null || !_timer!.isActive) {
      _scheduleCheck();
    }
    _analytics = context.read<Analytics>();
  }

  Future<void> _scheduleCheck() async {
    _timer = Timer(const Duration(seconds: 3), () async {
      if (!mounted) {
        _logger.fine('No longer mounted. Skipping checkConfirmed.');
        return;
      }
      await _checkConfirmed();
      unawaited(_scheduleCheck());
      _logger.fine('${clock.now().difference(_tokenCreatedAt)}');
      if (!_showResendButton &&
          clock.now().difference(_tokenCreatedAt) >
              const Duration(seconds: 30)) {
        setState(() {
          _showResendButton = true;
        });
      }
    });
  }

  Future<bool> _checkConfirmed() async {
    if (await widget.bloc.checkConfirmed()) {
      _analytics.events.trackCloudAuth(CloudAuthAction.authSuccess);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    return Column(
      children: [
        Text(loc.authPassCloudAuthConfirmEmail),
        const SizedBox(height: 32),
        Text(
          loc.authPassCloudAuthConfirmEmailExplain,
          style: theme.textTheme.caption,
        ),
        const SizedBox(height: 32),
        const CircularProgressIndicator(),
        const SizedBox(height: 32),
        if (_showResendButton) ...[
          TextButton(
            onPressed: asyncTaskCallback((task) async {
              _timer?.cancel();
              try {
                if (!await _checkConfirmed()) {
                  await DialogUtils.showSimpleAlertDialog(
                    context,
                    null,
                    loc.authPassCloudAuthNotConfirmed,
                    routeAppend: 'authPassCloudAuthNotConfirmed',
                    moreActions: [
                      TextButton(
                        onPressed: () {
                          DialogUtils.openUrl(UrlConstants.forumUrl);
                        },
                        child: Text(loc.getHelpButton),
                      )
                    ],
                  );
                }
              } finally {
                await _scheduleCheck();
              }
            }),
            child: Text(loc.authPassCloudAuthClickedLink),
          ),
          const SizedBox(height: 32),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Text(
              loc.authPassCloudAuthResendExplain,
              textAlign: TextAlign.center,
              style: theme.textTheme.caption!.copyWith(height: 1.4),
              maxLines: 5,
            ),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () {
              context
                  .read<Analytics>()
                  .events
                  .trackCloudAuth(CloudAuthAction.authResend);
              widget.bloc.clearToken();
            },
            child: Text(loc.authPassCloudAuthResendButtonLabel),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.bloc.tokenStatus != TokenStatus.confirmed) {
      _analytics.events.trackCloudAuth(CloudAuthAction.authCanceled);
    }
    _timer!.cancel();
    _timer = null;
  }
}
