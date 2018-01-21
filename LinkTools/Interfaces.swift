/*
 * Copyright (C) 2012-2018 halo https://io.github.com/halo/LinkLiar
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

import SystemConfiguration

struct Interfaces {

  static func anyOriginalMac() -> Bool {
    let interfaces = SCNetworkInterfaceCopyAll()

    for interfaceRef in interfaces {
      guard let BSDName = SCNetworkInterfaceGetBSDName(interfaceRef as! SCNetworkInterface) else { continue }
      guard let displayName = SCNetworkInterfaceGetLocalizedDisplayName(interfaceRef as! SCNetworkInterface) else { continue }
      guard let hardMAC = SCNetworkInterfaceGetHardwareAddressString(interfaceRef as! SCNetworkInterface) else { continue }
      guard let type = SCNetworkInterfaceGetInterfaceType(interfaceRef as! SCNetworkInterface) else { continue }

      let interface = Interface(BSDName: BSDName as String, displayName: displayName as String, kind: type as String, hardMAC: hardMAC as String, async: false)
      if !interface.isSpoofable { continue }
      if interface.hasOriginalMAC { return true }
    }
    return false
  }

  static func all(async: Bool) -> [Interface] {
    let interfaces = SCNetworkInterfaceCopyAll()
    var instances: [Interface] = []

    for interfaceRef in interfaces {
      guard let BSDName = SCNetworkInterfaceGetBSDName(interfaceRef as! SCNetworkInterface) else { continue }
      guard let displayName = SCNetworkInterfaceGetLocalizedDisplayName(interfaceRef as! SCNetworkInterface) else { continue }
      guard let hardMAC = SCNetworkInterfaceGetHardwareAddressString(interfaceRef as! SCNetworkInterface) else { continue }
      guard let type = SCNetworkInterfaceGetInterfaceType(interfaceRef as! SCNetworkInterface) else { continue }

      let interface = Interface(BSDName: BSDName as String, displayName: displayName as String, kind: type as String, hardMAC: hardMAC as String, async: async)
      if (interface.isSpoofable) { instances.append(interface) }
    }
    return instances.sorted { $0.BSDName < $1.BSDName }
  }

}
