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
    /// The user dismissed Face ID, or it failed. Distinct from every other
    /// error because it is not a fault: the right response is to say nothing
    /// went wrong, rather than "AuthPass could not read your databases".
    case cancelled
  }

  /// One manifest entry plus whether a key for it exists — established without
  /// reading the key, so without authenticating.
  struct VaultStatus {
    let fileUuid: String
    let name: String
    let hasKey: Bool
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
  static func vaults() async throws -> [Vault] {
    let container = try containerUrl()
    let manifest = try readManifest()
    let keys = try await cachedKeys()

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

  /// What the Settings screen shows: every mirrored vault, and whether a key
  /// for it exists. Never prompts — see [accountsWithKeys].
  static func statuses() throws -> [VaultStatus] {
    let manifest = try readManifest()
    let withKeys = accountsWithKeys()
    return manifest.entries.map {
      VaultStatus(
        fileUuid: $0.fileUuid,
        name: $0.name,
        hasKey: withKeys.contains($0.fileUuid)
      )
    }
  }

  private static func readManifest() throws -> Manifest {
    let manifestUrl = try containerUrl().appendingPathComponent(manifestFileName)
    guard let data = try? Data(contentsOf: manifestUrl) else {
      throw StoreError.noVaults
    }
    return try JSONDecoder().decode(Manifest.self, from: data)
  }

  // MARK: - the shared keychain item

  private struct CachedKey: Decodable {
    let transformedKey: String
    let kdfFingerprint: String
  }

  /// Every cached key, by file uuid, behind exactly one Face ID sheet.
  ///
  /// **The authentication is done here, explicitly, before the query.** A bulk
  /// `kSecMatchLimitAll` read does not put up authentication UI of its own —
  /// interactive evaluation is a single-item affair, and items whose access
  /// control would need interaction are dropped from the results instead. So
  /// handing this query an unevaluated `LAContext` does not produce one prompt
  /// covering N items; it produces no prompt and no items, which reads exactly
  /// like "nothing has been cached yet" and would send a device debugging
  /// session after the wrong layer entirely.
  ///
  /// With the context already evaluated, no item *requires* interaction any
  /// more, and the bulk read returns all of them without further UI. One sheet
  /// by construction rather than by hope.
  ///
  /// The policy has to match the access control the app wrote with, and that is
  /// `.biometryCurrentSet` — `biometric_storage` defaults `darwinBiometricOnly`
  /// to true. Two consequences worth knowing rather than discovering: a
  /// passcode cannot open these items, so `.deviceOwnerAuthentication` would
  /// authenticate and still return nothing; and the keys are invalidated by
  /// re-enrolling Face ID, which is intended — the next save re-caches them.
  private static func cachedKeys() async throws -> [String: CachedKey] {
    let context = LAContext()
    do {
      try await context.evaluatePolicy(
        .deviceOwnerAuthenticationWithBiometrics,
        localizedReason: "Unlock AuthPass to fill a password")
    } catch let error as LAError where error.code == .userCancel
      || error.code == .userFallback || error.code == .appCancel
      || error.code == .systemCancel
    {
      throw StoreError.cancelled
    }

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
          "cached key for \(fileUuid, privacy: .public) is not readable: \(error, privacy: .public)"
        )
      }
    }
    return keys
  }

  /// Which file uuids have a cached key, without reading one.
  ///
  /// Attributes only — no `kSecReturnData` — so the keychain never decrypts
  /// anything and never evaluates the access control. That is what lets the
  /// Settings screen describe the state without demanding Face ID to do it,
  /// which it should not: knowing *which* databases are usable needs no key
  /// material, and the one prompt belongs at an actual fill.
  private static func accountsWithKeys() -> Set<String> {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: keychainService,
      kSecAttrAccessGroup as String: appGroupIdentifier,
      kSecReturnAttributes as String: true,
      kSecMatchLimit as String: kSecMatchLimitAll,
    ]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status == errSecSuccess, let entries = item as? [[String: Any]] else {
      if status != errSecItemNotFound {
        logger.error("keychain scan failed: \(status, privacy: .public)")
      }
      return []
    }
    return Set(
      entries.compactMap { entry in
        guard let account = entry[kSecAttrAccount as String] as? String,
          account.hasPrefix(keychainAccountPrefix)
        else {
          return nil
        }
        return String(account.dropFirst(keychainAccountPrefix.count))
      })
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
