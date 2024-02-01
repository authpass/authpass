import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:flutter/widgets.dart';

abstract interface class CloudStorageCustomLoginButtonAdapter
    implements CloudStorageProvider {
  Widget getCustomLoginWidget({
    required VoidCallback onSuccess,
    required Widget defaultWidget,
  });
}
