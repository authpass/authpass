import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx/file_content.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/cloud_storage/cloud_storage_helper.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/webdav/webdav_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:http_auth/http_auth.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:xml/xml.dart' as xml;

final _logger = Logger('authpass.webdav_provider');

class AuthenticationException extends StorageException {
  AuthenticationException(String details)
      : super(StorageExceptionType.authentication, details);
}

class WebDavClient extends NegotiateAuthClient {
  WebDavClient(this.credentials)
      : super(credentials.username, credentials.password);

  UserNamePasswordCredentials credentials;
}

class WebDavProvider extends CloudStorageProviderClientBase<WebDavClient> {
  WebDavProvider({@required CloudStorageHelper helper}) : super(helper: helper);

  xml.XmlNode _propfindRequest() {
    final builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('d:propfind', namespaces: {'DAV:': 'd'}, nest: () {
      builder.element('d:prop', nest: () {
        builder.element('d:getlastmodified');
        builder.element('d:getetag');
        builder.element('d:getcontenttype');
        builder.element('d:resourcetype');
      });
    });
    return builder.buildDocument();
  }

  @override
  Future<WebDavClient> clientFromAuthenticationFlow<
      TF extends UserAuthenticationPromptResult,
      UF extends UserAuthenticationPromptData<TF>>(prompt) async {
    assert(prompt is PromptUserForCode<UrlUsernamePasswordResult,
        UrlUsernamePasswordPromptData>);
    final urlPrompt = prompt as PromptUserForCode<UrlUsernamePasswordResult,
        UrlUsernamePasswordPromptData>;
    final result = await promptUser<UrlUsernamePasswordResult,
            UrlUsernamePasswordPromptData>(
        urlPrompt, UrlUsernamePasswordPromptData());
    if (result == null) {
      _logger.finer('prompt was canceled by user.');
      return null;
    }
    final credentials = UserNamePasswordCredentials(
        baseUrl: result.url,
        username: result.username,
        password: result.password);
    final client = WebDavClient(credentials);

    // fetch root, to validate credentials.
    await propFind(client, null);

    await storeCredentials(json.encode(credentials));
    return client;
  }

  @override
  WebDavClient clientWithStoredCredentials(String stored) {
    final credentials = UserNamePasswordCredentials.fromJson(
        json.decode(stored) as Map<String, dynamic>);
    if (credentials != null) {
      return WebDavClient(credentials);
    }
    return null;
  }

  @override
  Future<FileSource> createEntity(
      CloudStorageSelectorSaveResult saveAs, Uint8List bytes) async {
    final client = await requireAuthenticatedClient();
    final uri = _uriForEntity(client, saveAs.parent).resolve(saveAs.fileName);
    _logger.finer('Saving to $uri');
    final request = Request('PUT', uri);
    request.headers[HttpHeaders.ifNoneMatchHeader] = '*';
    request.bodyBytes = bytes;
    final response = await client.send(request);
    await _expectSuccessResponse(response);
    final newMetadata =
        WebDavFileMetadata(etag: response.headers[HttpHeaders.etagHeader]);
    _logger.finer(
        'Successfully created entity. new metadata: ${newMetadata.toJson()}');
    return toFileSource(
      _toCloudStorageEntity(
        client,
        uri.path,
        CloudStorageEntityType.file,
      ).toSimpleFileInfo(),
      uuid: AppDataBloc.createUuid(),
      initialCachedContent: FileContent(bytes, newMetadata.toJson()),
    );
  }

  @override
  FileSourceIcon get displayIcon => FileSourceIcon.webDav;

  @override
  String get displayName => 'WebDAV';

  Uri _uriForEntity(WebDavClient client, CloudStorageEntity entity) {
    final uri = Uri.parse(client.credentials.baseUrl);
    if (entity != null) {
      if (entity.type == CloudStorageEntityType.directory) {
        return uri.resolve(entity.id + '/');
      }
      return uri.resolve(entity.id);
    }
    return uri;
  }

