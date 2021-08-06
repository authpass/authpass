import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class OtpFieldEntryEditor extends StatelessWidget {
  const OtpFieldEntryEditor({
    Key? key,
    required this.otpCode,
    required this.elapsed,
    required this.period,
  }) : super(key: key);

  final String otpCode;
  final int elapsed;
  final int period;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return StreamBuilder(
      stream: Stream<void>.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: loc.otpEntryLabel,
            prefixIcon: CircularPercentIndicator(
              radius: 20.0,
              lineWidth: 4,
              percent: 1 - (elapsed / period.toDouble()),
              backgroundColor: Colors.black12,
              progressColor: Theme.of(context).primaryColor,
            ),
          ),
          child: Text(
            otpCode,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
