import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:archive/archive.dart' as archive;
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/authpass_cloud_bloc.dart';
import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx/file_source_cloud_storage.dart';
import 'package:authpass/bloc/kdbx/storage_exception.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/platform.dart';
import 'package:authpass_cloud_shared/authpass_cloud_shared.dart';
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:openapi_base/openapi_base.dart';
import 'package:pointycastle/export.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

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
      _$FileMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$FileMetadataToJson(this);
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

  @NonNls
  @override
  final String id = 'AuthPassCloudProvider';

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
  String get displayName => AppConstants.authPassCloud;

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
          fileList.files.map((e) => e.toCloudStorageEntity()),
        ),
    );
  }

  @override
  Future<FileContent> loadEntity(CloudStorageEntity file) async {
    final c = await getClient();
    final response =
        await c.filecloudFileRetrievePost(FileId(fileToken: file.id));
    final fileContent = response.requireSuccess();
    // FIXME there must be a better solution than to hard code `etag` here.
    const _etagHeader = 'etag'; // NON-NLS
    final versionToken = response.headers[_etagHeader]?.firstOrNull;
    if (versionToken == null) {
      _logger.warning('response did not contain $_etagHeader header.');
      throw StateError(
          'Missing $_etagHeader in response. got: ${response.headers} '
          '(${response.status})');
    }
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

  Future<bool> delete(CloudStorageEntity file) async {
    final client = await _authPassCloudBloc.client;
    await client
        .filecloudFileDeletePost(FileId(fileToken: file.id))
        .requireSuccess();
    return true;
  }

  Future<List<FileTokenInfo>> listShareTokens(CloudStorageEntity file) async {
    final client = await _authPassCloudBloc.client;
    final list = await client
        .filecloudFileTokenListPost(FileId(fileToken: file.id))
        .requireSuccess();
    return list.tokens;
  }

  Future<FileId> createShareToken(
    CloudStorageEntity file, {
    required String label,
    required bool readOnly,
  }) async {
    final client = await _client;
    final response = await client
        .filecloudFileTokenCreatePost(FilecloudFileTokenCreatePostSchema(
          fileToken: file.id,
          label: label,
          readOnly: readOnly,
        ))
        .requireSuccess();
    return response;
  }

  Future<LoadedShareToken> loadFromShareToken({required String token}) async {
    final client = await _client;
    final result = await client
        .filecloudFileMetadataPost(FileId(fileToken: token))
        .requireSuccess();
    final entity = result.toCloudStorageEntity();
    return LoadedShareToken(
      fileInfo: result,
      fileSource: toFileSource(
        entity,
        uuid: AppDataBloc.createUuid(),
        initialCachedContent: null,
      ),
    );
  }

  Future<AuthPassExternalAttachment> createAttachment({
    required FileSourceCloudStorage fileSource,
    required String name,
    required Uint8List bytes,
  }) async {
    final client = await _client;
    final entity = CloudStorageEntity.fromSimpleFileInfo(fileSource.fileInfo);
    final fileToken = entity.id;

    /// 32 bytes key plus 12 bytes nonce.
    final key = ByteUtils.randomBytes(32 + 12);
    final cipherKey = key.sublist(0, 32);
    final cipherNonce = key.sublist(32);
    final gzipped = _gzipEncode(bytes);
    _logger
        .finer('compressed attachment ${gzipped.length} (was ${bytes.length})');
    final chaCha = ChaCha7539Engine()
      ..init(true, ParametersWithIV(KeyParameter(cipherKey), cipherNonce));
    final encrypted = chaCha.process(gzipped);
    _logger.finer('encrypted attachment ${encrypted.length} - uploading…');

    final response = await client
        .filecloudAttachmentPost(encrypted,
            fileName: name, fileToken: fileToken)
        .requireSuccess();
    _logger.fine('Successfully uploaded file.');
    return AuthPassExternalAttachment(
      attachmentId: response.attachmentToken,
      secret: base64.encode(key),
      format: AttachmentFormat.gzipChaCha7539,
      size: bytes.length,
    );
  }

  Future<Uint8List> loadAttachment(AuthPassExternalAttachment info) async {
    final client = await _client;
    final data = await client
        .filecloudAttachmentRetrievePost(
            AttachmentId(attachmentToken: info.attachmentId))
        .requireSuccess();
    if (info.format != AttachmentFormat.gzipChaCha7539) {
      throw StateError('Unsupported.');
    }
    final key = base64.decode(info.secret);
    if (key.length != 32 + 12) {
      throw FormatException(
          'Expected secret to be 44 bytes. was: ${key.length}');
    }
    final cipherKey = key.sublist(0, 32);
    final cipherNonce = key.sublist(32);
    final chaCha = ChaCha7539Engine()
      ..init(false, ParametersWithIV(KeyParameter(cipherKey), cipherNonce));
    final compressed = chaCha.process(data);
    _logger.fine('decrypted attachment. ${compressed.length}');
    final content = _gzipDecode(compressed);
    _logger.fine('decompressed attachment. ${content.length}');
    return content;
  }

  Future<void> openedFile(KdbxBloc bloc, KdbxOpenedFile openedFile) async {
    final fileSource = openedFile.fileSource;
    if (fileSource is! FileSourceCloudStorage) {
      return;
    }
    final entity = CloudStorageEntity.fromSimpleFileInfo(fileSource.fileInfo);

    final watch = Stopwatch()..start();
    final attachments = openedFile.kdbxFile.ctx.binariesIterable
        .map((e) {
          final info = bloc.attachmentInfo(e);
          if (info == null) {
            return null;
          }
          return info.attachmentId;
        })
        .whereNotNull()
        .toList();
    bloc.analytics.trackTiming('touchAttachments', watch.elapsedMilliseconds);
    if (attachments.isNotEmpty) {
      final client = await _client;
      try {
        await client
            .filecloudAttachmentTouchPost(
              AttachmentTouch(
                file: FileId(fileToken: entity.id),
                attachmentTokens: attachments,
              ),
            )
            .requireSuccess();
        _logger.info('Touched ${attachments.length} attachments.');
      } catch (e, stackTrace) {
        _logger.severe('Unable to touch attachments.', e, stackTrace);
      }
    } else {
      _logger.info('No attachments.');
    }
  }

  Future<AuthPassCloudClient> get _client => _authPassCloudBloc.client;
}

