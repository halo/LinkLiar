// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SystemConfiguration

///
/// Helper to query macOS network interfaces.
///
struct Interfaces {
  // MARK: Class Methods

  /// Returns every ``Interface`` where the MAC address likely can be modified.
  /// The ``Interface`` instances are immediately returned.
  ///
  /// Pass in a resolving mechanism to query the soft MAC addresses in the background.
  /// In that case, the instances will update their softMac property.
  ///
  static func all(_ resolving: Interface.SoftMACResolving) -> [Interface] {
    var instances = [Interface]()

    all(resolving: resolving, using: { interface in
      instances.append(interface)
    })

    return instances.sorted()
  }

  // MARK: Private Class Methods

  /// Internal helper that yields every spoofable ``Interface``.
  ///
  private static func all(resolving: Interface.SoftMACResolving, using yield: (Interface) -> Void) {
    let interfaces = SCNetworkInterfaceCopyAll()

    for interfaceRef in interfaces {
      // swiftlint:disable force_cast
      guard let BSDName = SCNetworkInterfaceGetBSDName(interfaceRef as! SCNetworkInterface) else { continue }
      guard let name = SCNetworkInterfaceGetLocalizedDisplayName(interfaceRef as! SCNetworkInterface)
              as? String else { continue }
      guard let hardMAC = SCNetworkInterfaceGetHardwareAddressString(interfaceRef as! SCNetworkInterface)
        else { continue }
      guard let type = SCNetworkInterfaceGetInterfaceType(interfaceRef as! SCNetworkInterface)
              as? String else { continue }
      // swiftlint:enable force_cast

      guard let bsd = BSD(BSDName as String) else { continue }
      guard let hardMAC = MAC(hardMAC as String) else { continue }
      guard let interface = Interface(bsd: bsd,
                                      hardMAC: hardMAC,
                                      name: name,
                                      kind: type,
                                      resolving: resolving) else { continue }
      if !interface.isSpoofable { continue }

      yield(interface)
    }
  }
}
