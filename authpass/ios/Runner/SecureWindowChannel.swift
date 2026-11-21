import Flutter
import Foundation
import UIKit

/// Hides the screen while iOS photographs it for the app switcher.
///
/// When an app is backgrounded UIKit captures whatever is on screen and keeps
/// the image in the app container, where it outlives the process. For a
/// password manager that can be an entry with a revealed field.
///
/// iOS has no equivalent of Android's `FLAG_SECURE`, so the only thing that
/// works is to put an opaque view over the window before the capture happens
/// and take it away afterwards. The capture is taken after
/// `applicationDidEnterBackground` returns — that is what the few seconds
/// granted there are for — so covering the window on that notification is
/// early enough.
///
/// Not `willResignActive`, although it comes earlier: it fires whenever the
/// app merely stops being frontmost, so the cover would also appear over the
/// biometric prompt, the document picker and the share sheet, and the user
/// would be looking at the launch screen if they dismissed one of those.
///
/// The observers are registered with `queue: nil` on purpose: that delivers
/// the notification synchronously, while the app is still entering the
/// background. Handing it to `OperationQueue.main` would schedule the block
/// for a later turn of the run loop, which may not come before the app is
/// suspended.
///
/// This cannot be done from Dart. A widget swapped in on
/// `AppLifecycleState.paused` is not guaranteed to be painted before the
/// capture, and a frame that arrives late arrives after the photograph.
///
/// What it does not do: stop the user taking a screenshot, which iOS offers no
/// way to prevent. It covers the capture the system takes unasked.
enum SecureWindowChannel {
  static let channelName = "design.codeux.authpass/secure_window"

  /// Mirrors the `secureWindow` app data flag, which is shared with Android
  /// and defaults to off.
  private static var isEnabled = false
  private static var coverView: UIView?
  /// Held only to keep it alive. A `UIViewController` owns its view, so
  /// letting the launch screen's controller go while its view is on the
  /// window relies on the window's reference alone.
  private static var coverController: UIViewController?
  private static var observers: [NSObjectProtocol] = []

  /// NSLog to match the other channel in this target.
  private static func log(_ message: String) {
    NSLog("[secure-window] %@", message)
  }

  static func register(with controller: FlutterViewController) {
    let channel = FlutterMethodChannel(
      name: channelName, binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "setSecure":
        guard let enabled = call.arguments as? Bool else {
          result(
            FlutterError(
              code: "invalid_argument",
              message: "setSecure expects a bool",
              details: nil))
          return
        }
        setSecure(enabled)
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    observeLifecycle()
  }

  private static func setSecure(_ enabled: Bool) {
    guard enabled != isEnabled else {
      return
    }
    isEnabled = enabled
    log("secure window \(enabled ? "enabled" : "disabled")")
    // Turning it off while a cover happens to be up should not leave the app
    // behind a blank screen.
    if !enabled {
      hideCover()
    }
  }

  private static func observeLifecycle() {
    guard observers.isEmpty else {
      return
    }
    let center = NotificationCenter.default
    // The old spelling of these two on purpose. The Runner target still builds
    // with `SWIFT_VERSION = 4.0` (and `SWIFT_SWIFT3_OBJC_INFERENCE = On`), and
    // the `UIApplication.didEnterBackgroundNotification` form arrived in Swift
    // 4.2, so in this target the compiler rejects it and points back at these.
    // Modernising the names means moving the target off Swift 4 first.
    observers.append(
      center.addObserver(
        forName: NSNotification.Name.UIApplicationDidEnterBackground,
        object: nil,
        queue: nil
      ) { _ in showCover() })
    observers.append(
      center.addObserver(
        forName: NSNotification.Name.UIApplicationWillEnterForeground,
        object: nil,
        queue: nil
      ) { _ in hideCover() })
  }

  private static func showCover() {
    guard isEnabled, coverView == nil, let window = targetWindow() else {
      return
    }
    let cover = makeCoverView(frame: window.bounds)
    cover.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    window.addSubview(cover)
    coverView = cover
  }

  private static func hideCover() {
    coverView?.removeFromSuperview()
    coverView = nil
    coverController = nil
  }

  /// The launch screen, reused as the cover.
  ///
  /// So the switcher shows the same thing the app shows while starting, rather
  /// than a black rectangle — which is what made covering the window look
  /// broken enough to leave the Android flag off by default (#100).
  private static func makeCoverView(frame: CGRect) -> UIView {
    if let controller = UIStoryboard(name: "LaunchScreen", bundle: nil)
      .instantiateInitialViewController(),
      let launch = controller.view
    {
      coverController = controller
      launch.frame = frame
      return launch
    }
    log("LaunchScreen could not be instantiated; covering with a plain view.")
    let fallback = UIView(frame: frame)
    fallback.backgroundColor = .white
    return fallback
  }

  private static func targetWindow() -> UIWindow? {
    let windows = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
    return windows.first { $0.isKeyWindow } ?? windows.first
  }
}
