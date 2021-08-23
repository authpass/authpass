import Cocoa
import FlutterMacOS
import HotKey

class MainFlutterWindow: NSWindow {
    let streamHandler = SwiftStreamHandler()
    
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    let messenger = flutterViewController.engine.binaryMessenger
    let eventChannel = FlutterEventChannel(name: "platform_channel_events/search", binaryMessenger: messenger)
    eventChannel.setStreamHandler(streamHandler)

    super.awakeFromNib()
    
    hotKey = HotKey(key: .n, modifiers: [.command, .option])
  }
        
    func notify() {
        streamHandler.sink?("search")
    }
    
    
    public var hotKey: HotKey? {
        didSet {
            guard let hotKey = hotKey else {
                return
            }

            hotKey.keyDownHandler = { [weak self] in
                guard let sink = self?.streamHandler.sink else {
                    return
                }
                
                NSApplication.shared.activate(ignoringOtherApps: true)
                self?.makeKeyAndOrderFront(self)
                self?.makeKey()
                self?.notify()
                sink("search")
            }
        }
    }
}


class SwiftStreamHandler: NSObject, FlutterStreamHandler {
    var sink: FlutterEventSink? = nil
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
}
