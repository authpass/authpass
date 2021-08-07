import 'dart:async';
import 'dart:convert';
import 'dart:io' show HttpHeaders, ContentType, HttpStatus;
import 'dart:typed_data';

import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx/storage_exception.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/dropbox/dropbox_models.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/utils/constants.dart';
import 'package:logging/logging.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:path/path.dart' as path;
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('authpass.dropbox_provider');

@NonNls
const _METADATA_KEY_DROPBOX_DATA = 'dropbox.file_metadata';

/// header name used by dropbox to return metadata during file download.
@NonNls
const _HEADER_DOWNLOAD_METADATA = 'Dropbox-API-Result';

class DropboxProvider extends CloudStorageProviderClientBase<oauth2.Client> {
  DropboxProvider({required this.env, required CloudStorageHelperBase helper})
      : super(helper: helper);

  @NonNls
  @override
  final String id = 'DropboxProvider';

  static const _oauthEndpoint =
      'https://www.dropbox.com/oauth2/authorize'; // NON-NLS
  static const _oauthToken =
      'https://api.dropboxapi.com/oauth2/token'; // NON-NLS
  static const _dropboxApiUrlSearch =
      'https://api.dropboxapi.com/2/files/search_v2'; // NON-NLS
  static const _dropboxApiUrlList =
      'https://api.dropboxapi.com/2/files/list_folder'; // NON-NLS
  static const _dropboxApiUrlDownload =
      'https://content.dropboxapi.com/2/files/download'; // NON-NLS
  static const _dropboxApiUrlUpload =
      'https://content.dropboxapi.com/2/files/upload'; // NON-NLS

  Env env;

//  Future<oauth2.Client> _requireAuthenticatedClient() async {
//    return _client ??= await _loadStoredCredentials().then((client) async {
//      if (client == null) {
//        throw LoadFileException('Unable to load dropbox credentials.');
//      }
//      return client;
//    });
//  }
//
//  Future<oauth2.Client> _loadStoredCredentials() async {
//    final credentialsJson = await loadCredentials();
//    _logger.finer('Tried to load auth. ${credentialsJson == null ? 'not found' : 'found'}');
//    if (credentialsJson == null) {
//      return null;
//    }
//    final credentials = oauth2.Credentials.fromJson(credentialsJson);
//    return oauth2.Client(
//      credentials,
//      identifier: env.secrets.dropboxKey,
//      secret: env.secrets.dropboxSecret,
//      onCredentialsRefreshed: _onCredentialsRefreshed,
//    );
//  }
//
//  @override
//  Future<bool> loadSavedAuth() async {
//    _client = await _loadStoredCredentials();
//    return isAuthenticated;
//  }

  @override
  oauth2.Client clientWithStoredCredentials(String stored) {
    final credentials = oauth2.Credentials.fromJson(stored);
    return oauth2.Client(
      credentials,
      identifier: env.secrets!.dropboxKey,
      secret: env.secrets!.dropboxSecret,
      onCredentialsRefreshed: _onCredentialsRefreshed,
    );
  }

  @override
  Future<oauth2.Client?> clientFromAuthenticationFlow<
      TF extends UserAuthenticationPromptResult,
      UF extends UserAuthenticationPromptData<TF>>(prompt) async {
    final grant = oauth2.AuthorizationCodeGrant(
      env.secrets!.dropboxKey!,
      Uri.parse(_oauthEndpoint),
      Uri.parse(_oauthToken),
      secret: env.secrets!.dropboxSecret,
      onCredentialsRefreshed: _onCredentialsRefreshed,
    );
//    final authUrl = grant.getAuthorizationUrl(null);
    final authUrl = grant.getAuthorizationUrl(
        env.oauthRedirectUri != null ? Uri.parse(env.oauthRedirectUri!) : null);
    final params = Map<String, String>.from(
        authUrl.queryParameters); //..remove('redirect_uri');
    final url = authUrl.replace(queryParameters: params);
    final code =
        await oAuthTokenPrompt(prompt as PromptUserForCode, url.toString());
    if (code == null) {
      _logger.warning('User cancelled authorization. (did not provide code)');
      return null;
    }
    final client = await grant.handleAuthorizationCode(code);
    _onCredentialsRefreshed(client.credentials);
    return client;
  }

