import SwiftUI

@Observable

class LinkState {
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
  var daemonRegistration = daemonRegistrations.unknown
  var xpcStatus = xpcStatuses.unknown
  var daemonVersion: Version = Version("0.0.0")


  var connectedToDaemon = false
  var warnAboutLeakage = false
  var requestsDaemonAuthorization = false
  
  var interfaces = [Interface]()
}
