import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/ui/screens/main_app_scaffold.dart';
import 'package:authpass/ui/widgets/password_input_field.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/extension_methods.dart';
import 'package:authpass/utils/password_entropy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
// ignore: implementation_imports
import 'package:zxcvbn/src/result.dart';
import 'package:zxcvbn/zxcvbn.dart';

final _logger = Logger('create_file');

class CreateFile extends StatefulWidget {
  static PageRoute<void> route() => MaterialPageRoute(
        settings: const RouteSettings(name: '/createFile'),
        builder: (context) => CreateFile(),
      );

  @override
  _CreateFileState createState() => _CreateFileState();
}

class _CreateFileState extends State<CreateFile> with FutureTaskStateMixin {
  static final _zxcvbn = Zxcvbn();
  static final _calculatePasswordEntropy=PasswordEntropy();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _databaseName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  Result _strength;
  String _passwordEntropy;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = AppLocalizations.of(context);
    if (_databaseName.text.isEmpty) {
      _databaseName.text = loc.databaseCreateDefaultName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.createPasswordDatabase),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
          child: Theme(
            data: theme.copyWith(
                inputDecorationTheme:
                    theme.inputDecorationTheme.copyWith(filled: true)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _databaseName,
                  decoration: InputDecoration(
                    labelText: loc.nameNewPasswordDatabase,
                    suffixText: '.kdbx', // NON-NLS
                    filled: true,
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (val) => _passwordFocus.requestFocus(),
                  validator: (val) {
                    if (val.isEmpty) {
                      return loc.validatorNameMissing;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                PasswordInputField(
                  labelText: loc.inputMasterPasswordText,
                  controller: _password,
                  focusNode: _passwordFocus,
                  autofocus: true,
                  onFieldSubmitted: (val) => _submitCallback()(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) {
                    final userInput = _databaseName.text.pathCase.split('/');
                    setState(() {
                      if (value.isEmpty) {
                        _strength = null;
                        _passwordEntropy = null;
                      } else {
                        _strength =
                            _zxcvbn.evaluate(value, userInputs: userInput);
                        _passwordEntropy =
                            _calculatePasswordEntropy.passwordEntropy(value);
                      }
                    });
                  },
                  validator: (val) {
                    if (val.isEmpty) {
                      return loc.masterPasswordMissingCreate;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                PasswordStrengthDisplay(strength: _strength),
                const SizedBox(height: 8),
                _passwordEntropy!=null?Text('Entrophy: $_passwordEntropy'):Container(),
                const SizedBox(height: 8),
                Text(
                  'The master password is used to securely encrypt your password database. Make sure to remember it, it can not be restored.',
                  style: Theme.of(context).textTheme.caption,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  alignment: Alignment.centerRight,
                  child: task != null
                      ? const CircularProgressIndicator(
                          backgroundColor: Colors.red,
                        )
                      : PrimaryButton(
                          large: false,
                          child: Text(loc.createDatabaseAction),
                          onPressed: _submitCallback(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  VoidCallback _submitCallback() => asyncTaskCallback((progress) async {
        if (_formKey.currentState.validate()) {
          final kdbxBloc = Provider.of<KdbxBloc>(context, listen: false);
          try {
            final created = await kdbxBloc.createFile(
              password: _password.text,
              databaseName: _databaseName.text,
              openAfterCreate: true,
            );
            assert(created != null);
            await Navigator.of(context)
                .pushAndRemoveUntil(MainAppScaffold.route(), (route) => false);
          } on FileExistsException catch (e, stackTrace) {
            _logger.warning('Showing file exists error dialog.', e, stackTrace);
            final loc = AppLocalizations.of(context);
            await DialogUtils.showSimpleAlertDialog(
              context,
              loc.databaseExistsError,
              loc.databaseExistsErrorDescription(e.path),
              routeAppend: 'createFileExists',
            );
          } catch (e, stackTrace) {
            _logger.severe('Error while creating file.', e, stackTrace);
            rethrow;
          }
        }
      });
}

class PasswordStrengthDisplay extends ImplicitlyAnimatedWidget {
  const PasswordStrengthDisplay({Key key, this.strength})
      : super(key: key, duration: const Duration(milliseconds: 500));

  final Result strength;

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

  Tween<double> _scoreTween;
  ColorTween _colorTween;
  ColorTween _backgroundColorTween;

  @override
  void forEachTween(visitor) {
    _scoreTween = visitor(
            _scoreTween,
            widget.strength?.score?.let((val) => val + 1) ?? 0.0,
            (dynamic value) => Tween<double>(begin: value as double))
        as Tween<double>;
    _colorTween = visitor(
        _colorTween,
        _strengthColors[widget.strength?.score?.toInt() ?? 0],
        (dynamic value) => ColorTween(begin: value as Color)) as ColorTween;
    _backgroundColorTween = visitor(
        _backgroundColorTween,
        widget.strength == null ? Colors.redAccent : Colors.grey,
        (dynamic value) => ColorTween(begin: value as Color)) as ColorTween;
  }

  @override
  Widget build(BuildContext context) {
    final _strength = widget.strength;
    // final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final feedback = _strength?.feedback?.warning?.takeUnlessBlank() ??
        // _strength?.feedback?.suggestions?.firstOrNull ??
        ''; // NON-NLS

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_strength != null) ...[
          LinearProgressIndicator(
            value: _scoreTween.evaluate(animation) / 5.0,
            valueColor: AlwaysStoppedAnimation(
              _colorTween.evaluate(animation),
            ),
            backgroundColor: _backgroundColorTween.evaluate(animation),
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
            value: _scoreTween.evaluate(animation) / 5.0,
            valueColor: AlwaysStoppedAnimation(_colorTween.evaluate(animation)),
            backgroundColor: _backgroundColorTween.evaluate(animation),
          ),
          const SizedBox(height: 4),
          const Text(' '), // NON-NLS
        ],
      ],
    );
  }
}
