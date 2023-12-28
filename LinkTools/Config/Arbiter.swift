// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

extension Config {
  class Arbiter {
    // MARK: Class Methods

    init(config: Config.Reader, hardMAC: MACAddress) {
      self.config = config
      self.hardMAC = hardMAC
    }

    // MARK: Instance Properties

    var action: Interface.Action {
      if let interfaceSpecificAction = config.policy(hardMAC).action {
        return interfaceSpecificAction
      }

      if let fallbackAction = config.fallbackPolicy.action {
        return fallbackAction
      }

      return .ignore
    }

    var prefixes: [MACPrefix] {
      if !config.vendors.chosenPopular.isEmpty {
        return config.vendors.chosenPopular.flatMap { $0.prefixes }
      }

      return PopularVendors.find("apple")!.prefixes
    }

    var address: MACAddress? {
      if let interfaceSpecificAddress = config.policy(hardMAC).address {
        return interfaceSpecificAddress
      }

      return config.fallbackPolicy.address
    }

    var exceptionAddress: MACAddress? {
      config.policy(hardMAC).exceptionAddress
    }

    var overrideAddressInTests: MACAddress?

    // MARK: Instance Methods

    func randomAddress() -> MACAddress {
      if let override = overrideAddressInTests {
        return override
      }

      let prefix = prefixes.randomElement()!
      let suffix = [
        String(Int.random(in: 0..<256), radix: 16, uppercase: false),
        String(Int.random(in: 0..<256), radix: 16, uppercase: false),
        String(Int.random(in: 0..<256), radix: 16, uppercase: false)
      ].joined()

      return MACAddress([prefix.formatted, suffix].joined())
    }

    // MARK: Private Instance Properties

    private var config: Config.Reader
    private var hardMAC: MACAddress
  }
}
