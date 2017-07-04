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
    statusItem.button!.alternateImage = icon
    statusItem.button!.setAccessibilityLabel("Linkliar")

    statusItem.menu = self.menu.menu
    statusItem.menu!.delegate = self
    NotificationCenter.default.addObserver(forName: .interfacesChanged, object: nil, queue: nil, using: iconNeedsRefreshUsingNotification)
    //NotificationCenter.default.addObserver(forName: .softMacIdentified, object: nil, queue: nil, using: iconNeedsRefreshSoon)
    NotificationCenter.default.addObserver(forName: .configChanged, object: nil, queue: nil, using: iconNeedsRefreshSoon)
    NotificationCenter.default.addObserver(forName: .menuChanged, object: nil, queue: nil, using: menuNeedsRefresh)
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
      Log.debug("--------------")
      let icon = self.icon
      self.statusItem.button!.image = icon
      self.statusItem.button!.alternateImage = icon
    })
  }

  // This method is called from an asynchronous background task. That's the wrong run loop.
  // Let's hop into the correct runloop, the one managing the opened macOS status bar menu, and trigger a live refresh of the GUI.
  func menuNeedsRefresh(_ _: Notification) {
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
