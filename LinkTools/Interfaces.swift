import Foundation
import SystemConfiguration
import os.log

class Interfaces: NSObject {
  
  static func all() -> [Interface] {
    let interfaces = SCNetworkInterfaceCopyAll()
    var instances: [Interface] = []

    for interfaceRef in interfaces {
      let BSDName = SCNetworkInterfaceGetBSDName(interfaceRef as! SCNetworkInterface)! as String
      let displayName = SCNetworkInterfaceGetLocalizedDisplayName(interfaceRef as! SCNetworkInterface)! as String
      let hardMAC = SCNetworkInterfaceGetHardwareAddressString(interfaceRef as! SCNetworkInterface)! as String
      let type = SCNetworkInterfaceGetInterfaceType(interfaceRef as! SCNetworkInterface)! as String

      let interface = Interface(BSDName: BSDName, displayName: displayName, hardMAC: hardMAC, kind: type)
      instances.append(interface)
    }
    return instances

  }
/*
  class func all() -> [NSString:NSString] {
    os_log("Fetching all interfaces")

    var dict = [NSString:NSString]()
    let interfaceArray = SCNetworkInterfaceCopyAll()

    for interface in interfaceArray {
      let x:SCNetworkInterface = interface as! SCNetworkInterface
      let name:NSString = SCNetworkInterfaceGetLocalizedDisplayName(x)!
      let bsdName:NSString = SCNetworkInterfaceGetBSDName(x)!
      dict[name] = bsdName
    }

    return dict

  }
 */
}




