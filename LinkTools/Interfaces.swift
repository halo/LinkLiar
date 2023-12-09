// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

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
      // swiftlint:disable force_cast
      guard let BSDName = SCNetworkInterfaceGetBSDName(interfaceRef as! SCNetworkInterface) else { continue }
      guard let displayName = SCNetworkInterfaceGetLocalizedDisplayName(interfaceRef as! SCNetworkInterface)
      else { continue }
      guard let hardMAC = SCNetworkInterfaceGetHardwareAddressString(interfaceRef as! SCNetworkInterface)
      else { continue }
      guard let type = SCNetworkInterfaceGetInterfaceType(interfaceRef as! SCNetworkInterface) else { continue }
      // swiftlint:enable force_cast

      let interface = Interface(BSDName: BSDName as String, displayName: displayName as String,
                                kind: type as String, hardMAC: hardMAC as String, async: asyncSoftMac)
      if !interface.isSpoofable { continue }

      yield(interface)
    }
  }
}
