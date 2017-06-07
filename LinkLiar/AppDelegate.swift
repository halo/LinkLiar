import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

  var statusItem: NSStatusItem?

  func applicationDidFinishLaunching(_ aNotification: Notification) {

    self.statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let menu = NSMenu()


    menu.addItem(NSMenuItem.separator())

    menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

    statusItem!.image = NSImage(named: "NSStatusAvailable")
    statusItem!.menu = menu
  }
}
