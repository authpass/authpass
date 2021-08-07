import 'dart:async';
import 'dart:typed_data';

import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx/file_source_cloud_storage.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/utils/path_util.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

part 'cloud_storage_provider.g.dart';

final _logger = Logger('authpass.cloud_storage_provider');

class LoadFileException implements Exception {
  LoadFileException(this.message);
  final String message;

  @override
  String toString() {
    return 'LoadFileException{message: $message}'; // NON-NLS
  }
}

class LoadFileNotFoundException extends LoadFileException {
  LoadFileNotFoundException(String message) : super(message);

  @NonNls
  @override
  String toString() {
    return 'LoadFileNotFoundException{message: $message}';
  }
}

enum CloudStorageEntityType {
  directory,
  file,
  unknown,
}

abstract class CloudStorageEntity
    implements Built<CloudStorageEntity, CloudStorageEntityBuilder> {
  factory CloudStorageEntity(
          [void Function(CloudStorageEntityBuilder b)? updates]) =
      _$CloudStorageEntity;
  CloudStorageEntity._();

  // TODO: make this non-nullable
  String get id;
  CloudStorageEntityType? get type;
  String? get name;
  String? get path;

  String get pathOrBaseName => path ?? name ?? id;

  static CloudStorageEntity fromSimpleFileInfo(Map<String, String?> fileInfo) {
    return nonNls(CloudStorageEntity(
      (b) => b
        ..id = fileInfo['id']
        ..type = CloudStorageEntityType.file
        ..name = fileInfo['name']
        ..path = fileInfo['path'],
    ));
  }

  Map<String, String?> toSimpleFileInfo() => nonNls({
        'id': id,
        'name': name,
        'path': path,
      });
}

abstract class SearchResponse
    implements Built<SearchResponse, SearchResponseBuilder> {
  factory SearchResponse([void Function(SearchResponseBuilder b)? updates]) =
      _$SearchResponse;
  SearchResponse._();

  BuiltList<CloudStorageEntity?> get results;
  bool get hasMore;
}

enum PromptType {
  oauthTokenFlow,
  urlUsernamePassword,
  authPassCloudAuth,
}

abstract class UserAuthenticationPromptResult {}

class OAuthTokenResult extends UserAuthenticationPromptResult {
  OAuthTokenResult(this.code);
  final String? code;
}

class UrlUsernamePasswordResult extends UserAuthenticationPromptResult {
  UrlUsernamePasswordResult(this.url, this.username, this.password);
  final String url;
  final String username;
  final String password;
}

abstract class UserAuthenticationPromptData<
    T extends UserAuthenticationPromptResult?> {
  PromptType get type;
}

class OAuthTokenFlowPromptData
    extends UserAuthenticationPromptData<OAuthTokenResult> {
  OAuthTokenFlowPromptData(this.openUri);
  @override
  PromptType get type => PromptType.oauthTokenFlow;
  final String openUri;
}

/// Right now this is a pretty WebDAV specific prompt. But anyway.
class UrlUsernamePasswordPromptData
    extends UserAuthenticationPromptData<UrlUsernamePasswordResult> {
  UrlUsernamePasswordPromptData();

  @override
  PromptType get type => PromptType.urlUsernamePassword;
}

class UserAuthenticationPrompt<RESULT extends UserAuthenticationPromptResult,
    U extends UserAuthenticationPromptData<RESULT>> {
  UserAuthenticationPrompt(this.data, this.result);
  final U data;
  final PromptUserResult<RESULT> result;
}

typedef PromptUserForCode<T extends UserAuthenticationPromptResult,
        U extends UserAuthenticationPromptData<T>>
    = Future<void> Function(UserAuthenticationPrompt<T, U> prompt);
typedef PromptUserResult<T extends UserAuthenticationPromptResult> = void
    Function(T? result);

class CloudStorageSaveTarget {
  CloudStorageSaveTarget({required this.provider, this.parent});

  final CloudStorageEntity? parent;
  final CloudStorageProvider provider;
}

abstract class CloudStorageProvider {
  CloudStorageProvider({required this.helper});

  @protected
  final CloudStorageHelperBase helper;
  PathUtil get pathUtil => helper.pathUtil;

  /// whether we are initialized, authenticated and ready for requests.
  bool get isAuthenticated;

  String get id;
  String get displayName;
  FileSourceIcon get displayIcon;
  bool get supportSearch => false;
  Future<bool> loadSavedAuth();
  Future<bool> startAuth<RESULT extends UserAuthenticationPromptResult,
          DATA extends UserAuthenticationPromptData<RESULT>>(
      PromptUserForCode<RESULT, DATA> prompt);

  /// make sure to check [supportSearch] before calling this method, otherwise a [UnsupportedError] will be thrown.
  Future<SearchResponse> search({String name = Env.KeePassExtension}) =>
      throw UnsupportedError('Search not supported');
  Future<SearchResponse> list({CloudStorageEntity? parent});

  @protected
  Future<void> storeCredentials(String credentials) async {
    await helper.saveCredentials(id, credentials);
  }

  @protected
  Future<String?> loadCredentials() async {
    return await helper.loadCredentials(id);
  }

  String displayNameFromPath(Map<String, String?> fileInfo) =>
      path.basename(displayPath(fileInfo));

  String displayPath(Map<String, String?> fileInfo) =>
      CloudStorageEntity.fromSimpleFileInfo(fileInfo).pathOrBaseName;

