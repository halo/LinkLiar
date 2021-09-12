/*
 * Copyright (C) 2012-2021 halo https://io.github.com/halo/LinkLiar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Cocoa

class InterfaceSubmenu {

  private let interface: Interface

  init(_ interface: Interface) {
    self.interface = interface
  }

  lazy var titleMenuItem: NSMenuItem = {
    let item = NSMenuItem(title: self.interface.title, action: nil, keyEquivalent: "")
    item.toolTip = "The MAC address of this Interface can be changed."
    item.representedObject = self.interface
    return item
  }()

  lazy var menuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Loading...", action: nil, keyEquivalent: "")
    item.representedObject = self.interface
    item.target = Controller.self
    item.toolTip = "The currently assigned MAC address of this Interface."
    item.tag = 42 // So we can identify this menu item among other Inteface-based items.

    if self.interface.softMAC.isValid {
      item.title = self.interface.softMAC.humanReadable
      SoftMACCache.remember(BSDName: self.interface.BSDName, address: self.interface.softMAC.humanReadable)
    } else {
      if let address = SoftMACCache.address(BSDName: self.interface.BSDName) {
        item.title = address
      } else {
        item.title = self.interface.hardMAC.humanReadable
      }
    }
    item.state = NSControl.StateValue(rawValue: self.interface.hasOriginalMAC ? 1 : 0)
    item.onStateImage = #imageLiteral(resourceName: "InterfaceLeaking")
    item.submenu = self.subMenuItem()
    return item
  }()

  private func subMenuItem() -> NSMenu {
    let configurable = ConfigWriter.isWritable
    let submenu: NSMenu = NSMenu()
    submenu.autoenablesItems = false

    let vendorName = MACVendors.name(address: interface.softMAC)

    let vendorNameItem = NSMenuItem(title: vendorName, action: nil, keyEquivalent: "")
    vendorNameItem.isEnabled = false
    vendorNameItem.toolTip = "The vendor of this Interface's currently assigned MAC address."
    submenu.addItem(vendorNameItem)
    submenu.addItem(NSMenuItem.separator())

    if (interface.isPoweredOffWifi) {
      let poweredOffItem = NSMenuItem(title: "Powered off", action: nil, keyEquivalent: "")
      submenu.addItem(poweredOffItem)
    } else {

      let action = Config.instance.knownInterface.action(interface.hardMAC)

      let ignoreItem: NSMenuItem = NSMenuItem(title: "Do nothing", action: #selector(Controller.ignoreInterface), keyEquivalent: "")
      ignoreItem.representedObject = interface
      ignoreItem.target = Controller.self
      ignoreItem.state = NSControl.StateValue(rawValue: action == .ignore ? 1 : 0)
      ignoreItem.isEnabled = configurable
      ignoreItem.toolTip = "This Interface will not be modified in any way."
      submenu.addItem(ignoreItem)

      let randomizeItem: NSMenuItem = NSMenuItem(title: "Random", action: #selector(Controller.randomizeInterface), keyEquivalent: "")
      randomizeItem.representedObject = interface
      randomizeItem.target = Controller.self
      randomizeItem.state = NSControl.StateValue(rawValue: action == .random ? 1 : 0)
      randomizeItem.isEnabled = configurable
      randomizeItem.toolTip = "Keep the MAC address of this Interface random."
      submenu.addItem(randomizeItem)

      let specifyItem: NSMenuItem = NSMenuItem(title: "Define manually", action: #selector(Controller.specifyInterface), keyEquivalent: "")
      specifyItem.representedObject = interface
      specifyItem.target = Controller.self
      specifyItem.state = NSControl.StateValue(rawValue: action == .specify ? 1 : 0)
      specifyItem.isEnabled = configurable
      specifyItem.toolTip = "Assign a specific MAC address to this Interfaces."
      submenu.addItem(specifyItem)

      let originalizeItem: NSMenuItem = NSMenuItem(title: "Keep original", action: #selector(Controller.originalizeInterface), keyEquivalent: "")
      originalizeItem.representedObject = interface
      originalizeItem.target = Controller.self
      originalizeItem.state = NSControl.StateValue(rawValue: action == .original ? 1 : 0)
      originalizeItem.isEnabled = configurable
      originalizeItem.toolTip = "Ensure this Interface is kept at its original hardware MAC address."
      submenu.addItem(originalizeItem)

      let forgetItem: NSMenuItem = NSMenuItem(title: "Default", action: #selector(Controller.forgetInterface), keyEquivalent: "")
      forgetItem.representedObject = interface
      forgetItem.target = Controller.self
      forgetItem.state = NSControl.StateValue(rawValue: action == nil ? 1 : 0)
      forgetItem.isEnabled = configurable
      forgetItem.toolTip = "Handle this Interfaces according to whatever is specified under \"Default\"."
      submenu.addItem(forgetItem)

      submenu.addItem(NSMenuItem.separator())

      let hardMACItem: NSMenuItem = NSMenuItem(title: interface.hardMAC.humanReadable, action: nil, keyEquivalent: "")
      hardMACItem.isEnabled = false
      hardMACItem.toolTip = "The original hardware MAC address of this interface."
      submenu.addItem(hardMACItem)
    }
    return submenu
  }

}
