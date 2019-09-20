import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/utils/password_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:quiver/iterables.dart' as iterables;

class PasswordGeneratorScreen extends StatelessWidget {
  static Route<String> route() => MaterialPageRoute(
        settings: const RouteSettings(name: '/passwordGenerator'),
        builder: (context) => PasswordGeneratorScreen(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Generator'),
      ),
      body: GeneratePassword(
        doneButtonOnPressed: (password) => Navigator.of(context).pop(password),
      ),
    );
  }
}

class GeneratePassword extends StatefulWidget {
  const GeneratePassword({Key key, this.doneButtonIcon, this.doneButtonLabel, this.doneButtonOnPressed})
      : super(key: key);

  final Icon doneButtonIcon;
  final String doneButtonLabel;
  final void Function(String password) doneButtonOnPressed;

  @override
  _GeneratePasswordState createState() => _GeneratePasswordState();
}

class _GeneratePasswordState extends State<GeneratePassword> {
  static const _characterSets = <String, CharacterSet>{
    'Lowerase (a-z)': CharacterSet.alphabetAsciiLowerCase,
    'Uppercase (A-Z)': CharacterSet.alphabetAsciiUpperCase,
    'Numeric (0-9)': CharacterSet.numeric,
    'Umlauts (ä)': CharacterSet.alphabetUmlauts,
    'Special (@%+)': CharacterSet.specialCharacters,
  };

  static const _defaultCharacterSets = {
    CharacterSet.alphabetAsciiLowerCase,
    CharacterSet.alphabetAsciiUpperCase,
    CharacterSet.numeric,
  };

  static const int passwordLengthMin = 5;
  static const int passwordLengthMax = 40;

  final Set<CharacterSet> _selectedCharacterSet = Set.of(_defaultCharacterSets);

  String _password;
  int _passwordLength = 20;

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  void _generatePassword() {
    setState(() {
      _password = PasswordGenerator.singleton()
          .generatePassword(CharacterSetCollection(_selectedCharacterSet.toList()), _passwordLength);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Password',
                suffix: IconButton(
                  icon: Icon(Icons.content_copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _password));
                    Scaffold.of(context)
                      ..hideCurrentSnackBar(reason: SnackBarClosedReason.remove)
                      ..showSnackBar(const SnackBar(content: Text('Copied.')));
                  },
                ),
              ),
              child: Text(_password),
            ),
          ),
          SimpleGridWidget(
            children: _characterSets.entries
                .map<Widget>(
              (entry) => SwitchListTile(
                title: Text(entry.key),
                value: _selectedCharacterSet.contains(entry.value),
                onChanged: (val) {
                  setState(() {
                    if (val) {
                      _selectedCharacterSet.add(entry.value);
                    } else {
                      _selectedCharacterSet.remove(entry.value);
                    }
                    _generatePassword();
                  });
                },
              ),
            )
                .followedBy(
              [
                Row(
                  children: <Widget>[
                    const SizedBox(width: 16),
                    const Text('Length'),
                    Expanded(
                      child: Slider(
                        value: _passwordLength.toDouble(),
                        min: passwordLengthMin.toDouble(),
                        max: passwordLengthMax.toDouble(),
                        divisions: (passwordLengthMax - passwordLengthMin),
                        label: _passwordLength.toString(),
                        onChanged: (val) {
                          setState(() {
                            _generatePassword();
                            _passwordLength = val.round();
                          });
                        },
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 32),
                      child: Text(_passwordLength.toString()),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ],
            ).toList(),
          ),
          ...?(widget.doneButtonOnPressed == null
              ? null
              : [
                  Center(
                    child: PrimaryButton(
                      child: Text(widget.doneButtonLabel ?? 'Done'),
                      onPressed: () => widget.doneButtonOnPressed(_password),
                      icon: widget.doneButtonIcon ?? Icon(Icons.check_circle_outline),
                      large: false,
                    ),
                  )
                ]),
        ],
      ),
    );
  }
}

class SimpleGridWidget extends StatelessWidget {
  const SimpleGridWidget({
    Key key,
    this.columns = 2,
    @required this.children,
  })  : assert(children != null),
        super(key: key);

  final int columns;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: iterables
            .partition(children.followedBy(List.generate(children.length % columns, (_) => Container())), columns)
            .map((partition) => Row(
                  mainAxisSize: MainAxisSize.max,
                  children: partition.map((child) => Expanded(child: child)).toList(),
                ))
            .toList());
  }
}
