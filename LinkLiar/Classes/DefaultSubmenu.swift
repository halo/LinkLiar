import Cocoa

class DefaultSubmenu {

  func update() {
    ignoreItem.state = Config.instance.actionForDefaultInterface() == Interface.Action.ignore ? 1 : 0
    randomizeItem.state = Config.instance.actionForDefaultInterface() == Interface.Action.random ? 1 : 0
  }
  
  lazy var menuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Default", action: nil, keyEquivalent: "")
    item.target = Controller.self
    item.submenu = self.defaultSubMenuItem
    return item
  }()

  private lazy var defaultSubMenuItem: NSMenu = {
    let submenu: NSMenu = NSMenu()
    submenu.addItem(self.ignoreItem)
    submenu.addItem(self.randomizeItem)
    return submenu
  }()

  private lazy var ignoreItem: NSMenuItem = {
    let item = NSMenuItem(title: "Do nothing", action: #selector(Controller.ignoreDefaultInterface(_:)), keyEquivalent: "")
    item.target = Controller.self
    //item.state = Config.instance.actionForDefaultInterface() == Interface.Action.ignore ? 1 : 0
    return item
  }()

  private lazy var randomizeItem: NSMenuItem = {
    let item = NSMenuItem(title: "Random", action: #selector(Controller.randomizeDefaultInterface(_:)), keyEquivalent: "")
    item.target = Controller.self
    //item.state = Config.instance.actionForDefaultInterface() == Interface.Action.random ? 1 : 0
    return item
  }()

}
