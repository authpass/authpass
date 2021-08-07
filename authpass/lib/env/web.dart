import 'package:authpass/env/_base.dart';
import 'package:authpass/env/env.dart';

Future<void> main() async => await WebProduction().start();

class WebProduction extends EnvAppBase {
  WebProduction() : super(EnvType.production);

  @override
  bool get featureCloudStorageProprietary => false;

  @override
  bool get featureCloudStorageWebDav => false;

  @override
  EnvSecrets? get secrets => EnvSecrets.nullSecrets;
}