  void _onCredentialsRefreshed(oauth2.Credentials credentials) {
    _logger.fine('Received new credentials from oauth.');
    storeCredentials(credentials.toJson());
  }

  @override
  bool get supportSearch => true;

  @override
  Future<SearchResponse> search({String name = Env.KeePassExtension}) async {
    final searchUri = Uri.parse(_dropboxApiUrlSearch);
    final client = await requireAuthenticatedClient();
    final response = await client.post(
      searchUri,
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
      body: json.encode(nonNls(<String, String>{'query': name})),
    );
    if (response.statusCode >= 300 || response.statusCode < 200) {
      _logger.severe('Error during call to dropbox endpoint. '
          '${response.statusCode} ${response.reasonPhrase} ($response)');
      throw Exception(
          'Error during request. (${response.statusCode} ${response.reasonPhrase})');
    }
    final jsonData = json.decode(response.body) as Map<String, dynamic>;
    _logger.finest('response: $jsonData');
    final jsonResponse = FileSearchResponse.fromJson(jsonData);
    _logger.finest('Got response: $jsonResponse');
    return SearchResponse(
      (srb) => srb
        ..results.addAll(
          jsonResponse.matches!.map((responseEntity) {
            final metadata = responseEntity.metadata!.metadata!;
            return metadata.toCloudStorageEntity();
          }),
        )
        ..hasMore = jsonResponse.hasMore,
    );
  }

  @override
  Future<SearchResponse> list({CloudStorageEntity? parent}) async {
    final listUri = Uri.parse(_dropboxApiUrlList);
    final client = await requireAuthenticatedClient();
    final response = await client.post(
      listUri,
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
      body: json.encode(nonNls(<String, String>{
        'path': parent?.id ?? '',
      })),
    );
    _logger.fine('request: ${response.request}');
    if (response.statusCode >= 300 || response.statusCode < 200) {
      _logger.severe('Error during call to dropbox endpoint. '
          '${response.statusCode} ${response.reasonPhrase} ($response)');
      throw Exception(
          'Error during request. (${response.statusCode} ${response.reasonPhrase})');
    }
    final jsonData = json.decode(response.body) as Map<String, dynamic>;
    _logger.finest('response: $jsonData');
    final jsonResponse = FileListResponse.fromJson(jsonData);
    _logger.finest('Got response: $jsonResponse');
    return SearchResponse(
      (srb) => srb
        ..results.addAll(
          jsonResponse.entries!.map((metadata) {
            return metadata.toCloudStorageEntity();
          }),
        )
        ..hasMore = jsonResponse.hasMore,
    );
  }

  @NonNls
  @override
  String get displayName => 'Dropbox';

  @override
  FileSourceIcon get displayIcon => FileSourceIcon.dropbox;

  static const _apiArgPath = 'path'; // NON-NLS
  static const _apiResponseErrorSummary = 'error_summary'; // NON-NLS

  @override
  Future<FileContent> loadEntity(CloudStorageEntity file) async {
    final client = await requireAuthenticatedClient();
    final downloadUrl = Uri.parse(_dropboxApiUrlDownload);
    final apiArg = json.encode(<String, String>{_apiArgPath: file.id});
    _logger.finer('Downloading file with id ${file.id}');
    final response = await client.post(downloadUrl,
        headers: nonNls({'Dropbox-API-Arg': apiArg}));
    _logger.finer(
        'downloaded file. status:${response.statusCode} byte length: ${response.bodyBytes.lengthInBytes} --- headers: ${response.headers}');
    if (response.statusCode ~/ 100 != 2) {
      _logger.warning('Got error code ${response.statusCode}');
      final contentType =
          ContentType.parse(response.headers[HttpHeaders.contentTypeHeader]!);
      if (contentType.subType == ContentType.json.subType) {
        final jsonBody = json.decode(response.body) as Map<String, dynamic>;
        if (jsonBody[_apiResponseErrorSummary] != null) {
          throw LoadFileException(
              jsonBody[_apiResponseErrorSummary].toString());
        }
        _logger.severe('got a json response?! ${response.body}');
        _logger.info('Got content type: $contentType');
      }
    }
    // we store the whole metadata, but just make sure it is a correct json.
    _logger.info('headers: ${response.headers}');
    final apiResultJson =
        response.headers[_HEADER_DOWNLOAD_METADATA.toLowerCase()];
    if (apiResultJson == null) {
      throw StateError(
          'Invalid respose from dropbox. missing header $_HEADER_DOWNLOAD_METADATA');
    }
    final fileMetadataJson = json.decode(apiResultJson) as Map<String, dynamic>;
    final metadata = FileMetadata.fromJson(fileMetadataJson);
    _logger.fine('Loaded rev ${metadata.rev}');
    return FileContent(response.bodyBytes,
        <String, dynamic>{_METADATA_KEY_DROPBOX_DATA: fileMetadataJson});
  }

