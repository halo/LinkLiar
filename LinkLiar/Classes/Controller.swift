import Foundation
import ServiceManagement

class Controller {
  
  static var version: String = {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
  }()
  
  static func install() {
    Radio.install(reply: { success in
      if (success) {
        Log.debug("Installation complete")
      } else {
        Log.debug("Could not complete installation")
      }
    })
  }
  
  static func uninstall() {
    Radio.uninstall(reply: { success in
      if (success) {
        Log.debug("umInstallation complete")
      } else {
        Log.debug("Could not complete uninstallation")
      }
    })
  }
  
  static func doUnAuthorize() {
    print("authorizing...")
    let helper = SMAppService.daemon(plistName: "\(Identifiers.daemon.rawValue).plist")
    
    print("\(helper) has first status \(helper.status)")
    
    DispatchQueue.global().async {
      
//      do {
//        try helper.unregister()
//
//        Log.debug("Successfully UNregistered \(helper)")
//        print("\(helper) has status \(helper.status)")
//      } catch {
//        Log.debug("Unable to UNregister \(error)")
//      }
      
      do {
        try helper.unregister()
        
        Log.debug("Successfully UNregistered \(helper)")
        print("\(helper) has then status \(helper.status)")
      } catch {
        Log.debug("Unable to UNregister \(error)")
      }
      
    }
    
    
  }
  
  static func doAuthorize() {
    print("authorizing...")
    let helper = SMAppService.daemon(plistName: "\(Identifiers.daemon.rawValue).plist")
    
    print("\(helper) has first status \(helper.status)")
    
    DispatchQueue.global().async {
      
//      do {
//        try helper.unregister()
//        
//        Log.debug("Successfully UNregistered \(helper)")
//        print("\(helper) has status \(helper.status)")
//      } catch {
//        Log.debug("Unable to UNregister \(error)")
//      }
      
      do {
        try helper.register()
        
        Log.debug("Successfully registered \(helper)")
        print("\(helper) has then status \(helper.status)")
      } catch {
        Log.debug("Unable to register \(error)")
      }
      
    }
    
    
  }
  
}
