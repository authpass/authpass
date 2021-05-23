import 'package:authpass/utils/path_utils.dart';
import 'package:usage/usage_io.dart' as usage;

Future<usage.Analytics> analyticsCreate(
  String trackingId,
  String applicationName,
  String applicationVersion, {
  String? userAgent,
}) async {
  final docsDir = await PathUtils().getAppDataDirectory();
  return usage.AnalyticsIO(
    trackingId,
    applicationName,
    applicationVersion,
    documentDirectory: docsDir,
    userAgent: userAgent,
  );
}
