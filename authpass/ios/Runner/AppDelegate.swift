import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var credentialsPlugin: Any?;
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "design.codeux.authpass.ios/as", binaryMessenger: controller.binaryMessenger)
    if #available(iOS 12.0, *) {
        credentialsPlugin = CredentialsPlugin(channel)
    } else {
        // Fallback on earlier versions
        channel.setMethodCallHandler { (call, result) in
            if (call.method == "isAvailable" || call.method == "isEnabled") {
                result(0);
            }
        }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
