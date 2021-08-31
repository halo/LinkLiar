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

class Menu {

  let menu = NSMenu()

  // Prevent threads from interfering with one other.
  let queue: DispatchQueue = DispatchQueue(label: "io.github.halo.LinkLiar.menuQueue")

  private var interfaces: [Interface] = []
  private lazy var defaultSubmenu = DefaultSubmenu()
  private lazy var prefixesSubmenu = PrefixesSubmenu()
  private lazy var settingsSubmenu = SettingsSubmenu()
  private lazy var developerSubmenu = DeveloperSubmenu()

  private lazy var helpItem: NSMenuItem = {
    return NSMenuItem(title: "Help", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")
  }()

  private lazy var quitItem: NSMenuItem = {
    let item = NSMenuItem(title: "Quit", action: #selector(Controller.quit), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  var hasAnyOriginalMAC: Bool {
    return self.interfaces.contains(where: { interface in interface.hasOriginalMAC })
  }

  // MARK: Initialization

  init() {
    NotificationCenter.default.addObserver(forName: .softMacIdentified, object: nil, queue: nil, using: softMacIdentified)
    NotificationCenter.default.addObserver(forName: .configChanged, object: nil, queue: nil, using: configChanged)

    menu.addItem(authorizeItem)
    menu.addItem(authorizeSeparatorItem)
    // <-- Here the Interfaces will be injected -->
    menu.addItem(NSMenuItem.separator())
    menu.addItem(defaultSubmenu.menuItem)
    menu.addItem(prefixesSubmenu.menuItem)
    menu.addItem(settingsSubmenu.menuItem)
    menu.addItem(NSMenuItem.placeholder())
    menu.addItem(developerSubmenu.menuItem)
    menu.addItem(NSMenuItem.separator())
    menu.addItem(helpItem)
    menu.addItem(quitItem)
  }

  func update() {
    Log.debug("Updating...")
    reloadInterfaceItems()
    defaultSubmenu.update()
    prefixesSubmenu.update()
    settingsSubmenu.update()
    developerSubmenu.update()
    checkHelper()
    updateQuitButton()
  }

  private func updateQuitButton() {
    if Config.instance.settings.isRestrictedDaemon {
      quitItem.toolTip = "Quits this Menu and the LinkLiar Background Daemon"
    } else {
      quitItem.toolTip = "Quits this Menu"
    }
  }

  private lazy var authorizeItem: NSMenuItem = {
    let item = NSMenuItem(title: "Authorize...", action: #selector(Controller.authorize), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var authorizeSeparatorItem: NSMenuItem = {
    return NSMenuItem.separator()
  }()

  private func reloadInterfaceItems() {
    queue.sync {
      Log.debug("Reloading Interface menu items")

      // Remove all Interface items
      for item in menu.items {
        if (item.representedObject is Interface) {
          menu.removeItem(item)
        }
      }

      // Replenish Interfaces
      // In reverse order because we insert them from the top and they move down.
      interfaces = Interfaces.all(async: true).reversed()

      // Replenish corresponding items
      for interface in interfaces {
        let interfaceSubmenu = InterfaceSubmenu(interface)
        menu.insertItem(NSMenuItem.separator(), at: 2)
        menu.insertItem(interfaceSubmenu.menuItem, at: 2)
        menu.insertItem(interfaceSubmenu.titleMenuItem, at: 2)
      }
    }
  }

  func softMacIdentified(_ notification: Notification) {
    let interface: Interface = notification.object as! Interface

    queue.sync {
      for item in menu.items {
        guard item.tag == 42 else { continue }
        guard item.representedObject is Interface else { continue }
        guard (item.representedObject as! Interface).hardMAC == interface.hardMAC else { continue }
        let index = menu.index(of: item)
        let interfaceSubmenu = InterfaceSubmenu(interface)
        menu.insertItem(interfaceSubmenu.menuItem, at: index)
        menu.removeItem(item)
      }
    }
    NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
  }
  
  func configChanged(_ notification: Notification) {
    defaultSubmenu.update()
    NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
  }

  func checkHelper() {
    Intercom.helperVersion(reply: { versionOrNil in
      guard let version = versionOrNil else {
        self.authorizeItem.title = "Authorize LinkLiar..."
        self.authorizeItem.isHidden = false
        self.authorizeSeparatorItem.isHidden = false
        NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
        return
      }

      if (version.isCompatible(with: AppDelegate.version)) {
        self.authorizeItem.isHidden = true
        self.authorizeSeparatorItem.isHidden = true
      } else {
        self.authorizeItem.title = "Re-authorize LinkLiar..."
        self.authorizeItem.isHidden = false
        self.authorizeSeparatorItem.isHidden = false
      }
      NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
    })
  }

}
