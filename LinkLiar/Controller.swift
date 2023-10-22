//
//  Controller.swift
//  LinkLiar
//
//  Created by orange on 22.10.23.
//

import Foundation
import ServiceManagement

class Controller {
  
  static func doAuthorize() {
    print("authorizing...")
    let helper = SMAppService.daemon(plistName: "\(Identifiers.daemon.rawValue).plist")
    
    print("\(helper) has status \(helper.status)")
    
    do {
      try helper.register()
      
      Log.debug("Successfully registered \(helper)")
      //      Intercom.reset()
    } catch {
      Log.debug("Unable to register \(error)")
    }
    
    print("\(helper) has status \(helper.status) which is enabled: \(helper.status == SMAppService.Status.enabled)")
  }
  
}
