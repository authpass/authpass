import 'package:authpass/cloud_storage/cloud_storage.dart';
import 'package:authpass/env/_base.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

final _logger = Logger('authpass.google_drive_bloc');

class GoogleDriveProvider extends CloudStorageProvider {
  GoogleDriveProvider({@required this.env});

  final Env env;
  AutoRefreshingAuthClient _client;

  @override
  Future<bool> startAuth(prompt) async {
    final id = ClientId(env.secrets.googleClientId, env.secrets.googleClientSecret);
    final scopes = [DriveApi.DriveScope];

    _client = await clientViaUserConsentManual(id, scopes, prompt);
    _logger.finer('Finished user consent.');
    return true;
  }

  @override
  Future<SearchResponse> searchKdbx() async {
    assert(_client != null);
    final driveApi = DriveApi(_client);
    _logger.fine('Query: ${SearchQueryTerm('name', QOperator.contains, 'kdbx').toQuery()}');
    final files = await driveApi.files.list(
      q: SearchQueryTerm('name', QOperator.contains, 'kdbx').toQuery(),
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
  bool get isAuthenticated => _client != null;

  @override
  String get displayName => 'Google Drive';
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
