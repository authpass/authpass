import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:authpass/autofill/autofill_manifest.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:path_provider_foundation/path_provider_foundation.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('autofill_mirror');

/// Keeps a copy of the vaults enabled for autofill where the credential
/// provider extension can reach them.
///
/// The extension cannot resolve the security scoped bookmarks the app opens
/// files with, and it cannot ask the app for anything — the app is usually not
/// running. So the app mirrors each enabled vault into the shared app group
/// container and caches the post-KDF transformed key in a shared keychain
/// access group. See docs/autofill/plan.md.
///
/// Read-only from the extension's side in v1, but the layout is meant to carry
/// a staging file alongside the mirror later, for passkey registration.
///
/// iOS and macOS only; every method is a no-op elsewhere.
class AutofillMirror {
  AutofillMirror({
    required this.appGroupIdentifier,
    PathProviderFoundation? pathProvider,
    BiometricStorage? biometricStorage,
  }) : _pathProvider = pathProvider ?? PathProviderFoundation(),
       _biometricStorage = biometricStorage ?? BiometricStorage();

  /// e.g. `group.design.codeux.authpass`. Doubles as the keychain access
  /// group: an app group identifier is a valid `kSecAttrAccessGroup` and,
  /// unlike a `keychain-access-groups` entry, needs no team id prefix.
  final String appGroupIdentifier;

  final PathProviderFoundation _pathProvider;
  final BiometricStorage _biometricStorage;

  /// Name of the keychain item holding every cached transformed key.
  @NonNls
  static const _keyStoreName = 'AutofillTransformedKeys';

  @NonNls
  static const _vaultsDirName = 'vaults';

  Directory? _containerCache;

  /// The app group container, or null when there is none — every platform
  /// except iOS/macOS, and iOS/macOS builds whose entitlements lack the group.
  Future<Directory?> container() async {
    if (_containerCache != null) {
      return _containerCache;
    }
    if (!Platform.isIOS && !Platform.isMacOS) {
      return null;
    }
    final String? path;
    try {
      path = await _pathProvider.getContainerPath(
        appGroupIdentifier: appGroupIdentifier,
      );
    } catch (e, stackTrace) {
      _logger.warning('Unable to resolve app group container.', e, stackTrace);
      return null;
    }
    if (path == null) {
      _logger.warning(
        'No container for $appGroupIdentifier — is the app group entitlement '
        'missing from this build?',
      );
      return null;
    }
    return _containerCache = Directory(path);
  }

  Future<bool> get isAvailable async => await container() != null;

  /// Writes [bytes] and the transformed key for [file] so the extension can
  /// open it, and records it in the manifest.
  ///
  /// [bytes] is the exact content written to (or read from) the file source,
  /// so the mirror always matches a revision that really exists — writing
  /// freshly serialized bytes would rotate the salts again and invalidate the
  /// key we just cached.
  ///
  /// Silently does nothing when there is no container. Never throws for
  /// autofill reasons: failing to mirror must not fail a save.
  Future<bool> syncFile({
    required String fileUuid,
    required String name,
    required KdbxFile file,
    required Uint8List bytes,
  }) async {
    final dir = await container();
    if (dir == null) {
      return false;
    }
    try {
      final credentials = file.transformedKeyCredentials;
      if (credentials == null) {
        _logger.warning(
          'No transformed key for $name; kdbx3 files cannot be mirrored.',
        );
        return false;
      }

      final vaults = Directory('${dir.path}/$_vaultsDirName');
      await vaults.create(recursive: true);
      final fileName = '$_vaultsDirName/${_sanitize(fileUuid)}.kdbx';
      await File('${dir.path}/$fileName').writeAsBytes(bytes, flush: true);

      await _storeKey(fileUuid, credentials);
      await _updateManifest(
        (manifest) => manifest.withEntry(
          AutofillManifestEntry(
            fileUuid: fileUuid,
            name: name,
            fileName: fileName,
            updatedAt: DateTime.now().toUtc(),
            kdfFingerprint: credentials.kdfFingerprint,
          ),
        ),
      );
      _logger.fine('Mirrored $name (${bytes.length} bytes) for autofill.');
      return true;
    } catch (e, stackTrace) {
      _logger.warning('Unable to mirror $name for autofill.', e, stackTrace);
      return false;
    }
  }

