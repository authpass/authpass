import 'package:authpass/env/_base.dart';

Future<void> main() async => await Production().start();

class Production extends Env {
  Production() : super(EnvType.production);
}
