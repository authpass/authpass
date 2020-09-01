import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/utils/password_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
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
  const GeneratePassword(
      {Key key,
      this.doneButtonIcon,
      this.doneButtonLabel,
      this.doneButtonOnPressed})
      : super(key: key);

  final Icon doneButtonIcon;
  final String doneButtonLabel;
  final void Function(String password) doneButtonOnPressed;

  @override
  _GeneratePasswordState createState() => _GeneratePasswordState();
}

class _GeneratePasswordState extends State<GeneratePassword> {
  static const _characterSets = <String, CharacterSet>{
    'Lowercase (a-z)': CharacterSet.alphabetAsciiLowerCase,
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appData = Provider.of<AppData>(context);
    _passwordLength = appData.passwordGeneratorLength ?? _passwordLength;
    if (appData.passwordGeneratorCharacterSets.isNotEmpty) {
      _selectedCharacterSet
        ..clear()
        ..addAll(CharacterSet.characterSetFromIds(
            appData.passwordGeneratorCharacterSets));
    }
    _generatePassword();
  }

  void _generatePassword() {
    setState(() {
      _password = PasswordGenerator.singleton().generatePassword(
          CharacterSetCollection(_selectedCharacterSet.toList()),
          _passwordLength);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffix: IconButton(
                    icon: const Icon(Icons.content_copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _password));
                      Scaffold.of(context)
                        ..hideCurrentSnackBar(
                            reason: SnackBarClosedReason.remove)
                        ..showSnackBar(
                            const SnackBar(content: Text('Copied.')));
                    },
                  ),
                ),
                child: Text(_password),
              ),
            ),
            SimpleGridWidget(
              children: _characterSets.entries
                  .map<Widget>(
                    (entry) => OptionToggleTile(
                      label: entry.key.replaceFirst(' (', '\n('),
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
                  .toList(),
            ),
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
            ...?(widget.doneButtonOnPressed == null
                ? null
                : [
                    Center(
                      child: PrimaryButton(
                        child: Text(widget.doneButtonLabel ?? 'Done'),
                        onPressed: () {
                          final appDataBloc =
                              Provider.of<AppDataBloc>(context, listen: false);
                          appDataBloc.update((b, appData) => b
                            ..passwordGeneratorLength = _passwordLength
                            ..passwordGeneratorCharacterSets.replace(
                                _selectedCharacterSet.map<String>((set) =>
                                    CharacterSet.characterSetIdFor(set))));
                          widget.doneButtonOnPressed(_password);
                        },
                        icon: widget.doneButtonIcon ??
                            const Icon(Icons.check_circle_outline),
                        large: false,
                      ),
                    )
                  ]),
          ],
        ),
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
            .partition(
                children.followedBy(List.generate(
                    children.length % columns, (_) => Container())),
                columns)
            .map((partition) => Row(
                  mainAxisSize: MainAxisSize.max,
                  children:
                      partition.map((child) => Expanded(child: child)).toList(),
                ))
            .toList());
  }
}

class OptionToggleTile extends StatelessWidget {
  const OptionToggleTile({
    Key key,
    @required this.label,
    @required this.value,
    @required this.onChanged,
  })  : assert(label != null),
        assert(value != null),
        assert(onChanged != null),
        super(key: key);

  final String label;
  final bool value;
  final void Function(bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(value: value, onChanged: onChanged),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.subtitle1),
            ),
            // Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
      onTap: () {
        onChanged(!value);
      },
    );
  }
}