  /// Drops a vault from the mirror — opted out, or closed for good.
  Future<void> removeFile(String fileUuid) async {
    final dir = await container();
    if (dir == null) {
      return;
    }
    try {
      final manifest = await readManifest();
      final entry = manifest.byFileUuid(fileUuid);
      if (entry != null) {
        final file = File('${dir.path}/${entry.fileName}');
        if (file.existsSync()) {
          await file.delete();
        }
      }
      await _updateManifest((m) => m.withoutFileUuid(fileUuid));
      await _removeKey(fileUuid);
    } catch (e, stackTrace) {
      _logger.warning('Unable to un-mirror $fileUuid.', e, stackTrace);
    }
  }

  /// Removes every mirrored vault and every cached key.
  Future<void> clear() async {
    final dir = await container();
    if (dir == null) {
      return;
    }
    try {
      final vaults = Directory('${dir.path}/$_vaultsDirName');
      if (vaults.existsSync()) {
        await vaults.delete(recursive: true);
      }
      final manifest = File('${dir.path}/${AutofillManifest.fileName}');
      if (manifest.existsSync()) {
        await manifest.delete();
      }
      await (await _keyStore()).delete();
    } catch (e, stackTrace) {
      _logger.warning('Unable to clear the autofill mirror.', e, stackTrace);
    }
  }

  Future<AutofillManifest> readManifest() async {
    final dir = await container();
    if (dir == null) {
      return AutofillManifest(entries: []);
    }
    final file = File('${dir.path}/${AutofillManifest.fileName}');
    if (!file.existsSync()) {
      return AutofillManifest(entries: []);
    }
    try {
      return AutofillManifest.parse(await file.readAsString());
    } catch (e, stackTrace) {
      _logger.warning(
        'Corrupt autofill manifest, starting over.',
        e,
        stackTrace,
      );
      return AutofillManifest(entries: []);
    }
  }

  Future<void> _updateManifest(
    AutofillManifest Function(AutofillManifest manifest) update,
  ) async {
    final dir = await container();
    if (dir == null) {
      return;
    }
    final manifest = update(await readManifest());
    await File(
      '${dir.path}/${AutofillManifest.fileName}',
    ).writeAsString(manifest.encode(), flush: true);
  }

  // --- the transformed key cache ---------------------------------------------

  /// The keychain item every cached key lives in.
  ///
  /// Biometry bound and `WhenPasscodeSetThisDeviceOnly`, so a key never leaves
  /// this device and never survives a change to the enrolled biometrics. It is
  /// only as powerful as the vault revision it belongs to — the next save
  /// rotates the kdf salt and strands it.
  Future<BiometricStorageFile> _keyStore() => _biometricStorage.getStorage(
    _keyStoreName,
    options: StorageFileInitOptions(
      darwinKeychainAccessGroup: appGroupIdentifier,
    ),
  );

  Future<void> _storeKey(
    String fileUuid,
    TransformedKeyCredentials credentials,
  ) async {
    final store = await _keyStore();
    final keys = await _readKeys(store);
    keys[fileUuid] = {
      'transformedKey': base64.encode(credentials.transformedKey), // NON-NLS
      'kdfFingerprint': credentials.kdfFingerprint, // NON-NLS
    };
    await store.write(json.encode(keys));
  }

  Future<void> _removeKey(String fileUuid) async {
    final store = await _keyStore();
    final keys = await _readKeys(store);
    if (keys.remove(fileUuid) == null) {
      return;
    }
    if (keys.isEmpty) {
      await store.delete();
    } else {
      await store.write(json.encode(keys));
    }
  }

  Future<Map<String, Object?>> _readKeys(BiometricStorageFile store) async {
    final content = await store.read();
    if (content == null) {
      return {};
    }
    try {
      return (json.decode(content) as Map<Object?, Object?>)
          .cast<String, Object?>();
    } catch (e, stackTrace) {
      _logger.warning(
        'Corrupt autofill key store, starting over.',
        e,
        stackTrace,
      );
      return {};
    }
  }

  /// File uuids are generated, but they end up in a path — do not trust them.
  static String _sanitize(String value) =>
      value.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_'); // NON-NLS
}
