import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/l10n/app_localizations.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:logging/logging.dart';

final _logger = Logger('locked_screen');

class LockedScreen extends StatelessWidget {
  static MaterialPageRoute<void> route() => MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/lock'),
        builder: (context) => LockedScreen(),
      );

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final kdbxBloc = context.watch<KdbxBloc>();

    if (!kdbxBloc.hasQuickUnlockOpen()) {
      _logger.fine('hasQuickUnlock: false');
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SelectFileScreen.navigate(context);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(Env.AuthPass),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.lock,
              size: 128,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              child: Text(loc.unlock),
              onPressed: () {
                SelectFileScreen.navigate(context);
              },
            ),
            const SizedBox(height: 128),
          ],
        ),
      ),
    );
  }
}
