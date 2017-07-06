import Cocoa

class SettingsSubmenu {

  lazy var menuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Settings", action: nil, keyEquivalent: "")
    item.submenu = self.settingsSubmenu
    return item
  }()

  func update() {
    self.allowRerandomizationItem.state = Config.instance.isForbiddenToRerandomize ? 0 : 1
    self.independentDaemonItem.state = Config.instance.isRestrictedDaemon ? 0 : 1
  }

  private lazy var settingsSubmenu: NSMenu = {
    let item: NSMenu = NSMenu()
    item.addItem(self.allowRerandomizationItem)
    item.addItem(self.independentDaemonItem)
    //item.addItem(self.showLogsItem)
    return item
  }()

  private lazy var allowRerandomizationItem: NSMenuItem = {
    let item = NSMenuItem(title: "Allow Rerandomization", action: #selector(Controller.toggleRerandomization), keyEquivalent: "")
    item.target = Controller.self
    item.toolTip = "When sleeping or logging out, re-randomize MAC addresses of interfaces that are set to be random (recommended)."
    return item
  }()

  private lazy var independentDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Run in Background", action: #selector(Controller.toggleDaemonRestriction), keyEquivalent: "")
    item.target = Controller.self
    item.toolTip = "Manage Interfaces even when this GUI is not running (recommended)."
    return item
  }()

  private lazy var showLogsItem: NSMenuItem = {
    let item = NSMenuItem(title: "Show Logs", action: #selector(Controller.showLogs), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

}
