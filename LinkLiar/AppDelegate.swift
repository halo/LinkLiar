import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

  var statusItem: NSStatusItem?
  var menu: Menu?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    Log.debug("LinkLiar GUI launched.")

    self.statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

    statusItem!.image = NSImage(named: "NSStatusAvailable")
    self.menu = Menu()
    statusItem!.menu = self.menu!.menu
    statusItem!.menu!.delegate = self

  }

  func menuWillOpen(_ nsMenu: NSMenu) {
    Log.debug("I will open")
    self.menu!.refresh(nsMenu)
  }

}
