import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

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
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SelectFileScreen.navigate(context);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(Env.AuthPass),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
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
                  onPressed: () {
                    SelectFileScreen.navigate(context);
                  },
                  child: Text(loc.unlock),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          Container(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () async {
                await kdbxBloc.closeAllFiles(clearQuickUnlock: true);
                await SelectFileScreen.navigate(context);
              },
              child: Text(loc.closePasswordFiles.toUpperCase()),
            ),
          ),
        ],
      ),
    );
  }
}
