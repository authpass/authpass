import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/env/_base.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

final _logger = Logger('authpass.google_drive_bloc');

class GoogleDriveProvider extends CloudStorageProviderClientBase<AutoRefreshingAuthClient> {
  GoogleDriveProvider({@required this.env, @required CloudStorageHelper helper}) : super(helper: helper);

  final Env env;

  static const _scopes = [DriveApi.DriveScope];
  ClientId get _clientId => ClientId(env.secrets.googleClientId, env.secrets.googleClientSecret);

  @override
  Future<AutoRefreshingAuthClient> clientFromAuthenticationFlow(prompt) async {
    final client = await clientViaUserConsentManual(_clientId, _scopes, prompt);
    client.credentialUpdates.listen(_credentialsChanged);
    _credentialsChanged(client.credentials);
    _logger.finer('Finished user consent.');
    return client;
  }

  @override
  AutoRefreshingAuthClient clientWithStoredCredentials(String stored) {
    final accessCredentials = _parseAccessCredentials(stored);
    final client = autoRefreshingClient(_clientId, accessCredentials, Client());
    client.credentialUpdates.listen(_credentialsChanged);
    return client;
  }

  void _credentialsChanged(AccessCredentials credentials) {
    final jsonString = <String, dynamic>{
      'accessToken': _accessTokenToJson(credentials.accessToken),
      'refreshToken': credentials.refreshToken,
      'idToken': credentials.idToken,
      'scopes': credentials.scopes,
    };
    storeCredentials(json.encode(jsonString));
  }

  Map<String, dynamic> _accessTokenToJson(AccessToken at) => <String, dynamic>{
        'type': at.type,
        'data': at.data,
        'expiry': at.expiry.toString(),
      };

  AccessToken _accessTokenFromJson(Map<String, dynamic> map) {
    return AccessToken(
      map['type'] as String,
      map['data'] as String,
      DateTime.parse(map['expiry'] as String),
    );
  }

  AccessCredentials _parseAccessCredentials(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return AccessCredentials(
      _accessTokenFromJson(map['accessToken'] as Map<String, dynamic>),
      map['refreshToken'] as String,
      (map['scopes'] as List).cast<String>(),
      idToken: map['idToken'] as String,
    );
  }

  @override
  Future<SearchResponse> search({String name = 'kdbx'}) async {
    final driveApi = DriveApi(await requireAuthenticatedClient());
    _logger.fine('Query: ${SearchQueryTerm('name', QOperator.contains, name).toQuery()}');
    final files = await driveApi.files.list(
      q: SearchQueryTerm('name', QOperator.contains, name).toQuery(),
    );
    _logger.fine('Got file results: ${files.files.map((f) => '${f.id}: ${f.name}')}');
    SearchResponse(
      (srb) => srb
        ..hasMore = files.nextPageToken != null
        ..results.addAll(
          files.files.map(
            (f) => CloudStorageEntity(
              (b) => b
                ..id = f.id
                ..type = CloudStorageEntityType.file
                ..name = f.name,
            ),
          ),
        ),
    );
    return null;
  }

  @override
  String get displayName => 'Google Drive';

  @override
  IconData get displayIcon => FontAwesomeIcons.googleDrive;

  @override
  Future<FileContent> loadEntity(CloudStorageEntity file) async {
    final driveApi = DriveApi(await requireAuthenticatedClient());
    final dynamic response = await driveApi.files.get(file.id, downloadOptions: DownloadOptions.FullMedia);
    final media = response as Media;
    final bytes = BytesBuilder(copy: false);
    // ignore: prefer_foreach
    await for (final chunk in media.stream) {
      bytes.add(chunk);
    }
    return FileContent(bytes.toBytes());
  }

  @override
  Future<Map<String, dynamic>> saveEntity(
      CloudStorageEntity file, Uint8List bytes, Map<String, dynamic> previousMetadata) async {
    final driveApi = DriveApi(await requireAuthenticatedClient());
    final byteStream = ByteStream.fromBytes(bytes);
    final updatedFile = await driveApi.files.update(null, file.id, uploadMedia: Media(byteStream, bytes.lengthInBytes));
    _logger.fine('Successfully saved file ${updatedFile.name}');
    return <String, dynamic>{};
  }
}

class QOperator {
  const QOperator._(this.op);

  final String op;

  static const contains = QOperator._('contains');
}

/// Search query terms
/// https://developers.google.com/drive/api/v3/search-files
/// https://developers.google.com/drive/api/v3/reference/query-ref
class SearchQueryTerm {
  SearchQueryTerm(this.term, this.operator, this.values);

  final String term;
  final QOperator operator;
  final Object values;

  String toQuery() {
    return '$term ${operator.op} ${_quoteValues(values)}';
  }

  String _quoteValues(dynamic value) {
    if (value is String) {
      final escaped = value.replaceAllMapped(RegExp(r'''['\\]'''), (match) => '\\${match.group(0)}');
      return "'$escaped'";
    } else {
      throw StateError('Unsupported type. ${value.runtimeType}');
    }
  }
}
