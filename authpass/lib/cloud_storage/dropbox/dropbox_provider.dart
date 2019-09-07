import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/dropbox/dropbox_models.dart';
import 'package:authpass/env/_base.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

final _logger = Logger('authpass.dropbox_provider');

class DropboxProvider extends CloudStorageProvider {
  DropboxProvider({@required this.env, @required CloudStorageHelper helper}) : super(helper: helper);

  oauth2.Client _client;

  static const String _oauthEndpoint = 'https://www.dropbox.com/oauth2/authorize';
  static const String _oauthToken = 'https://api.dropboxapi.com/oauth2/token';

  Env env;

  @override
  Future<bool> loadSavedAuth() async {
    final credentialsJson = await loadCredentials();
    _logger.finer('Tried to load auth. ${credentialsJson == null ? 'not found' : 'found'}');
    if (credentialsJson != null) {
      final credentials = oauth2.Credentials.fromJson(credentialsJson);
      _client = oauth2.Client(
        credentials,
        identifier: env.secrets.dropboxKey,
        secret: env.secrets.dropboxSecret,
        onCredentialsRefreshed: _onCredentialsRefreshed,
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> startAuth(prompt) async {
    final grant = oauth2.AuthorizationCodeGrant(
      env.secrets.dropboxKey,
      Uri.parse(_oauthEndpoint),
      Uri.parse(_oauthToken),
      secret: env.secrets.dropboxSecret,
      onCredentialsRefreshed: _onCredentialsRefreshed,
    );
    final authUrl = grant.getAuthorizationUrl(null);
    final params = Map<String, String>.from(authUrl.queryParameters); //..remove('redirect_uri');
    final url = authUrl.replace(queryParameters: params);
    final code = await prompt(url.toString());
    if (code == null) {
      _logger.warning('User cancelled authorization. (did not provide code)');
      return false;
    }
    _client = await grant.handleAuthorizationCode(code);
    _onCredentialsRefreshed(_client.credentials);
    return true;
  }

  void _onCredentialsRefreshed(oauth2.Credentials credentials) {
    _logger.fine('Received new credentials from oauth.');
    storeCredentials(credentials.toJson());
  }

  @override
  Future<SearchResponse> search({String name = 'kdbx'}) async {
    final searchUri = Uri.parse('https://api.dropboxapi.com/2/files/search_v2');
    final response = await _client.post(
      searchUri,
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
      body: json.encode(<String, String>{'query': name}),
    );
    if (response.statusCode >= 300 || response.statusCode < 200) {
      _logger.severe('Error during call to dropbox endpoint. '
          '${response.statusCode} ${response.reasonPhrase} ($response)');
      throw Exception('Error during request. (${response.statusCode} ${response.reasonPhrase})');
    }
    final jsonData = json.decode(response.body) as Map<String, dynamic>;
    _logger.finest('response: $jsonData');
    final jsonResponse = FileSearchResponse.fromJson(jsonData);
    _logger.finest('Got response: $jsonResponse');
    return SearchResponse(
      (srb) => srb
        ..results.addAll(
          jsonResponse.matches.map((responseEntity) {
            final metadata = responseEntity.metadata.metadata;
            return CloudStorageEntity(
              (b) => b
                ..name = metadata.name
                ..id = metadata.id
                ..type = CloudStorageEntityType.file
                ..path = metadata.pathDisplay,
            );
          }),
        )
        ..hasMore = jsonResponse.hasMore,
    );
  }

  @override
  bool get isAuthenticated => _client != null;

  @override
  String get displayName => 'Dropbox';

  @override
  IconData get displayIcon => FontAwesomeIcons.dropbox;

  @override
  Future<Uint8List> loadEntity(CloudStorageEntity file) async {
    final downloadUrl = Uri.parse('https://content.dropboxapi.com/2/files/download');
    final apiArg = json.encode(<String, String>{'path': '${file.id}'});
    _logger.finer('Downloading file with id ${file.id}');
    final response = await _client.post(downloadUrl, headers: {'Dropbox-API-Arg': apiArg});
    _logger.finer(
        'downloaded file. status:${response.statusCode} byte length: ${response.bodyBytes.lengthInBytes} --- headers: ${response.headers}');
    if (response.statusCode ~/ 100 != 2) {
      _logger.warning('Got error code ${response.statusCode}');
      final contentType = ContentType.parse(response.headers[HttpHeaders.contentTypeHeader]);
      if (contentType.subType == ContentType.json.subType) {
        final jsonBody = json.decode(response.body) as Map<String, dynamic>;
        if (jsonBody['error_summary'] != null) {
          throw LoadFileException(jsonBody['error_summary'].toString());
        }
        _logger.severe('got a json response?! ${response.body}');
        _logger.info('Got content type: $contentType');
      }
    }
    return response.bodyBytes;
  }

  @override
  Future<void> saveEntity(CloudStorageEntity file, Uint8List bytes) async {
    final uploadUrl = Uri.parse('https://content.dropboxapi.com/2/files/upload');
    final apiArg = json.encode(<String, String>{
      'path': 'id:${file.id}',
      // TODO we should probably change this to 'update' and add the old revision.
      'mode': 'overwrite',
    });
    await _client.post(uploadUrl,
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.binary.toString(),
          'Dropbox-API-Arg': apiArg,
        },
        body: bytes);
    return null;
  }
}
