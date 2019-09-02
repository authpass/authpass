import 'package:authpass/env/_base.dart';

Future<void> main() async => await Development().start();

class Development extends Env {
  Development() : super(EnvType.development);

  @override
  String get analyticsAmplitudeApiKey => '35c469b59298de2f195ed3c979958dbc';
}
