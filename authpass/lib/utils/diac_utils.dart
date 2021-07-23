import 'package:authpass/env/_base.dart';
import 'package:diac_client/diac_client.dart';

extension AppInfoDiac on AppInfo {
  DiacPackageInfo toDiacPackageInfo() => DiacPackageInfo(
        appName: appName,
        packageName: packageName,
        version: version,
        buildNumber: buildNumber.toString(),
      );
}
