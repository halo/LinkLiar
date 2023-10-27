import SwiftUI

@Observable

class LinkState {
  var connectedToDaemon = false
  var warnAboutLeakage = false
  var requestsDaemonAuthorization = false
  var daemonVersion: Version = Version("0.0.0")
  var xpcStatus = "unknown"
}
