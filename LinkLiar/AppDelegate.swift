import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

  var statusItem: NSStatusItem?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    Log.debug("LinkLiar GUI launched.")

    self.statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let menu = NSMenu()

    let item: NSMenuItem = NSMenuItem(title: "Authorize...", action: #selector(Controller.authorize(_:)), keyEquivalent: "")
    item.target = Controller.self

    menu.addItem(NSMenuItem.separator())
    menu.addItem(item)
    menu.addItem(NSMenuItem(title: "Helper Version", action: #selector(helperVersion(_:)), keyEquivalent: "h"))
    menu.addItem(NSMenuItem(title: "Create Config dir", action: #selector(createConfigDir(_:)), keyEquivalent: "h"))
    menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

    statusItem!.image = NSImage(named: "NSStatusAvailable")
    statusItem!.menu = menu
  }

  //func authorize(_ sender: Any) {
    //Controller.authorize(sender)
    //print("NOOO")
  //}

  func helperVersion(_ sender: Any) {
    Intercom.helperVersion(reply: {
      rawVersion in
      if (rawVersion == nil) {
        // TODO Compare SemVer
        Log.debug("helper does not seem to say much")
        Elevator().install()
      } else {
        Log.debug("helper is helpful")
        let version = Version(rawVersion!)
        Log.debug("\(version.version())")
      }
      // Elevator().bless()

    })
  }

  func createConfigDir(_ sender: Any) {
    Intercom.createConfigDir(reply: {
      success in
      if (success) {
        Log.debug("You gotta dir now")
      } else {
        Log.debug("No dir for you")
      }
    })
  }

}
