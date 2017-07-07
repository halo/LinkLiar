import Cocoa

class DeveloperSubmenu {

  lazy var menuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Advanced", action: nil, keyEquivalent: "")
    item.submenu = self.developerSubmenu
    item.keyEquivalentModifierMask = .option
    item.isAlternate = true
    return item
  }()

  func update() {
    updateHelper()
    updateConfig()
    updateDaemon()
  }

  private func updateHelper() {
    Intercom.helperVersion(reply: { versionOrNil in
      guard let version = versionOrNil else {
        self.helperTitleItem.title = "Helper not installed"
        NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
        return
      }

      if (version.isCompatible(with: AppDelegate.version)) {
        self.helperTitleItem.title = "Helper \(version.formatted) installed"
      } else {
        self.helperTitleItem.title = "Helper \(version.formatted) incompatible"
      }
      NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
    })
  }

  private func updateConfig() {
    var isDirectory: ObjCBool = false
    if FileManager.default.fileExists(atPath: Paths.configDirectory, isDirectory: &isDirectory) {
        if isDirectory.boolValue {
           self.configDirectoryTitleItem.title = "ConfigDir exists"
        } else {
          self.configDirectoryTitleItem.title = "ConfigDir is file"
        }
      } else {
      self.configDirectoryTitleItem.title = "ConfigDir missing"
    }
  }

  private func updateDaemon() {
    LaunchCtl.isDaemonRunning(reply: { isRunning in
      if isRunning {
        self.daemonTitleItem.title = "Daemon running"
      } else {
        self.daemonTitleItem.title = "Daemon not running"
      }
    })
  }

  private lazy var developerSubmenu: NSMenu = {
    let item: NSMenu = NSMenu()
    item.addItem(self.installAllItem)
    item.addItem(NSMenuItem.separator())
    item.addItem(self.helperTitleItem)
    item.addItem(self.installHelperItem)
    item.addItem(self.uninstallHelperItem)
    item.addItem(NSMenuItem.separator())
    item.addItem(self.configDirectoryTitleItem)
    item.addItem(self.createConfigDirectoryItem)
    item.addItem(self.resetConfigItem)
    item.addItem(self.removeConfigDirectoryItem)
    item.addItem(self.revealConfigDirectoryItem)
    item.addItem(NSMenuItem.separator())
    item.addItem(self.daemonTitleItem)
    item.addItem(self.installDaemonItem)
    item.addItem(self.activateDaemonItem)
    item.addItem(self.deactivateDaemonItem)
    item.addItem(self.uninstallDaemonItem)
    return item
  }()

  private lazy var installAllItem: NSMenuItem = {
    let item = NSMenuItem(title: "Install all", action: #selector(Controller.authorize), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var helperTitleItem: NSMenuItem = {
    return NSMenuItem(title: "Helper...", action: nil, keyEquivalent: "")
  }()

  private lazy var installHelperItem: NSMenuItem = {
    let item = NSMenuItem(title: "Install Helper", action: #selector(Controller.installHelper(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var uninstallHelperItem: NSMenuItem = {
    let item = NSMenuItem(title: "Remove Helper", action: #selector(Controller.uninstallHelper(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var configDirectoryTitleItem: NSMenuItem = {
    return NSMenuItem(title: "Config dir...", action: nil, keyEquivalent: "")
  }()

  private lazy var createConfigDirectoryItem: NSMenuItem = {
    let item = NSMenuItem(title: "Create Config Dir", action: #selector(Controller.createConfigDir(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var resetConfigItem: NSMenuItem = {
    let item = NSMenuItem(title: "Reset Config File", action: #selector(Controller.resetConfig(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var removeConfigDirectoryItem: NSMenuItem = {
    let item = NSMenuItem(title: "Remove Config Dir", action: #selector(Controller.removeConfigDir(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var revealConfigDirectoryItem: NSMenuItem = {
    let item = NSMenuItem(title: "Reveal Config Dir", action: #selector(Controller.revealConfigDir), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var daemonTitleItem: NSMenuItem = {
    return NSMenuItem(title: "Daemon...", action: nil, keyEquivalent: "")
  }()

  private lazy var installDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Install Daemon", action: #selector(Controller.installDaemon(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var activateDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Activate Daemon", action: #selector(Controller.activateDaemon(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var deactivateDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Deactivate Daemon", action: #selector(Controller.deactivateDaemon), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var uninstallDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Uninstall Daemon", action: #selector(Controller.uninstallDaemon), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

}
