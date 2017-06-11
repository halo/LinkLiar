import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

  lazy var bar: Bar = Bar()

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    Log.debug("LinkLiar GUI launched.")
    bar.setup()
    //NSApplication.shared().showHelp(self)
  }

}
