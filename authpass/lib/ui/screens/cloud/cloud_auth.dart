import 'dart:async';

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
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pop();
        });
        break;
    }
    return Container();
  }
}

class _EnterEmailAddress extends StatefulWidget {
  const _EnterEmailAddress({Key key, @required this.bloc})
      : assert(bloc != null),
        super(key: key);
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
            child: const Text(
              'AuthPass Cloud\n'
              'For details visit https://authpass.app/docs/authpass-cloud/',
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              DialogUtils.openUrl('https://authpass.app/docs/authpass-cloud/');
            },
          ),
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(
              labelText: 'Enter email address to register or sign in.',
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.send,
            onEditingComplete: () {},
            validator: SValidator.notEmpty(
                    msg: 'Please enter a valid email address.') +
                SValidator.email(msg: 'Please enter a valid email address.'),
          ),
          RaisedButton(
            onPressed: _submitCallback(),
            child: const Text('Confirm Address'),
          ),
        ],
      ),
    );
  }

  VoidCallback _submitCallback() => asyncTaskCallback((progress) async {
        if (_form.currentState.validate()) {
          await widget.bloc.authenticate(_email.text);
        }
      });
}

class _ConfirmEmailAddress extends StatefulWidget {
  const _ConfirmEmailAddress({Key key, @required this.bloc})
      : assert(bloc != null),
        super(key: key);

  final AuthPassCloudBloc bloc;

  @override
  __ConfirmEmailAddressState createState() => __ConfirmEmailAddressState();
}

class __ConfirmEmailAddressState extends State<_ConfirmEmailAddress> {
  Timer _timer;
  bool _showResendButton = false;

  @override
  void initState() {
    super.initState();
    _scheduleCheck();
  }

  Future<void> _scheduleCheck() async {
    _timer = Timer(const Duration(seconds: 3), () async {
      await widget.bloc.checkConfirmed();
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
        if (_showResendButton)
          RaisedButton(
            onPressed: () {
              widget.bloc.clearToken();
            },
            child: const Text('Send a new confirmation link'),
          ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
