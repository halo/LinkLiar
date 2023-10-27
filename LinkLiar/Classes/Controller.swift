import Foundation
import ServiceManagement

class Controller {
  
  
  static var version: String = {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
  }()
  
  static func install(state: LinkState) {
    Radio.install(state: state, reply: { success in
      if (success) {
        Log.debug("Installation complete")
      } else {
        Log.debug("Could not complete installation")
      }
    })
  }
  
  static func uninstall(state: LinkState) {
    Radio.uninstall(state: state, reply: { success in
      if (success) {
        Log.debug("umInstallation complete")
      } else {
        Log.debug("Could not complete uninstallation")
      }
    })
  }
  
  static func unregisterDaemon(state: LinkState) {
    queryDaemonRegistration(state: state)
    let helper = SMAppService.daemon(plistName: "\(Identifiers.daemon.rawValue).plist")
   
    DispatchQueue.global().async {
      do {
        try helper.unregister()
        queryDaemonRegistration(state: state)

        Log.debug("Successfully UNregistered \(helper)")
        print("\(helper) has then status \(helper.status)")
      } catch {
        Log.debug("Unable to UNregister \(error)")
        queryDaemonRegistration(state: state)
      }
      
    }
  }
  
  static func registerDaemon(state: LinkState) {
    queryDaemonRegistration(state: state)
    print("1")
    let helper = SMAppService.daemon(plistName: "\(Identifiers.daemon.rawValue).plist")
    print("2")

//    print("\(helper) has first status \(helper.status)")
    
    DispatchQueue.global().async {
      print("3")

      //      do {
      //        try helper.unregister()
      //
      //        Log.debug("Successfully UNregistered \(helper)")
      //        print("\(helper) has status \(helper.status)")
      //      } catch {
      //        Log.debug("Unable to UNregister \(error)")
      //      }
      
      do {
        print("4")
        try helper.register()
        print("5")
        queryDaemonRegistration(state: state)
        print("6")

        Log.debug("Successfully registered \(helper)")
//        print("\(helper) has then status \(helper.status)")
      } catch {
        print("7")
        Log.debug("Unable to register \(error)")
        print("8")
        queryDaemonRegistration(state: state)
        print("9")
      }
      
    }
  }
  
  
  
  static func troubleshoot(state: LinkState) {
    Radio.version(state: state, reply: { version in
      if (version == nil) {
        Log.debug("No Version")
        state.daemonVersion = Version("0.0.0")
      } else {
        Log.debug("Received Version")
        state.daemonVersion = version!
      }
    })
  }
  
  private static func queryDaemonRegistration(state: LinkState) {
    Log.debug("BEFORE")
    let helper = SMAppService.daemon(plistName: "\(Identifiers.daemon.rawValue).plist")
    Log.debug("AFTER")

    switch helper.status {
      case .notRegistered:
        state.daemonRegistration = .notRegistered
      case .enabled:
        state.daemonRegistration = .enabled
      case .requiresApproval:
        state.daemonRegistration = .requiresApproval
      case .notFound:
        state.daemonRegistration = .notFound
      default:
        state.daemonRegistration = .novel
    }
  }
  
}
