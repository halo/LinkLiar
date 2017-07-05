import Cocoa

class DeveloperSubmenu {

  lazy var menuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Developer", action: nil, keyEquivalent: "")
    item.submenu = self.developerSubmenu
    item.keyEquivalentModifierMask = [.shift, .option]
    item.isAlternate = true
    return item
  }()

  func update() {
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

  private lazy var developerSubmenu: NSMenu = {
    let item: NSMenu = NSMenu()
    item.addItem(self.helperTitleItem)
    item.addItem(self.installHelperItem)
    item.addItem(self.implodeHelperItem)
    item.addItem(NSMenuItem.separator())
    item.addItem(self.createConfigDirectoryItem)
    item.addItem(self.removeConfigDirectoryItem)
    item.addItem(self.resetConfigItem)
    item.addItem(NSMenuItem.separator())
    item.addItem(self.configureDaemonItem)
    item.addItem(self.activateDaemonItem)
    item.addItem(self.deactivateDaemonItem)
    item.addItem(NSMenuItem.separator())
    item.addItem(self.installAllItem)
    return item
  }()

  private lazy var helperTitleItem: NSMenuItem = {
    return NSMenuItem(title: "Helper", action: nil, keyEquivalent: "")
  }()

  private lazy var installHelperItem: NSMenuItem = {
    let item = NSMenuItem(title: "Install Helper", action: #selector(Controller.installHelper(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var implodeHelperItem: NSMenuItem = {
    let item = NSMenuItem(title: "Remove Helper", action: #selector(Controller.implodeHelper(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var createConfigDirectoryItem: NSMenuItem = {
    let item = NSMenuItem(title: "Create Config Dir", action: #selector(Controller.createConfigDir(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var removeConfigDirectoryItem: NSMenuItem = {
    let item = NSMenuItem(title: "Remove Config Dir", action: #selector(Controller.removeConfigDir(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var resetConfigItem: NSMenuItem = {
    let item = NSMenuItem(title: "Reset Config File", action: #selector(Controller.resetConfig(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var configureDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Configure Daemon", action: #selector(Controller.configureDaemon(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var activateDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Activate Daemon", action: #selector(Controller.activateDaemon(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var deactivateDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Deactivate Daemon", action: #selector(Controller.deactivateDaemon(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var installAllItem: NSMenuItem = {
    let item = NSMenuItem(title: "Establish all", action: #selector(Controller.authorize(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

}
