import Foundation
import Cocoa

class Controller: NSObject {

  static func authorize(_ sender: NSMenuItem) {
    Log.debug("Installing Helper and Daemon...")
    installHelper(sender)
    createConfigDir(sender)
    configureDaemon(sender)
    activateDaemon(sender)
  }

  static func installHelper(_ sender: NSMenuItem) {
    Log.debug("Elevating Helper...")
    Elevator().install()
  }


  static func resetConfig(_ sender: NSMenuItem) {
    ConfigWriter.reset()
  }

  static func ignoreInterface(_ sender: NSMenuItem) {
    guard let interface = sender.representedObject as? Interface else {
      Log.error("Expected the NSMenuItem to be associated to an Interface")
      return
    }
    ConfigWriter.ignoreInterface(interface)
  }

  static func ignoreDefaultInterface(_ sender: NSMenuItem) {
    ConfigWriter.ignoreDefaultInterface()
  }

  static func randomizeInterface(_ sender: NSMenuItem) {
    guard let interface = sender.representedObject as? Interface else {
      Log.error("Expected the NSMenuItem to be associated to an Interface")
      return
    }
    ConfigWriter.randomizeInterface(interface)
  }

  static func randomizeDefaultInterface(_ sender: NSMenuItem) {
    ConfigWriter.randomizeDefaultInterface()
  }

  static func specifyInterface(_ sender: NSMenuItem) {
    guard let interface = sender.representedObject as? Interface else {
      Log.error("Expected the NSMenuItem to be associated to an Interface")
      return
    }
    let title = "Choose new MAC for \(interface.displayName)"
    let description = "The original hardware MAC for this Interface is\n\(interface.hardMAC.formatted)"
    guard let answer = MACAddressQuestion(title: title, description: description).ask() else {
      Log.debug("You pressed <Cancel> when asked to enter a MAC address.")
      return
    }
    let softMAC = MACAddress(answer)
    Log.debug("You typed in \(answer) as desired MAC address, which is \(softMAC.formatted)")
    ConfigWriter.specifyInterface(interface, softMAC: softMAC)
  }

  static func originalizeInterface(_ sender: NSMenuItem) {
    guard let interface = sender.representedObject as? Interface else {
      Log.error("Expected the NSMenuItem to be associated to an Interface")
      return
    }
    ConfigWriter.originalizeInterface(interface)
  }

  static func helperIsCompatible(_ sender: Any) {
    Log.debug("Querying helper version")
    Intercom.helperVersion(reply: { version in
      if (true) {
        Log.debug("helper does not seem to say much")

      } else {
        Log.debug("helper is helpful")

      }
    })
  }

  static func createConfigDir(_ sender: Any) {
    Intercom.createConfigDir(reply: {
      success in
      if (success) {
        Log.debug("You gotta dir now")
      } else {
        Log.debug("No dir for you")
      }
    })
  }

  static func configureDaemon(_ sender: Any) {
    Intercom.configureDaemon(reply: {
      success in
      if (success) {
        Log.debug("You gotta daemon now")
      } else {
        Log.debug("No daemon for you")
      }
    })
  }

  static func activateDaemon(_ sender: Any) {
    Intercom.activateDaemon(reply: {
      success in
      if (success) {
        Log.debug("daemon activated")
      } else {
        Log.debug("daemon could not be activated")
      }
    })
  }

  static func deactivateDaemon(_ sender: Any) {
    Intercom.deactivateDaemon(reply: {
      success in
      if (success) {
        Log.debug("daemon deactivated")
      } else {
        Log.debug("daemon could not be deactivated")
      }
    })
  }

  static func implodeHelper(_ sender: Any) {
    Intercom.implodeHelper(reply: {
      success in
      if (success) {
        Log.debug("helper imploded")
      } else {
        Log.debug("helper could not be imploded")
      }
    })
  }

  static func showLogs(_ sender: Any) {
    let command = "/usr/bin/log stream --predicate 'subsystem == \\\"io.github.halo.LinkLiar\\\"' --level debug"
    let source = "tell application \"Terminal\" \n activate \n do script with command \"\(command)\" \n end tell"
    let script = NSAppleScript(source: source)!
    var error : NSDictionary?
    script.executeAndReturnError(&error)
    if error != nil { Log.error((error?.description)!) }
  }

}


