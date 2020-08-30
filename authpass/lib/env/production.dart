import 'package:authpass/env/_base.dart';
import 'package:authpass/env/env.dart';

import 'secrets.dart';

Future<void> main() async => await Production().start();

class Production extends EnvAppBase {
  Production() : super(EnvType.production);

  @override
  EnvSecrets get secrets => PROD_SECRETS;
}
