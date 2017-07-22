/*
 * Copyright (C) 2017 halo https://io.github.com/halo/LinkLiar
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

class SettingsSubmenu {

  lazy var menuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Settings", action: nil, keyEquivalent: "")
    item.submenu = self.settingsSubmenu
    return item
  }()

  func update() {
    self.allowRerandomizationItem.state = Config.instance.isForbiddenToRerandomize ? 0 : 1
    self.independentDaemonItem.state = Config.instance.isRestrictedDaemon ? 0 : 1
    self.anonymizeItem.state = Config.instance.isAnonymized ? 1 : 0
  }

  private lazy var settingsSubmenu: NSMenu = {
    let item: NSMenu = NSMenu()
    item.addItem(self.allowRerandomizationItem)
    item.addItem(self.independentDaemonItem)
    item.addItem(self.anonymizeItem)
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

  private lazy var anonymizeItem: NSMenuItem = {
    let item = NSMenuItem(title: "Anonymize Logs", action: #selector(Controller.toggleAnonymization), keyEquivalent: "")
    item.target = Controller.self
    item.toolTip = "Convenient if you wish to share your logs or screenshots (but do not share your config.yml, because it contains the key to de-anonymize anonymized logs)."
    return item
  }()

  private lazy var showLogsItem: NSMenuItem = {
    let item = NSMenuItem(title: "Show Logs", action: #selector(Controller.showLogs), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

}
