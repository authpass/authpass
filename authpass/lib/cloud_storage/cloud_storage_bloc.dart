import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/dropbox/dropbox_provider.dart';
import 'package:authpass/cloud_storage/google_drive/google_drive_provider.dart';
import 'package:authpass/cloud_storage/onedrive/onedrive_provider.dart';
import 'package:authpass/cloud_storage/webdav/webdav_provider.dart';
import 'package:authpass/env/_base.dart';

/// manages available cloud storages.
/// BloC is definitely the wrong name here...
class CloudStorageBloc {
  CloudStorageBloc(this.env)
      : _helper = CloudStorageHelper(env),
        availableCloudStorage = {} {
    if (env.featureCloudStorageProprietary) {
      availableCloudStorage.addAll({
        DropboxProvider(env: env, helper: _helper),
        GoogleDriveProvider(env: env, helper: _helper),
        OneDriveProvider(env: env, helper: _helper),
      }.where((element) => element.isSupported()));
    }
    if (env.featureCloudStorageWebDav) {
      availableCloudStorage.add(WebDavProvider(helper: _helper));
    }
  }

  final Env env;
  final CloudStorageHelper _helper;
  final Set<CloudStorageProvider> availableCloudStorage;

  CloudStorageProvider providerById(String id) =>
      availableCloudStorage.firstWhere((p) => p.id == id, orElse: () => null);
}
