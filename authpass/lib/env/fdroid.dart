import 'package:authpass/env/_base.dart';

Future<void> main() async => await FDroid().start();

class FDroid extends Env {
  FDroid() : super(EnvType.development);

  @override
  EnvSecrets get secrets => const EnvSecrets(
        analyticsAmplitudeApiKey: null,
        analyticsGoogleAnalyticsId: null,
        googleClientId: null,
        googleClientSecret: null,
        dropboxKey: null,
        dropboxSecret: null,
        microsoftClientId: null,
        microsoftClientSecret: null,
      );

  @override
  bool get featureCloudStorageProprietary => false;

  @override
  bool get diacDefaultDisabled => true;
}
