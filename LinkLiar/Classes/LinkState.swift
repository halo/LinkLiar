import SwiftUI

@Observable

class LinkState {
  // GUI
  var wantsToQuit = false
  var version: Version = {
    Version(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
  }()

  // Daemon
  var daemonRegistration = daemonRegistrations.unknown
  var xpcStatus = xpcStatuses.unknown
  var daemonVersion = Version("0.0.0")
  
  // Network
  var interfaces = [Interface]()

  // Settings
  
  /// Holds the raw configuration file as Dictionary.
  var configDictionary: [String: Any] = [:]
  
//  var settingsEditingInterface: Interface?
  
  // Derived
  var warnAboutLeakage: Bool {
    self.interfaces.contains(where: { interface in
      interface.hasOriginalMAC &&
        config.policy(interface.hardMAC).action != .ignore &&
        config.policy(interface.hardMAC).action != .hide
    })
  }
  
  /// Convenience wrapper for reading the configuration.
  var config: Configuration {
    Configuration(dictionary: configDictionary)
  }

}

extension LinkState {
  // Analogous to `SMAppService.Status`.
  enum daemonRegistrations: String {
    case unknown = "unknown"
    case notRegistered = "not registered"
    case enabled = "enabled"
    case requiresApproval = "requires approval"
    case notFound = "not found"
    case novel = "novel" // Didn't exist yet in `SMAppService.Status` in this release.
  }

  enum xpcStatuses: String {
    case unknown = "unknown"
    case initialized = "initialized"
    case connected = "connected"
    case invalidated = "invalidated"
    case interrupted = "interrupted"
  }
}
