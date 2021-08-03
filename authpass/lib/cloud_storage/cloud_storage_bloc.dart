import 'package:authpass/cloud_storage/authpasscloud/authpass_cloud_provider.dart';
import 'package:authpass/cloud_storage/cloud_storage_helper.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/dropbox/dropbox_provider.dart';
import 'package:authpass/cloud_storage/google_drive/google_drive_provider.dart';
import 'package:authpass/cloud_storage/onedrive/onedrive_provider.dart';
import 'package:authpass/cloud_storage/webdav/webdav_provider.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/utils/path_util.dart';
import 'package:collection/collection.dart' show IterableExtension;

/// manages available cloud storages.
/// BloC is definitely the wrong name here...
class CloudStorageBloc {
  CloudStorageBloc(this.env, PathUtil pathUtil)
      : _helper = CloudStorageHelper(env, pathUtil),
        availableCloudStorage = {} {
    availableCloudStorage.add(AuthPassCloudProvider(helper: _helper));
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

  CloudStorageProvider? providerById(String? id) =>
      availableCloudStorage.firstWhereOrNull((p) => p.id == id);
}
