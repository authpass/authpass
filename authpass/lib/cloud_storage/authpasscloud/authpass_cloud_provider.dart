import 'dart:async';
import 'dart:typed_data';

import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/authpass_cloud_bloc.dart';
import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx/storage_exception.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass_cloud_shared/authpass_cloud_shared.dart';
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:openapi_base/openapi_base.dart';

part 'authpass_cloud_provider.g.dart';

final _logger = Logger('authpass_cloud_provider');

class AuthPassCloudAuthPromptData
    extends UserAuthenticationPromptData<DummyUserAuthenticationPromptResult> {
  AuthPassCloudAuthPromptData();

  @override
  PromptType get type => PromptType.authPassCloudAuth;
}

class DummyUserAuthenticationPromptResult
    extends UserAuthenticationPromptResult {
  DummyUserAuthenticationPromptResult(this.authenticated);
  bool authenticated;
}

@JsonSerializable()
class _FileMetadata {
  _FileMetadata({
    required this.name,
    required this.fileToken,
    required this.versionToken,
  });
  factory _FileMetadata.fromJson(Map<String, dynamic> json) =>
      _$_FileMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$_FileMetadataToJson(this);
  Map<String, String> toJsonSimple() => toJson().cast();

  final String name;
  final String fileToken;
  final String versionToken;

  CloudStorageEntity toCloudStorageEntity() => CloudStorageEntity(
        (b) => b
          ..id = fileToken
          ..type = CloudStorageEntityType.file
          ..name = name,
      );
}

class AuthPassCloudProvider extends CloudStorageProvider
    with AuthPassCloudClientConsumer {
  AuthPassCloudProvider({required CloudStorageHelperBase helper})
      : super(helper: helper);

  /// will be injected later - pretty bad workaround..
  /// have to change it one day to be properly injected upfront.
  set authPassCloudBloc(AuthPassCloudBloc value) {
    _logger.info('Setting AuthPassCloudBloc to $value');
    _authPassCloudBloc = value;
  }

  late AuthPassCloudBloc _authPassCloudBloc;

  @protected
  @override
  AuthPassCloudBloc getAuthPassCloudBloc() => _authPassCloudBloc;

  @override
  Future<FileSource> createEntity(
      CloudStorageSelectorSaveResult saveAs, Uint8List bytes) async {
    final c = await getClient();
    final saved = await c
        .filecloudFilePost(bytes, fileName: saveAs.fileName)
        .requireSuccess();
    final metadata = _FileMetadata(
      name: saveAs.fileName,
      fileToken: saved.fileToken,
      versionToken: saved.versionToken,
    );
    final metadataJson = metadata.toJsonSimple();
    //c.checkStatusPost()
    return toFileSource(
      metadata.toCloudStorageEntity(),
      uuid: AppDataBloc.createUuid(),
      initialCachedContent: FileContent(bytes, metadataJson),
    );
  }

  @override
  final FileSourceIcon displayIcon = FileSourceIcon.authPass;

  @override
  String get displayName => 'AuthPass Cloud';

  @override
  bool get isAuthenticated =>
      _authPassCloudBloc.tokenStatus == TokenStatus.confirmed;

  @override
  Future<SearchResponse> list({CloudStorageEntity? parent}) async {
    final c = await getClient();
    final fileList = await c.filecloudFileGet().requireSuccess();
    return SearchResponse(
      (b) => b
        ..hasMore = false
        ..results.addAll(
          fileList.files.map((e) => CloudStorageEntity(
                (cse) => cse
                  ..id = e.fileToken
                  ..name = e.name
                  ..type = CloudStorageEntityType.file,
              )),
        ),
    );
  }

  @override
  Future<FileContent> loadEntity(CloudStorageEntity file) async {
    final c = await getClient();
    final response = await c.filecloudFileRetrievePost(
        FilecloudFileRetrievePostSchema(fileToken: file.id));
    final fileContent = response.requireSuccess();
    final versionToken = response.headers['etag']?.firstOrNull as String;
    final metadata = _FileMetadata(
      name: file.pathOrBaseName,
      fileToken: file.id,
      versionToken: versionToken,
    );
    return FileContent(fileContent, metadata.toJsonSimple());
  }

  @override
  Future<bool> loadSavedAuth() async {
    return _authPassCloudBloc.tokenStatus == TokenStatus.confirmed;
  }

  @override
  Future<void> logout() async {
    await _authPassCloudBloc.clearToken();
  }

  @override
  Future<Map<String, dynamic>> saveEntity(CloudStorageEntity file,
      Uint8List bytes, Map<String, dynamic>? previousMetadata) async {
    if (previousMetadata == null) {
      throw StateError('Expected previousMetadata.');
    }
    final c = await getClient();
    final metadata = _FileMetadata.fromJson(previousMetadata);
    final response = await c.filecloudFilePut(bytes,
        fileToken: file.id, versionToken: metadata.versionToken);
    late Map<String, dynamic> ret;
    response.map(on200: (r) {
      ret = _FileMetadata(
        name: metadata.name,
        fileToken: file.id,
        versionToken: r.body.versionToken,
      ).toJsonSimple();
    }, on409: (error) {
      throw StorageConflictException('Conflict while trying to save file.');
    });
    return ret;
  }

  @override
  Future<bool> startAuth<RESULT extends UserAuthenticationPromptResult,
          DATA extends UserAuthenticationPromptData<RESULT>>(
      PromptUserForCode<RESULT, DATA> prompt) async {
    final p = prompt as PromptUserForCode<DummyUserAuthenticationPromptResult,
        AuthPassCloudAuthPromptData>;
    final completer = Completer<bool>();
    await p(UserAuthenticationPrompt(AuthPassCloudAuthPromptData(),
        (DummyUserAuthenticationPromptResult? data) {
      completer.complete(true);
    }));
    return completer.future;
  }
}
