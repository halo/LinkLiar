import Cocoa

class Bar: NSObject, NSMenuDelegate {

  var statusItem: NSStatusItem?
  lazy var customMenu: Menu = Menu()

  func setup() {
    self.statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    //customMenu = Menu()

    statusItem!.image = NSImage(named: "NSStatusAvailable")
    statusItem!.menu = self.customMenu.menu
    statusItem!.menu!.delegate = self

    let center = NotificationCenter.default
    center.addObserver(forName:Notification.Name(rawValue:"MyNotification"),
                   object:nil, queue:nil,
                   using:refresh)
  }

  func refresh(_ notification: Notification) {
    RunLoop.main.perform(#selector(self.refreshMenu), target: self, argument: nil, order: 0, modes: [.commonModes])
  }

  func refreshMenu() {
    statusItem!.menu!.update()
  }

  func menuWillOpen(_ nsMenu: NSMenu) {
    Log.debug("IASDASDASDASDASDn")
    self.customMenu.refresh(nsMenu)
  }

}
