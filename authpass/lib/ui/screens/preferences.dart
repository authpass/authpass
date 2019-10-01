import 'dart:io';

import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:autofill_service/autofill_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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

class _PreferencesBodyState extends State<PreferencesBody> {
  KdbxBloc _kdbxBloc;

  AutofillServiceStatus _autofillStatus;
  AutofillPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _doInit();
  }

  Future<void> _doInit() async {
    final autofill = AutofillService();
    _autofillStatus = await autofill.status();
    _prefs = await autofill.getPreferences();
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _kdbxBloc = Provider.of<KdbxBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ...?(!Platform.isAndroid || _prefs == null
            ? null
            : [
                SwitchListTile(
                  title: const Text('Enable autofill'),
                  subtitle: _autofillStatus == AutofillServiceStatus.unsupported
                      ? const Text('Only supported on Android Oreo (8.0) or later.')
                      : null,
                  value: _autofillStatus == AutofillServiceStatus.enabled,
                  onChanged: _autofillStatus == AutofillServiceStatus.unsupported
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
                  title: const Text('Enable debug'),
                  subtitle: const Text('Shows for every input field'),
                  value: _prefs.enableDebug,
                  onChanged: (val) async {
                    await AutofillService().setPreferences(AutofillPreferences(enableDebug: val));
                    await _doInit();
                  },
                ),
              ]),
        ListTile(
          leading: Icon(FontAwesomeIcons.signOutAlt),
          title: const Text('Lock all open files'),
          onTap: () async {
            _kdbxBloc.closeAllFiles();
            await Navigator.of(context).pushAndRemoveUntil(SelectFileScreen.route(), (_) => false);
          },
        ),
      ],
    );
  }
}
