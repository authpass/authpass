import AuthenticationServices
import UIKit
import os

/// The picker the system shows when the user taps AuthPass in the QuickType
/// bar or the password menu.
///
/// Everything expensive happens in Dart: this opens the mirrored vaults, asks
/// for the entries matching the requested service, and shows them. No password
/// is fetched until a row is tapped — the list only ever holds titles and
/// usernames.
final class CredentialListViewController: UITableViewController {
  private let engine: AutofillEngine
  private let serviceIdentifiers: [ASCredentialServiceIdentifier]
  private let onPick: (ASPasswordCredential) -> Void
  private let onCancel: () -> Void

  private var matches: [Match] = []
  private var message: String?

  private let logger = Logger(
    subsystem: "design.codeux.authpass", category: "autofill")

  init(
    engine: AutofillEngine,
    serviceIdentifiers: [ASCredentialServiceIdentifier],
    onPick: @escaping (ASPasswordCredential) -> Void,
    onCancel: @escaping () -> Void
  ) {
    self.engine = engine
    self.serviceIdentifiers = serviceIdentifiers
    self.onPick = onPick
    self.onCancel = onCancel
    super.init(style: .insetGrouped)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) is not used")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "AuthPass"
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "credential")
    Task { await load() }
  }

  @objc private func cancelTapped() {
    onCancel()
  }

  // MARK: - loading

  private func load() async {
    do {
      let vaults = try await AutofillVaultStore.vaults()
      guard !vaults.isEmpty else {
        // Either nothing is enabled for autofill, or every cached key went
        // stale. Both are fixed in the app, not here.
        return show(message: "Open AuthPass and enable AutoFill for a database.")
      }

      try engine.start()
      _ = try await engine.invoke(
        "openVaults", ["vaults": vaults.map { $0.channelArguments }])

      let identifiers = serviceIdentifiers.map { $0.identifier }
      let result = try await engine.invoke(
        "matchEntries", ["identifiers": identifiers])
      matches = (result as? [[String: Any]] ?? []).compactMap(Match.init)

      if matches.isEmpty {
        let what = identifiers.first ?? "this app"
        return show(message: "No entries for \(what).")
      }
      message = nil
      tableView.reloadData()
    } catch AutofillVaultStore.StoreError.cancelled {
      // Not a failure. The user declined Face ID, and telling them something
      // went wrong when they chose this would be both wrong and alarming.
      show(message: "Unlock AuthPass to see your entries.")
    } catch AutofillVaultStore.StoreError.biometryLockout {
      // Recoverable, and the recovery is somewhere this screen cannot reach —
      // so say where it is rather than describing the symptom.
      show(message: "Face ID is locked. Unlock your iPhone with your passcode "
        + "once, then try again.")
    } catch AutofillVaultStore.StoreError.biometryNotEnrolled {
      show(message: "AutoFill needs Face ID or Touch ID, which is not set up "
        + "on this device.")
    } catch {
      logger.error("lookup failed: \(String(describing: error), privacy: .public)")
      show(message: "AuthPass could not read your databases.")
    }
  }

  private func show(message: String) {
    self.message = message
    matches = []
    tableView.reloadData()
  }

  // MARK: - table

  override func numberOfSections(in tableView: UITableView) -> Int { 1 }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    message != nil ? 1 : matches.count
  }

  override func tableView(
    _ tableView: UITableView, cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "credential", for: indexPath)
    var content = cell.defaultContentConfiguration()
    if let message = message {
      content.text = message
      content.textProperties.color = .secondaryLabel
      cell.selectionStyle = .none
    } else {
      let match = matches[indexPath.row]
      content.text = match.label
      // The vault name earns its place when several are open: two entries can
      // look identical otherwise.
      content.secondaryText = [match.username, match.fileName]
        .compactMap { $0?.isEmpty == false ? $0 : nil }
        .joined(separator: " — ")
      cell.selectionStyle = .default
    }
    cell.contentConfiguration = content
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard message == nil, indexPath.row < matches.count else { return }
    let match = matches[indexPath.row]
    Task {
      do {
        let result = try await engine.invoke(
          "credentialFor", ["fileUuid": match.fileUuid, "uuid": match.uuid])
        guard let credential = result as? [String: Any],
          let password = credential["password"] as? String
        else {
          throw AutofillEngineError.dart(code: "FAILED", message: "no credential")
        }
        onPick(
          ASPasswordCredential(
            user: credential["username"] as? String ?? "",
            password: password))
      } catch {
        logger.error("could not read entry: \(String(describing: error), privacy: .public)")
        show(message: "AuthPass could not read that entry.")
      }
    }
  }

  /// One row: metadata only, which is all that crosses the channel until the
  /// user picks.
  struct Match {
    let fileUuid: String
    let fileName: String?
    let uuid: String
    let label: String?
    let username: String?

    init?(_ json: [String: Any]) {
      guard let fileUuid = json["fileUuid"] as? String,
        let uuid = json["uuid"] as? String
      else { return nil }
      self.fileUuid = fileUuid
      self.uuid = uuid
      self.fileName = json["fileName"] as? String
      self.label = json["label"] as? String
      self.username = json["username"] as? String
    }
  }
}
