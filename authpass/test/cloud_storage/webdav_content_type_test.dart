import 'dart:async';
import 'dart:io';

import 'package:authpass/cloud_storage/webdav/webdav_models.dart';
import 'package:authpass/cloud_storage/webdav/webdav_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../util/test_util.dart';

const _multistatus = '''
<?xml version="1.0" encoding="utf-8"?>
<d:multistatus xmlns:d="DAV:">
  <d:response>
    <d:href>/dav/</d:href>
    <d:propstat>
      <d:prop><d:resourcetype><d:collection/></d:resourcetype></d:prop>
      <d:status>HTTP/1.1 200 OK</d:status>
    </d:propstat>
  </d:response>
  <d:response>
    <d:href>/dav/passwords.kdbx</d:href>
    <d:propstat>
      <d:prop><d:resourcetype/></d:prop>
      <d:status>HTTP/1.1 200 OK</d:status>
    </d:propstat>
  </d:response>
</d:multistatus>
''';

/// A WebDAV server which is as strict as lighttpd's mod_webdav: a request body
/// that is not labelled as XML is refused with 415 (RFC 4918, section 8.2).
class _StrictWebDavServer {
  _StrictWebDavServer(this._server) {
    _subscription = _server.listen(_handle);
  }

  static Future<_StrictWebDavServer> start() async => _StrictWebDavServer(
    await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
  );

  final HttpServer _server;
  late final StreamSubscription<HttpRequest> _subscription;

  /// The `Content-Type` of every request seen, in order.
  final contentTypes = <String?>[];

  String get baseUrl =>
      'http://${_server.address.address}:${_server.port}/dav/';

  Future<void> _handle(HttpRequest request) async {
    contentTypes.add(request.headers.contentType?.mimeType);
    await request.drain<void>();
    final mimeType = request.headers.contentType?.mimeType;
    if (mimeType != 'application/xml' && mimeType != 'text/xml') {
      request.response.statusCode = HttpStatus.unsupportedMediaType;
    } else {
      request.response
        ..statusCode = 207
        ..headers.contentType = ContentType('application', 'xml')
        ..write(_multistatus);
    }
    await request.response.close();
  }

  Future<void> close() async {
    await _subscription.cancel();
    await _server.close(force: true);
  }
}

void main() {
  late _StrictWebDavServer server;

  setUp(() async {
    server = await _StrictWebDavServer.start();
  });

  tearDown(() async {
    await server.close();
  });

  test('PROPFIND body is sent as application/xml', () async {
    final provider = WebDavProvider(helper: CloudStorageHelperMock());
    final client = WebDavClient(
      UserNamePasswordCredentials(
        baseUrl: server.baseUrl,
        username: 'authpass',
        password: 'authpa55',
      ),
    );

    final response = await provider.propFind(client, null);

    expect(server.contentTypes, ['application/xml']);
    expect(response.results.map((e) => e?.name), ['passwords.kdbx']);
  });
}
