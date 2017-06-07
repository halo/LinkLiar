import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

  var statusItem: NSStatusItem?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    Log.debug("LinkLiar GUI launched.")

    self.statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

    statusItem!.image = NSImage(named: "NSStatusAvailable")
    statusItem!.menu = Menu().menu
  }

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
