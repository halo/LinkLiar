import Foundation
import ServiceManagement

class Elevator: NSObject {

  func install() {
    var cfError: Unmanaged<CFError>? = nil
    if !SMJobBless(kSMDomainSystemLaunchd, Identifiers.helper.rawValue as CFString, authorization(), &cfError) {
      let blessError = cfError!.takeRetainedValue() as Error
      Log.debug("Bless Error: \(blessError)")
    } else {
      Log.debug("\(Identifiers.helper.rawValue) installed successfully")
      Intercom.reset()
    }
  }

  func authorization() -> AuthorizationRef? {
    var authRef:AuthorizationRef?
    var authItem = AuthorizationItem(name: kSMRightBlessPrivilegedHelper, valueLength: 0, value:UnsafeMutableRawPointer(bitPattern: 0), flags: 0)
    var authRights:AuthorizationRights = AuthorizationRights(count: 1, items:&authItem)
    let authFlags: AuthorizationFlags = [ [], .extendRights, .interactionAllowed, .preAuthorize ]

    let status = AuthorizationCreate(&authRights, nil, authFlags, &authRef)
    if (status != errAuthorizationSuccess) {
      let error = NSError(domain:NSOSStatusErrorDomain, code:Int(status), userInfo:nil)
      Log.debug("Authorization error: \(error)")
      return nil
    } else {
      return authRef
    }
  }

}
