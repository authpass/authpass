import 'dart:convert';
import 'dart:io';

import 'package:authpass/cloud_storage/cloud_storage.dart';
import 'package:authpass/cloud_storage/dropbox/dropbox_models.dart';
import 'package:authpass/env/_base.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

final _logger = Logger('authpass.dropbox_provider');

class DropboxProvider extends CloudStorageProvider {
  DropboxProvider({@required this.env});

  oauth2.Client _client;

  static const String _oauthEndpoint = 'https://www.dropbox.com/oauth2/authorize';
  static const String _oauthToken = 'https://api.dropboxapi.com/oauth2/token';

  Env env;

  @override
  Future<bool> startAuth(prompt) async {
    var grant = oauth2.AuthorizationCodeGrant(
      env.secrets.dropboxKey,
      Uri.parse(_oauthEndpoint),
      Uri.parse(_oauthToken),
      secret: env.secrets.dropboxSecret,
    );
    final authUrl = grant.getAuthorizationUrl(null);
    final params = Map<String, String>.from(authUrl.queryParameters); //..remove('redirect_uri');
    final url = authUrl.replace(queryParameters: params);
    final code = await prompt(url.toString());
    _client = await grant.handleAuthorizationCode(code);
    return true;
  }

  @override
  Future<SearchResponse> searchKdbx() async {
    final searchUri = Uri.parse('https://api.dropboxapi.com/2/files/search_v2');
    final response = await _client.post(
      searchUri,
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
      body: json.encode(<String, String>{'query': 'kdbx'}),
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
                ..type = CloudStorageEntityType.file,
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
}