  Future<SearchResponse> propFind(
      WebDavClient client, CloudStorageEntity parent) async {
    final parentUri = _uriForEntity(client, parent);
    final request = Request('PROPFIND', parentUri);
    request.headers['Depth'] = '1';
    final body = _propfindRequest();
//    _logger.finest('Requesting: ${body.toXmlString(pretty: true)}');
    request.body = body.toXmlString();
    final response = await client.send(request);

    await _expectSuccessResponse(response);

    final bytes = await response.stream.toBytes();
    final doc = xml.XmlDocument.parse(utf8.decode(bytes));
//    _logger.finer('Got propfind result: ${doc.toXmlString(pretty: true)}');
    final entities = doc.findAllElements('response', namespace: 'DAV:');
    _logger.finer('entities: ${entities.length}');
    final cloudStorageEntities = entities
        .map((entity) {
          final hrefEls = entity.findAllElements('href', namespace: 'DAV:');
          final href = hrefEls.isEmpty ? null : hrefEls.first.text;
          final resourcetype =
              entity.findAllElements('resourcetype', namespace: 'DAV:').first;
          final isFolder = resourcetype
              .findElements('collection', namespace: 'DAV:')
              .isNotEmpty;
          final isFile = resourcetype.children.isEmpty;
//          _logger.fine('Got entity: $href ($isFolder,$isFile) (${entity.toXmlString(pretty: true)})');
          final type = isFolder
              ? CloudStorageEntityType.directory
              : isFile ? CloudStorageEntityType.file : null;
          if (type == null) {
            return null;
          }

          final cse = _toCloudStorageEntity(client, href, type);
          final uri = _uriForEntity(client, cse);
          if (uri == parentUri) {
            return null;
          }
          return cse;
        })
        .where((el) => el != null)
        .toList();

    return SearchResponse((b) => b
      ..results.addAll(cloudStorageEntities)
      ..hasMore = false);
  }

  static final _removeTrailingSlash = RegExp(r'/+$');

  CloudStorageEntity _toCloudStorageEntity(
      WebDavClient client, String href, CloudStorageEntityType type) {
    href = href.replaceFirst(_removeTrailingSlash, '');
    final hrefUri = Uri.parse(href);
    _logger.fine(
        'Cloud entity to href: $href (pathSegments: ${hrefUri.pathSegments})');
    final basePath =
        path.joinAll(Uri.parse(client.credentials.baseUrl).pathSegments);
    final pathSegments = hrefUri.pathSegments.where((val) => val != '');
    return CloudStorageEntity(
      (b) => b
        ..id = href
        ..type = type
        ..path = '/' +
            path.relative(path.joinAll(hrefUri.pathSegments), from: basePath)
        ..name = pathSegments.isEmpty ? '/' : pathSegments.last,
    );
  }

  @override
  Future<SearchResponse> list({CloudStorageEntity parent}) async {
    final client = await requireAuthenticatedClient();
    return propFind(client, parent);
  }

  @override
  Future<FileContent> loadEntity(CloudStorageEntity file) async {
    final client = await requireAuthenticatedClient();
    final uri = _uriForEntity(client, file);
    final response = await client.get(uri);
    final metadata =
        WebDavFileMetadata(etag: response.headers[HttpHeaders.etagHeader]);
    _logger.finer(
        'Successfully loaded entity with metadata: ${metadata.toJson()}');
    return FileContent(response.bodyBytes, metadata.toJson());
  }

  @override
  Future<Map<String, dynamic>> saveEntity(CloudStorageEntity file,
      Uint8List bytes, Map<String, dynamic> previousMetadata) async {
    final client = await requireAuthenticatedClient();
    final uri = _uriForEntity(client, file);
    final request = Request('PUT', uri);
    if (previousMetadata == null) {
      _logger
          .severe('There was no previous metadata set?! Overwriting blindly.');
    } else {
      final metadata = WebDavFileMetadata.fromJson(previousMetadata);
      request.headers[HttpHeaders.ifMatchHeader] = metadata.etag;
    }
    request.bodyBytes = bytes;
    final response = await client.send(request);
    await _expectSuccessResponse(response);
    final newMetadata =
        WebDavFileMetadata(etag: response.headers[HttpHeaders.etagHeader]);
    _logger.finer(
        'Successfully saved entity. new metadata: ${newMetadata.toJson()}');
    return newMetadata.toJson();
  }

  Future<void> _expectSuccessResponse(StreamedResponse response) async {
    if (response.statusCode == 401) {
      _logger.severe(
          'Authentication error. ${response.statusCode} ${response.headers}');
      throw AuthenticationException(
          'Provided credentials were invalid. (Server Response ${response.statusCode}');
    } else if (response.statusCode >= 300 || response.statusCode < 200) {
      if (response.statusCode == HttpStatus.preconditionFailed) {
        throw StorageException(
            StorageExceptionType.conflict, 'Precondition failed.');
      }
      final body = utf8.decode(await response.stream.toBytes());
//      final contentType = ContentType.parse(response.headers[HttpHeaders.contentTypeHeader]);
//      if (contentType.subType == 'xml') {
//        final xmlBody = xml.parse(body);
//        if (xmlBody.rootElement.name.local == 'error') {
//
//        }
//      }
      _logger.severe('Error during call to webdav endpoint. '
          '${response.statusCode} ${response.reasonPhrase} (${response.headers})');
      _logger.severe('webdav request to: ${response.request.url}');
      throw StorageException(
        StorageExceptionType.unknown,
        'Error during request. (${response.statusCode} ${response.reasonPhrase})',
        errorBody: body,
      );
    }
  }
}
