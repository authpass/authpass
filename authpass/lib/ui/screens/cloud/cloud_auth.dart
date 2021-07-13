import 'dart:async';

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/authpass_cloud_bloc.dart';
import 'package:authpass/ui/widgets/link_button.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';
import 'package:simple_form_field_validator/simple_form_field_validator.dart';

class AuthPassCloudAuthScreen extends StatelessWidget {
  static MaterialPageRoute<void> route() => MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/auth_pass_cloud_auth/'),
        builder: (_) => AuthPassCloudAuthScreen(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthPass Cloud'),
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
          Navigator.of(context).pop();
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
    return Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          LinkButton(
            onPressed: () {
              DialogUtils.openUrl('https://authpass.app/docs/authpass-cloud/');
            },
            child: const Text(
              'AuthPass Cloud\n'
              'For details visit https://authpass.app/docs/authpass-cloud/',
              textAlign: TextAlign.center,
            ),
          ),
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(
              labelText: 'Enter email address to register or sign in.',
              hintMaxLines: 2,
            ),
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.send,
            onEditingComplete: () {},
            validator: SValidator.notEmpty(
                    msg: 'Please enter a valid email address.') +
                SValidator.email(msg: 'Please enter a valid email address.'),
          ),
          ElevatedButton(
            onPressed: _submitCallback(),
            child: const Text('Confirm Address'),
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

class __ConfirmEmailAddressState extends State<_ConfirmEmailAddress> {
  Timer? _timer;
  bool _showResendButton = false;
  late Analytics _analytics;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_timer == null || !_timer!.isActive) {
      _scheduleCheck();
    }
    _analytics = context.read<Analytics>();
  }

  Future<void> _scheduleCheck() async {
    _timer = Timer(const Duration(seconds: 3), () async {
      if (await widget.bloc.checkConfirmed()) {
        _analytics.events.trackCloudAuth(CloudAuthAction.authSuccess);
      }
      unawaited(_scheduleCheck());
      if (!_showResendButton) {
        setState(() {
          _showResendButton = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text('Please check your emails to confirm your email address.'),
        ...?_showResendButton
            ? [
                const SizedBox(height: 32),
                Text(
                  'If you have not received an email,\n'
                  'please check your spam folder. Otherwise you can try \n'
                  'to request a new confirmation link.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(height: 1.4),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<Analytics>()
                        .events
                        .trackCloudAuth(CloudAuthAction.authResend);
                    widget.bloc.clearToken();
                  },
                  child: const Text('Request a new confirmation link'),
                ),
              ]
            : null,
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
