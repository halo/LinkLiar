import Foundation
import Cocoa
import ServiceManagement

struct LaunchAtLogin {
  static var isEnabled: Bool {
    get {
      // You may live with this compiler warning, for now.
      // See https://stackoverflow.com/a/44610931
      guard let jobDictionaries = SMCopyAllJobDictionaries( kSMDomainUserLaunchd ).takeRetainedValue() as? [[String:Any]] else { return false }
      let job = jobDictionaries.first { $0["Label"] as! String == Identifiers.launcher.rawValue }
      return job?["OnDemand"] as? Bool ?? false
    }

    /**
     * If true: adds LinkLauncher to the Operating System Login Items and kills the launcher.
     * If false: Removes the Login Item.
     */
    set {
      Log.debug("Setting Login Item to \(newValue)")
      let result = SMLoginItemSetEnabled(Identifiers.launcher.rawValue as CFString, newValue)
      guard result else { return Log.error("Could not disable Login item") }
      
      if newValue {
        Log.debug("Successfully enabled Login Item")
      } else {
        Log.debug("Successfully removed Login Item")
      }
    }
  }

  static func toggle() {
    isEnabled = !isEnabled
  }
}
