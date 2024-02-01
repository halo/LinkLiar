// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

extension Config {
  struct AccessPointPolicy: Identifiable {
    // MARK: Class Methods

    init(ssid: SSID, softMAC: MAC) {
      self.ssid = ssid
      self.softMAC = softMAC
    }

    // MARK: Instance Properties

    /// Conforming to `Identifiable`.
    var id: String { "\(ssid)|\(softMAC.address)" }

    /**
     * Gives access to the underlying dictionary of this configuration.
     */
    var ssid: SSID
    var softMAC: MAC
  }
}

extension Config.AccessPointPolicy: Comparable {
  static func == (lhs: Config.AccessPointPolicy, rhs: Config.AccessPointPolicy) -> Bool {
    lhs.id == rhs.id
  }

  static func < (lhs: Config.AccessPointPolicy, rhs: Config.AccessPointPolicy) -> Bool {
    lhs.id < rhs.id
  }
}
