import Cocoa

class SettingsSubmenu {

  lazy var menuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Settings", action: nil, keyEquivalent: "")
    item.submenu = self.settingsSubmenu
    return item
  }()

  private lazy var settingsSubmenu: NSMenu = {
    let item: NSMenu = NSMenu()
    item.addItem(self.launchAtLoginItem)
    item.addItem(self.independentDaemonItem)
    item.addItem(self.allowRerandomizationItem)
    item.addItem(self.showLogsItem)
    return item
  }()

  private lazy var launchAtLoginItem: NSMenuItem = {
    let item = NSMenuItem(title: "Launch on Login", action: #selector(Controller.helperIsCompatible(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var independentDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Run in Background", action: #selector(Controller.helperIsCompatible(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var allowRerandomizationItem: NSMenuItem = {
    let item = NSMenuItem(title: "Allow Rerandomization", action: #selector(Controller.helperIsCompatible(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var showLogsItem: NSMenuItem = {
    let item = NSMenuItem(title: "Show Logs", action: #selector(Controller.showLogs(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()


}
