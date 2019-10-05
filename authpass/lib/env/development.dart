import 'package:authpass/env/_base.dart';

Future<void> main() async => await Development().start();

class Development extends Env {
  Development() : super(EnvType.development);

  @override
  String get storageNamespace => 'development';

  @override
  EnvSecrets get secrets => const EnvSecrets(
        analyticsAmplitudeApiKey: null,
        analyticsGoogleAnalyticsId: null,
        googleClientId: null,
        googleClientSecret: null,
        dropboxKey: null,
        dropboxSecret: null,
      );
}
