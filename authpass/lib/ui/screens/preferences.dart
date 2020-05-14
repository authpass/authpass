import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:autofill_service/autofill_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

final _logger = Logger('preferences');

class PreferencesScreen extends StatelessWidget {
  static Route<void> route() => MaterialPageRoute(
        settings: const RouteSettings(name: '/preferences'),
        builder: (context) => PreferencesScreen(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: PreferencesBody(),
    );
  }
}

class PreferencesBody extends StatefulWidget {
  @override
  _PreferencesBodyState createState() => _PreferencesBodyState();
}

class _PreferencesBodyState extends State<PreferencesBody>
    with StreamSubscriberMixin {
  KdbxBloc _kdbxBloc;

  AutofillServiceStatus _autofillStatus;
  AutofillPreferences _autofillPrefs;

  AppDataBloc _appDataBloc;
  AppData _appData;

  @override
  void initState() {
    super.initState();
    _doInit();
  }

  Future<void> _doInit() async {
    final autofill = AutofillService();
    _autofillStatus = await autofill.status();
    if (_autofillStatus != AutofillServiceStatus.unsupported) {
      _autofillPrefs = await autofill.getPreferences();
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_kdbxBloc == null) {
      _kdbxBloc = Provider.of<KdbxBloc>(context);
      _appDataBloc = Provider.of<AppDataBloc>(context);
      handleSubscription(
          _appDataBloc.store.onValueChangedAndLoad.listen((appData) {
        setState(() {
          _appData = appData;
        });
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_appData == null) {
      return const Text('loading');
    }
    return Column(
      children: <Widget>[
        ...?(_autofillStatus == AutofillServiceStatus.unsupported ||
                _autofillPrefs == null
            ? null
            : [
                SwitchListTile(
                  secondary: const Icon(FontAwesomeIcons.iCursor),
                  title: const Text('Enable autofill'),
                  subtitle: _autofillStatus == AutofillServiceStatus.unsupported
                      ? const Text(
                          'Only supported on Android Oreo (8.0) or later.')
                      : null,
                  value: _autofillStatus == AutofillServiceStatus.enabled,
                  onChanged: _autofillStatus ==
                          AutofillServiceStatus.unsupported
                      ? null
                      : (val) async {
                          if (val) {
                            await AutofillService().requestSetAutofillService();
                          } else {
                            await AutofillService().disableAutofillServices();
                          }
                          await _doInit();
                        },
                ),
                SwitchListTile(
                  secondary: const Icon(FontAwesomeIcons.bug),
                  title: const Text('Enable debug'),
                  subtitle: const Text('Shows for every input field'),
                  value: _autofillPrefs.enableDebug,
                  onChanged: (val) async {
                    _logger.fine('Setting debug to $val');
                    await AutofillService()
                        .setPreferences(AutofillPreferences(enableDebug: val));
                    await _doInit();
                  },
                ),
              ]),
        ListTile(
          leading: Icon(FontAwesomeIcons.signOutAlt),
          title: const Text('Lock all open files'),
          onTap: () async {
            _kdbxBloc.closeAllFiles();
            await Navigator.of(context)
                .pushAndRemoveUntil(SelectFileScreen.route(), (_) => false);
          },
        ),
        ListTile(
          leading: Icon(
            FontAwesomeIcons.lightbulb,
          ),
          title: const Text('Theme'),
          trailing: _appData?.theme == null
              ? const Text('System Default')
              : _appData?.theme == AppDataTheme.light
                  ? const Text('Light')
                  : const Text('Dark'),
          onTap: () async {
            if (_appData == null) {
              return;
            }
            final nextTheme = _appData.theme == null
                ? AppDataTheme.light
                : _appData.theme == AppDataTheme.light
                    ? AppDataTheme.dark
                    : null;
            await _appDataBloc
                .update((builder, data) => builder.theme = nextTheme);
          },
        ),
        ValueSelectorTile(
          icon: const FaIcon(FontAwesomeIcons.arrowsAltH),
          title: const Text('Visual Density'),
          onChanged: (value) {
            _appDataBloc
                .update((builder, data) => builder.themeVisualDensity = value);
          },
          value: _appData.themeVisualDensity,
          minValue: -4,
          maxValue: 4,
          steps: 16,
        ),
        ValueSelectorTile(
          icon: const FaIcon(FontAwesomeIcons.textHeight),
          title: const Text('Text Scale Factor'),
          onChanged: (value) {
            _appDataBloc
                .update((builder, data) => builder.themeFontSizeFactor = value);
          },
          value: _appData.themeFontSizeFactor,
          minValue: 0.5,
          maxValue: 2,
          valueForNull: 1,
          steps: 15,
        ),
      ],
    );
  }
}

class ValueSelectorTile extends StatelessWidget {
  const ValueSelectorTile({
    Key key,
    @required this.value,
    @required this.minValue,
    @required this.maxValue,
    @required this.steps,
    @required this.onChanged,
    this.icon,
    this.title,
    this.valueForNull = 0,
  })  : assert(minValue != null),
        assert(maxValue != null),
        assert(steps != null),
        assert(valueForNull != null),
        super(key: key);

  final Widget icon;
  final Widget title;
  final double value;
  final double valueForNull;
  final double minValue;
  final double maxValue;
  final int steps;
  final void Function(double value) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final density = theme.visualDensity;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              icon,
              SizedBox(width: 32 + density.horizontal * 2),
              Expanded(
                child: DefaultTextStyle(
                  style: theme.textTheme.subtitle1,
                  child: title,
                ),
              ),
              Text(value == null ? 'Default' : value.toStringAsFixed(2)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.minusSquare),
                onPressed: () => _updateValue(-1),
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.plusSquare),
                onPressed: () => _updateValue(1),
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.times),
                onPressed: () => onChanged(null),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _updateValue(int stepDirection) {
    assert(stepDirection != null);
    final v = value ?? valueForNull;
    final valueStep = (maxValue - minValue) / steps;
    final newValue =
        (v + valueStep * stepDirection).clamp(minValue, maxValue).toDouble();
    if (value != newValue) {
      onChanged(newValue);
    }
  }
}

class SliderSelector extends StatefulWidget {
  const SliderSelector({
    Key key,
    @required this.initialValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.steps,
    @required this.onChanged,
  })  : assert(initialValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(steps != null),
        super(key: key);

  final double initialValue;
  final double minValue;
  final double maxValue;
  final int steps;
  final void Function(double value) onChanged;

  @override
  _SliderSelectorState createState() => _SliderSelectorState();
}

class _SliderSelectorState extends State<SliderSelector> {
  double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _value,
      min: widget.minValue,
      max: widget.maxValue,
      divisions: widget.steps,
      onChanged: (value) {
        setState(() {
          _value = value;
          widget.onChanged(value);
        });
      },
    );
  }
}
