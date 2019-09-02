import 'package:authpass/main.dart';

enum EnvType { production, development }

abstract class Env {
  Env(this.type) {
    value = this;
  }

  static Env value;

  final EnvType type;

  Future<void> start() async {
    await startApp(this);
  }

  String get name => runtimeType.toString();

  String get analyticsAmplitudeApiKey => null;
}
