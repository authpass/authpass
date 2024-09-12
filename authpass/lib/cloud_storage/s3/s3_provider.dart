import 'dart:convert';
import 'dart:typed_data';

import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/s3/s3_models.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/utils/uuid_util.dart';
import 'package:aws_client/s3_2006_03_01.dart';
// ignore: implementation_imports
import 'package:aws_client/src/shared/shared.dart';
import 'package:logging/logging.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('authpass.amazon_s3_provider');

@NonNls
const _METADATA_ETAG = 'etag';

class S3Client {
  S3Client(this.credentials)
      : api = S3(
            region: credentials.authRegion,
            credentials: AwsClientCredentials(
                accessKey: credentials.accessKey,
                secretKey: credentials.secretKey),
            endpointUrl: credentials.serviceUrl);

  S3Metadata credentials;
  final S3 api;

  bool isReadable(List<Grant>? grants) {
    if (grants == null || grants.isEmpty) {
      return false;
    }

    return List.from(grants.where((g) =>
        g.permission == Permission.read ||
        g.permission == Permission.fullControl)).isNotEmpty;
  }

  Future<List<CloudStorageEntity>> listBuckets() async {
    final output = await api.listBuckets();
    final List<Bucket> accessibleBuckets = [];

    if (output.buckets == null) {
      return [];
    }

    for (final bucket in output.buckets!) {
      if (bucket.name == null) {
        continue;
      }

      try {
        final bucketAcl = await api.getBucketAcl(bucket: bucket.name!);
        if (isReadable(bucketAcl.grants)) {
          accessibleBuckets.add(bucket);
        }
      } on GenericAwsException catch (e) {
        _logger.warning('Cant access bucket ${bucket.name} ACL $e');
        continue;
      }
    }
    return List.from(accessibleBuckets.map((e) => CloudStorageEntity((b) => b
      ..id = e.name
      ..type = CloudStorageEntityType.directory
      ..name = e.name
      ..path = e.name)));
  }

  Future<List<CloudStorageEntity>> listKDBXObjects(String bucket) async {
    final objects = await api.listObjects(bucket: bucket);
    final List<Object> kdbxObjects = [];

    if (objects.contents == null) {
      return [];
    }

    for (final object in objects.contents!) {
      if (object.key == null) {
        continue;
      }

      if (!object.key!.endsWith('.kdbx' // NON-NLS
          )) {
        continue;
      }

      try {
        final objectAcl =
            await api.getObjectAcl(bucket: bucket, key: object.key!);
        if (isReadable(objectAcl.grants)) {
          kdbxObjects.add(object);
        }
      } on GenericAwsException catch (e) {
        _logger.warning('Cant access object $bucket//${object.key} ACL ($e)');
        continue;
      }
    }

    return List.from(kdbxObjects.map((e) => CloudStorageEntity((b) => b
      ..id = bucket
      ..type = CloudStorageEntityType.file
      ..name = e.key
      ..path = e.key)));
  }

  Future<FileContent> loadObject(String bucket, String key) {
    return api.getObject(bucket: bucket, key: key).then((output) {
      return FileContent(output.body ?? Uint8List(0));
    });
  }

  Future<Map<String, dynamic>> writeObject(
      String bucket, String key, Uint8List bytes) {
    return api.putObject(bucket: bucket, key: key, body: bytes).then((output) {
      return {_METADATA_ETAG: output.eTag};
    });
  }
}

class S3Provider extends CloudStorageProviderClientBase<S3Client> {
  S3Provider({required this.env, required super.helper});

  final Env env;

  @NonNls
  @override
  final String id = 'S3Provider';

  @override
  Future<S3Client?> clientFromAuthenticationFlow<
          TF extends UserAuthenticationPromptResult,
          UF extends UserAuthenticationPromptData<TF>>(
      PromptUserForCode<TF, UF> prompt) async {
    assert(prompt is PromptUserForCode<S3PromptResult, S3PromptData>);
    final urlPrompt = prompt as PromptUserForCode<S3PromptResult, S3PromptData>;
    final result = await promptUser<S3PromptResult, S3PromptData>(
        urlPrompt, S3PromptData());

    if (result == null) {
      _logger.finer('prompt was canceled by user.');
      return null;
    }

    final credentials = S3Metadata(
        serviceUrl: result.serviceUrl,
        accessKey: result.accessKey,
        secretKey: result.secretKey,
        authRegion: result.authRegion);
    final client = S3Client(credentials);

    await storeCredentials(json.encode(credentials));
    return client;
  }

  @override
  S3Client clientWithStoredCredentials(String stored) {
    final credentials =
        S3Metadata.fromJson(json.decode(stored) as Map<String, dynamic>);
    return S3Client(credentials);
  }

  @override
  Future<FileSource> createEntity(
      CloudStorageSelectorSaveResult saveAs, Uint8List bytes) async {
    // TODO: implement createEntity
    final bucket = saveAs.parent!.name!;
    var filename = saveAs.fileName;

    if (!filename.endsWith('.kdbx' // NON-NLS
        )) {
      filename = '$filename.kdbx'; // NON-NLS
    }

    final client = await requireAuthenticatedClient();
    final metadata = await client.writeObject(bucket, filename, bytes);
    return toFileSource(
        CloudStorageEntity((b) => b
          ..id = bucket
          ..type = CloudStorageEntityType.file
          ..name = filename
          ..path = filename),
        uuid: UuidUtil.createUuid(),
        initialCachedContent: FileContent(bytes, metadata),
        databaseName: bucket);
  }

  @override
  FileSourceIcon get displayIcon => FileSourceIcon.S3;

  @override
  String get displayName => 'S3'; // NON-NLS

  @override
  Future<SearchResponse> list({CloudStorageEntity? parent}) async {
    // TODO: implement list
    final client = await requireAuthenticatedClient();
    if (parent == null) {
      return client.listBuckets().then((buckets) {
        return SearchResponse((srb) => srb
          ..results.addAll(buckets)
          ..hasMore = false);
      });
    }

    if (parent.type == CloudStorageEntityType.directory) {
      return client.listKDBXObjects(parent.name!).then((kdbxFiles) {
        return SearchResponse((srb) => srb
          ..results.addAll(kdbxFiles)
          ..hasMore = false);
      });
    }

    throw UnimplementedError();
  }

  @override
  Future<FileContent> loadEntity(CloudStorageEntity file) async {
    final client = await requireAuthenticatedClient();
    return client.loadObject(file.id, file.path!);
  }

  @override
  Future<Map<String, dynamic>> saveEntity(CloudStorageEntity file,
      Uint8List bytes, Map<String, dynamic>? previousMetadata) async {
    // TODO: implement saveEntity
    final client = await requireAuthenticatedClient();
    return client.writeObject(file.id, file.path!, bytes);
  }
}
