import 'package:authpass/env/test_driver.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:authpass/env/production.dart' as app;

Future<void> main() async {
  // This line enables the extension.
  enableFlutterDriverExtension();

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  await TestDriverEnv().start();
}