  FileSource toFileSourceFromFileInfo(
    Map<String, String?> fileInfo, {
    required String uuid,
    required FileContent? initialCachedContent,
    String? databaseName,
  }) =>
      FileSourceCloudStorage(
        provider: this,
        fileInfo: fileInfo,
        uuid: uuid,
        databaseName: databaseName,
        initialCachedContent: initialCachedContent,
      );

  FileSource toFileSource(
    CloudStorageEntity entity, {
    required String uuid,
    required FileContent? initialCachedContent,
    String? databaseName,
  }) =>
      FileSourceCloudStorage(
        provider: this,
        fileInfo: entity.toSimpleFileInfo(),
        uuid: uuid,
        databaseName: databaseName,
        initialCachedContent: initialCachedContent,
      );

  Future<FileContent> loadFile(Map<String, String?> fileInfo) =>
      loadEntity(CloudStorageEntity.fromSimpleFileInfo(fileInfo));

  /// Saves the given bytes into the file source.
  /// [previousMetadata] will contain the metadata returned from the last [load] call.
  /// Can return a new metadata object for the next call.
  Future<Map<String, dynamic>> saveFile(Map<String, String?> fileInfo,
          Uint8List bytes, Map<String, dynamic>? previousMetadata) =>
      saveEntity(CloudStorageEntity.fromSimpleFileInfo(fileInfo), bytes,
          previousMetadata);

  Future<FileContent> loadEntity(CloudStorageEntity file);
  Future<Map<String, dynamic>> saveEntity(CloudStorageEntity file,
      Uint8List bytes, Map<String, dynamic>? previousMetadata);
  Future<FileSource> createEntity(
      CloudStorageSelectorSaveResult saveAs, Uint8List bytes);

  Future<void> logout();

  bool isSupported() => true;
}

abstract class CloudStorageHelperBase {
  PathUtil get pathUtil;
  Future<String?> loadCredentials(String cloudStorageId);

  Future<void> saveCredentials(String cloudStorageId, String data);
}

abstract class CloudStorageProviderClientBase<CLIENT>
    extends CloudStorageProvider {
  CloudStorageProviderClientBase({required CloudStorageHelperBase helper})
      : super(helper: helper);

  CLIENT? _client;

  @override
  bool get isAuthenticated => _client != null;

  @override
  Future<void> logout() async {
    final c = _client;
    if (c is http.Client) {
      c.close();
    }
    _client = null;
  }

  @protected
  Future<String?> oAuthTokenPrompt(PromptUserForCode prompt, String uri) async {
    final result = await promptUser<OAuthTokenResult, OAuthTokenFlowPromptData>(
        prompt as PromptUserForCode<OAuthTokenResult, OAuthTokenFlowPromptData>,
        OAuthTokenFlowPromptData(uri));
    return result?.code;
  }

  Future<RESULT?> promptUser<RESULT extends UserAuthenticationPromptResult,
          U extends UserAuthenticationPromptData<RESULT>>(
      PromptUserForCode<RESULT, U> prompt, U promptData) {
    final completer = Completer<RESULT?>();
    prompt(UserAuthenticationPrompt(promptData, (result) {
      completer.complete(result);
    })).then((_) {
      if (!completer.isCompleted) {
        _logger.severe(
            'prompt callback completed, without calling result code.',
            null,
            StackTrace.current);
      }
    }).catchError((Object error, StackTrace stackTrace) {
      completer.completeError(error, stackTrace);
    });
    return completer.future;
  }

  @protected
  Future<CLIENT> requireAuthenticatedClient() async {
    return (_client ??= await _loadStoredCredentials().then((client) async {
      if (client == null) {
        throw LoadFileException('Unable to load cloud storage credentials.');
      }
      return client;
    }))!;
  }

  Future<CLIENT?> _loadStoredCredentials() async {
    final credentialsJson = await loadCredentials();
    _logger.finer(
        'Tried to load auth. ${credentialsJson == null ? 'not found' : 'found'}');
    if (credentialsJson == null) {
      return null;
    }
    return clientWithStoredCredentials(credentialsJson);
  }

  @override
  Future<bool> startAuth<RESULT extends UserAuthenticationPromptResult,
          DATA extends UserAuthenticationPromptData<RESULT>>(
      PromptUserForCode<RESULT, DATA> prompt) async {
    _client = await clientFromAuthenticationFlow(prompt);
    return isAuthenticated;
  }

  CLIENT clientWithStoredCredentials(String stored);

  Future<CLIENT?> clientFromAuthenticationFlow<
          TF extends UserAuthenticationPromptResult,
          UF extends UserAuthenticationPromptData<TF>>(
      PromptUserForCode<TF, UF> prompt);

  @override
  Future<bool> loadSavedAuth() async {
    _client = await _loadStoredCredentials();
    return isAuthenticated;
  }
}

abstract class CloudStorageSelectorResult {}

class CloudStorageSelectorSaveResult implements CloudStorageSelectorResult {
  CloudStorageSelectorSaveResult(this.parent, this.fileName);
  final CloudStorageEntity? parent;
  final String fileName;
}

class CloudStorageSelectorLoadResult implements CloudStorageSelectorResult {
  CloudStorageSelectorLoadResult(this.fileSource);
  final FileSource fileSource;
}
