import Cocoa

class DeveloperSubmenu {

  /// The Developer Menu is revealed as alternative to this invisible dummy while holding the option key.
  lazy var placeholderItem: NSMenuItem = {
    let item = NSMenuItem(title: "", action: nil, keyEquivalent: "")
    item.view = NSView(frame: NSMakeRect(0, 0, 0, 0))
    return item
  }()

  lazy var menuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Developer", action: nil, keyEquivalent: "")
    item.submenu = self.developerSubmenu
    item.keyEquivalentModifierMask = [.shift, .option]
    item.isAlternate = true
    return item
  }()

  private lazy var developerSubmenu: NSMenu = {
    let item: NSMenu = NSMenu()
    item.addItem(self.installHelperItem)
    item.addItem(self.implodeHelperItem)
    item.addItem(self.helperVersionItem)
    item.addItem(NSMenuItem.separator())
    item.addItem(self.createConfigDirectoryItem)
    item.addItem(self.resetConfigItem)
    item.addItem(NSMenuItem.separator())
    item.addItem(self.configureDaemonItem)
    item.addItem(self.activateDaemonItem)
    item.addItem(self.deactivateDaemonItem)
    return item
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

  private lazy var helperVersionItem: NSMenuItem = {
    let item = NSMenuItem(title: "Helper Version", action: #selector(Controller.helperIsCompatible(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
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

}
