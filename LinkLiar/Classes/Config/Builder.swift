// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation
import os.log

extension Config {
  struct Builder {
    // MARK: Class Methods

    init(_ dictionary: [String: Any]) {
      self.configDictionary = dictionary
    }

    // MARK: Instance Methods

    func setInterfaceAction(_ interface: Interface, action: Interface.Action?) -> [String: Any] {
      var dictionary = configDictionary

      // Make variable known outside of conditional.
      var interfaceDictionary: [String: String] = [:]

      if action == nil {
        interfaceDictionary = dictionary[interface.hardMAC.address] as? [String: String] ?? [:]
        interfaceDictionary.removeValue(forKey: Config.Key.action.rawValue)

      } else if let newAction = action?.rawValue {
        interfaceDictionary = dictionary[interface.hardMAC.address] as? [String: String] ?? [:]
        interfaceDictionary[Config.Key.action.rawValue] = newAction

        // Whenever you want an Interface to have a random MAC address,
        // there is a chance that the softMAC already was random.
        // We disallow the current softMAC (whatever it was), so that
        // the daemon can determine that it should re-randomize anyway.
        if newAction == Interface.Action.random.rawValue {
          if let mac = interface.softMAC {
            interfaceDictionary[Config.Key.except.rawValue] = mac.address
          }
        }
      }

      if interfaceDictionary.isEmpty {
        dictionary.removeValue(forKey: interface.hardMAC.address)
      } else {
        dictionary[interface.hardMAC.address] = interfaceDictionary
      }

      return dictionary
    }

    func setFallbackInterfaceAction(_ action: Interface.Action?) -> [String: Any] {
      var dictionary = configDictionary

      // Make variable known outside of conditional.
      var interfaceDictionary: [String: String] = [:]

      if action == nil {
        interfaceDictionary = dictionary[Config.Key.theDefault.rawValue] as? [String: String] ?? [:]
        interfaceDictionary.removeValue(forKey: Config.Key.action.rawValue)

      } else if let newAction = action?.rawValue {
        interfaceDictionary = dictionary[Config.Key.theDefault.rawValue] as? [String: String] ?? [:]
        interfaceDictionary[Config.Key.action.rawValue] = newAction

      }

      if interfaceDictionary.isEmpty {
        dictionary.removeValue(forKey: Config.Key.theDefault.rawValue)
      } else {
        dictionary[Config.Key.theDefault.rawValue] = interfaceDictionary
      }

      return dictionary
    }

    func setInterfaceAddress(_ interface: Interface, address: MAC?) -> [String: Any] {
      guard let mac = address else { return configDictionary }
      var dictionary = configDictionary

      var interfaceDictionary = dictionary[interface.hardMAC.address] as? [String: String] ?? [:]
      interfaceDictionary[Config.Key.address.rawValue] = mac.address

      dictionary[interface.hardMAC.address] = interfaceDictionary
      return dictionary
    }

    /// Convenience Wrapper if you don't have an ``Interface`` or ``MACAddress``
    /// but you have a hardMAC as String and a MACAddress as String.
    ///
    func setInterfaceAddress(_ hardMAC: String, address: String) -> [String: Any] {
      let interface = Interface(hardMAC)
      let address = MAC(address)
      return setInterfaceAddress(interface, address: address)
    }

    /// If this is an Interface that is supposed to have a random MAC address,
    /// you can instruct it to force a re-randomization by setting the current
    /// softMAC to forbidden (by saving it in the "except" key/value).
    ///
    func resetExceptionAddress(_ interface: Interface) -> [String: Any] {
      var dictionary = configDictionary

      // Technically, this could happen. Because the softMAC is resolved asynchronously in the background.
      guard interface.softMAC != nil else {
        Log.debug("\(interface.BSDName) has no valid softMAC.")
        return configDictionary
      }

      var interfaceDictionary = dictionary[interface.hardMAC.address] as? [String: Any] ?? [:]
      if let mac = interface.softMAC {
        interfaceDictionary[Config.Key.except.rawValue] = mac.address
      }

      dictionary[interface.hardMAC.address] = interfaceDictionary

      return dictionary
    }

