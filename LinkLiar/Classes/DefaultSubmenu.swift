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

class DefaultSubmenu {

  func update() {
    updateStates()
    updateEnability()
  }

  private func updateStates() {
    ignoreItem.state = NSControl.StateValue(rawValue: Config.instance.unknownInterface.action == .ignore ? 1 : 0)
    randomizeItem.state = NSControl.StateValue(rawValue: Config.instance.unknownInterface.action == .random ? 1 : 0)
    specifyItem.state = NSControl.StateValue(rawValue: Config.instance.unknownInterface.action == .specify ? 1 : 0)
    originalizeItem.state = NSControl.StateValue(rawValue: Config.instance.unknownInterface.action == .original ? 1 : 0)
  }

  private func updateEnability() {
    Intercom.helperIsCompatible(reply: { yesOrNo in
      self.enableAll(yesOrNo)
      NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
    })
  }

  private func enableAll(_ enableOrDisable: Bool) {
    ignoreItem.isEnabled = enableOrDisable
    randomizeItem.isEnabled = enableOrDisable
    specifyItem.isEnabled = enableOrDisable
    originalizeItem.isEnabled = enableOrDisable
  }

  lazy var menuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Default", action: nil, keyEquivalent: "")
    item.target = Controller.self
    item.submenu = self.defaultSubMenuItem
    item.toolTip = "Interfaces marked as \"Default\" have this value."
    self.update()
    return item
  }()

  private lazy var defaultSubMenuItem: NSMenu = {
    let submenu: NSMenu = NSMenu()
    submenu.autoenablesItems = false
    submenu.addItem(self.ignoreItem)
    submenu.addItem(self.randomizeItem)
    submenu.addItem(self.specifyItem)
    submenu.addItem(self.originalizeItem)
    return submenu
  }()

  private lazy var ignoreItem: NSMenuItem = {
    let item = NSMenuItem(title: "Do nothing", action: #selector(Controller.ignoreDefaultInterface), keyEquivalent: "")
    item.target = Controller.self
    item.toolTip = "New Interfaces will not be modified in any way."
    return item
  }()

  private lazy var randomizeItem: NSMenuItem = {
    let item = NSMenuItem(title: "Random", action: #selector(Controller.randomizeDefaultInterface), keyEquivalent: "")
    item.target = Controller.self
    item.toolTip = "Randomize the MAC address of new Interfaces."
    return item
  }()

  private lazy var specifyItem: NSMenuItem = {
    let item = NSMenuItem(title: "Define manually", action: #selector(Controller.specifyDefaultInterface), keyEquivalent: "")
    item.target = Controller.self
    item.toolTip = "Assign a specific MAC address to new Interfaces."
    return item
  }()

  private lazy var originalizeItem: NSMenuItem = {
    let item = NSMenuItem(title: "Keep original", action: #selector(Controller.originalizeDefaultInterface), keyEquivalent: "")
    item.target = Controller.self
    item.toolTip = "Ensure new Interfaces are kept at their original hardware MAC address."
    return item
  }()

}
