import Foundation
import Cocoa

class Controller: NSObject {

  static func authorize(_ sender: NSMenuItem) {
    Log.debug("Looking up helper version")
    Elevator().install()
  }

  static func resetConfig(_ sender: NSMenuItem) {
    ConfigWriter.reset()
  }

  static func forgetInterface(_ sender: NSMenuItem) {
    guard let interface = sender.representedObject as? Interface else {
      Log.error("Expected the NSMenuItem to be associated to an Interface")
      return
    }
    ConfigWriter.ignoreInterface(interface.hardMAC.formatted)
  }

  static func randomizeInterface(_ sender: NSMenuItem) {
    guard let interface = sender.representedObject as? Interface else {
      Log.error("Expected the NSMenuItem to be associated to an Interface")
      return
    }
    ConfigWriter.randomizeInterface(interface.hardMAC.formatted)
  }

  static func helperVersion(_ sender: Any) {
    Intercom.helperVersion(reply: {
      rawVersion in
      if (rawVersion == nil) {
        // TODO Compare SemVer
        Log.debug("helper does not seem to say much")
        Elevator().install()
      } else {
        Log.debug("helper is helpful")
        let version = Version(rawVersion!)
        Log.debug("\(version.humanReadable)")
      }
      // Elevator().bless()

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

  static func establishDaemon(_ sender: Any) {
    Intercom.establishDaemon(reply: {
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




}