class LoadedShareToken {
  LoadedShareToken({
    required this.fileInfo,
    required this.fileSource,
  });

  final FileInfo fileInfo;
  final FileSource fileSource;
}

extension FileInfoCloudStorage on FileInfo {
  CloudStorageEntity toCloudStorageEntity() => CloudStorageEntity(
        (cse) => cse
          ..id = fileToken
          ..name = name
          ..type = CloudStorageEntityType.file,
      );
}

@JsonSerializable()
class AuthPassExternalAttachment {
  AuthPassExternalAttachment({
    required this.attachmentId,
    required this.secret,
    required this.format,
    required this.size,
  });
  factory AuthPassExternalAttachment.fromJson(Map<String, dynamic> json) =>
      _$AuthPassExternalAttachmentFromJson(json);
  Map<String, dynamic> toJson() => _$AuthPassExternalAttachmentToJson(this);

  @JsonKey(name: 'id')
  final String attachmentId;

  /// for ChaCha7539 contains secret and nonce.
  final String secret;

  // @JsonKey(unknownEnumValue: AttachmentFormat.unsupported)
  final AttachmentFormat format;

  final int size;

  @NonNls
  String get identifier => prefixIdentifier;

  @NonNls
  static const prefixIdentifier = 'https://authpass.app/filecloud ';

  static late final prefixIdentifierBytes = utf8.encode(prefixIdentifier);
}

enum AttachmentFormat {
  gzipChaCha7539,
  unsupported,
}

Uint8List _gzipEncode(Uint8List bytes) {
  if (AuthPassPlatform.isWeb) {
    return archive.GZipEncoder().encode(bytes) as Uint8List;
  }
  return io.GZipCodec().encode(bytes) as Uint8List;
}

Uint8List _gzipDecode(Uint8List bytes) {
  if (AuthPassPlatform.isWeb) {
    return archive.GZipDecoder().decodeBytes(bytes) as Uint8List;
  }
  return io.GZipCodec().decode(bytes) as Uint8List;
}
