import Cocoa

class InterfaceSubmenu {

  private let interface: Interface

  init(_ interface: Interface) {
    self.interface = interface
  }

  lazy var titleMenuItem: NSMenuItem = {
    let item = NSMenuItem(title: self.interface.title, action: nil, keyEquivalent: "")
    item.representedObject = self.interface
    return item
  }()

  lazy var menuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Loading...", action: nil, keyEquivalent: "")
    item.representedObject = self.interface
    item.target = Controller.self
    item.tag = 42

    if self.interface.softMAC.isValid {
      item.title = self.interface.softMAC.humanReadable
      SoftMACCache.remember(BSDName: self.interface.BSDName, address: self.interface.softMAC.formatted)
    } else {
      if let address = SoftMACCache.address(BSDName: self.interface.BSDName) {
        item.title = address
      } else {
        item.title = self.interface.hardMAC.formatted
      }
    }
    item.state = self.interface.hasOriginalMAC ? 1 : 0
    item.onStateImage = #imageLiteral(resourceName: "InterfaceLeaking")
    item.submenu = self.subMenuItem()
    return item
  }()

  private func subMenuItem() -> NSMenu {
    let submenu: NSMenu = NSMenu()

    let vendorName = MACVendors.name(address: interface.softMAC)

    let vendorNameItem = NSMenuItem(title: vendorName, action: nil, keyEquivalent: "")
    submenu.addItem(vendorNameItem)
    submenu.addItem(NSMenuItem.separator())

    if (interface.isPoweredOffWifi) {
      let poweredOffItem = NSMenuItem(title: "Powered off", action: nil, keyEquivalent: "")
      submenu.addItem(poweredOffItem)
    } else {

      let action = Config.instance.actionForInterface(interface.hardMAC)

      let ignoreItem: NSMenuItem = NSMenuItem(title: "Do nothing", action: #selector(Controller.ignoreInterface), keyEquivalent: "")
      ignoreItem.representedObject = interface
      ignoreItem.target = Controller.self
      ignoreItem.state = action == Interface.Action.ignore ? 1 : 0
      submenu.addItem(ignoreItem)

      let randomizeItem: NSMenuItem = NSMenuItem(title: "Random", action: #selector(Controller.randomizeInterface), keyEquivalent: "")
      randomizeItem.representedObject = interface
      randomizeItem.target = Controller.self
      randomizeItem.state = action == Interface.Action.random ? 1 : 0
      submenu.addItem(randomizeItem)

      let specifyItem: NSMenuItem = NSMenuItem(title: "Define manually", action: #selector(Controller.specifyInterface), keyEquivalent: "")
      specifyItem.representedObject = interface
      specifyItem.target = Controller.self
      specifyItem.state = action == Interface.Action.specify ? 1 : 0
      submenu.addItem(specifyItem)

      let originalizeItem: NSMenuItem = NSMenuItem(title: "Keep original", action: #selector(Controller.originalizeInterface), keyEquivalent: "")
      originalizeItem.representedObject = interface
      originalizeItem.target = Controller.self
      originalizeItem.state = action == Interface.Action.original ? 1 : 0
      submenu.addItem(originalizeItem)

      let forgetItem: NSMenuItem = NSMenuItem(title: "Forget", action: #selector(Controller.forgetInterface), keyEquivalent: "")
      forgetItem.representedObject = interface
      forgetItem.target = Controller.self
      forgetItem.state = action == Interface.Action.original ? 1 : 0
      submenu.addItem(forgetItem)

      submenu.addItem(NSMenuItem.separator())

      let hardMACItem: NSMenuItem = NSMenuItem(title: interface.hardMAC.formatted, action: nil, keyEquivalent: "")
      submenu.addItem(hardMACItem)
}
    return submenu
  }

}
