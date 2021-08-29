/*
 * Copyright (C) 2012-2018 halo https://io.github.com/halo/LinkLiar
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

class PrefixesSubmenu {

  func update() {
    Log.debug("Updating...")
  }

  lazy var menuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Prefixes", action: nil, keyEquivalent: "")
    item.target = Controller.self
    item.submenu = self.prefixesSubMenuItem
    item.toolTip = "When randomizing, which prefixes should be used?"
    self.update()
    return item
  }()


  private lazy var prefixesSubMenuItem: NSMenu = {
    let submenu: NSMenu = NSMenu()
    submenu.autoenablesItems = false
    chosenVendorItems.forEach { submenu.addItem($0) }
    submenu.addItem(NSMenuItem.separator())
    prefixItems.forEach { submenu.addItem($0) }
    submenu.addItem(self.addVendorItem)
    submenu.addItem(self.addPrefixItem)
    return submenu
  }()

  private lazy var chosenVendorItems: [NSMenuItem] = {
    Log.debug("Loading vendors into submenu...")
    return Config.instance.prefixes.vendors.map {
      let item = NSMenuItem(title: $0.title, action: #selector(Controller.removeVendor), keyEquivalent: "")
      item.representedObject = $0
      item.target = Controller.self
      item.toolTip = "Remove vendor \"\($0.name)\" with its \"\(String($0.prefixes.count))\" prefixes from the list of prefixes."
      return item
    }
  }()

  private lazy var prefixItems: [NSMenuItem] = {
    Log.debug("Loading prefixes into submenu...")
    return Config.instance.prefixes.prefixes.map {
      let item = NSMenuItem(title: $0.formatted, action: #selector(Controller.removePrefix), keyEquivalent: "")
      item.representedObject = $0
      item.target = Controller.self
      item.toolTip = "Remove custom prefix \"\($0.formatted)\" from the list of prefixes."
      return item
    }
  }()

  private lazy var addPrefixItem: NSMenuItem = {
    let item = NSMenuItem(title: "Add prefix...", action: #selector(Controller.addPrefix), keyEquivalent: "")
    item.target = Controller.self
    item.toolTip = "Add all prefixes of a vendor."
    return item
  }()

  private lazy var addVendorItem: NSMenuItem = {
    let item = NSMenuItem(title: "Add Vendor", action: #selector(Controller.addVendor), keyEquivalent: "")
    item.target = Controller.self
    item.submenu = self.vendorsSubMenuItem
    item.toolTip = "When randomizing, which prefixes should be used?"
    return item
  }()

  private lazy var vendorsSubMenuItem: NSMenu = {
    let submenu: NSMenu = NSMenu()
    submenu.autoenablesItems = false
    missindVendorItems.forEach { submenu.addItem($0) }
    return submenu
  }()

  private lazy var missindVendorItems: [NSMenuItem] = {
    Log.debug("Loading vendors into submenu...")
    return Vendors.all.map {
      let item = NSMenuItem(title: $0.title, action: #selector(Controller.removeVendor), keyEquivalent: "")
      item.representedObject = $0
      item.target = Controller.self
      item.toolTip = "Remove vendor \"\($0.name)\" with its \"\(String($0.prefixes.count))\" prefixes from the list of prefixes."
      return item
    }
  }()
}
