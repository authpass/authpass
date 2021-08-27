import 'dart:async';
import 'dart:convert';

import 'package:authpass/env/_base.dart';
import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/platform.dart';
import 'package:authpass_cloud_shared/authpass_cloud_shared.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:clock/clock.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:enough_mail/enough_mail.dart' as enough;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:openapi_base/openapi_base.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';
import 'package:synchronized/synchronized.dart';

part 'authpass_cloud_bloc.g.dart';

final _logger = Logger('authpass_cloud_bloc');

// ignore: deprecated_member_use
@JsonSerializable(nullable: false)
class _StoredToken {
  _StoredToken({
    required this.authToken,
    required this.isConfirmed,
    required DateTime? createdAt,
  }) : createdAt = createdAt ?? clock.now().toUtc();
  factory _StoredToken.fromJson(Map<String, dynamic> json) =>
      _$StoredTokenFromJson(json);
  Map<String, dynamic> toJson() => _$StoredTokenToJson(this);

  final String authToken;
  final bool isConfirmed;
  final DateTime createdAt;
}

enum TokenStatus {
  none,
  created,
  confirmed,
}

class AuthPassCloudBlocDummy with ChangeNotifier implements AuthPassCloudBloc {
  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

/// mixin for classes which need a [AuthPassCloudClient]
abstract class AuthPassCloudClientConsumer {
  @protected
  AuthPassCloudBloc getAuthPassCloudBloc();

  @protected
  Future<AuthPassCloudClient> getClient() async {
    return await getAuthPassCloudBloc()._getClient();
  }
}

class AuthPassCloudBloc with ChangeNotifier {
  AuthPassCloudBloc({required this.env, required this.featureFlags}) {
    _logger.fine('Creating AuthPassCloudBloc with $featureFlags');
    _init();
  }

  final Env env;
  final FeatureFlags featureFlags;
  HttpRequestSender? _requestSender;
  AuthPassCloudClient? _client;
  _StoredToken? _storedToken;
  final _tokenLock = Lock();
  Future<AuthPassCloudClient> get client => _getClient();

  @NonNls
  late final imageBaseUrl = Uri.parse(
      ArgumentError.checkNotNull(featureFlags.authpassCloudUri) +
          'website/image');

  late final _cloudStatus = LazyBehaviorSubject<CloudStatus?>(() async {
    if (tokenStatus != TokenStatus.confirmed) {
      return null;
    }
    final c = await _getClient();
    final s = await c.statusGet().requireSuccess();
    return CloudStatus(
      lastFetched: clock.now().toUtc(),
      messagesUnread: s.mail.messagesUnread,
    );
  });
  ValueStream<CloudStatus?> get cloudStatus => _cloudStatus.streamReloadable();
  // ValueStream<CloudStatus?> get cloudStatus => _cloudStatus.stream(() async {
  //       if (tokenStatus != TokenStatus.confirmed) {
  //         return null;
  //       }
  //       final c = await _getClient();
  //       final s = await c.statusGet().requireSuccess();
  //       return CloudStatus(
  //         lastFetched: clock.now().toUtc(),
  //         messagesUnread: s.mail.messagesUnread,
  //       );
  //     });

  late final _mailboxList = LazyBehaviorSubject<MailboxList>(() async {
    final client = await _getClient();
    final mailboxResponse = await client.mailboxGet().requireSuccess();
    return MailboxList(mailboxes: mailboxResponse.data);
  });
  ReloadableValueStream<MailboxList> get mailboxList =>
      _mailboxList.streamReloadable();

  final _messageList = BehaviorSubject.seeded(const EmailMessageList.empty());
  ValueStream<EmailMessageList> get messageList => _messageList.stream;
  final _messageListFetch = JoinRun<EmailMessageList>();

  Future<void> _init() async {
    if (!featureFlags.authpassCloud!) {
      return;
    }
    await _loadToken();
  }

  TokenStatus get tokenStatus => _storedToken?.isConfirmed == null
      ? TokenStatus.none
      : _storedToken!.isConfirmed
          ? TokenStatus.confirmed
          : TokenStatus.created;

  DateTime? get tokenCreatedAt => _storedToken?.createdAt;

