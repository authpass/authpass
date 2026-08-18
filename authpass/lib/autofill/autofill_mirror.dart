import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:autofill_shared/autofill_manifest.dart';
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
/// iOS only; every method is a no-op elsewhere.
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

  /// Prefix of the keychain item holding one file's cached transformed key.
  ///
  /// One item per file, rather than one item holding a map of them all. The map
  /// cost two Face ID prompts per file per save: [_storeKey] had to read the
  /// existing map before it could add to it, and the write then found the item
  /// already present and fell through to `SecItemUpdate`, which evaluates the
  /// access control again. Three open databases meant six prompts on every
  /// save.
  ///
  /// With one item per file the app never reads this keychain at all — it
  /// deletes and adds, and neither of those requires user presence. Only the
  /// extension reads, which is where a prompt belongs.
  @NonNls
  static const _keyStorePrefix = 'AutofillTransformedKeys_';

  @NonNls
  static const _vaultsDirName = 'vaults';

  Directory? _containerCache;

  /// The app group container, or null when there is none — every platform
  /// except iOS/macOS, and iOS/macOS builds whose entitlements lack the group.
  Future<Directory?> container() async {
    if (_containerCache != null) {
      return _containerCache;
    }
    // iOS only, deliberately. There is no credential provider extension under
    // macos/ yet, so mirroring there would write a decrypted copy of every
    // open vault into a shared container that nothing reads — cost with no
    // benefit. Lift this when the macOS extension exists.
    if (!Platform.isIOS) {
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
      // The manifest names every file with a cached key, so it has to be read
      // before it is deleted — with one keychain item per file there is no
      // single item to drop, and an orphaned key would outlive its vault.
      final manifest = await readManifest();
      for (final entry in manifest.entries) {
        await _removeKey(entry.fileUuid);
      }
      final vaults = Directory('${dir.path}/$_vaultsDirName');
      if (vaults.existsSync()) {
        await vaults.delete(recursive: true);
      }
      final manifestFile = File('${dir.path}/${AutofillManifest.fileName}');
      if (manifestFile.existsSync()) {
        await manifestFile.delete();
      }
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
  /// `biometryCurrentSet` and `WhenPasscodeSetThisDeviceOnly` — the default
  /// `darwinBiometricOnly` in `biometric_storage`, taken deliberately. So a key
  /// never leaves this device, cannot be reached with the passcode, and does
  /// not survive re-enrolling Face ID. It is also only as powerful as the vault
  /// revision it belongs to: the next save rotates the kdf salt and strands it.
  /// Not [_sanitize]d, deliberately: a `kSecAttrAccount` is an arbitrary
  /// string with no path to traverse, and the extension recovers the uuid by
  /// stripping the prefix — so it has to be the same uuid the manifest holds.
  Future<BiometricStorageFile> _keyStore(String fileUuid) =>
      _biometricStorage.getStorage(
        '$_keyStorePrefix$fileUuid',
        options: StorageFileInitOptions(
          darwinKeychainAccessGroup: appGroupIdentifier,
        ),
      );

  /// Caches one file's transformed key, without ever reading the keychain.
  ///
  /// Deleting first is what keeps this prompt-free. `SecItemAdd` on an absent
  /// item needs no user presence, but on a present one it returns
  /// `errSecDuplicateItem` and `biometric_storage` retries as `SecItemUpdate`
  /// — and updating an item guarded by `.userPresence` puts up Face ID. So the
  /// old item goes before the new one arrives.
  Future<void> _storeKey(
    String fileUuid,
    TransformedKeyCredentials credentials,
  ) async {
    final store = await _keyStore(fileUuid);
    await _deleteQuietly(store);
    await store.write(
      json.encode({
        'transformedKey': base64.encode(credentials.transformedKey), // NON-NLS
        'kdfFingerprint': credentials.kdfFingerprint, // NON-NLS
      }),
    );
  }

  Future<void> _removeKey(String fileUuid) async =>
      _deleteQuietly(await _keyStore(fileUuid));

  /// `delete` throws when the item is not there, which is a normal state here
  /// — nothing has been cached for this file yet, or it was already removed.
  Future<void> _deleteQuietly(BiometricStorageFile store) async {
    try {
      await store.delete();
    } catch (e) {
      _logger.finest('Nothing to delete from the autofill key store.', e);
    }
  }

  /// File uuids are generated, but they end up in a path — do not trust them.
  static String _sanitize(String value) =>
      value.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_'); // NON-NLS
}
