// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import CoreWLAN
import Foundation

extension Ifconfig {
  class Setter {
    // MARK: Class Methods

    init(_ BSDName: String) {
      self.BSDName = BSDName
    }

    // MARK: Instance Properties

    /// The BSD Name of a network interface. This property is read-only.
    /// For example `en0` or `en1`.
    private(set) var BSDName: String

    // MARK: Instance Methods

    func setSoftMAC(_ mac: MAC) {
      let state = WifiState(BSDName)
      state.prepare()

      Log.info("Setting MAC address of Interface \(BSDName) to <\(mac.address)>...")
      let command = Command(Paths.ifconfigCLI, arguments: [BSDName, "ether", mac.address])
      _ = command.run()

      // Giving the Interface some time before attempting a re-connect to a network.
      Log.info("Waiting for prior changes to take effect...")
      sleep(1)

//      state.restore()
    }
  }
}