  Future<BiometricStorageFile> _getStorageFile() async {
    return await BiometricStorage().getStorage(
      nonNls('${env.storageNamespace ?? ''}AuthPassCloud'),
      options: StorageFileInitOptions(authenticationRequired: false),
    );
  }

  Future<void> _saveToken(_StoredToken? token) async {
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
            _client!, SecuritySchemeHttpData(bearerToken: token.authToken));
      }
      notifyListeners();
      if (token.isConfirmed) {
        unawaited(_dirtyAll());
      }
    });
  }

  Future<_StoredToken?> _loadToken() async {
    return _storedToken ??= await _tokenLock.synchronized(() async {
      if (_storedToken != null) {
        return _storedToken;
      }
      _logger.finest('Loading token.');
      try {
        final f = await _getStorageFile();
        final str = await f.read();
        if (str == null) {
          return null;
        }
        _storedToken =
            _StoredToken.fromJson(json.decode(str) as Map<String, dynamic>);
        // TODO: The following should only matter for old stored tokens,
        //       this can probably be removed in the next version.
        ArgumentError.checkNotNull(_storedToken!.authToken);
        ArgumentError.checkNotNull(_storedToken!.isConfirmed);
      } on AuthException catch (e, stackTrace) {
        _storedToken = null;
        _logger.warning(
            'Unable to load token, due to (known) error'
            ' from secure storage. ignoring.',
            e,
            stackTrace);
      } on PlatformException catch (e, stackTrace) {
        _logger.severe('Unable to load cloud storage token', e, stackTrace);
        rethrow;
      } catch (e, stackTrace) {
        _storedToken = null;
        _logger.warning(
            'Error while loading token. Ignoring stored token.', e, stackTrace);
      }
      _logger.finest('loaded. $tokenStatus --- $_storedToken');
      unawaited(Future<void>.microtask(() => notifyListeners()));
      return _storedToken;
    });
  }

  @NonNls
  static String getUserAgent(AppInfo ai) => '${ai.appName}/${ai.versionLabel} '
      '(${AuthPassPlatform.operatingSystem}) [${ai.packageName}]';

  static http.Client getUserAgentClient(AppInfo ai) =>
      UserAgentClient(nonNls(getUserAgent(ai)), http.Client());

  Future<AuthPassCloudClient> _getClient() async {
    return _client ??= await (() async {
      final ai = await env.getAppInfo();

      _requestSender =
          HttpRequestSender(clientCreator: () => getUserAgentClient(ai));
      final baseUri = Uri.parse(featureFlags.authpassCloudUri!);
      final client = AuthPassCloudClient(baseUri, _requestSender!);
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
      createdAt: null,
    ));
  }

  Future<bool> checkConfirmed() async {
    final _storedToken = this._storedToken;
    if (_storedToken == null) {
      throw ArgumentError('_storedToken');
    }
    final client = await _getClient();
    final response = await client.emailStatusGet().requireSuccess();
    if (response.status == EmailStatusGetResponseBody200Status.confirmed) {
      await _saveToken(
        _StoredToken(
          authToken: _storedToken.authToken,
          isConfirmed: true,
          createdAt: _storedToken.createdAt,
        ),
      );
      return true;
    }
    return false;
  }

  Future<String?> createMailbox(
      {String label = CharConstants.empty,
      String entryUuid = CharConstants.empty}) async {
    final client = await _getClient();
    final ret = await client
        .mailboxCreatePost(MailboxCreatePostSchema(
          label: label,
          entryUuid: entryUuid,
        ))
        .requireSuccess();
    _logger.finer('Created mail box with ${ret.address}');
    unawaited(_dirtyAll());
    return ret.address;
  }

  Future<void> deleteMailbox(Mailbox mailbox) async {
    final client = await _getClient();
    await client
        .mailboxUpdate(MailboxUpdateSchema(isDeleted: true),
            mailboxAddress: mailbox.address)
        .requireSuccess();
    unawaited(_dirtyAll());
  }

  Future<void> updateMailbox(Mailbox mailbox, {bool? isDisabled}) async {
    final client = await _getClient();
    await client
        .mailboxUpdate(MailboxUpdateSchema(isDisabled: isDisabled),
            mailboxAddress: mailbox.address)
        .requireSuccess();
    unawaited(_dirtyAll());
  }

  Future<EmailMessageList>? loadMessageListMore({bool reload = false}) async {
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

  Future<void> _dirtyAll({
    bool mailboxList = true,
    bool messageList = true,
    bool status = true,
  }) async {
    if (mailboxList) {
      await _mailboxList.reload();
    }
    if (messageList) {
      _messageListReload();
    }
    if (status) {
      await _cloudStatus.reload();
    }
  }

  void _messageListReload() {
    _messageList.add(const EmailMessageList.empty());
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
        await _dirtyAll();
        _logger.finer('Marked mail as read.');
      })());
    }
    return enough.MimeMessage.parseFromText(body);
  }

  Future<void> forwardMail(EmailMessage message) async {
    final client = await _getClient();
    await client.mailboxMessageForward(MailboxMessageForwardSchema(),
        messageId: message.id);
  }

  Future<void> deleteMail(EmailMessage message) async {
    final client = await _getClient();
    await client.mailboxMessageDelete(messageId: message.id);
    await _dirtyAll();
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

  Future<Mailbox?> findMailboxByUuid(ApiUuid uuid) async {
    final list = await mailboxList.load();
    return list.mailboxes!.firstWhereOrNull((element) => uuid == element.id);
  }
}

