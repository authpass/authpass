import 'dart:async';
import 'dart:typed_data';

import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx/storage_exception.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/cloud_storage_ui_adapt.dart';
import 'package:authpass/cloud_storage/google_drive/google_drive_models.dart';
import 'package:authpass/cloud_storage/google_drive/login_widget.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/utils/platform.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('authpass.google_drive_bloc');

@NonNls
const _METADATA_KEY_GOOGLE_DRIVE_DATA = 'googledrive.file_metadata';

class GoogleDriveProvider extends CloudStorageProvider
    implements CloudStorageCustomLoginButtonAdapter {
  GoogleDriveProvider({required this.env, required super.helper}) {
    googleSignIn.onCurrentUserChanged
        .listen((final account) => _checkAuthentication());
  }

  Future<void> _checkAuthentication() async {
    final account = googleSignIn.currentUser;
    _logger.fine('_checkAuthentication: (${account?.id})');
    if (account == null) {
      isAuthorized = false;
      return;
    }
    if (AuthPassPlatform.isWeb) {
      // for some reason `canAccessScopes` is only implemented on Web.
      if (await googleSignIn.canAccessScopes(_scopes)) {
        isAuthorized = true;
      }
    } else {
      isAuthorized = true;
    }
    _logger.fine('_checkAuthentication:  $isAuthorized');
  }

  late final googleSignIn = GoogleSignIn(
    clientId: env.secrets?.googleClientId?.call(),
    scopes: _scopes,
    forceCodeForRefreshToken: true,
  );

  @NonNls
  @override
  final String id = 'GoogleDriveProvider';

  final Env env;

  // static const _oauthEndpoint =
  //     'https://accounts.google.com/o/oauth2/v2/auth'; // NON-NLS
  // static const _oauthToken = 'https://oauth2.googleapis.com/token'; // NON-NLS

  static const _scopes = [DriveApi.driveScope];
  static const scopes = _scopes;

  // String get _clientId => env.secrets!.googleClientId!;
  // String get _clientSecret => env.secrets!.googleClientSecret!;

  @override
  bool get supportSearch => true;

  @override
  Future<SearchResponse> search({String name = Env.KeePassExtension}) async {
    return _search(SearchQueryTerm(const SearchQueryField('name'),
        QOperator.contains, SearchQueryValueLiteral(name)));
  }

  Future<SearchResponse> _search(SearchQueryTerm search) async {
    final driveApi = DriveApi(await requireAuthenticatedClient());
    _logger.fine('Query: ${search.toQuery()}');
    final files = await driveApi.files.list(
      q: search.toQuery(),
    );
    _logger.fine(
        'Got file results (incomplete:${files.incompleteSearch}): ${files.files!.map((f) => '${f.id}: ${f.name} (${f.mimeType})')}');
    return SearchResponse(
      (srb) => srb
        ..hasMore = files.nextPageToken != null
        ..results.addAll(
          files.files!.map(
            (f) => CloudStorageEntity(
              (b) => b
                ..id = f.id
                ..type = f.mimeType ==
                        'application/vnd.google-apps.folder' // NON-NLS
                    ? CloudStorageEntityType.directory
                    : CloudStorageEntityType.file
                ..name = f.name,
            ),
          ),
        ),
    );
  }

  @override
  Future<SearchResponse> list({CloudStorageEntity? parent}) {
    return _search(parent == null
        ? const SearchQueryTerm(SearchQueryValueLiteral('root'), QOperator.in_,
            SearchQueryField('parents'))
        : SearchQueryTerm(SearchQueryValueLiteral(parent.id), QOperator.in_,
            const SearchQueryField('parents')));
  }

  @override
  String get displayName => 'Google Drive'; // NON-NLS

  @override
  FileSourceIcon get displayIcon => FileSourceIcon.googleDrive;

  @override
  Future<FileContent> loadEntity(CloudStorageEntity file) async {
    final driveApi = DriveApi(await requireAuthenticatedClient());
    final metadata = (await driveApi.files.get(
      file.id,
      downloadOptions: DownloadOptions.metadata,
      $fields: GoogleDriveMetadata.fields,
    )) as File;
    final dynamic response = await driveApi.files
        .get(file.id, downloadOptions: DownloadOptions.fullMedia);
    final media = response as Media;
    final bytes = BytesBuilder(copy: false);
    // ignore: prefer_foreach
    await for (final chunk in media.stream) {
      bytes.add(chunk);
    }
    return FileContent(
      bytes.toBytes(),
      _metadataForFile(metadata),
    );
  }

  @override
  Future<Map<String, dynamic>> saveEntity(CloudStorageEntity file,
      Uint8List bytes, Map<String, dynamic>? previousMetadata) async {
    final driveApi = DriveApi(await requireAuthenticatedClient());
    final byteStream = ByteStream.fromBytes(bytes);
    if (previousMetadata != null) {
      final compareMetadata = GoogleDriveMetadata.fromJson(
          previousMetadata[_METADATA_KEY_GOOGLE_DRIVE_DATA]
              as Map<String, dynamic>);
      final remoteMetadata = (await driveApi.files.get(file.id,
          downloadOptions: DownloadOptions.metadata,
          $fields: GoogleDriveMetadata.fields)) as File;
      if (compareMetadata.version != remoteMetadata.version) {
        final remote = GoogleDriveMetadata.fromMetadata(remoteMetadata);
        throw StorageException.conflict(
            'Version differs from last loaded version. '
            'Local: ${compareMetadata.toJson()} Remote: ${remote.toJson()}');
      }
    }
    final updatedFile = await driveApi.files.update(File(), file.id,
        uploadMedia: Media(byteStream, bytes.lengthInBytes),
        $fields: GoogleDriveMetadata.fields);
    _logger.fine('Successfully saved file ${updatedFile.name}');
    return _metadataForFile(updatedFile);
  }

  @override
  Future<FileSource> createEntity(
      CloudStorageSelectorSaveResult saveAs, Uint8List bytes) async {
    final driveApi = DriveApi(await requireAuthenticatedClient());
    final metadata = File();
    metadata.name = saveAs.fileName;
    if (saveAs.parent != null) {
      metadata.parents = [saveAs.parent!.id];
    }
    final byteStream = ByteStream.fromBytes(bytes);
    _logger
        .fine('Creating google drive entity. bytes.length: ${bytes.length} / '
            'lengthInBytes: ${bytes.lengthInBytes}');
    final newFile = await driveApi.files.create(
      metadata,
      uploadMedia: Media(byteStream, bytes.lengthInBytes),
      $fields: GoogleDriveMetadata.fields,
    );
    return toFileSource(
      CloudStorageEntity((b) => b
        ..id = newFile.id
        ..name = newFile.name
        ..type = CloudStorageEntityType.file),
      uuid: AppDataBloc.createUuid(),
      initialCachedContent: FileContent(bytes, _metadataForFile(newFile)),
    );
  }

  Map<String, dynamic> _metadataForFile(File metadata) => <String, dynamic>{
        _METADATA_KEY_GOOGLE_DRIVE_DATA:
            GoogleDriveMetadata.fromMetadata(metadata).toJson(),
      };

  bool isAuthorized = false;

  @override
  bool get isAuthenticated => isAuthorized;

  @override
  Future<bool> loadSavedAuth() async {
    return await googleSignIn.isSignedIn();
  }

  @override
  Future<void> logout() {
    return googleSignIn.disconnect();
  }

  @override
  Future<bool> startAuth<RESULT extends UserAuthenticationPromptResult,
          DATA extends UserAuthenticationPromptData<RESULT>>(
      PromptUserForCode<RESULT, DATA> prompt) async {
    final user = await googleSignIn.signIn();
    _logger.finer('Authenticated user: $user');
    return user != null;
  }

  Future<Client> requireAuthenticatedClient() async {
    _logger.fine(
        'Getting authenticated client from googleSignIn (currentUser == null: ${googleSignIn.currentUser == null})');
    if (googleSignIn.currentUser == null) {
      final signedIn = await googleSignIn.signInSilently();
      _logger.fine(
          'signedIn: ${signedIn != null} (currentUser == null: ${googleSignIn.currentUser == null})');
    }
    final authClient = await googleSignIn.authenticatedClient();
    if (authClient == null) {
      throw LoadFileException(
          'Unable to (re)sign in to google drive using Google Sign-In.');
    }
    return authClient;
  }

  @override
  Widget getCustomLoginWidget({
    required VoidCallback onSuccess,
    required Widget defaultWidget,
  }) {
    if (!AuthPassPlatform.isWeb) {
      return defaultWidget;
    }
    return GoogleLoginWidget(
      onSuccess: () async {
        await _checkAuthentication();
        onSuccess();
      },
      googleDriveProvider: this,
      defaultWidget: defaultWidget,
    );
  }
}

