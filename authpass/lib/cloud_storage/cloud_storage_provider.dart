import 'dart:convert';
import 'dart:typed_data';

import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_ui.dart';
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

typedef PromptUserForCode = Future<String> Function(String openUri);

/// Common functionality shared across all cloud storages,
/// right now simply storing of oauth tokens.
class CloudStorageHelper {
  BiometricStorageFile _storageFile;
  Future<BiometricStorageFile> _getStorageFile() async => _storageFile ??= await BiometricStorage().getStorage(
        'CloudProvider',
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
  Future<bool> loadSavedAuth();
  Future<bool> startAuth(PromptUserForCode prompt);
  Future<SearchResponse> search({String name = 'kdbx'});
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

  String displayPath(Map<String, String> fileInfo) => CloudStorageEntity.fromSimpleFileInfo(fileInfo).path;

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

abstract class CloudStorageProviderClientBase<T> extends CloudStorageProvider {
  CloudStorageProviderClientBase({CloudStorageHelper helper}) : super(helper: helper);

  T _client;

  @override
  bool get isAuthenticated => _client != null;

  @override
  Future<void> logout() async {
    _client = null;
  }

  @protected
  Future<T> requireAuthenticatedClient() async {
    return _client ??= await _loadStoredCredentials().then((client) async {
      if (client == null) {
        throw LoadFileException('Unable to load dropbox credentials.');
      }
      return client;
    });
  }

  Future<T> _loadStoredCredentials() async {
    final credentialsJson = await loadCredentials();
    _logger.finer('Tried to load auth. ${credentialsJson == null ? 'not found' : 'found'}');
    if (credentialsJson == null) {
      return null;
    }
    return clientWithStoredCredentials(credentialsJson);
  }

  @override
  Future<bool> startAuth(PromptUserForCode prompt) async {
    _client = await clientFromAuthenticationFlow(prompt);
    return isAuthenticated;
  }

  T clientWithStoredCredentials(String stored);

  Future<T> clientFromAuthenticationFlow(PromptUserForCode prompt);

  @override
  Future<bool> loadSavedAuth() async {
    _client = await _loadStoredCredentials();
    return isAuthenticated;
  }
}

enum StorageExceptionType {
  conflict,
  unknown,
}

class StorageException implements Exception {
  StorageException(this.type, this.details);

  final StorageExceptionType type;
  final String details;

  @override
  String toString() {
    return 'StorageException{type: $type, details: $details}';
  }
}
