import 'package:authpass/env/_base.dart';
import 'package:authpass/env/env.dart';

Future<void> main() async => await FDroid().start();

class FDroid extends EnvAppBase {
  FDroid() : super(EnvType.production);

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
  bool get featureFetchWebsiteIconEnabledByDefault => false;

  @override
  bool get featureCloudStorageProprietary => false;

  @override
  bool get diacDefaultDisabled => true;
}
