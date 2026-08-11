import AuthenticationServices
import Flutter
import UIKit

/// The credential provider itself.
///
/// It owns nothing but the routing: the system opens it for one of three
/// reasons, and each installs the child controller that does the work. The
/// engine is created here and handed down, so a single Dart isolate serves
/// whichever screen appears.
class CredentialProviderViewController: ASCredentialProviderViewController {
  private let engine = AutofillEngine()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
  }

  /// Set when the system opened us from Settings rather than for a fill.
  /// The two modes are dismissed differently.
  private var isConfiguring = false

  // MARK: - ASCredentialProviderViewController

  override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
    showPicker(for: serviceIdentifiers)
  }

  /// Reached when the user taps one of our QuickType suggestions.
  ///
  /// Registering an identity buys the suggestion, not the fill. iOS asks
  /// `provideCredentialWithoutUserInteraction` first, and the
  /// `userInteractionRequired` answer arrives *here* rather than in
  /// `prepareCredentialList` — so without this override the system presents a
  /// controller nothing has populated, and the user sees a blank screen after
  /// tapping their own credential.
  override func prepareInterfaceToProvideCredential(for credentialRequest: ASCredentialRequest) {
    showPicker(for: [credentialRequest.credentialIdentity.serviceIdentifier])
  }

  private func showPicker(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
    let list = CredentialListViewController(
      engine: engine,
      serviceIdentifiers: serviceIdentifiers,
      onPick: { [weak self] credential in
        self?.extensionContext.completeRequest(withSelectedCredential: credential)
      },
      onCancel: { [weak self] in
        self?.cancel()
      }
    )

    // Hosted in a navigation controller for the title and cancel button; the
    // system presents this controller, so the picker has to live inside it
    // rather than being presented on top.
    install(UINavigationController(rootViewController: list))
  }

  /// Reached from Settings > General > AutoFill & Passwords > AuthPass.
  override func prepareInterfaceForExtensionConfiguration() {
    isConfiguring = true

    let configuration = ConfigurationViewController(onDone: { [weak self] in
      self?.extensionContext.completeExtensionConfigurationRequest()
    })
    install(UINavigationController(rootViewController: configuration))
  }

  /// The fast path arrives in phase 2. Until then always ask for UI, which is
  /// the sanctioned way to bail out of this callback.
  override func provideCredentialWithoutUserInteraction(for credentialRequest: ASCredentialRequest) {
    extensionContext.cancelRequest(
      withError: NSError(
        domain: ASExtensionErrorDomain,
        code: ASExtensionError.userInteractionRequired.rawValue))
  }

  private func install(_ child: UIViewController) {
    addChild(child)
    child.view.frame = view.bounds
    child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(child.view)
    child.didMove(toParent: self)
  }

  private func cancel() {
    if isConfiguring {
      extensionContext.completeExtensionConfigurationRequest()
      return
    }
    extensionContext.cancelRequest(
      withError: NSError(
        domain: ASExtensionErrorDomain,
        code: ASExtensionError.userCanceled.rawValue))
  }
}