    func addInterfaceSsid(_ interface: Interface, accessPointPolicy: AccessPointPolicy) -> [String: Any] {
      var dictionary = configDictionary

      // Adding "Coffeeshop"

      // { "action": "random", ... } or {}
      var interfaceDictionary = dictionary[interface.hardMAC.address] as? [String: Any] ?? [:]
      // { "Existing SSID": "aa:aa:aa:aa:aa:aa" } or {}
      var ssidsDictionary = interfaceDictionary[Config.Key.ssids.rawValue] as? [String: String] ?? [:]
      // { "Existing SSID": "aa:aa:aa:aa:aa:aa", "Coffeeshop": "aa:aa:aa:aa:aa:aa" }
      ssidsDictionary[accessPointPolicy.ssid] = accessPointPolicy.softMAC.address
      // { "action": "random", "ssids": { "Existing SSID": "aa:aa:aa:aa:aa:aa", "Coffeeshop": "aa:aa:aa:aa:aa:aa" } }
      interfaceDictionary[Config.Key.ssids.rawValue] = ssidsDictionary
      // { "e1:e1:e1:e1:e1:e1": { "action": "random", "ssids": { ... } }
      dictionary[interface.hardMAC.address] = interfaceDictionary

      return dictionary
    }

    ///
    /// Convenience Wrapper if you don't have an ``Interface`` but you have a hardware MAC address.
    ///
    func addInterfaceSsid(_ hardMAC: String, accessPointPolicy: AccessPointPolicy) -> [String: Any] {
      let interface = Interface(hardMAC)
      return addInterfaceSsid(interface, accessPointPolicy: accessPointPolicy)
    }

    func removeInterfaceSsid(_ interface: Interface, ssid: String) -> [String: Any] {
      var dictionary = configDictionary

      // Removing "Coffeeshop".

      // { "action": "random", ... } or {}
      var interfaceDictionary = dictionary[interface.hardMAC.address] as? [String: Any] ?? [:]
      // { "Existing SSID": "aa:aa:aa:aa:aa:aa", Coffeeshop": "aa:aa:aa:aa:aa:aa" } or {}
      var ssidsDictionary = interfaceDictionary[Config.Key.ssids.rawValue] as? [String: String] ?? [:]
      // { "Existing SSID": "aa:aa:aa:aa:aa:aa" } or {}
      ssidsDictionary.removeValue(forKey: ssid)

      // { "action": "random", "ssids": { "Existing SSID": "aa:aa:aa:aa:aa:aa" } }
      interfaceDictionary[Config.Key.ssids.rawValue] = ssidsDictionary

      // { "e1:e1:e1:e1:e1:e1": { "action": "random", ssids: {} } }
      if ssidsDictionary.isEmpty {
        // { "e1:e1:e1:e1:e1:e1": { "action": "random" } }
        interfaceDictionary.removeValue(forKey: Config.Key.ssids.rawValue)
      }

      // { "e1:e1:e1:e1:e1:e1": { "action": "random", "ssids": { ... } }
      dictionary[interface.hardMAC.address] = interfaceDictionary

      // This compression stuff could be extracted using `compactMapValues`.
      // { "e1:e1:e1:e1:e1:e1": { } }
      if interfaceDictionary.isEmpty {
        // { }
        dictionary.removeValue(forKey: interface.hardMAC.address)
      }

      return dictionary
    }

    ///
    /// Convenience Wrapper if you don't have an ``Interface`` but you have a hardware MAC address.
    ///
    func removeInterfaceSsid(_ hardMAC: String, ssid: String) -> [String: Any] {
      let interface = Interface(hardMAC)
      return removeInterfaceSsid(interface, ssid: ssid)
    }

    func setVendors(vendors: [Vendor]) -> [String: Any] {
      var dictionary = configDictionary

      if vendors.isEmpty {
        dictionary.removeValue(forKey: Config.Key.vendors.rawValue)
      } else {
        dictionary[Config.Key.vendors.rawValue] = Array(Set(vendors)).map { $0.id }
      }

      return dictionary
    }

    func addVendor(_ vendor: Vendor) -> [String: Any] {
      var dictionary = configDictionary
      var currentVendorIds = dictionary[Config.Key.vendors.rawValue] as? [String] ?? []
      currentVendorIds.append(vendor.id)

      dictionary[Config.Key.vendors.rawValue] = Array(Set(currentVendorIds)).sorted().map { $0 }

      return dictionary
    }

    func removeVendor(_ vendor: Vendor) -> [String: Any] {
      var dictionary = configDictionary
      var currentVendorIds = dictionary[Config.Key.vendors.rawValue] as? [String] ?? []
      currentVendorIds.removeAll(where: { $0 == vendor.id })
      let newVendors = Array(Set(currentVendorIds)).sorted().map { $0 }

      if newVendors.isEmpty {
        dictionary.removeValue(forKey: Config.Key.vendors.rawValue)
      } else {
        dictionary[Config.Key.vendors.rawValue] = newVendors
      }

      return dictionary
    }

    func dismissRecommendedSettings() -> [String: Any] {
      var dictionary = configDictionary

      dictionary[Config.Key.recommendation.rawValue] = false

      return dictionary
    }

    // MARK: Private Instance Properties

    private var configDictionary: [String: Any]
  }
}
