import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

  lazy var bar: Bar = Bar()

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    Log.debug("LinkLiar GUI launched.")
    bar.setup()
    Config.instance
    //NSApplication.shared().showHelp(self)
  }

}
