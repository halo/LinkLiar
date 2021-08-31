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

class DeveloperSubmenu {

  lazy var menuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Advanced", action: nil, keyEquivalent: "")
    item.submenu = self.developerSubmenu
    item.keyEquivalentModifierMask = NSEvent.ModifierFlags.option
    item.isAlternate = true
    return item
  }()

  func update() {
    updateHelper()
    updateConfigDir()
    updateConfigFile()
    updateDaemon()
  }

  private func updateHelper() {
    Intercom.helperVersion(reply: { versionOrNil in
      guard let version = versionOrNil else {
        self.helperTitleItem.title = "Helper not installed"
        NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
        return
      }

      if (version.isCompatible(with: AppDelegate.version)) {
        self.helperTitleItem.title = "Helper \(version.formatted) compatible"
      } else {
        self.helperTitleItem.title = "Helper \(version.formatted) incompatible"
      }
      NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
    })
  }

  private func updateConfigDir() {
    var isDirectory: ObjCBool = false
    if FileManager.default.fileExists(atPath: Paths.configDirectory, isDirectory: &isDirectory) {
        if isDirectory.boolValue {
           self.configDirectoryTitleItem.title = "Config dir exists"
        } else {
          self.configDirectoryTitleItem.title = "Config dir is file"
        }
      } else {
      self.configDirectoryTitleItem.title = "Config dir missing"
    }
  }

  private func updateConfigFile() {
    if FileManager.default.isWritableFile(atPath: Paths.configDirectory) {
      self.configFileTitleItem.title = "Config file writable"
    } else {
      self.configFileTitleItem.title = "Config file unwritable"
    }
  }

  private func updateDaemon() {
    LaunchCtl.isDaemonRunning(reply: { isRunning in
      if isRunning {
        self.daemonTitleItem.title = "Daemon running"
      } else {
        self.daemonTitleItem.title = "Daemon not running"
      }
    })
  }

  private lazy var developerSubmenu: NSMenu = {
    let item: NSMenu = NSMenu()
    item.addItem(self.versionTitleItem)
    item.addItem(self.installAllItem)
    item.addItem(self.uninstallAllItem)
    item.addItem(NSMenuItem.separator())
    item.addItem(self.helperTitleItem)
    item.addItem(self.installHelperItem)
    item.addItem(self.uninstallHelperItem)
    item.addItem(NSMenuItem.separator())
    item.addItem(self.configDirectoryTitleItem)
    item.addItem(self.createConfigDirectoryItem)
    item.addItem(self.removeConfigDirectoryItem)
    item.addItem(self.revealConfigDirectoryItem)
    item.addItem(NSMenuItem.separator())
    item.addItem(self.configFileTitleItem)
    item.addItem(self.resetConfigItem)
    item.addItem(NSMenuItem.separator())
    item.addItem(self.daemonTitleItem)
    item.addItem(self.installDaemonItem)
    item.addItem(self.activateDaemonItem)
    item.addItem(self.deactivateDaemonItem)
    item.addItem(self.uninstallDaemonItem)
    item.addItem(NSMenuItem.separator())
    item.addItem(self.pathsSubmenuItem)
    return item
  }()

  private lazy var versionTitleItem: NSMenuItem = {
    return NSMenuItem(title: "LinkLiar \(AppDelegate.version.formatted)", action: nil, keyEquivalent: "")
  }()

  private lazy var installAllItem: NSMenuItem = {
    let item = NSMenuItem(title: "Install everything", action: #selector(Controller.authorize), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var uninstallAllItem: NSMenuItem = {
    let item = NSMenuItem(title: "Uninstall everything", action: #selector(Controller.uninstall), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var helperTitleItem: NSMenuItem = {
    return NSMenuItem(title: "Helper...", action: nil, keyEquivalent: "")
  }()

  private lazy var installHelperItem: NSMenuItem = {
    let item = NSMenuItem(title: "Install Helper", action: #selector(Controller.installHelper(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var uninstallHelperItem: NSMenuItem = {
    let item = NSMenuItem(title: "Remove Helper", action: #selector(Controller.uninstallHelper(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var configDirectoryTitleItem: NSMenuItem = {
    return NSMenuItem(title: "Config dir...", action: nil, keyEquivalent: "")
  }()

  private lazy var configFileTitleItem: NSMenuItem = {
    return NSMenuItem(title: "Config file...", action: nil, keyEquivalent: "")
  }()

  private lazy var createConfigDirectoryItem: NSMenuItem = {
    let item = NSMenuItem(title: "Create Config Dir", action: #selector(Controller.createConfigDir(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var resetConfigItem: NSMenuItem = {
    let item = NSMenuItem(title: "Reset Config File", action: #selector(Controller.resetConfig(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var removeConfigDirectoryItem: NSMenuItem = {
    let item = NSMenuItem(title: "Remove Config Dir", action: #selector(Controller.removeConfigDir(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var revealConfigDirectoryItem: NSMenuItem = {
    let item = NSMenuItem(title: "Reveal Config Dir", action: #selector(Controller.revealConfigDir), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var daemonTitleItem: NSMenuItem = {
    return NSMenuItem(title: "Daemon...", action: nil, keyEquivalent: "")
  }()

  private lazy var installDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Install Daemon", action: #selector(Controller.installDaemon(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var activateDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Activate Daemon", action: #selector(Controller.activateDaemon(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var deactivateDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Deactivate Daemon", action: #selector(Controller.deactivateDaemon), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var uninstallDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Uninstall Daemon", action: #selector(Controller.uninstallDaemon), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var pathsSubmenuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Paths", action: nil, keyEquivalent: "")
    item.submenu = self.pathsSubmenu
    return item
  }()


  private lazy var pathsSubmenu: NSMenu = {
    let item: NSMenu = NSMenu()

    item.addItem(NSMenuItem(title: "Config File", action: nil, keyEquivalent: ""))
    item.addItem(NSMenuItem(title: Paths.configFile, action: nil, keyEquivalent: ""))
    item.addItem(NSMenuItem.separator())

    item.addItem(NSMenuItem(title: "Debug Log File", action: nil, keyEquivalent: ""))
    item.addItem(NSMenuItem(title: Paths.debugLogFile, action: nil, keyEquivalent: ""))
    item.addItem(NSMenuItem.separator())

    item.addItem(NSMenuItem(title: "Daemon Plist File", action: nil, keyEquivalent: ""))
    item.addItem(NSMenuItem(title: Paths.daemonPlistFile, action: nil, keyEquivalent: ""))
    item.addItem(NSMenuItem.separator())

    item.addItem(NSMenuItem(title: "Helper Plist File", action: nil, keyEquivalent: ""))
    item.addItem(NSMenuItem(title: Paths.helperPlistFile, action: nil, keyEquivalent: ""))
    item.addItem(NSMenuItem.separator())

    item.addItem(NSMenuItem(title: "Helper Executable", action: nil, keyEquivalent: ""))
    item.addItem(NSMenuItem(title: Paths.helperExecutable, action: nil, keyEquivalent: ""))
    item.addItem(NSMenuItem.separator())

    item.addItem(NSMenuItem(title: "Daemon Pristine Executable File", action: nil, keyEquivalent: ""))
    item.addItem(NSMenuItem(title: Paths.daemonPristineExecutablePath, action: nil, keyEquivalent: ""))
    item.addItem(NSMenuItem.separator())

    item.addItem(NSMenuItem(title: "Daemon Executable", action: nil, keyEquivalent: ""))
    item.addItem(NSMenuItem(title: Paths.daemonExecutable, action: nil, keyEquivalent: ""))
    item.addItem(NSMenuItem.separator())

    return item
  }()
}
