import Flutter
import Foundation
import LocalAuthentication
import os

/// Everything the extension can see of the app: the manifest and mirrored
/// vaults in the shared container, and the cached transformed keys in the
/// shared keychain group.
///
/// The extension reads; the app writes. Nothing here can open a vault the app
/// has not already mirrored and cached a key for.
enum AutofillVaultStore {
  /// Doubles as the keychain access group — an app group identifier is a valid
  /// `kSecAttrAccessGroup` and needs no team prefix.
  static let appGroupIdentifier = "group.design.codeux.authpass"

  static let manifestFileName = "autofill_manifest.json"

  /// `biometric_storage`'s own service name, and the account it files our keys
  /// under. Both have to match the plugin exactly or the lookup silently finds
  /// nothing — see deps/biometric_storage BiometricStorageImpl.baseQuery.
  private static let keychainService = "flutter_biometric_storage"
  /// One item per file, named `<prefix><file uuid>` — see AutofillMirror.
  private static let keychainAccountPrefix = "AutofillTransformedKeys_"

  private static let logger = Logger(
    subsystem: "design.codeux.authpass", category: "autofill")

  /// A vault the extension can actually open: mirrored on disk *and* holding a
  /// cached key.
  struct Vault {
    let fileUuid: String
    let name: String
    let path: String
    let transformedKey: Data
    let kdfFingerprint: String

    /// The shape `openVaults` expects on the Dart side.
    var channelArguments: [String: Any] {
      [
        "fileUuid": fileUuid,
        "name": name,
        "path": path,
        "transformedKey": FlutterStandardTypedData(bytes: transformedKey),
        "kdfFingerprint": kdfFingerprint,
      ]
    }
  }

  enum StoreError: Error {
    /// The entitlement is missing, or the app has never run.
    case noContainer
    /// Nothing has been enabled for autofill yet.
    case noVaults
  }

  static func containerUrl() throws -> URL {
    guard
      let url = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: appGroupIdentifier)
    else {
      throw StoreError.noContainer
    }
    return url
  }

  /// The vaults worth handing to Dart, in manifest order.
  ///
  /// A vault with no cached key is skipped rather than failing the lookup: the
  /// user may have enabled autofill for one database and not another, and the
  /// ones that do work should still be offered.
  static func vaults() throws -> [Vault] {
    let container = try containerUrl()
    let manifestUrl = container.appendingPathComponent(manifestFileName)
    guard let data = try? Data(contentsOf: manifestUrl) else {
      throw StoreError.noVaults
    }

    let manifest = try JSONDecoder().decode(Manifest.self, from: data)
    let keys = cachedKeys()

    return manifest.entries.compactMap { entry in
      guard let key = keys[entry.fileUuid] else {
        logger.info("no cached key for \(entry.fileUuid, privacy: .public)")
        return nil
      }
      // The app rotates the kdf salt on every save, so a key cached against an
      // older revision cannot open the current file. Dart would report
      // STALE_KEY; catching it here saves reading and decrypting first.
      guard key.kdfFingerprint == entry.kdfFingerprint else {
        logger.info("stale key for \(entry.fileUuid, privacy: .public)")
        return nil
      }
      guard let transformedKey = Data(base64Encoded: key.transformedKey) else {
        return nil
      }
      return Vault(
        fileUuid: entry.fileUuid,
        name: entry.name,
        path: container.appendingPathComponent(entry.fileName).path,
        transformedKey: transformedKey,
        kdfFingerprint: key.kdfFingerprint
      )
    }
  }

  // MARK: - the shared keychain item

  private struct CachedKey: Decodable {
    let transformedKey: String
    let kdfFingerprint: String
  }

  /// Every cached key, by file uuid. Empty when there are none, which is the
  /// normal state before the user enables autofill for anything.
  ///
  /// One item per file, so this is a single `kSecMatchLimitAll` query rather
  /// than one lookup per vault. The app writes them individually — that is what
  /// keeps *it* from prompting on every save — and the uuid is the part of
  /// `kSecAttrAccount` after the prefix.
  ///
  /// The shared `LAContext` is what holds this to one Face ID sheet. Each item
  /// is guarded by `.userPresence`, so without a context to authenticate into,
  /// decrypting N items asks N times. With one, the first evaluation satisfies
  /// the rest.
  private static func cachedKeys() -> [String: CachedKey] {
    let context = LAContext()
    context.touchIDAuthenticationAllowableReuseDuration =
      LATouchIDAuthenticationMaximumAllowableReuseDuration
    context.localizedReason = "Unlock AuthPass to fill a password"

    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: keychainService,
      kSecAttrAccessGroup as String: appGroupIdentifier,
      kSecReturnData as String: true,
      kSecReturnAttributes as String: true,
      kSecMatchLimit as String: kSecMatchLimitAll,
      kSecUseAuthenticationContext as String: context,
    ]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status == errSecSuccess, let entries = item as? [[String: Any]] else {
      if status != errSecItemNotFound {
        logger.error("keychain read failed: \(status, privacy: .public)")
      }
      return [:]
    }

    var keys: [String: CachedKey] = [:]
    for entry in entries {
      guard let account = entry[kSecAttrAccount as String] as? String,
        account.hasPrefix(keychainAccountPrefix),
        let data = entry[kSecValueData as String] as? Data
      else {
        // Other items live under the same service — biometric_storage is also
        // what quick-unlock uses — so anything without our prefix is not ours.
        continue
      }
      let fileUuid = String(account.dropFirst(keychainAccountPrefix.count))
      do {
        keys[fileUuid] = try JSONDecoder().decode(CachedKey.self, from: data)
      } catch {
        logger.error(
          "cached key for \(fileUuid, privacy: .public) is not readable: "
            + "\(error, privacy: .public)")
      }
    }
    return keys
  }

  // MARK: - the manifest, as the app writes it

  private struct Manifest: Decodable {
    let entries: [Entry]

    struct Entry: Decodable {
      let fileUuid: String
      let name: String
      let fileName: String
      let kdfFingerprint: String
    }
  }
}
