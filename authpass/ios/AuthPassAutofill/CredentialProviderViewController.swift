import AuthenticationServices
import Flutter
import UIKit

/// Phase 0 spike.
///
/// Not a credential provider yet — it boots the headless Dart module, opens a
/// vault with a pre-derived key and decrypts an entry, reporting
/// `os_proc_available_memory()` at each step. The question it exists to answer
/// is whether a Flutter engine plus a realistic kdbx fits in the extension's
/// memory budget, or whether the fallback (native Swift + KeePassiumLib) is
/// needed.
///
/// Run it on a physical device in release: the simulator has no memory cap and
/// a debug engine blows the budget on its own (flutter/flutter#135243).
class CredentialProviderViewController: ASCredentialProviderViewController {
  private let engine = AutofillEngine()
  private let output = UITextView()
  private var startedAt = Date()

  override func viewDidLoad() {
    super.viewDidLoad()
    setUpViews()
    // Only the spike screen runs on load. A fill request arrives through
    // prepareCredentialList, which puts the picker up instead.
    if !isFillRequest {
      Task { await runSpike() }
    }
  }

  /// Set by [prepareCredentialList] before the view loads.
  private var isFillRequest = false

  private func setUpViews() {
    view.backgroundColor = .systemBackground

    let cancel = UIButton(type: .system)
    cancel.setTitle("Cancel", for: .normal)
    cancel.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    cancel.translatesAutoresizingMaskIntoConstraints = false

    output.isEditable = false
    output.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
    output.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(cancel)
    view.addSubview(output)

    let guide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      cancel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 8),
      cancel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),
      output.topAnchor.constraint(equalTo: cancel.bottomAnchor, constant: 8),
      output.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
      output.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),
      output.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
    ])
  }

  // MARK: - the measurement

  private func runSpike() async {
    startedAt = Date()
    report("baseline")

    do {
      try engine.start()
      report("engine started")

      _ = try await engine.invoke("ping")
      report("channel round trip")

      guard let vault = Bundle.main.url(forResource: "vault", withExtension: "kdbx"),
        let keyUrl = Bundle.main.url(forResource: "vault_key", withExtension: "json")
      else {
        log("\nNo fixture in the bundle.")
        log("Run: cd autofill_module && dart run tool/generate_test_vault.dart")
        return
      }

      let key = try JSONDecoder().decode(FixtureKey.self, from: Data(contentsOf: keyUrl))
      guard let transformedKey = Data(base64Encoded: key.transformedKey) else {
        log("\nfixture key is not valid base64")
        return
      }

      let opened = try await engine.invoke(
        "openVault",
        [
          "path": vault.path,
          "transformedKey": FlutterStandardTypedData(bytes: transformedKey),
          "kdfFingerprint": key.kdfFingerprint,
        ]) as? [String: Any]
      let entryCount = opened?["entryCount"] as? Int ?? -1
      let elapsedMs = opened?["elapsedMs"] as? Int ?? -1
      report("vault open (\(entryCount) entries, \(elapsedMs) ms in dart)")

      let entries = try await engine.invoke("listEntries") as? [[String: Any]] ?? []
      report("listed \(entries.count) entries")

      if let uuid = entries.first?["uuid"] as? String {
        let credential = try await engine.invoke("credentialFor", ["uuid": uuid])
          as? [String: Any]
        let username = credential?["username"] as? String ?? ""
        let password = credential?["password"] as? String ?? ""
        report("decrypted entry (user \(username), password \(password.count) chars)")
      }

      log("\nVERDICT: reached the end without being killed.")
      log("Compare 'available' against the ~120 MB cap other password")
      log("managers report; what matters is the headroom left at the end.")
    } catch {
      log("\nFAILED: \(error)")
      report("after failure")
    }
  }

  /// Appends one line with the memory still available at this point.
  private func report(_ label: String) {
    let available = AutofillEngine.formatBytes(AutofillEngine.availableMemory)
    let elapsed = String(format: "%.2fs", Date().timeIntervalSince(startedAt))
    log(String(format: "%-46@ available %@  %@", label as NSString, available, elapsed))
  }

  private func log(_ line: String) {
    NSLog("[autofill-spike] %@", line)
    output.text = (output.text ?? "") + line + "\n"
  }

  /// Set when the system opened us from Settings rather than for a fill.
  /// The two modes are dismissed differently.
  private var isConfiguring = false

  @objc private func cancelTapped() {
    if isConfiguring {
      extensionContext.completeExtensionConfigurationRequest()
      return
    }
    extensionContext.cancelRequest(
      withError: NSError(
        domain: ASExtensionErrorDomain,
        code: ASExtensionError.userCanceled.rawValue))
  }

  // MARK: - ASCredentialProviderViewController

  override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
    isFillRequest = true

    let list = CredentialListViewController(
      engine: engine,
      serviceIdentifiers: serviceIdentifiers,
      onPick: { [weak self] credential in
        self?.extensionContext.completeRequest(withSelectedCredential: credential)
      },
      onCancel: { [weak self] in
        self?.extensionContext.cancelRequest(
          withError: NSError(
            domain: ASExtensionErrorDomain,
            code: ASExtensionError.userCanceled.rawValue))
      }
    )

    // Hosted in a navigation controller for the title and cancel button; the
    // system presents this controller, so the picker has to live inside it
    // rather than being presented on top.
    let navigation = UINavigationController(rootViewController: list)
    addChild(navigation)
    navigation.view.frame = view.bounds
    navigation.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(navigation.view)
    navigation.didMove(toParent: self)
  }

  /// Reached from Settings > General > AutoFill & Passwords > AuthPass.
  ///
  /// Same process and same memory limit as a real fill, so the numbers are
  /// comparable — and it does not need a login form to trigger.
  override func prepareInterfaceForExtensionConfiguration() {
    isConfiguring = true
    log("opened from settings")
  }

  /// The fast path arrives in phase 2. Until then always ask for UI, which is
  /// the sanctioned way to bail out of this callback.
  override func provideCredentialWithoutUserInteraction(for credentialRequest: ASCredentialRequest) {
    extensionContext.cancelRequest(
      withError: NSError(
        domain: ASExtensionErrorDomain,
        code: ASExtensionError.userInteractionRequired.rawValue))
  }
}

private struct FixtureKey: Decodable {
  let transformedKey: String
  let kdfFingerprint: String
}
