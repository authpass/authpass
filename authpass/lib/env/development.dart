import 'package:authpass/env/_base.dart';

Future<void> main() async => await Development().start();

class Development extends Env {
  Development() : super(EnvType.development);

  @override
  String get storageNamespace => '${super.storageNamespace ?? ''}development';

  @override
  EnvSecrets get secrets => EnvSecrets.nullSecrets;
}
