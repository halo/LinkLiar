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

class SettingsSubmenu {

  lazy var menuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Settings", action: nil, keyEquivalent: "")
    item.submenu = self.settingsSubmenu
    return item
  }()

  func update() {
    self.allowRerandomizationItem.state = NSControl.StateValue(rawValue: Config.instance.settings.isForbiddenToRerandomize ? 0 : 1)
    self.independentDaemonItem.state = NSControl.StateValue(rawValue: Config.instance.settings.isRestrictedDaemon ? 0 : 1)
    self.anonymizeItem.state = NSControl.StateValue(rawValue: Config.instance.settings.anonymizationSeed.isValid ? 1 : 0)
    self.loginStartupItem.state = NSControl.StateValue(rawValue: LaunchAtLogin.isEnabled ? 1 : 0)

    if ConfigWriter.isWritable {
      self.allowRerandomizationItem.isEnabled = true
      self.independentDaemonItem.isEnabled = true
      self.anonymizeItem.isEnabled = true
    } else {
      self.allowRerandomizationItem.isEnabled = false
      self.independentDaemonItem.isEnabled = false
      self.anonymizeItem.isEnabled = false
    }
  }

  private lazy var settingsSubmenu: NSMenu = {
    let menu: NSMenu = NSMenu()
    menu.autoenablesItems = false
    menu.addItem(self.allowRerandomizationItem)
    menu.addItem(self.independentDaemonItem)
    menu.addItem(self.anonymizeItem)
    menu.addItem(self.loginStartupItem)
    //menu.addItem(self.showLogsItem)
    return menu
  }()

  private lazy var allowRerandomizationItem: NSMenuItem = {
    let item = NSMenuItem(title: "Allow Rerandomization", action: #selector(Controller.toggleRerandomization), keyEquivalent: "")
    item.target = Controller.self
    item.toolTip = "When sleeping or logging out, re-randomize MAC addresses of interfaces that are set to be random (recommended)."
    return item
  }()

  private lazy var independentDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Keep Running in Background", action: #selector(Controller.toggleDaemonRestriction), keyEquivalent: "")
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

  private lazy var loginStartupItem: NSMenuItem = {
    let item = NSMenuItem(title: "Start Menu Bar at Login", action: #selector(Controller.toggleLoginItem), keyEquivalent: "")
    item.target = Controller.self
    item.toolTip = "Useful if you didn't choose \"Keep running in background\""
    return item
  }()

  private lazy var showLogsItem: NSMenuItem = {
    let item = NSMenuItem(title: "Show Logs", action: #selector(Controller.showLogs), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

}
