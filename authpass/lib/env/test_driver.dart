import 'package:authpass/env/_base.dart';

Future<void> main() async => await TestDriverEnv().start();

class TestDriverEnv extends Env {
  TestDriverEnv() : super(EnvType.production);

  @override
  EnvSecrets get secrets => EnvSecrets.nullSecrets;
}
