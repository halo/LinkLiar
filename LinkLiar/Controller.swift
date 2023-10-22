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
    
    DispatchQueue.global().async {
      
      do {
        try helper.register()
        
        Log.debug("Successfully registered \(helper)")
        print("\(helper) has status \(helper.status)")
      } catch {
        Log.debug("Unable to register \(error)")
      }
      
    }
    
    
  }
  
}
