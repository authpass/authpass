import 'package:authpass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/logo_icon.png',
              height: 128,
            ),
            Text(
              loc.onboardingHeadline,
              textAlign: TextAlign.center,
              style: theme.textTheme.headline3,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              loc.onboardingQuestion,
              textAlign: TextAlign.center,
              style: theme.textTheme.subtitle1,
            ),
            OnboardingButton(
              image: null,
              labelText: loc.onboardingNoCreate,
            ),
            OnboardingButton(
              image: null,
              labelText: loc.onboardingNoCreate,
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingButton extends StatelessWidget {
  const OnboardingButton({
    Key key,
    this.image,
    this.labelText,
  }) : super(key: key);

  final Icon image;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Row(
        children: [
          Text(labelText),
        ],
      ),
    );
  }
}
