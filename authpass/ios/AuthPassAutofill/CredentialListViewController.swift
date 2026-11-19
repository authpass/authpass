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
///
/// When the url matcher finds nothing — or not what the user wanted — the
/// search bar searches every open vault instead, and a picked result fills just
/// the same. With no matches at all the search starts focused, so the user can
/// type straight away rather than meeting a dead end.
final class CredentialListViewController: UITableViewController,
  UISearchResultsUpdating
{
  private let engine: AutofillEngine
  private let serviceIdentifiers: [ASCredentialServiceIdentifier]
  private let onPick: (ASPasswordCredential) -> Void
  private let onCancel: () -> Void

  /// What the url matcher offered for the requested service.
  private var matches: [Match] = []
  /// Results for the current query; nil while nothing is typed, which puts
  /// `matches` back on screen.
  private var searchResults: [Match]?
  /// Bumped per query, so a slow answer to an old query cannot overwrite the
  /// answer to a newer one.
  private var searchGeneration = 0

  /// Replaces the list with a single explanatory row. Set for failures, and
  /// for an empty list — whichever list is showing.
  private var message: String?

  private lazy var searchController: UISearchController = {
    let controller = UISearchController(searchResultsController: nil)
    controller.searchResultsUpdater = self
    controller.obscuresBackgroundDuringPresentation = false
    controller.searchBar.placeholder = "Search all entries"
    controller.searchBar.autocapitalizationType = .none
    controller.searchBar.autocorrectionType = .no
    return controller
  }()

  /// The rows on screen: search results while searching, matches otherwise.
  private var rows: [Match] { searchResults ?? matches }

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
    navigationItem.hidesSearchBarWhenScrolling = false
    definesPresentationContext = true
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
        return fail(message: "Open AuthPass and enable AutoFill for a database.")
      }

      try engine.start()
      _ = try await engine.invoke(
        "openVaults", ["vaults": vaults.map { $0.channelArguments }])

      let identifiers = serviceIdentifiers.map { $0.identifier }
      let result = try await engine.invoke(
        "matchEntries", ["identifiers": identifiers])
      matches = (result as? [[String: Any]] ?? []).compactMap(Match.init)

      // Only now: until the vaults are open there is nothing to search.
      navigationItem.searchController = searchController
      showRowsOrEmptyMessage()
      if matches.isEmpty {
        // Straight into the search field, the only way forward from here.
        // Async, because the bar is not in the window until the next layout.
        DispatchQueue.main.async { self.searchController.searchBar.becomeFirstResponder() }
      }
    } catch AutofillVaultStore.StoreError.cancelled {
      // Not a failure. The user declined Face ID, and telling them something
      // went wrong when they chose this would be both wrong and alarming.
      fail(message: "Unlock AuthPass to see your entries.")
    } catch AutofillVaultStore.StoreError.biometryLockout(let biometry) {
      // Recoverable, and the recovery is somewhere this screen cannot reach —
      // so say where it is rather than describing the symptom. Both nouns come
      // from the device rather than from an assumption about it: this runs on
      // Touch ID iPhones and on iPads.
      fail(message: "\(biometry) is locked. Unlock your \(deviceNoun) with "
        + "your passcode once, then try again.")
    } catch AutofillVaultStore.StoreError.biometryNotEnrolled {
      fail(message: "AutoFill needs Face ID or Touch ID, which is not set up "
        + "on this device.")
    } catch {
      logger.error("lookup failed: \(String(describing: error), privacy: .public)")
      fail(message: "AuthPass could not read your databases.")
    }
  }

  /// What to call the thing the user is holding.
  private var deviceNoun: String {
    UIDevice.current.userInterfaceIdiom == .pad ? "iPad" : "iPhone"
  }

  private func show(message: String) {
    self.message = message
    tableView.reloadData()
  }

  /// Ends in a state with nothing to pick and nothing to search: the vaults
  /// could not be opened, or an entry could not be read.
  private func fail(message: String) {
    // Also discards any search still in flight.
    searchGeneration += 1
    searchController.isActive = false
    navigationItem.searchController = nil
    matches = []
    searchResults = nil
    show(message: message)
  }

  // MARK: - search

  func updateSearchResults(for searchController: UISearchController) {
    let query = searchController.searchBar.text?
      .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    searchGeneration += 1
    let generation = searchGeneration

    guard !query.isEmpty else {
      searchResults = nil
      showRowsOrEmptyMessage()
      return
    }
    Task {
      do {
        let result = try await engine.invoke("searchEntries", ["query": query])
        guard generation == searchGeneration else { return }
        searchResults = (result as? [[String: Any]] ?? []).compactMap(Match.init)
        showRowsOrEmptyMessage(query: query)
      } catch {
        logger.error("search failed: \(String(describing: error), privacy: .public)")
        guard generation == searchGeneration else { return }
        // Not fail(): the vaults are still open, and the next keystroke may
        // well succeed.
        searchResults = []
        show(message: "AuthPass could not search your databases.")
      }
    }
  }

  /// Puts whichever list is current on screen, or says why it is empty.
  private func showRowsOrEmptyMessage(query: String? = nil) {
    if !rows.isEmpty {
      message = nil
      tableView.reloadData()
    } else if let query = query {
      show(message: "No entries match “\(query)”.")
    } else {
      let what = serviceIdentifiers.first?.identifier ?? "this app"
      show(message: "No entries for \(what). Search to pick one anyway.")
    }
  }

  // MARK: - table

  override func numberOfSections(in tableView: UITableView) -> Int { 1 }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    message != nil ? 1 : rows.count
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
      let match = rows[indexPath.row]
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
    guard message == nil, indexPath.row < rows.count else { return }
    let match = rows[indexPath.row]
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
        fail(message: "AuthPass could not read that entry.")
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
