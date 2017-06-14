import SystemConfiguration

struct Interfaces {
  
  static func all(async: Bool) -> [Interface] {
    let interfaces = SCNetworkInterfaceCopyAll()
    var instances: [Interface] = []

    for interfaceRef in interfaces {
      let BSDName = SCNetworkInterfaceGetBSDName(interfaceRef as! SCNetworkInterface)! as String
      let displayName = SCNetworkInterfaceGetLocalizedDisplayName(interfaceRef as! SCNetworkInterface)! as String
      let hardMAC = SCNetworkInterfaceGetHardwareAddressString(interfaceRef as! SCNetworkInterface)! as String
      let type = SCNetworkInterfaceGetInterfaceType(interfaceRef as! SCNetworkInterface)! as String

      let interface = Interface(BSDName: BSDName, displayName: displayName, kind: type, hardMAC: hardMAC, async: async)
      instances.append(interface)
    }
    return instances

  }

}
