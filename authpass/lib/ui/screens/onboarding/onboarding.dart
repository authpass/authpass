import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/l10n/app_localizations.dart';
import 'package:authpass/ui/screens/create_file.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:logging/logging.dart';

final _logger = Logger('onboarding');

class OnboardingScreen extends StatelessWidget {
  static MaterialPageRoute<void> route() => MaterialPageRoute(
        settings: const RouteSettings(name: '/onboarding'),
        builder: (context) => OnboardingScreen(),
      );

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: OnboardingContent(loc: loc, theme: theme),
        ),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    Key key,
    @required this.loc,
    @required this.theme,
  }) : super(key: key);

  final AppLocalizations loc;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    var imageScaleFactor = 1.0;
    var onboardingHeadlineStyle = theme.textTheme.headline3;
    if (mq.orientation == Orientation.portrait) {
      // let's try to do some magic in portrait mode to fit it in.
      _logger.fine('height: ${mq.size.height}');
      if (mq.size.height < 600) {
        imageScaleFactor *= 0.5;
        onboardingHeadlineStyle =
            onboardingHeadlineStyle.apply(fontSizeFactor: 0.5);
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),
        Image.asset(
          'assets/images/authpass-logo-fit-512w.webp',
          height: 96 * imageScaleFactor,
          width: 96 * imageScaleFactor,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        Text(
          loc.onboardingHeadline,
          textAlign: TextAlign.center,
          style: onboardingHeadlineStyle,
        ),
        const SizedBox(height: 16),
        Text(
          loc.onboardingQuestion,
          textAlign: TextAlign.center,
          style:
              theme.textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        OnboardingButton(
          image: Image.asset('assets/images/safe-filled.webp'),
          labelText: loc.onboardingYesOpenPasswords,
          onPressed: () {
            SelectFileScreen.navigate(context);
            context.read<Analytics>().events.trackOnboardingExisting();
          },
        ),
        const SizedBox(height: 16),
        OnboardingButton(
          image: Image.asset('assets/images/safe-empty.webp'),
          labelText: loc.onboardingNoCreate,
          onPressed: () {
            Navigator.of(context).push(CreateFile.route());
            context.read<Analytics>().events.trackOnboardingNew();
          },
        ),
      ],
    );
  }
}

class OnboardingButton extends StatelessWidget {
  const OnboardingButton({
    Key key,
    @required this.image,
    @required this.labelText,
    @required this.onPressed,
  }) : super(key: key);

  final Image image;
  final String labelText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);

    _logger.fine('with: ${mq.size.width}');
    var textStyle = theme.primaryTextTheme.bodyText1.apply(
      fontSizeFactor: 1.5,
      shadows: const [
        Shadow(
          color: Colors.black38,
          blurRadius: 4,
        )
      ],
    );
    if (mq.size.width < 400) {
      textStyle = textStyle.apply(fontSizeFactor: 0.8);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        // elevation: 8,
        // borderRadius: const BorderRadius.all(Radius.circular(8)),
        onPressed: onPressed,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
              width: 96,
              height: 96,
              child: image,
            ),
            Expanded(
              child: Text(
                labelText,
                maxLines: 2,
                style: textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
