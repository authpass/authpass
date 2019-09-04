import 'package:authpass/env/_base.dart';

import 'secrets.dart';

Future<void> main() async => await Production().start();

class Production extends Env {
  Production() : super(EnvType.production);

  @override
  EnvSecrets get secrets => PROD_SECRETS;
}
