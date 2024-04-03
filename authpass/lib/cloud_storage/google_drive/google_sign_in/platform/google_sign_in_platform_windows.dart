
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class GoogleSignInPlatformWindow extends GoogleSignInPlatform {

  static const String storageKey = 'GOOGLE_SIGN_IN_AUTH'; // NON-NLS
  GoogleSignInPlatformWindow({required this.secret});
  FlutterSecureStorage storage = const FlutterSecureStorage();
  Uri? url;

  Uri? callbackUrlScheme;

  SignInInitParameters? params;

  BehaviorSubject<GoogleSignInUserData> userData = BehaviorSubject();
  String secret;

  Map<String, GoogleSignInTokenData> tokens = Map();

  @override
  Future<bool> canAccessScopes(List<String> scopes, {String? accessToken}) async{
    return true;
  }

  @override
  Future<void> clearAuthCache({required String token}) async{
    return storage.delete(key: storageKey);
  }

  @override
  Future<void> disconnect()  async{
    return;
  }

  @override
  Future<GoogleSignInTokenData> getTokens({required String email, bool? shouldRecoverAuth}) async {
    return tokens[email]!;
  }

  @override
  Future<void> init({List<String> scopes = const <String>[], SignInOption signInOption = SignInOption.standard, String? hostedDomain, String? clientId})  async{
    return initWithParams(SignInInitParameters(
      signInOption: signInOption,
      scopes: scopes,
      hostedDomain: hostedDomain,
      clientId: clientId,
    ));
  }
  Future<int> getUnusedPort(InternetAddress address) {
    return ServerSocket.bind(address, 0).then((socket) {
      var port = socket.port;
      socket.close();
      return port;
    });
  }
  @override
  Future<void> initWithParams(SignInInitParameters params) async {
    try {
      if (await storage.containsKey(key: storageKey)) {
        var mailStorage = await storage.read(key: storageKey);
        var mails = jsonDecode(mailStorage!);
        final List<dynamic> mailList = mails as List<dynamic>;
        for (final mail in mailList) {
          tokens[mail as String] = GoogleSignInTokenData(accessToken: await storage.read(
              key: '$storageKey.$mail.accessToken'),// NON-NLS
              // NON-NLS
              idToken: await storage.read(key: '$storageKey.$mail.idToken'), // NON-NLS
              // NON-NLS
              serverAuthCode: await storage.read(
                  key: '$storageKey.$mail.serverAuthCode')); // NON-NLS
        }
      }
    }catch(ex){
      //ignore
    }
    final freePort = await getUnusedPort(InternetAddress.anyIPv4);
    callbackUrlScheme = Uri(scheme: 'http', host: 'localhost', port: freePort);

    url = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
      'response_type': 'code',
      'client_id': params.clientId,
      'redirect_uri': callbackUrlScheme.toString(),
      'scope': '${params.scopes.join(' ')} https://www.googleapis.com/auth/userinfo.email',
    });

    this.params = params;
  }

  @override
  bool get isMock => false;

  @override
  Future<bool> isSignedIn() async{
    return tokens.isNotEmpty;
  }

  @override
  Future<bool> requestScopes(List<String> scopes) async {
    return true;
  }

  @override
  Future<GoogleSignInUserData?> signIn() async {
    if(url == null
    || callbackUrlScheme == null
    || params == null){
      throw Exception('call init first');
    }
    final result = await FlutterWebAuth2.authenticate(url: url.toString(), callbackUrlScheme: callbackUrlScheme.toString());
    final code = Uri.parse(result).queryParameters['code']; // NON-NLS

// Construct an Uri to Google's oauth2 endpoint
    final tokenUrl = Uri.https('www.googleapis.com', 'oauth2/v4/token'); // NON-NLS

// Use this code to get an access token
    final response = await http.post(tokenUrl, body: {
      'client_id': params!.clientId,// NON-NLS
      'client_secret': secret,// NON-NLS
      'redirect_uri': callbackUrlScheme.toString(),// NON-NLS
      'grant_type': 'authorization_code',// NON-NLS
      'code': code,// NON-NLS
    });

// Get the access token from the response
    final json = jsonDecode(response.body);
    final accessToken = json['access_token'] as String;// NON-NLS
    final id = json['id_token'] as String;// NON-NLS
    //https://openidconnect.googleapis.com/v1/userinfo

    final userInfoUrl = Uri.https('openidconnect.googleapis.com', 'v1/userinfo', {
      'access_token' : accessToken
    });
    final userresp = await http.post(userInfoUrl);
    final userInfo = jsonDecode(userresp.body);
    final email = userInfo['email'] as String;// NON-NLS

    tokens[email] = GoogleSignInTokenData(accessToken: accessToken, serverAuthCode: code);
    await writeStorage();
    var luserData = GoogleSignInUserData(email: email, id: UniqueKey().toString(), displayName: email, idToken: id, serverAuthCode: code);
    userData.add(luserData);
    return luserData;
  }

  @override
  Future<GoogleSignInUserData?> signInSilently() async {
    var email = tokens.keys.firstOrNull;
    if(email != null){
      return GoogleSignInUserData(email: email, id: UniqueKey().toString(), displayName: email, idToken: tokens[email]!.idToken, serverAuthCode: tokens[email]!.serverAuthCode);

    }else{
      return null;
    }
  }

  @override
  Future<void> signOut() async{
    tokens.clear();
    await writeStorage();
  }

  Future<void> writeStorage() async {
    await storage.write(key: storageKey, value: jsonEncode(List.from(tokens.keys)));
    tokens.forEach((key, value) async {
      await storage.write(key: '$storageKey.$key.accessToken', value: value.accessToken); // NON-NLS
      await storage.write(key: '$storageKey.$key.idToken', value: value.idToken); // NON-NLS
      await storage.write(key: '$storageKey.$key.serverAuthCode', value: value.serverAuthCode); // NON-NLS
    });
  }

  @override
  Stream<GoogleSignInUserData?>? get userDataEvents => userData.stream;

}