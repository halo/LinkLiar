import SwiftUI

@Observable

class LinkState {
  var warnAboutLeakage = false
  var requestsDaemonAuthorization = false
}
