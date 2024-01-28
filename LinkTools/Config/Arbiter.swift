// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

extension Config {
  class Arbiter {
    // MARK: Class Methods

    init(config: Config.Reader, hardMAC: MAC) {
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

    // TODO: Do we need to include SSID-MAC binding prefixes?
    var prefixes: [MACPrefix] {
      if !config.vendors.chosenPopular.isEmpty {
        return config.vendors.chosenPopular.flatMap { $0.prefixes }
      }

      return PopularVendors.find(Config.Key.apple.rawValue)!.prefixes
    }

    var address: MAC? {
      if let interfaceSpecificAddress = config.policy(hardMAC).address {
        return interfaceSpecificAddress
      }

      return config.fallbackPolicy.address
    }

    func addressForSsid(_ ssid: String) -> MAC? {
      guard action == .original || action == .specify || action == .random  else {
        return nil
      }

      guard let accessPoint = config.policy(hardMAC).accessPoints.first(where: { $0.ssid == ssid }) else {
        return nil
      }

      return accessPoint.softMAC
    }

    var exceptionAddress: MAC? {
      config.policy(hardMAC).exceptionAddress
    }

    var overrideAddressInTests: MAC?

    // MARK: Instance Methods

    func randomAddress() -> MAC {
      if let override = overrideAddressInTests {
        return override
      }

      let prefix = prefixes.randomElement()!
      let suffix = [
        String(Int.random(in: 0..<256), radix: 16, uppercase: false),
        String(Int.random(in: 0..<256), radix: 16, uppercase: false),
        String(Int.random(in: 0..<256), radix: 16, uppercase: false)
      ].joined()

      return MAC(address: [prefix.formatted, suffix].joined())
    }

    // MARK: Private Instance Properties

    private var config: Config.Reader
    private var hardMAC: MAC
  }
}
