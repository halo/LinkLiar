import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

  var statusItem: NSStatusItem?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    Log.debug("LinkLiar GUI launched.")

    self.statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

    statusItem!.image = NSImage(named: "NSStatusAvailable")
    statusItem!.menu = Menu().menu

  }
}
