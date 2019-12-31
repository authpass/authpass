import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_ui.dart';
import 'package:authpass/env/_base.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

part 'cloud_storage_provider.g.dart';

final _logger = Logger('authpass.cloud_storage_provider');

class LoadFileException implements Exception {
  LoadFileException(this.message);
  final String message;

  @override
  String toString() {
    return 'LoadFileException{message: $message}';
  }
}

enum CloudStorageEntityType {
  directory,
  file,
}

abstract class CloudStorageEntity implements Built<CloudStorageEntity, CloudStorageEntityBuilder> {
  factory CloudStorageEntity([void updates(CloudStorageEntityBuilder b)]) = _$CloudStorageEntity;
  CloudStorageEntity._();

  String get id;
  CloudStorageEntityType get type;
  String get name;
  @nullable
  String get path;

  String get pathOrBaseName => path ?? name;

  static CloudStorageEntity fromSimpleFileInfo(Map<String, String> fileInfo) {
    return CloudStorageEntity(
      (b) => b
        ..id = fileInfo['id']
        ..type = CloudStorageEntityType.file
        ..name = fileInfo['name']
        ..path = fileInfo['path'],
    );
  }

  Map<String, String> toSimpleFileInfo() => {
        'id': id,
        'name': name,
        'path': path,
      };
}

abstract class SearchResponse implements Built<SearchResponse, SearchResponseBuilder> {
  factory SearchResponse([void updates(SearchResponseBuilder b)]) = _$SearchResponse;
  SearchResponse._();

  BuiltList<CloudStorageEntity> get results;
  bool get hasMore;
}

enum PromptType {
  oauthTokenFlow,
  urlUsernamePassword,
}

abstract class UserAuthenticationPromptResult {}

class OAuthTokenResult extends UserAuthenticationPromptResult {
  OAuthTokenResult(this.code);
  final String code;
}

class UrlUsernamePasswordResult extends UserAuthenticationPromptResult {
  UrlUsernamePasswordResult(this.url, this.username, this.password);
  final String url;
  final String username;
  final String password;
}

abstract class UserAuthenticationPromptData<T extends UserAuthenticationPromptResult> {
  PromptType get type;
}

class OAuthTokenFlowPromptData extends UserAuthenticationPromptData<OAuthTokenResult> {
  OAuthTokenFlowPromptData(this.openUri);
  @override
  PromptType get type => PromptType.oauthTokenFlow;
  final String openUri;
}

/// Right now this is a pretty WebDAV specific prompt. But anyway.
class UrlUsernamePasswordPromptData extends UserAuthenticationPromptData<UrlUsernamePasswordResult> {
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

typedef PromptUserForCode<T extends UserAuthenticationPromptResult, U extends UserAuthenticationPromptData<T>>
    = Future<void> Function(UserAuthenticationPrompt<T, U> prompt);
typedef PromptUserResult<T extends UserAuthenticationPromptResult> = void Function(T result);

/// Common functionality shared across all cloud storages,
/// right now simply storing of oauth tokens.
class CloudStorageHelper {
  CloudStorageHelper(this.env);

  final Env env;
  BiometricStorageFile _storageFile;

  Future<BiometricStorageFile> _getStorageFile() async => _storageFile ??= await BiometricStorage().getStorage(
        '${env.storageNamespace ?? ''}CloudProviderCreds',
        options: StorageFileInitOptions(authenticationRequired: false),
      );

  Future<Map<String, dynamic>> _readDataMap() async {
    final file = await _getStorageFile();
    final data = await file.read();
    if (data != null) {
      return json.decode(data) as Map<String, dynamic>;
    }
    return <String, dynamic>{};
  }

  Future<void> _writeDataMap(Map<String, dynamic> dataMap) async {
    final file = await _getStorageFile();
    await file.write(json.encode(dataMap));
  }

  Future<String> _loadCredentials(String cloudStorageId) async {
    return (await _readDataMap())[cloudStorageId] as String;
  }

  Future<void> _saveCredentials(String cloudStorageId, String data) async {
    final dataMap = await _readDataMap();
    dataMap[cloudStorageId] = data;
    await _writeDataMap(dataMap);
  }
}

abstract class CloudStorageProvider {
  CloudStorageProvider({@required this.helper});

  @protected
  final CloudStorageHelper helper;

  /// whether we are initialized, authenticated and ready for requests.
  bool get isAuthenticated;

  String get id => runtimeType.toString();
  String get displayName;
  IconData get displayIcon;
  bool get supportSearch => false;
  Future<bool> loadSavedAuth();
  Future<bool>
      startAuth<RESULT extends UserAuthenticationPromptResult, DATA extends UserAuthenticationPromptData<RESULT>>(
          PromptUserForCode<RESULT, DATA> prompt);