  @override
  Future<Map<String, dynamic>> saveEntity(CloudStorageEntity file,
      Uint8List bytes, Map<String, dynamic>? previousMetadata) async {
    return await _upload(file.id, bytes, previousMetadata: previousMetadata);
  }

  static const _apiModeOverwrite = 'overwrite'; // NON-NLS
  static const _apiModeAdd = 'add'; // NON-NLS

  Future<Map<String, dynamic>> _upload(String? path, Uint8List bytes,
      {Map<String, dynamic>? previousMetadata, bool update = true}) async {
    dynamic mode;
    if (update) {
      mode = _apiModeOverwrite;
      if (previousMetadata != null &&
          previousMetadata[_METADATA_KEY_DROPBOX_DATA] != null) {
        final fileMetadata = FileMetadata.fromJson(
            previousMetadata[_METADATA_KEY_DROPBOX_DATA]
                as Map<String, dynamic>);
        mode = nonNls(<String, dynamic>{
          '.tag': 'update',
          'update': fileMetadata.rev,
        });
        _logger.fine('Updating rev ${fileMetadata.rev}');
      }
    } else {
      mode = _apiModeAdd;
    }
    final uploadUrl = Uri.parse(_dropboxApiUrlUpload);
    final apiArg = json.encode(nonNls(<String, dynamic>{
      'path': path,
      'mode': mode,
      'autorename': false,
    }));
    _logger.fine('sending apiArg: $apiArg');
    final client = await requireAuthenticatedClient();
    final response = await client.post(uploadUrl,
        headers: nonNls({
          HttpHeaders.contentTypeHeader: ContentType.binary.toString(),
          'Dropbox-API-Arg': apiArg,
        }),
        body: bytes);
    _logger.fine('Got response ${response.statusCode}: ${response.body}');
    if (response.statusCode ~/ 100 != 2) {
      @NonNls
      final info = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == HttpStatus.conflict) {
        // @NonNls
        // final dynamic error = info['error'];
        throw StorageException.conflict(
            info[nonNls('error_summary')].toString());
      }
      throw StorageException.unknown(
          info['error_summary']?.toString() ?? info.toString());
    }
    final metadataJson = json.decode(response.body) as Map<String, dynamic>;
    final metadata = FileMetadata.fromJson(metadataJson);
    _logger.fine('new rev: ${metadata.rev}');
    return <String, dynamic>{_METADATA_KEY_DROPBOX_DATA: metadataJson};
  }

  @override
  Future<FileSource> createEntity(
      CloudStorageSelectorSaveResult saveAs, Uint8List bytes) async {
    final parent = saveAs.parent;
    final filePath = parent == null
        ? [CharConstants.slash, saveAs.fileName].join()
        : path.join(parent.id, saveAs.fileName);
    final metadataJson = await _upload(filePath, bytes, update: false);
    final metadata = FileMetadata.fromJson(metadataJson);
    return toFileSource(
      metadata.toCloudStorageEntity(),
      uuid: AppDataBloc.createUuid(),
      initialCachedContent: FileContent(bytes, metadataJson),
    );
  }
}
