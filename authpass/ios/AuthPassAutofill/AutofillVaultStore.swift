import Flutter
import Foundation
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
  private static let keychainAccount = "AutofillTransformedKeys"

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

  /// Every cached key, by file uuid. Empty when the item is absent, which is
  /// the normal state before the user enables autofill for anything.
  ///
  /// No `LAContext` and no prompt: the item is biometry bound, so the system
  /// puts up its own Face ID sheet when this runs. That is deliberate — the
  /// user is unlocking their vault, and it happens once per invocation.
  private static func cachedKeys() -> [String: CachedKey] {
    var query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: keychainService,
      kSecAttrAccount as String: keychainAccount,
      kSecAttrAccessGroup as String: appGroupIdentifier,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne,
    ]
    query[kSecUseOperationPrompt as String] = "Unlock AuthPass to fill a password"

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status == errSecSuccess, let data = item as? Data else {
      if status != errSecItemNotFound {
        logger.error("keychain read failed: \(status, privacy: .public)")
      }
      return [:]
    }
    do {
      return try JSONDecoder().decode([String: CachedKey].self, from: data)
    } catch {
      logger.error("cached key store is not readable: \(error, privacy: .public)")
      return [:]
    }
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
