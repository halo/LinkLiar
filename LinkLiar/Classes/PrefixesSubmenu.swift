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

class PrefixesSubmenu {

  // Prevent threads from interfering with one other.
  let queue: DispatchQueue = DispatchQueue(label: "io.github.halo.LinkLiar.prefixesSubmenuQueue")

  func update() {
    Log.debug("Updating...")
    reloadChosenVendorItems()
    reloadChosenPrefixesItems()
    reloadAvailableVendorItems()
    updateEnability()
  }

  private func updateEnability() {
    self.enableAll(ConfigWriter.isWritable)
  }

  private func enableAll(_ enableOrDisable: Bool) {
    prefixesSubMenuItem.items.forEach {
      $0.isEnabled = enableOrDisable
    }
  }

  lazy var menuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Prefixes", action: nil, keyEquivalent: "")
    item.target = Controller.self
    item.submenu = self.prefixesSubMenuItem
    item.toolTip = "When randomizing, which prefixes should be used?"
    item.keyEquivalentModifierMask = NSEvent.ModifierFlags.option
    item.isAlternate = true
    self.update()
    return item
  }()

  private lazy var prefixesSubMenuItem: NSMenu = {
    let submenu: NSMenu = NSMenu()
    submenu.autoenablesItems = false
    // <-- Here the active vendors will be injected -->
    submenu.addItem(NSMenuItem.separator())
    // <-- Here the active prefixes will be injected -->
    submenu.addItem(NSMenuItem.separator())
    submenu.addItem(self.addVendorItem)
    submenu.addItem(self.addPrefixItem)
    return submenu
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
    // <-- Here the available vendors will be injected -->
    return submenu
  }()

  private func reloadChosenVendorItems() {
    queue.sync {
      Log.debug("Loading chosen vendors into submenu...")

      // Remove all currently listed vendors
      for item in prefixesSubMenuItem.items {
        if (item.representedObject is Vendor) {
          prefixesSubMenuItem.removeItem(item)
        }
      }

      // Replenish active vendors
      // In reverse order because we insert them from the top and they move down.
      Config.instance.prefixes.vendors.reversed().forEach {
        let item = NSMenuItem(title: $0.title, action: #selector(Controller.removeVendor), keyEquivalent: "")
        item.representedObject = $0
        item.target = Controller.self
        item.toolTip = "Remove vendor \"\($0.name)\" with its \"\(String($0.prefixes.count))\" prefixes from the list of prefixes."
        prefixesSubMenuItem.insertItem(item, at: 0)
      }
    }
  }

  private func reloadChosenPrefixesItems() {
    queue.sync {
      Log.debug("Loading chosen prefixes into submenu...")

      // Remove all currently listed vendors
      for item in prefixesSubMenuItem.items {
        if (item.representedObject is MACPrefix) {
          prefixesSubMenuItem.removeItem(item)
        }
      }

      // Replenish active vendors
      Config.instance.prefixes.prefixes.reversed().forEach {
        let item = NSMenuItem(title: $0.formatted, action: #selector(Controller.removePrefix), keyEquivalent: "")
        item.representedObject = $0
        item.target = Controller.self
        item.toolTip = "Remove custom prefix \"\($0.formatted)\" from the list of prefixes."
        prefixesSubMenuItem.insertItem(item, at: prefixesSubMenuItem.items.count - 3)
      }
    }
  }

  private func reloadAvailableVendorItems() {
    queue.sync {
      Log.debug("Loading available vendors into submenu...")

      // Remove all currently listed vendors
      for item in vendorsSubMenuItem.items {
        if (item.representedObject is Vendor) {
          vendorsSubMenuItem.removeItem(item)
        }
      }

      // Replenish active vendors
      // In reverse order because we insert them from the top and they move down.
      Vendors.available.forEach {
        let item = NSMenuItem(title: $0.title, action: #selector(Controller.addVendor), keyEquivalent: "")
        item.representedObject = $0
        item.target = Controller.self
        item.toolTip = "Add vendor \"\($0.name)\" with its \"\(String($0.prefixes.count))\" prefixes to the list of prefixes."
        vendorsSubMenuItem.insertItem(item, at: 0)
      }
    }
  }

}
