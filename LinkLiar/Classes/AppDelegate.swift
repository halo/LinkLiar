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

}

// MARK: - NSXPCListenerDelegate
extension AppDelegate: NSApplicationDelegate {

  // MARK: Instance Methods

  /**
   * Loads the status bar, auxiliary data and observers.
   */
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    Log.debug("LinkLiar GUI \(AppDelegate.version.formatted) launched.")
    bar.load()
    Config.observe()
    NetworkObserver.observe()
    IntervalTimer.run()
    MACVendors.load()
  }

}
