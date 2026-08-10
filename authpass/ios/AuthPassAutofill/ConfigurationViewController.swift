import AuthenticationServices
import UIKit

/// What iOS shows when AuthPass is switched on in
/// Settings › General › AutoFill & Passwords, and whenever it is tapped there
/// afterwards.
///
/// It is the first thing a user sees after enabling autofill, and the only
/// place the extension can explain itself before a fill request arrives. So it
/// answers one question — is this actually going to work? — by reporting what
/// the extension can see right now, rather than showing a welcome screen that
/// would look identical whether or not anything was set up.
final class ConfigurationViewController: UIViewController {
  init(onDone: @escaping () -> Void) {
    self.onDone = onDone
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private let onDone: () -> Void
  private let stack = UIStackView()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    navigationItem.title = "AuthPass AutoFill"
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done, target: self, action: #selector(doneTapped))

    stack.axis = .vertical
    stack.spacing = 12
    stack.alignment = .fill
    stack.translatesAutoresizingMaskIntoConstraints = false

    let scroll = UIScrollView()
    scroll.translatesAutoresizingMaskIntoConstraints = false
    scroll.addSubview(stack)
    view.addSubview(scroll)

    let guide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      scroll.topAnchor.constraint(equalTo: guide.topAnchor),
      scroll.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
      scroll.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
      scroll.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
      stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 20),
      stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -20),
      stack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 20),
      stack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -20),
    ])

    describeState()
  }

  /// Reads the same manifest and keychain the fill path reads.
  ///
  /// Deliberately the real lookup rather than a summary written by the app:
  /// if the container is unreachable or a key is missing, this screen says so
  /// at the moment the user is looking, instead of the failure surfacing later
  /// as an empty password list in Safari with no explanation.
  private func describeState() {
    let vaults: [AutofillVaultStore.Vault]
    do {
      vaults = try AutofillVaultStore.vaults()
    } catch AutofillVaultStore.StoreError.noVaults {
      // No manifest at all, which is what "nothing has been enabled yet" looks
      // like — not a failure, and the state every user starts in.
      add(title: "No databases yet", body:
        "Open AuthPass, choose a database, and switch on AutoFill for it.\n\n"
        + "Each database is enabled separately, because enabling one keeps a "
        + "copy of it for AutoFill until you switch it off again.")
      return
    } catch AutofillVaultStore.StoreError.noContainer {
      add(title: "AutoFill is not ready", body:
        "The shared container could not be opened, so no databases can be "
        + "read. This usually means the app group entitlement is missing from "
        + "this build.")
      return
    } catch {
      // A manifest that exists but will not parse — worth showing verbatim,
      // since nothing the user can do in the app will fix it.
      add(title: "AutoFill is not ready", body:
        "The list of databases could not be read.\n\n"
        + "\(error.localizedDescription)")
      return
    }

    guard !vaults.isEmpty else {
      // The manifest listed databases but none had a usable key: either the
      // app has not cached one yet, or every one of them went stale when the
      // database was saved somewhere else.
      add(title: "Open AuthPass to finish setting up", body:
        "AutoFill is switched on for at least one database, but AuthPass has "
        + "not shared a key for it yet — or the database was saved elsewhere "
        + "since. Open AuthPass and unlock it once.")
      return
    }

    add(title: vaults.count == 1 ? "1 database ready" : "\(vaults.count) databases ready",
        body: "AuthPass will offer entries from these when an app or website "
          + "asks for a password.")
    for vault in vaults {
      add(row: vault.name)
    }
  }

  private func add(title: String, body: String) {
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = .preferredFont(forTextStyle: .headline)
    titleLabel.numberOfLines = 0

    let bodyLabel = UILabel()
    bodyLabel.text = body
    bodyLabel.font = .preferredFont(forTextStyle: .body)
    bodyLabel.textColor = .secondaryLabel
    bodyLabel.numberOfLines = 0

    stack.addArrangedSubview(titleLabel)
    stack.addArrangedSubview(bodyLabel)
  }

  private func add(row name: String) {
    let label = UILabel()
    label.text = "•  \(name)"
    label.font = .preferredFont(forTextStyle: .body)
    label.numberOfLines = 0
    stack.addArrangedSubview(label)
  }

  @objc private func doneTapped() {
    onDone()
  }
}
