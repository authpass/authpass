import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:autofill_shared/credential_matcher.dart';
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

/// Holds the vaults the extension is currently working with.
///
/// [openVaults] takes every vault the user enabled, keyed by file uuid, so a
/// lookup can span them. The single-vault `openVault` remains for the memory
/// spike, which measures one file at a time.
class AutofillVaultService {
  /// The spike's single file. Kept separate from [_files] so the two entry
  /// points cannot interfere with each other's measurements.
  KdbxFile? _file;

  /// Vaults opened by [_openVaults], keyed by the manifest's file uuid.
  final Map<String, _OpenVault> _files = {};

  final _format = KdbxFormat();

  /// Parsing the suffix list costs a few milliseconds, so it happens once.
  final _matcher = CredentialMatcher.instance;

  void attach(MethodChannel channel) {
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'ping':
          return 'pong';
        case 'openVault':
          return await _openVault(_args(call));
        case 'listEntries':
          return _listEntries();
        case 'openVaults':
          return await _openVaults(_args(call));
        case 'matchEntries':
          return _matchEntries(_args(call));
        case 'credentialFor':
          final args = _args(call);
          final fileUuid = args['fileUuid'] as String?;
          return fileUuid == null
              // spike form: the single file opened by openVault.
              ? _credentialFor(args['uuid']! as String)
              : _credentialForIn(fileUuid, args['uuid']! as String);
        case 'close':
          _file = null;
          _files.clear();
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

  // --- the real lookup path ---------------------------------------------------

  /// Opens every vault it is given, and reports on each one separately.
  ///
  /// One unopenable vault must not sink the others: a user with three
  /// databases, one of them saved on another device since the app last cached
  /// its key, should still be offered credentials from the other two. So a
  /// failure becomes a `status` on that vault rather than an exception.
  Future<List<Map<String, Object?>>> _openVaults(
    Map<String, Object?> args,
  ) async {
    final vaults = (args['vaults']! as List<Object?>)
        .map((v) => (v! as Map<Object?, Object?>).cast<String, Object?>())
        .toList();
    _files.clear();
    final results = <Map<String, Object?>>[];
    for (final vault in vaults) {
      final fileUuid = vault['fileUuid']! as String;
      final name = vault['name'] as String? ?? '';
      try {
        final file = await _read(vault);
        _files[fileUuid] = _OpenVault(name: name, file: file);
        results.add({
          'fileUuid': fileUuid,
          'status': 'open', // NON-NLS
          'entryCount': file.body.rootGroup.getAllEntries().length,
        });
      } on PlatformException catch (e) {
        results.add({
          'fileUuid': fileUuid,
          'status': e.code,
          'message': e.message,
        });
      }
    }
    return results;
  }

  Future<KdbxFile> _read(Map<String, Object?> vault) async {
    final path = vault['path']! as String;
    final file = File(path);
    if (!file.existsSync()) {
      throw PlatformException(
        code: AutofillErrors.noVault,
        message: 'no vault at $path',
      );
    }
    try {
      return await _format.read(
        await file.readAsBytes(),
        TransformedKeyCredentials(
          transformedKey: vault['transformedKey']! as Uint8List,
          kdfFingerprint: vault['kdfFingerprint']! as String,
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
    }
  }

  /// The entries worth offering for [args.identifiers], best match first.
  ///
  /// Filtering happens here rather than natively, and that is the point: the
  /// phase 0 measurement spent 17 MB sending 5000 entries across the channel,
  /// against ~28 MB fixed for the vault itself. Only matches cross, and only
  /// their metadata — no password moves until one is chosen.
  List<Map<String, Object?>> _matchEntries(Map<String, Object?> args) {
    final identifiers = (args['identifiers'] as List<Object?>? ?? [])
        .whereType<String>();
    final limit = args['limit'] as int? ?? 50;

    final requests = [
      for (final identifier in identifiers)
        // iOS hands over domains and urls; an android package name arrives
        // through the same door on the other platform.
        if (identifier.contains('://') || identifier.contains('.'))
          CredentialRequest.web(identifier)
        else
          CredentialRequest.application(identifier),
    ].where((request) => !request.isEmpty).toList();
    if (requests.isEmpty) {
      return const [];
    }

    // Ranked across every vault at once. Ranking per vault and concatenating
    // would put a weak match from the first database above an exact one from
    // the second.
    final candidates = [
      for (final vault in _files.entries)
        for (final entry in vault.value.file.body.rootGroup.getAllEntries())
          _Candidate(vault.key, vault.value.name, entry),
    ];

    final ranked = _matcher.rank(
      requests,
      candidates,
      (candidate) => candidate.entry.autofillUrls,
    );

    return [
      for (final candidate in ranked.take(limit))
        {
          'fileUuid': candidate.fileUuid,
          'fileName': candidate.fileName,
          'uuid': candidate.entry.uuid.uuid,
          'label': candidate.entry.label,
          'username': candidate.entry
              .getString(KdbxKeyCommon.USER_NAME)
              ?.getText(),
          'quality': _matcher
              .matchBest(requests, candidate.entry.autofillUrls)
              ?.name,
        },
    ];
  }

  Map<String, Object?> _credentialForIn(String fileUuid, String entryUuid) {
    final vault = _files[fileUuid];
    if (vault == null) {
      throw PlatformException(
        code: AutofillErrors.notOpen,
        message: 'vault $fileUuid is not open',
      );
    }
    final entry = vault.file.body.rootGroup.getAllEntries().firstWhere(
      (entry) => entry.uuid.uuid == entryUuid,
      orElse: () => throw PlatformException(
        code: AutofillErrors.failed,
        message: 'no entry $entryUuid',
      ),
    );
    return {
      'username': entry.getString(KdbxKeyCommon.USER_NAME)?.getText() ?? '',
      'password': entry.getString(KdbxKeyCommon.PASSWORD)?.getText() ?? '',
    };
  }
}

class _OpenVault {
  _OpenVault({required this.name, required this.file});

  final String name;
  final KdbxFile file;
}

class _Candidate {
  _Candidate(this.fileUuid, this.fileName, this.entry);

  final String fileUuid;
  final String fileName;
  final KdbxEntry entry;
}
