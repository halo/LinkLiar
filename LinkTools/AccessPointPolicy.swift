// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

extension Config {
  struct AccessPointPolicy: Identifiable {
    // MARK: Class Methods

    static func initIfValid(ssid: String, softMAC: String) -> Self? {
      let accessPointPolicy = self.init(ssid: ssid, softMAC: softMAC)
      if !accessPointPolicy.isValid { return nil }
      return accessPointPolicy
    }

    init(ssid: String, softMAC: String) {
      self.ssid = ssid
      self.softMAC = MACAddress(softMAC)
    }

    // MARK: Instance Properties
    /// Conforming to `Identifiable`.
    var id: String { "\(ssid)|\(softMAC.formatted)" }

    /**
     * Gives access to the underlying dictionary of this configuration.
     */
    var ssid: String
    var softMAC: MACAddress

    var isValid: Bool {
      softMAC.isValid && !ssid.isEmpty
    }
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
