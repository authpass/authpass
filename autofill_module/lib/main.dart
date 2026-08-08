import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kdbx/kdbx.dart';

/// Channel the native credential provider talks to. Same name on iOS and
/// macOS.
const _channelName = 'design.codeux.authpass/autofill';

/// Entry point for the headless engine the credential provider extension
/// boots. There is no [runApp] — the native side renders everything, this only
/// answers questions about the vault.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AutofillVaultService().attach(const MethodChannel(_channelName));
}

/// Errors reported back over the channel. The native side maps these to user
/// facing screens, so keep them stable.
class AutofillErrors {
  static const noVault = 'NO_VAULT';
  static const staleKey = 'STALE_KEY';
  static const invalidKey = 'INVALID_KEY';
  static const notOpen = 'NOT_OPEN';
  static const failed = 'FAILED';
}

/// Holds the vault the extension is currently working with.
///
/// Only one file at a time for the spike. The real implementation opens every
/// vault the user enabled for autofill, plus the staging file.
class AutofillVaultService {
  KdbxFile? _file;
  final _format = KdbxFormat();

  void attach(MethodChannel channel) {
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'ping':
          return 'pong';
        case 'openVault':
          return await _openVault(_args(call));
        case 'listEntries':
          return _listEntries();
        case 'credentialFor':
          return _credentialFor(_args(call)['uuid']! as String);
        case 'close':
          _file = null;
          return null;
        default:
          throw MissingPluginException('unknown method ${call.method}');
      }
    });
  }

  Map<String, Object?> _args(MethodCall call) =>
      (call.arguments as Map<Object?, Object?>).cast<String, Object?>();

  /// Opens the mirrored vault with a key the app already derived.
  ///
  /// Argon2 never runs here; if [kdfFingerprint] no longer matches the file the
  /// app has to refresh the cached key.
  Future<Map<String, Object?>> _openVault(Map<String, Object?> args) async {
    final path = args['path']! as String;
    final transformedKey = args['transformedKey']! as Uint8List;
    final kdfFingerprint = args['kdfFingerprint']! as String;

    final file = File(path);
    if (!file.existsSync()) {
      throw PlatformException(
        code: AutofillErrors.noVault,
        message: 'no vault at $path',
      );
    }

    final stopwatch = Stopwatch()..start();
    try {
      _file = await _format.read(
        await file.readAsBytes(),
        TransformedKeyCredentials(
          transformedKey: transformedKey,
          kdfFingerprint: kdfFingerprint,
        ),
      );
    } on KdbxTransformedKeyStaleException catch (e) {
      throw PlatformException(
        code: AutofillErrors.staleKey,
        message: 'vault was saved elsewhere',
        details: e.toString(),
      );
    } on KdbxInvalidKeyException {
      throw PlatformException(
        code: AutofillErrors.invalidKey,
        message: 'cached key does not open this vault',
      );
    } catch (e) {
      throw PlatformException(
        code: AutofillErrors.failed,
        message: e.toString(),
      );
    }
    stopwatch.stop();

    return {
      'entryCount': _requireFile().body.rootGroup.getAllEntries().length,
      'elapsedMs': stopwatch.elapsedMilliseconds,
    };
  }

  /// Metadata only — no secrets cross the channel until one is picked.
  List<Map<String, Object?>> _listEntries() {
    return _requireFile().body.rootGroup
        .getAllEntries()
        .map(
          (entry) => {
            'uuid': entry.uuid.uuid,
            'label': entry.label,
            'username': entry.getString(KdbxKeyCommon.USER_NAME)?.getText(),
            'url': entry.getString(KdbxKeyCommon.URL)?.getText(),
          },
        )
        .toList();
  }

  Map<String, Object?> _credentialFor(String uuid) {
    final entry = _requireFile().body.rootGroup.getAllEntries().firstWhere(
      (entry) => entry.uuid.uuid == uuid,
      orElse: () => throw PlatformException(
        code: AutofillErrors.failed,
        message: 'no entry $uuid',
      ),
    );
    return {
      'username': entry.getString(KdbxKeyCommon.USER_NAME)?.getText() ?? '',
      'password': entry.getString(KdbxKeyCommon.PASSWORD)?.getText() ?? '',
    };
  }

  KdbxFile _requireFile() {
    final file = _file;
    if (file == null) {
      throw PlatformException(
        code: AutofillErrors.notOpen,
        message: 'no vault open',
      );
    }
    return file;
  }
}
