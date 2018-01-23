import Cocoa

class AppDelegate: NSObject {
  @objc func terminate() {
    Log.debug("Shutting down myself")
    NSApp.terminate(nil)
  }

  private func startGUI() {
    Log.debug("Starting GUI located at \(path)")
    NSWorkspace.shared.launchApplication(path)
  }

  private var path: String {
    let launcherPath = Bundle.main.bundlePath as NSString
    var components = launcherPath.pathComponents
    components.removeLast()
    components.removeLast()
    components.removeLast()
    components.append("MacOS")
    components.append("LinkLiar")
    return NSString.path(withComponents: components)
  }
}

extension AppDelegate: NSApplicationDelegate {

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    Log.debug("I am alive")
    DistributedNotificationCenter.default().addObserver(self, selector: #selector(self.terminate), name: .killLauncher, object: Identifiers.gui.rawValue)

    if RunningApplications.isRunning(Identifiers.gui.rawValue) {
      Log.debug("LinkLiar is already running.")
    } else {
      startGUI()
    }
    self.terminate()
  }
}