  /// make sure to check [supportSearch] before calling this method, otherwise a [UnsupportedError] will be thrown.
  Future<SearchResponse> search({String name = 'kdbx'}) => throw UnsupportedError('Search not supported');
  Future<SearchResponse> list({CloudStorageEntity parent});

  @protected
  Future<void> storeCredentials(String credentials) async {
    await helper._saveCredentials(id, credentials);
  }

  @protected
  Future<String> loadCredentials() async {
    return await helper._loadCredentials(id);
  }

  String displayNameFromPath(Map<String, String> fileInfo) => path.basename(displayPath(fileInfo));

  String displayPath(Map<String, String> fileInfo) => CloudStorageEntity.fromSimpleFileInfo(fileInfo).pathOrBaseName;

  FileSource toFileSource(Map<String, String> fileInfo, {@required String uuid, FileContent initialCachedContent}) =>
      FileSourceCloudStorage(
          provider: this, fileInfo: fileInfo, uuid: uuid, initialCachedContent: initialCachedContent);

  Future<FileContent> loadFile(Map<String, String> fileInfo) =>
      loadEntity(CloudStorageEntity.fromSimpleFileInfo(fileInfo));

  /// Saves the given bytes into the file source.
  /// [previousMetadata] will contain the metadata returned from the last [load] call.
  /// Can return a new metadata object for the next call.
  Future<Map<String, dynamic>> saveFile(
          Map<String, String> fileInfo, Uint8List bytes, Map<String, dynamic> previousMetadata) =>
      saveEntity(CloudStorageEntity.fromSimpleFileInfo(fileInfo), bytes, previousMetadata);

  Future<FileContent> loadEntity(CloudStorageEntity file);
  Future<Map<String, dynamic>> saveEntity(
      CloudStorageEntity file, Uint8List bytes, Map<String, dynamic> previousMetadata);
  Future<FileSource> createEntity(CloudStorageSelectorSaveResult saveAs, Uint8List bytes);

  Future<void> logout();
}

abstract class CloudStorageProviderClientBase<CLIENT> extends CloudStorageProvider {
  CloudStorageProviderClientBase({@required CloudStorageHelper helper}) : super(helper: helper);

  CLIENT _client;

  @override
  bool get isAuthenticated => _client != null;

  @override
  Future<void> logout() async {
    _client = null;
  }

  @protected
  Future<String> oAuthTokenPrompt(PromptUserForCode<dynamic, dynamic> prompt, String uri) async {
    final result = await promptUser<OAuthTokenResult, OAuthTokenFlowPromptData>(prompt, OAuthTokenFlowPromptData(uri));
    return result?.code;
  }

  Future<RESULT>
      promptUser<RESULT extends UserAuthenticationPromptResult, U extends UserAuthenticationPromptData<RESULT>>(
          PromptUserForCode<RESULT, U> prompt, U promptData) {
    final completer = Completer<RESULT>();
    prompt(UserAuthenticationPrompt(promptData, (result) {
      completer.complete(result);
    })).then((_) {
      if (!completer.isCompleted) {
        _logger.severe('prompt callback completed, without calling result code.', null, StackTrace.current);
      }
    }).catchError((dynamic error, StackTrace stackTrace) {
      completer.completeError(error, stackTrace);
    });
    return completer.future;
  }

  @protected
  Future<CLIENT> requireAuthenticatedClient() async {
    return _client ??= await _loadStoredCredentials().then((client) async {
      if (client == null) {
        throw LoadFileException('Unable to load dropbox credentials.');
      }
      return client;
    });
  }

  Future<CLIENT> _loadStoredCredentials() async {
    final credentialsJson = await loadCredentials();
    _logger.finer('Tried to load auth. ${credentialsJson == null ? 'not found' : 'found'}');
    if (credentialsJson == null) {
      return null;
    }
    return clientWithStoredCredentials(credentialsJson);
  }

  @override
  Future<bool>
      startAuth<RESULT extends UserAuthenticationPromptResult, DATA extends UserAuthenticationPromptData<RESULT>>(
          PromptUserForCode<RESULT, DATA> prompt) async {
    _client = await clientFromAuthenticationFlow(prompt);
    return isAuthenticated;
  }

  CLIENT clientWithStoredCredentials(String stored);

  Future<CLIENT> clientFromAuthenticationFlow<TF extends UserAuthenticationPromptResult,
      UF extends UserAuthenticationPromptData<TF>>(PromptUserForCode<TF, UF> prompt);

  @override
  Future<bool> loadSavedAuth() async {
    _client = await _loadStoredCredentials();
    return isAuthenticated;
  }
}

enum StorageExceptionType {
  conflict,
  unknown,
  authentication,
}

class StorageException implements Exception {
  StorageException(this.type, this.details, {this.errorBody});

  final StorageExceptionType type;
  final String details;
  final String errorBody;

  @override
  String toString() {
    return 'StorageException{type: $type, details: $details, errorBody: $errorBody}';
  }
}
