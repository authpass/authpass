import Flutter
import Foundation
import os

/// Boots the headless Dart module and talks to it over a MethodChannel.
///
/// Deliberately not a plugin registration: nothing in the module needs plugins,
/// and plugin pods do not apply to extension targets anyway
/// (flutter/flutter#142136).
final class AutofillEngine {
  static let channelName = "design.codeux.authpass/autofill"

  private let logger = Logger(subsystem: "design.codeux.authpass", category: "autofill")
  private var engine: FlutterEngine?
  private var channel: FlutterMethodChannel?

  /// Memory still available to this process, in bytes.
  ///
  /// The credential provider extension gets roughly 120 MB, far less than the
  /// app. This is the number the Phase 0 go/no-go decision rests on.
  static var availableMemory: Int {
    return os_proc_available_memory()
  }

  static func formatBytes(_ bytes: Int) -> String {
    return String(format: "%.1f MB", Double(bytes) / 1024.0 / 1024.0)
  }

  /// Starts the engine if it is not running yet.
  ///
  /// `run` with a nil entrypoint uses `main()` in the module's lib/main.dart,
  /// which installs the channel handler and returns without calling runApp.
  func start() throws {
    guard engine == nil else { return }

    let engine = FlutterEngine(name: "authpass-autofill", project: nil, allowHeadlessExecution: true)
    guard engine.run() else {
      throw AutofillEngineError.startFailed
    }
    self.engine = engine
    self.channel = FlutterMethodChannel(
      name: Self.channelName,
      binaryMessenger: engine.binaryMessenger
    )
    logger.info("engine started, available memory \(Self.formatBytes(Self.availableMemory))")
  }

  func stop() {
    engine?.destroyContext()
    engine = nil
    channel = nil
  }

  /// Calls into Dart. Rethrows the Dart side's PlatformException codes as
  /// `AutofillEngineError.dart`.
  func invoke(_ method: String, _ arguments: Any? = nil) async throws -> Any? {
    guard let channel = channel else {
      throw AutofillEngineError.notStarted
    }
    return try await withCheckedThrowingContinuation { continuation in
      channel.invokeMethod(method, arguments: arguments) { result in
        if let error = result as? FlutterError {
          continuation.resume(
            throwing: AutofillEngineError.dart(
              code: error.code,
              message: error.message
            ))
        } else if (result as AnyObject) === FlutterMethodNotImplemented {
          continuation.resume(throwing: AutofillEngineError.notImplemented(method))
        } else {
          continuation.resume(returning: result)
        }
      }
    }
  }
}

enum AutofillEngineError: Error {
  case startFailed
  case notStarted
  case notImplemented(String)
  case dart(code: String, message: String?)
}
