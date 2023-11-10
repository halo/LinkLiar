import SwiftUI

@Observable

class LinkState {
  var daemonRegistration = daemonRegistrations.unknown
  var xpcStatus = xpcStatuses.unknown
  var daemonVersion = Version("0.0.0")
  
  var interfaces = [Interface]()
  
  var wantsToQuit = false
  
  var warnAboutLeakage: Bool {
    self.interfaces.contains(where: { interface in interface.hasOriginalMAC })
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
