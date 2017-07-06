import Cocoa

/**
 * The LinkLiar GUI Application.
 */
class AppDelegate: NSObject {

  // MARK: Instance Properties

  /**
   * Holds the Menu Bar instance that manages the menu tree.
   *
   * - Returns: An instance of `Bar`.
   */
  lazy var bar: Bar = Bar()

  // MARK: Type Properties

  /**
   * Looks up the version of the Application Bundle in Info.plist.
   *
   * - Returns: An instance of `Version`.
   */
  static var version: Version = {
    Version(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
  }()

  fileprivate func checkDaemon() {
    // If the daemon is self-sustained, no need to do anything
    if !Config.instance.isRestrictedDaemon {
      Log.debug("The daemon is not restricted.")
      return
    }

    // If the daemon is coupled to the GUI, activate it if necessary
    // If there is no Helper, the `reply` callback will never be triggered.
    LaunchCtl.isDaemonRunning(reply: { isRunning in
      if isRunning {
        Log.debug("Daemon is already running, no need to activate it.")
      } else {
        Log.debug("Daemon is not running, try to activate it.")
        Controller.activateDaemon(self)
      }
    })
  }

}

// MARK: - NSXPCListenerDelegate
extension AppDelegate: NSApplicationDelegate {

  // MARK: Instance Methods

  /**
   * Loads the status bar, auxiliary data and observers.
   */
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    Log.debug("LinkLiar GUI \(AppDelegate.version.formatted) launched.")
    Config.observe()
    checkDaemon()
    bar.load()
    NetworkObserver.observe()
    IntervalTimer.run()
    MACVendors.load()
  }

}
