import 'package:authpass/cloud_storage/cloud_storage.dart';
import 'package:authpass/env/_base.dart';
import 'package:meta/meta.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

class DropboxProvider extends CloudStorageProvider {
  oauth2.Client _client;

  DropboxProvider({@required this.env});

  static const String _oauthEndpoint = ' https://www.dropbox.com/oauth2/authorize';
  static const String _oauthToken = ' https://www.dropbox.com/oauth2/token';

  Env env;

  @override
  Future<bool> startAuth(prompt) async {
    var grant = oauth2.AuthorizationCodeGrant(
      env.dropboxKey,
      Uri.parse(_oauthEndpoint),
      Uri.parse(_oauthToken),
      secret: env.dropboxSecret,
    );
    final authUrl = grant.getAuthorizationUrl(Uri.parse('https://authpass.com'));
    final params = Map<String, String>.from(authUrl.queryParameters)..remove('redirect');
    final url = authUrl.replace(queryParameters: params);
    final code = await prompt(url.toString());
    _client = await grant.handleAuthorizationCode(code);
    return true;
  }

  @override
  Future<SearchResponse> searchKdbx() {
//    _client.re
    return null;
  }
}
