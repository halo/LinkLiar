import Cocoa

class Bar: NSObject, NSMenuDelegate {

  lazy var statusItem: NSStatusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
  lazy var menu: Menu = Menu()

  func setup() {
    statusItem.image = NSImage(named: "NSStatusAvailable")
    statusItem.menu = self.menu.menu
    statusItem.menu!.delegate = self
    self.menu.load()

    NotificationCenter.default.addObserver(forName:.menuChanged, object:nil, queue:nil, using:needsRefresh)
  }

  func needsRefresh(_ notification: Notification) {
    // This method is called from an asynchronous background task. That's the wrong run loop.
    // Let's hop into the correct runloop, the one managing the opened macOS status bar menu, and trigger a live refresh of the GUI.
    RunLoop.main.perform(#selector(self.refreshMenu), target: self, argument: nil, order: 0, modes: [.commonModes])
  }

  func refreshMenu() {
    statusItem.menu!.update()
  }

  func menuWillOpen(_ nsMenu: NSMenu) {
    Log.debug("Menu will open...")
    //menu.refresh()
  }

}
