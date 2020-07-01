import 'dart:convert';

import 'package:authpass/env/_base.dart';
import 'package:authpass_cloud_shared/authpass_cloud_shared.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:openapi_base/openapi_base.dart';
import 'package:pedantic/pedantic.dart';
import 'package:quiver/check.dart';
import 'package:synchronized/synchronized.dart';

part 'authpass_cloud_bloc.g.dart';

@JsonSerializable(nullable: false)
class _StoredToken {
  _StoredToken({
    @required this.authToken,
    @required this.isConfirmed,
  })  : assert(authToken != null),
        assert(isConfirmed != null);
  factory _StoredToken.fromJson(Map<String, dynamic> json) =>
      _$_StoredTokenFromJson(json);
  Map<String, dynamic> toJson() => _$_StoredTokenToJson(this);

  final String authToken;
  final bool isConfirmed;
}

enum TokenStatus {
  none,
  created,
  confirmed,
}

class AuthPassCloudBloc with ChangeNotifier {
  AuthPassCloudBloc({@required this.featureFlags})
      : assert(featureFlags != null) {
    _init();
  }

  final FeatureFlags featureFlags;
  HttpRequestSender _requestSender;
  AuthPassCloudClient _client;
  _StoredToken _storedToken;
  final _tokenLock = Lock();

  Future<void> _init() async {
    if (!featureFlags.authpassCloud) {
      return;
    }
    await _loadToken();
  }

  TokenStatus get tokenStatus => _storedToken == null
      ? TokenStatus.none
      : _storedToken.isConfirmed ? TokenStatus.confirmed : TokenStatus.created;

  Future<BiometricStorageFile> _getStorageFile() async {
    return await BiometricStorage().getStorage(
      'AuthPassCloud',
      options: StorageFileInitOptions(authenticationRequired: false),
    );
  }

  Future<void> _saveToken(_StoredToken token) async {
    await _tokenLock.synchronized(() async {
      _storedToken = token;
      final f = await _getStorageFile();
      if (token == null) {
        await f.delete();
        _client = null;
        notifyListeners();
        return;
      }
      await f.write(json.encode(token.toJson()));
      if (_client != null) {
        SecuritySchemes.authToken.setForClient(
            _client, SecuritySchemeHttpData(bearerToken: token.authToken));
      }
      notifyListeners();
    });
  }

  Future<_StoredToken> _loadToken() async {
    return _storedToken ??= await _tokenLock.synchronized(() async {
      if (_storedToken != null) {
        return _storedToken;
      }
      final f = await _getStorageFile();
      final str = await f.read();
      if (str == null) {
        return null;
      }
      _storedToken =
          _StoredToken.fromJson(json.decode(str) as Map<String, dynamic>);
      unawaited(Future<void>.microtask(() => notifyListeners()));
      return _storedToken;
    });
  }

  Future<AuthPassCloudClient> _getClient() async {
    return _client ??= await (() async {
      _requestSender = HttpRequestSender();
      final baseUri = Uri.parse(featureFlags.authpassCloudUri);
      final client = AuthPassCloudClient(baseUri, _requestSender);
      final token = await _loadToken();
      if (token != null) {
        SecuritySchemes.authToken.setForClient(
            client, SecuritySchemeHttpData(bearerToken: token.authToken));
      }
      return client;
    })();
  }

  Future<void> authenticate(String email) async {
    final client = await _getClient();
    final response = await client
        .userRegisterPost(RegisterRequest(email: email))
        .requireSuccess();
    await _saveToken(_StoredToken(
      authToken: response.authToken,
      isConfirmed: false,
    ));
    notifyListeners();
  }

  Future<bool> checkConfirmed() async {
    checkNotNull(_storedToken);
    final client = await _getClient();
    final response = await client.emailStatusGet().requireSuccess();
    if (response.status == EmailStatusGetResponseBody200Status.confirmed) {
      await _saveToken(
        _StoredToken(authToken: _storedToken.authToken, isConfirmed: true),
      );
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
    _requestSender.dispose();
  }

  Future<void> clearToken() async {
    await _saveToken(null);
  }
}
