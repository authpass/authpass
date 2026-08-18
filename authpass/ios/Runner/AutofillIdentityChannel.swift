import AuthenticationServices
import Flutter
import Foundation

/// Publishes which credentials exist, so iOS can offer them.
///
/// The extension can answer "what matches this domain?" once it is asked — but
/// on iOS 18 and later nothing asks unless the domain already appears in
/// `ASCredentialIdentityStore`. The QuickType bar is built from this store, and
/// a provider that has registered nothing contributes no suggestions and never
/// gets `prepareCredentialList`. So this is not an optimisation; it is what
/// makes the extension reachable at all.
///
/// Deliberately in the app rather than the extension: only the app has the
/// unlocked database, and the store is written from the side that knows.
/// Nothing secret goes in — a service identifier, a username, and an opaque
/// record id. The password is fetched later, by the extension, from the
/// mirrored vault.
enum AutofillIdentityChannel {
  static let channelName = "design.codeux.authpass/autofill_identities"

  /// NSLog rather than os.Logger: the app still deploys to iOS 13, where
  /// Logger does not exist. The extension is free to use it — it targets 17.
  private static func log(_ message: String) {
    NSLog("[autofill-identities] %@", message)
  }

  static func register(with controller: FlutterViewController) {
    let channel = FlutterMethodChannel(
      name: channelName, binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "isSupported":
        result(isSupported())
      case "state":
        state(result: result)
      case "requestEnable":
        requestEnable(result: result)
      case "replaceIdentities":
        replaceIdentities(call: call, result: result)
      case "removeAll":
        removeAll(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  /// `ASCredentialIdentityStore` exists from iOS 12, but this project targets
  /// the `ASCredentialRequest` era; anything older simply has no autofill.
  private static func isSupported() -> Bool {
    if #available(iOS 17.0, *) { return true }
    return false
  }

  /// Whether the user has switched AuthPass on in Settings.
  ///
  /// Writes are silently dropped while it is off, so the app asks first and can
  /// tell the difference between "nothing to offer" and "not turned on".
  private static func state(result: @escaping FlutterResult) {
    ASCredentialIdentityStore.shared.getState { state in
      result([
        "enabled": state.isEnabled,
        "supportsIncrementalUpdates": state.supportsIncrementalUpdates,
      ])
    }
  }

  /// Asks the user to switch AuthPass on, and says whether it is on afterwards.
  ///
  /// The android side of this app has had `requestSetAutofillService` since
  /// forever, and this is the same gesture: a banner offers it, the system asks,
  /// the answer comes back. iOS only grew the in-app prompt in 18. On 17 the
  /// best there is deep links to the AutoFill page in Settings, which cannot
  /// report anything back — so it answers false, and the banner goes away on the
  /// next check instead, when the app is resumed.
  ///
  /// Apple asks for 10 seconds between calls to the prompt. Nothing here
  /// enforces that; the button is not reachable often enough to matter, and a
  /// refused prompt simply leaves the banner up.
  private static func requestEnable(result: @escaping FlutterResult) {
    if #available(iOS 18.0, *) {
      ASSettingsHelper.requestToTurnOnCredentialProviderExtension { enabled in
        log("prompt closed, enabled: \(enabled)")
        result(enabled)
      }
    } else if #available(iOS 17.0, *) {
      ASSettingsHelper.openCredentialProviderAppSettings { error in
        if let error {
          log("could not open settings: \(error.localizedDescription)")
        }
        result(false)
      }
    } else {
      result(false)
    }
  }

  private static func replaceIdentities(
    call: FlutterMethodCall, result: @escaping FlutterResult
  ) {
    guard
      let arguments = call.arguments as? [String: Any],
      let raw = arguments["identities"] as? [[String: Any]]
    else {
      result(
        FlutterError(
          code: "BAD_ARGUMENTS", message: "identities missing", details: nil))
      return
    }

    guard #available(iOS 17.0, *) else {
      result(false)
      return
    }

    let identities: [ASPasswordCredentialIdentity] = raw.compactMap { entry in
      guard
        let serviceIdentifier = entry["serviceIdentifier"] as? String,
        let user = entry["user"] as? String,
        let recordIdentifier = entry["recordIdentifier"] as? String
      else {
        return nil
      }
      return ASPasswordCredentialIdentity(
        serviceIdentifier: ASCredentialServiceIdentifier(
          identifier: serviceIdentifier, type: .domain),
        user: user,
        recordIdentifier: recordIdentifier)
    }

    // Replace rather than save: the app knows the whole set, and replacing is
    // the only way an entry the user deleted stops being offered. Incremental
    // saves would leave removed credentials behind forever.
    ASCredentialIdentityStore.shared.replaceCredentialIdentities(identities) {
      success, error in
      if let error {
        log("replace failed: \(error.localizedDescription)")
        result(
          FlutterError(
            code: "STORE_FAILED", message: error.localizedDescription,
            details: nil))
        return
      }
      log("published \(identities.count) identities")
      result(success)
    }
  }

  private static func removeAll(result: @escaping FlutterResult) {
    ASCredentialIdentityStore.shared.removeAllCredentialIdentities { success, error in
      if let error {
        result(
          FlutterError(
            code: "STORE_FAILED", message: error.localizedDescription,
            details: nil))
        return
      }
      result(success)
    }
  }
}
