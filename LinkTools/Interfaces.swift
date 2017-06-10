import Foundation
import SystemConfiguration
import os.log

class Interfaces: NSObject {
  class func all() -> [NSString:NSString] {
    os_log("Fetching all interfaces")

    var dict = [NSString:NSString]()
    let interfaceArray = SCNetworkInterfaceCopyAll()

    for interface in interfaceArray{
      let x:SCNetworkInterface = interface as! SCNetworkInterface
      let name:NSString = SCNetworkInterfaceGetLocalizedDisplayName(x)!
      let bsdName:NSString = SCNetworkInterfaceGetBSDName(x)!
      dict[name] = bsdName
    }

    return dict

  }
}