abstract class SearchQueryAtom {
  String toQuery();
}

@immutable
class QOperator {
  const QOperator._(@NonNls this.op);

  final String op;

  static const contains = QOperator._('contains');
  static const eq = QOperator._('=');
  static const in_ = QOperator._('in');
  static const and = QOperator._('and');
}

class SearchQueryField implements SearchQueryAtom {
  const SearchQueryField(@NonNls this.fieldName);

  final String fieldName;

  @override
  String toQuery() => fieldName;
}

class SearchQueryValueLiteral implements SearchQueryAtom {
  const SearchQueryValueLiteral(@NonNls this.value);

  final Object? value;

  String _quoteValues(dynamic value) {
    if (value is String) {
      final escaped = value.replaceAllMapped(
          RegExp(r'''['\\]'''), (match) => '\\${match.group(0)}'); // NON-NLS
      return "'$escaped'"; // NON-NLS
    }
    if (value is List) {
      return '[${value.map((dynamic v) => _quoteValues(v)).join(',')}]'; // NON-NLS
    } else {
      throw StateError('Unsupported type. ${value.runtimeType}');
    }
  }

  @override
  String toQuery() => _quoteValues(value);
}

/// Search query terms
/// https://developers.google.com/drive/api/v3/search-files
/// https://developers.google.com/drive/api/v3/reference/query-ref
class SearchQueryTerm implements SearchQueryAtom {
  const SearchQueryTerm(this.left, this.operator, this.right);

  final SearchQueryAtom left;
  final QOperator operator;
  final SearchQueryAtom right;

  SearchQueryTerm operator &(SearchQueryTerm other) =>
      SearchQueryTerm(this, QOperator.and, other);

  @override
  String toQuery() {
    return '${left.toQuery()} ${operator.op} ${right.toQuery()}'; // NON-NLS
  }
}
