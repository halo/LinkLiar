import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

  var statusItem: NSStatusItem?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    Log.debug("LinkLiar GUI launched.")

    self.statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let menu = NSMenu()


    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: "Authorize", action: #selector(authorize(_:)), keyEquivalent: "a"))
    menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

    statusItem!.image = NSImage(named: "NSStatusAvailable")
    statusItem!.menu = menu
  }

  func authorize(_ sender: Any) {
    Controller.authorize(sender)
  }
}
