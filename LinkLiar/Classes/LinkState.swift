import SwiftUI

@Observable

class LinkState {
  enum xpcStatuses: String {
    case unknown = "unknown"
    case initialized = "initialized"
    case connected = "connected"
    case invalidated = "invalidated"
    case interrupted = "interrupted"
  }

  enum daemonRegistrations: String {
    case unknown = "unknown"
    case notRegistered = "not registered"
    case enabled = "enabled"
    case requiresApproval = "requires approval"
    case notFound = "not found"
    case novel = "novel"
  }

  var connectedToDaemon = false
  var warnAboutLeakage = false
  var requestsDaemonAuthorization = false
  var daemonVersion: Version = Version("0.0.0")
  var xpcStatus = xpcStatuses.unknown
  var daemonRegistration = daemonRegistrations.unknown
}
