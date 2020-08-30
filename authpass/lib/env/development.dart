import 'package:authpass/env/_base.dart';
import 'package:authpass/env/env.dart';

Future<void> main() async => await Development().start();

class Development extends EnvAppBase {
  Development() : super(EnvType.development);

  @override
  String get storageNamespace => '${super.storageNamespace ?? ''}development';

  @override
  EnvSecrets get secrets => EnvSecrets.nullSecrets;
}
