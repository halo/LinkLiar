/*
 * Copyright (C) 2017 halo https://io.github.com/halo/LinkLiar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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
