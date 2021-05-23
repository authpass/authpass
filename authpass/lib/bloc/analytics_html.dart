import 'package:usage/usage_html.dart' as usage;

Future<usage.Analytics> analyticsCreate(
  String trackingId,
  String applicationName,
  String applicationVersion, {
  String? userAgent,
}) async {
  return usage.AnalyticsHtml(
    trackingId,
    applicationName,
    applicationVersion,
  );
}
