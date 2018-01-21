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

import Foundation
import Cocoa

class Controller: NSObject {

  @objc static func authorize(_ sender: NSMenuItem) {
    Log.debug("Installing Helper and Daemon...")
    installHelper(sender)
    Intercom.install(reply: { success in
      if (success) {
        Log.debug("Installation complete")
      } else {
        Log.debug("Could not complete installation")
      }
    })
  }

  @objc static func uninstall(_ sender: NSMenuItem) {
    Log.debug("Uninstalling Helper, Daemon and config directory...")
    Intercom.uninstall(reply: { success in
      if (success) {
        Log.debug("Uninstall complete")
      } else {
        Log.debug("Could not complete uninstall")
      }
    })
  }

  @objc static func installHelper(_ _: Any) {
    Log.debug("Elevating Helper...")
    Elevator().install()
  }

  @objc static func quit(_ _: Any) {
    if Config.instance.isRestrictedDaemon { deactivateDaemon(self) }
    NSApp.terminate(self)
  }

  @objc static func toggleRerandomization(_ _: NSMenuItem) {
    if Config.instance.isForbiddenToRerandomize {
      ConfigWriter.allowRerandom()
    } else {
      ConfigWriter.forbidRerandom()
    }
  }

  @objc static func toggleDaemonRestriction(_ _: NSMenuItem) {
    Config.instance.isRestrictedDaemon ? freeDaemon() : restrictDaemon()
  }

  @objc static func toggleAnonymization(_ _: NSMenuItem) {
    if Config.instance.isAnonymized {
      ConfigWriter.deAnonymize()
    } else {
      ConfigWriter.anonymize()
    }
  }

  private static func restrictDaemon() {
    ConfigWriter.restrictDaemon()
  }

  private static func freeDaemon() {
    ConfigWriter.freeDaemon()
    activateDaemon(self)
  }

  @objc static func resetConfig(_ _: NSMenuItem) {
    ConfigWriter.reset()
  }

  @objc static func ignoreInterface(_ sender: NSMenuItem) {
    guard let interface = sender.representedObject as? Interface else {
      Log.error("Expected the NSMenuItem to be associated to an Interface")
      return
    }
    ConfigWriter.ignoreInterface(interface)
  }

  @objc static func forgetInterface(_ sender: NSMenuItem) {
    guard let interface = sender.representedObject as? Interface else {
      Log.error("Expected the NSMenuItem to be associated to an Interface")
      return
    }
    ConfigWriter.forgetInterface(interface)
  }

  @objc static func ignoreDefaultInterface(_ sender: NSMenuItem) {
    ConfigWriter.ignoreDefaultInterface()
  }

  @objc static func randomizeInterface(_ sender: NSMenuItem) {
    guard let interface = sender.representedObject as? Interface else {
      Log.error("Expected the NSMenuItem to be associated to an Interface")
      return
    }
    ConfigWriter.randomizeInterface(interface)
  }

  @objc static func randomizeDefaultInterface(_ sender: NSMenuItem) {
    ConfigWriter.randomizeDefaultInterface()
  }

  @objc static func specifyInterface(_ sender: NSMenuItem) {
    guard let interface = sender.representedObject as? Interface else {
      Log.error("Expected the NSMenuItem to be associated to an Interface")
      return
    }
    let title = "Choose new MAC for \(interface.displayName)"
    let description = "The original hardware MAC for this Interface is\n\(interface.hardMAC.humanReadable)"
    guard let answer = MACAddressQuestion(title: title, description: description).ask() else {
      Log.debug("You pressed <Cancel> when asked to enter a MAC address.")
      return
    }
    let softMAC = MACAddress(answer)
    Log.debug("You typed in \(answer) as desired MAC address, which is \(softMAC.formatted)")
    ConfigWriter.specifyInterface(interface, softMAC: softMAC)
  }

  @objc static func specifyDefaultInterface(_ sender: NSMenuItem) {
    let title = "Choose MAC for unknown Interfaces"
    let description = "Whenever a new Interface is detected, this MAC address will be assigned to it."
    guard let answer = MACAddressQuestion(title: title, description: description).ask() else {
      Log.debug("You pressed <Cancel> when asked to enter a MAC address.")
      return
    }
    let softMAC = MACAddress(answer)
    Log.debug("You typed in \(answer) as desired MAC address, which is \(softMAC.formatted)")
    ConfigWriter.specifyDefaultInterface(softMAC: softMAC)
  }

  @objc static func originalizeInterface(_ sender: NSMenuItem) {
    guard let interface = sender.representedObject as? Interface else {
      Log.error("Expected the NSMenuItem to be associated to an Interface")
      return
    }
    ConfigWriter.originalizeInterface(interface)
  }

  @objc static func originalizeDefaultInterface(_ _: NSMenuItem) {
    ConfigWriter.originalizeDefaultInterface()
  }

  static func helperIsCompatible(_ _: Any) {
    Log.debug("TODO")
  }

  @objc static func createConfigDir(_ _: Any) {
    Intercom.createConfigDir(reply: {
      success in
      if (success) {
        Log.debug("You gotta dir now")
      } else {
        Log.debug("No dir for you")
      }
    })
  }

 @objc  static func removeConfigDir(_ _: Any) {
    Intercom.removeConfigDir(reply: {
      success in
      if (success) {
        Log.debug("Deleted your dir now")
      } else {
        Log.debug("No dir deletion for you")
      }
    })
  }

  @objc static func installDaemon(_ _: Any) {
    Intercom.installDaemon(reply: {
      success in
      if (success) {
        Log.debug("You gotta daemon now")
      } else {
        Log.debug("No daemon for you")
      }
    })
  }

  @objc static func activateDaemon(_ _: Any) {
    Intercom.activateDaemon(reply: {
      success in
      if (success) {
        Log.debug("daemon activated")
      } else {
        Log.debug("daemon could not be activated")
      }
    })
  }

  @objc static func deactivateDaemon(_ _: Any) {
    Intercom.deactivateDaemon(reply: {
      success in
      if (success) {
        Log.debug("daemon deactivated")
      } else {
        Log.debug("daemon could not be deactivated")
      }
    })
  }

  @objc static func uninstallHelper(_ sender: Any) {
    Intercom.uninstallHelper(reply: {
      success in
      if (success) {
        Log.debug("helper imploded")
      } else {
        Log.debug("helper could not be imploded")
      }
    })
  }

  @objc static func uninstallDaemon(_ sender: Any) {
    Intercom.uninstallDaemon(reply: {
      success in
      if (success) {
        Log.debug("helper imploded")
      } else {
        Log.debug("helper could not be imploded")
      }
    })
  }

  @objc static func revealConfigDir(_ sender: Any) {
    revealPath(Paths.configDirectory)
  }

  @objc static func showLogs(_ sender: Any) {
    let command = "/usr/bin/log stream --predicate 'subsystem == \\\"io.github.halo.LinkLiar\\\"' --level debug"
    let source = "tell application \"Terminal\" \n activate \n do script \"\" \n set win to do script with command \"\(command)\" \n set win's current settings to settings set \"Pro\" \n end tell"
    let script = NSAppleScript(source: source)!
    var error : NSDictionary?
    script.executeAndReturnError(&error)
    if error != nil { Log.error((error?.description)!) }
  }

  private static func revealPath(_ path: String) {
    let source = "tell application \"Finder\" to reveal POSIX file \"\(path)\""
    let script = NSAppleScript(source: source)!
    var error : NSDictionary?
    script.executeAndReturnError(&error)
    if error != nil { Log.error((error?.description)!) }
  }

}
