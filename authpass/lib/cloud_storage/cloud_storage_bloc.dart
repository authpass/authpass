import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/dropbox/dropbox_provider.dart';
import 'package:authpass/cloud_storage/google_drive/google_drive_provider.dart';
import 'package:authpass/env/_base.dart';

class CloudStorageBloc {
  CloudStorageBloc(this.env)
      : availableCloudStorage = {
          DropboxProvider(env: env),
          GoogleDriveProvider(env: env),
        };

  final Env env;
  final Set<CloudStorageProvider> availableCloudStorage;
}
