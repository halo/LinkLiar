import Cocoa

/**
 * Owns and manages the entire menu tree in the status bar.
 */
class Bar: NSObject {

  // MARK: Instance Properties

  /**
   * Allocates a square little spot in the status menu bar (where your Wi-Fi and battery icon is).
   *
   * - Returns: An instance of `NSStatusItem`.
   */
  lazy var statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)

  /**
   * The delegate of the status bar.
   *
   * - Returns: An instance of `Menu`.
   */
  lazy var menu = Menu()

  var icon: NSImage {
    if Thread.isMainThread { return self.iconLeaking }

    if Interfaces.anyOriginalMac() {
      return self.iconLeaking
    } else {
      return self.iconProtected
    }
  }

  private lazy var iconLeaking: NSImage = {
    let icon = #imageLiteral(resourceName: "MenuIconLeaking")
    icon.isTemplate = true
    return icon
  }()

  private lazy var iconProtected: NSImage = {
    let icon = #imageLiteral(resourceName: "MenuIconProtected")
    icon.isTemplate = true
    return icon
  }()

  /**
   * Must be called *after* application finished launching.
   * Otherwise there will be no menu at all in the status bar.
   */
  func load() {
    statusItem.button!.image = icon
    statusItem.button!.alternateImage = statusItem.button!.image
    statusItem.button!.setAccessibilityLabel("Linkliar")
    statusItem.menu = self.menu.menu
    statusItem.menu!.delegate = self

    // A new Interface might have been attached, refresh immediately to see if we're leaking an original hard MAC
    NotificationCenter.default.addObserver(forName: .interfacesChanged, object: nil, queue: nil, using: iconNeedsRefreshUsingNotification)

    // The Daemon might have changed something as soon as a new Interface came up. Let us check the status after the Daemon has probably finished.
    NotificationCenter.default.addObserver(forName: .interfacesChanged, object: nil, queue: nil, using: iconNeedsRefreshSoon)

    // The config file has been modified. Let the Daemon do it's thing and when it has probably finished, let us refresh the icon.
    NotificationCenter.default.addObserver(forName: .configChanged, object: nil, queue: nil, using: iconNeedsRefreshSoon)

    // Some other application or the end-user might have modified a MAC address via ifconfig. We cannot detect that, so we poll (without killing the battery).
    NotificationCenter.default.addObserver(forName: .intervalElapsed, object: nil, queue: nil, using: periodicRefresh)

    // The contents of the status menu have updated, go ahead and re-render it.
    NotificationCenter.default.addObserver(forName: .menuChanged, object: nil, queue: nil, using: menuNeedsRendering)
  }

  func periodicRefresh(_ _: Notification) {
    Log.debug("Time for periodic activity...")
    iconNeedsRefresh()
  }

  func iconNeedsRefreshSoon(_ _: Notification) {
    Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.iconNeedsRefreshUsingTimer(_:)), userInfo: nil, repeats: false)
  }

  func iconNeedsRefreshUsingNotification(_ _: Notification) {
    iconNeedsRefresh()
  }

  func iconNeedsRefreshUsingTimer(_ _: Timer) {
    iconNeedsRefresh()
  }

  func iconNeedsRefresh() {
    DispatchQueue.global(qos: .background).async(execute: { () -> Void in
      Log.debug("Reloading status bar icon...")
      self.statusItem.button!.image = self.icon
      self.statusItem.button!.alternateImage = self.statusItem.button!.image
      Log.debug("Status bar icon reloaded.")
    })
  }

  // This method is called from an asynchronous background task. That's the wrong run loop.
  // Let's hop into the correct runloop, the one managing the opened macOS status bar menu, and trigger a live refresh of the GUI.
  func menuNeedsRendering(_ _: Notification) {
    RunLoop.main.perform(#selector(self.refreshMenu), target: self, argument: nil, order: 0, modes: [.commonModes])
  }

  func refreshMenu() {
    Log.debug("Immediately refreshing GUI")
    self.menu.queue.sync {
      statusItem.menu!.update()
    }
  }

}

// MARK: - NSXPCListenerDelegate
extension Bar: NSMenuDelegate {

  // MARK: Instance Methods

  func menuWillOpen(_ _: NSMenu) {
    Log.debug("User clicked on the status bar menu icon.")
    iconNeedsRefresh()
    menu.update()
  }

}
