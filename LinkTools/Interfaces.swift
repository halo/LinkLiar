/*
 * Copyright (C) halo https://io.github.com/halo/LinkLiar
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

/// Helper to query macOS interfaces.
struct Interfaces {

  // MARK: Class Methods

  /// Returns every ``Interface`` where the MAC address likely can be modified.
  /// The ``Interface`` instances are immediately returned.
  ///
  /// Pass in `asyncSoftMac` to query the soft MAC addresses in the background.
  /// In that case, the instances will update their softMac property.
  static func all(asyncSoftMac: Bool) -> [Interface] {
    var instances = [Interface]()
    
    all(asyncSoftMac: asyncSoftMac, using: { interface in
      instances.append(interface)
    })
    
    return instances.sorted()
  }

  // MARK: Private Class Methods
  
  private static func all(asyncSoftMac: Bool, using yield: (Interface) -> Void) {
    let interfaces = SCNetworkInterfaceCopyAll()

    for interfaceRef in interfaces {
      guard let BSDName = SCNetworkInterfaceGetBSDName(interfaceRef as! SCNetworkInterface) else { continue }
      guard let displayName = SCNetworkInterfaceGetLocalizedDisplayName(interfaceRef as! SCNetworkInterface) else { continue }
      guard let hardMAC = SCNetworkInterfaceGetHardwareAddressString(interfaceRef as! SCNetworkInterface) else { continue }
      guard let type = SCNetworkInterfaceGetInterfaceType(interfaceRef as! SCNetworkInterface) else { continue }

      let interface = Interface(BSDName: BSDName as String, displayName: displayName as String, kind: type as String, hardMAC: hardMAC as String, async: asyncSoftMac)
      if !interface.isSpoofable { continue }
      
      yield(interface)
    }
  }
}
