import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/env/test_driver.dart';
import 'package:authpass/main.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // This line enables the extension.
  enableFlutterDriverExtension(handler: (message) async {
    switch (message) {
      case 'nextTheme':
        final appDataBloc =
            AuthPassApp.currentNavigatorKey.currentContext.read<AppDataBloc>();
        return (await appDataBloc.updateNextTheme()).toString();
    }
    return 'unknown';
  });

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  await TestDriverEnv().start();
}