class EmailMessageList {
  const EmailMessageList({
    required this.messages,
    required this.hasMore,
    required this.nextPageToken,
  });
  const EmailMessageList.empty()
      : this(messages: const [], hasMore: true, nextPageToken: null);
  final List<EmailMessage> messages;
  final bool hasMore;
  final String? nextPageToken;
}

class MailboxList {
  const MailboxList({required this.mailboxes});
  static const empty = MailboxList(mailboxes: null);
  final List<Mailbox>? mailboxes;
}

class JoinRun<T> with ChangeNotifier {
  bool get isRunning => _currentRun != null;

  Future<T>? _currentRun;
  Future<T> joinRun(Future<T> Function() callback) async {
    if (_currentRun != null) {
      return _currentRun!;
    }
    try {
      _currentRun = callback();
      notifyListeners();
      return await _currentRun!;
    } finally {
      _currentRun = null;
      notifyListeners();
    }
  }
}

class CloudStatus {
  CloudStatus({required this.lastFetched, required this.messagesUnread});
  final DateTime lastFetched;
  final int messagesUnread;
}

class ReloadableValueStream<T> extends StreamView<T> implements ValueStream<T> {
  ReloadableValueStream(this._stream)
      : _valueStream = _stream._subject.stream,
        super(_stream._subject.stream);

  final LazyBehaviorSubject<T> _stream;
  final ValueStream<T> _valueStream;

  Future<T> load() async => _stream.load();

  Future<T?> reload() async => await _stream.reload();

  @override
  Object get error => _valueStream.error;

  @override
  Object? get errorOrNull => _valueStream.errorOrNull;

  @override
  bool get hasError => _valueStream.hasError;

  @override
  bool get hasValue => _valueStream.hasValue;

  @override
  StackTrace? get stackTrace => _valueStream.stackTrace;

  @override
  T get value => _valueStream.value;

  @override
  T? get valueOrNull => _valueStream.valueOrNull;
}

class LazyBehaviorSubject<T> {
  LazyBehaviorSubject(this._loadData);

  final _subject = BehaviorSubject<T>();
  final _joinRun = JoinRun<T>();
  final Future<T> Function() _loadData;

  bool _dirty = true;

  ReloadableValueStream<T> streamReloadable() {
    if (_dirty) {
      load();
    }
    // TODO do we really need to return a new stream each time?
    return ReloadableValueStream(this);
  }

  Future<T?> reload() async {
    dirty();
    return await load();
  }

  Future<T> load() async {
    return await _joinRun.joinRun(() async {
      if (!_dirty) {
        return _subject.value;
      }
      try {
        final data = await _loadData();
        _subject.add(data);
        return data;
      } catch (error, stackTrace) {
        _subject.addError(error, stackTrace);
        rethrow;
      } finally {
        _dirty = false;
      }
    });
  }

  void dirty() {
    _dirty = true;
  }
}
