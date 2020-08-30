import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/onedrive/onedrive_models.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/utils/uuid_util.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

final _logger = Logger('onedrive_provider');

class OneDriveProvider extends CloudStorageProviderClientBase<oauth2.Client> {
  OneDriveProvider(
      {@required this.env, @required CloudStorageHelperBase helper})
      : super(helper: helper);

  final Env env;

  static const String _oauthEndpoint =
      'https://login.microsoftonline.com/common/oauth2/v2.0/authorize';
  static const String _oauthToken =
      'https://login.microsoftonline.com/common/oauth2/v2.0/token';
  static const _baseUriString = 'https://graph.microsoft.com/v1.0/me/drive';
  static final _baseUri = Uri.parse(_baseUriString);

  static const _METADATA_ETAG = 'etag';
  static const _METADATA_CTAG = 'ctag';

  @override
  bool isSupported() => env.oauthRedirectUriSupported;

  @override
  Future<oauth2.Client> clientFromAuthenticationFlow<
      TF extends UserAuthenticationPromptResult,
      UF extends UserAuthenticationPromptData<TF>>(prompt) async {
    final grant = oauth2.AuthorizationCodeGrant(
      env.secrets.microsoftClientId,
      Uri.parse(_oauthEndpoint),
      Uri.parse(_oauthToken),
//      secret: env.secrets.microsoftClientSecret,
      onCredentialsRefreshed: _onCredentialsRefreshed,
    );
    final authUrl = grant.getAuthorizationUrl(Uri.parse(env.oauthRedirectUri),
        scopes: ['offline_access', 'Files.ReadWrite']);
    final params = Map<String, String>.from(
        authUrl.queryParameters); //..remove('redirect_uri');
    final url = authUrl.replace(queryParameters: params);
    final code = await oAuthTokenPrompt(
        prompt as PromptUserForCode<dynamic, dynamic>, url.toString());
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
  oauth2.Client clientWithStoredCredentials(String stored) {
    final credentials = oauth2.Credentials.fromJson(stored);
    return oauth2.Client(
      credentials,
      identifier: env.secrets.microsoftClientId,
//      secret: env.secrets.dropboxSecret,
      onCredentialsRefreshed: _onCredentialsRefreshed,
    );
  }

  @override
  FileSourceIcon get displayIcon => FileSourceIcon.oneDrive;

  @override
  String get displayName => 'One Drive';

  Uri _uri(List<String> subPath) {
    return _baseUri.replace(pathSegments: _baseUri.pathSegments + subPath);
  }

  void _assertSuccessResponse(Response response) {
    _logger.fine(
        'response (${response.statusCode}) for request: ${response.request}');
    if (response.statusCode >= 300 || response.statusCode < 200) {
      _logger.severe('Error during call to onedrive endpoint. '
          '${response.statusCode} ${response.reasonPhrase} (${response.body})');
      throw Exception(
          'Error during request. (${response.statusCode} ${response.reasonPhrase})');
    }
  }

  @override
  Future<SearchResponse> list({CloudStorageEntity parent}) async {
    final listUri = _uri(parent == null
        ? ['root', 'children']
        : ['items', parent.id, 'children']);
    final client = await requireAuthenticatedClient();
    final response = await client.get(
      listUri,
    );
    _assertSuccessResponse(response);
    final jsonData = json.decode(response.body) as Map<String, dynamic>;
    _logger.finest('response: $jsonData');
    final jsonResponse = ListChildrenResponse.fromJson(jsonData);
    _logger.finest('Got response: $jsonResponse');
    return SearchResponse(
      (srb) => srb
        ..results.addAll(
          jsonResponse.value.map((metadata) {
            return metadata.toCloudStorageEntity();
          }),
        )
        ..hasMore = false,
    );
  }

  @override
  Future<FileContent> loadEntity(CloudStorageEntity file) async {
    final uri = _uri(['items', file.id, 'content']);
    final client = await requireAuthenticatedClient();
    final response = await client.get(uri);
    return FileContent(response.bodyBytes, <String, dynamic>{
      _METADATA_ETAG: response.headers['etag'],
      _METADATA_CTAG: response.headers['ctag'],
    });
  }

  @override
  Future<Map<String, dynamic>> saveEntity(CloudStorageEntity file,
      Uint8List bytes, Map<String, dynamic> previousMetadata) async {
    final driveItem = await _upload(
      locationId: file.id,
      eTag: previousMetadata[_METADATA_ETAG] as String,
      bytes: bytes,
    );
    return <String, dynamic>{
      _METADATA_ETAG: driveItem.eTag,
      _METADATA_CTAG: driveItem.cTag,
    };
  }

  Future<OneDriveItem> _upload({
    @required String locationId,
    String fileName,
    String eTag,
    @required Uint8List bytes,
  }) async {
    assert(locationId != null);
    assert(bytes != null);
    final uri = fileName == null
        ? _uri(['items', locationId, 'createUploadSession'])
        : _uri(['items', '$locationId:', '$fileName:', 'createUploadSession']);
    final client = await requireAuthenticatedClient();
    if (eTag != null) {
      _logger.finer('Setting if-match to: $eTag');
    }
    final createResponse = await client.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
        ...?eTag == null ? null : {'if-match': eTag},
      },
      body: json.encode({
        'item': fileName == null
            ? {
                '@microsoft.graph.conflictBehavior': 'replace',
              }
            : {
                '@microsoft.graph.conflictBehavior': 'fail',
                'name': fileName,
              },
      }),
    );

    try {
      _assertSuccessResponse(createResponse);
    } catch (e) {
      if (createResponse.statusCode == 412) {
        throw StorageException(StorageExceptionType.conflict,
            'Conflict while uploading to One Drive.',
            errorBody: createResponse.body);
      }
      rethrow;
    }
    final createJson = json.decode(createResponse.body) as Map<String, dynamic>;
    final uploadUrl = createJson['uploadUrl'] as String;
    final uploadResponse = await client.put(uploadUrl, body: bytes);
    _assertSuccessResponse(uploadResponse);
    _logger.fine('uploadResponse: ${uploadResponse.statusCode}');
    final driveItem = OneDriveItem.fromJson(
        json.decode(uploadResponse.body) as Map<String, dynamic>);
    _logger.finer('upload: ${driveItem.toJson()}');
    return driveItem;
  }

  @override
  Future<FileSource> createEntity(
      CloudStorageSelectorSaveResult saveAs, Uint8List bytes) async {
    final driveItem = await _upload(
      locationId: saveAs.parent.id,
      fileName: saveAs.fileName,
      bytes: bytes,
    );
    return toFileSource(
      driveItem.toCloudStorageEntity().toSimpleFileInfo(),
      uuid: UuidUtil.createUuid(),
      initialCachedContent: FileContent(bytes, <String, dynamic>{
        _METADATA_ETAG: driveItem.eTag,
        _METADATA_CTAG: driveItem.cTag,
      }),
    );
  }
}
