import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

  lazy var bar: Bar = Bar()

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    Log.debug("LinkLiar GUI \(AppDelegate.version.formatted) launched.")
    bar.setup()
    Config.observe()
    MACVendors.load()
  }

  static var version: Version = {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      return Version(version)
    }
    return Version("?.?.?")
  }()

}
