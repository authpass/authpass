import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/screens/entry_details.dart';
import 'package:authpass/utils/otpauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kdbx/kdbx.dart';
import 'package:otp/otp.dart';
import 'package:base32/base32.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TotpFieldEntry extends StatefulWidget {
  const TotpFieldEntry({
    Key key,
    @required this.entry,
    @required this.fieldKey,
    this.commonField,
  }) : super(key: key);

  final KdbxEntry entry;
  final KdbxKey fieldKey;
  final CommonField commonField;

  @override
  _TotpFieldEntryState createState() => _TotpFieldEntryState();
}

class _TotpFieldEntryState extends State<TotpFieldEntry> {
  @override
  Widget build(BuildContext context) {
    final otpAuthUri = widget.entry.getString(widget.fieldKey)?.getText();
    final otpAuth = OtpAuth.fromUri(Uri.parse(otpAuthUri));
    final secretBase32 = base32.encode(otpAuth.secret);
    return StreamBuilder(
      stream: Stream<int>.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now().toUtc().millisecondsSinceEpoch;
        final elapsed = (now ~/ 1000) % otpAuth.period;
        final nextToken = otpAuth.period - elapsed;
        final totpCode = OTP.generateTOTPCode(
          secretBase32,
          now,
          algorithm: otpAuth.algorithm,
          length: otpAuth.digits,
          interval: otpAuth.period,
        );
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'One Time Token',
            prefixIcon: CircularPercentIndicator(
              radius: 20.0,
              lineWidth: 4,
              percent: 1 - (elapsed / otpAuth.period.toDouble()),
              backgroundColor: Colors.black12,
              progressColor: Theme.of(context).primaryColor,
            ),
          ),
          child: Text(
            '$totpCode',
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
