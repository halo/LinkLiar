// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

extension Config {
  class Arbiter {
    // MARK: Class Methods

    init(config: Config.Reader, hardMAC: MACAddress) {
      self.config = config
      self.hardMAC = hardMAC
    }

    // MARK: Public Instance Properties

    var action: Interface.Action {
      if let interfaceSpecificAction = config.policy(hardMAC).action {
        return interfaceSpecificAction
      }

      if let fallbackAction = config.fallbackPolicy.action {
        return fallbackAction
      }

      return .ignore
    }

    var address: MACAddress? {
      if let interfaceSpecificAddress = config.policy(hardMAC).address {
        return interfaceSpecificAddress
      }

      return config.fallbackPolicy.address
    }

    var prefixes: [MACPrefix] {
      if !config.vendors.chosenPopular.isEmpty {
        return config.vendors.chosenPopular.flatMap { $0.prefixes }
      }

      return PopularVendors.find("apple")!.prefixes
    }

    // MARK: Private Instance Properties

    private var config: Config.Reader
    private var hardMAC: MACAddress
  }
}
