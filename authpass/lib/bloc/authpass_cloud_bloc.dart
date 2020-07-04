import 'dart:convert';

import 'package:authpass/env/_base.dart';
import 'package:authpass_cloud_shared/authpass_cloud_shared.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:openapi_base/openapi_base.dart';
import 'package:pedantic/pedantic.dart';
import 'package:quiver/check.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';
import 'package:enough_mail/enough_mail.dart' as enough;

part 'authpass_cloud_bloc.g.dart';

final _logger = Logger('authpass_cloud_bloc');

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
    _logger.fine('Creating AuthPassCloudBloc with $featureFlags');
    _init();
  }

  final FeatureFlags featureFlags;
  HttpRequestSender _requestSender;
  AuthPassCloudClient _client;
  _StoredToken _storedToken;
  final _tokenLock = Lock();

  final _messageList = BehaviorSubject.seeded(const EmailMessageList.empty());
  ValueStream<EmailMessageList> get messageList => _messageList.stream;
  final _messageListFetch = JoinRun<EmailMessageList>();

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
      _logger.finest('Loading token.');
      final f = await _getStorageFile();
      final str = await f.read();
      if (str == null) {
        return null;
      }
      _storedToken =
          _StoredToken.fromJson(json.decode(str) as Map<String, dynamic>);
      _logger.finest('loaded. $tokenStatus');
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

  Future<List<Mailbox>> loadMailboxList() async {
    final client = await _getClient();
    final mailboxResponse = await client.mailboxGet().requireSuccess();
    return mailboxResponse.data;
  }

  Future<String> createMailbox(
      {String label = '', String entryUuid = ''}) async {
    final client = await _getClient();
    final ret = await client
        .mailboxCreatePost(MailboxCreateSchema(
          label: label,
          entryUuid: entryUuid,
        ))
        .requireSuccess();
    _logger.finer('Created mail box with ${ret.address}');
    notifyListeners();
    return ret.address;
  }

  Future<EmailMessageList> loadMessageListMore({bool reload = false}) async {
    return _messageListFetch.joinRun(() async {
      final client = await _getClient();
      final lastMessages =
          reload ? const EmailMessageList.empty() : _messageList.value;
      if (!lastMessages.hasMore) {
        return lastMessages;
      }
      final mailList = await client
          .mailboxListGet(pageToken: lastMessages.nextPageToken)
          .requireSuccess();
      final list = EmailMessageList(
        messages: [...lastMessages.messages, ...mailList.data],
        hasMore: mailList.page.nextPageToken != null,
        nextPageToken: mailList.page.nextPageToken,
      );
      _messageList.add(list);
      return list;
    });
  }

  Future<enough.MimeMessage> loadMail(EmailMessage message) async {
    final client = await _getClient();
    final body =
        await client.mailboxMessageGet(messageId: message.id).requireSuccess();
    if (!message.isRead) {
      unawaited((() async {
        await client
            .mailboxMessageMarkRead(messageId: message.id)
            .requireSuccess();
        _messageListReload();
        _logger.finer('Marked mail as read.');
      })());
    }
    final mimeMessage = enough.MimeMessage();
    mimeMessage.bodyRaw = body;
    mimeMessage.parse();
    return mimeMessage;
  }

  Future<void> deleteMail(EmailMessage message) async {
    final client = await _getClient();
    await client.mailboxMessageDelete(messageId: message.id);
    _messageListReload();
  }

  void _messageListReload() {
    _messageList.add(const EmailMessageList.empty());
  }

  @override
  void dispose() {
    super.dispose();
    _logger.fine('Disposing AuthPassCloudBloc');
    _requestSender?.dispose();
  }

  Future<void> clearToken() async {
    await _saveToken(null);
  }
}

class EmailMessageList {
  const EmailMessageList({
    @required this.messages,
    @required this.hasMore,
    @required this.nextPageToken,
  })  : assert(messages != null),
        assert(hasMore != null);
  const EmailMessageList.empty()
      : this(messages: const [], hasMore: true, nextPageToken: null);
  final List<EmailMessage> messages;
  final bool hasMore;
  final String nextPageToken;
}

class JoinRun<T> {
  Future<T> _currentRun;
  Future<T> joinRun(Future<T> Function() callback) async {
    if (_currentRun != null) {
      return _currentRun;
    }
    try {
      _currentRun = callback();
      return await _currentRun;
    } finally {
      _currentRun = null;
    }
  }
}
