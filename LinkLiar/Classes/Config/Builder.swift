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
        interfaceDictionary = dictionary[interface.hardMAC.formatted] as? [String: String] ?? [:]
        interfaceDictionary.removeValue(forKey: "action")
      } else {
        if let newAction = action?.rawValue {
          interfaceDictionary = dictionary[interface.hardMAC.formatted] as? [String: String] ?? ["action": newAction]
          interfaceDictionary["action"] = newAction
        }
      }

      if interfaceDictionary.isEmpty {
        dictionary.removeValue(forKey: interface.hardMAC.formatted)
      } else {
        dictionary[interface.hardMAC.formatted] = interfaceDictionary
      }

      return dictionary
    }

    func addInterfaceSsid(_ interface: Interface, accessPointPolicy: AccessPointPolicy) -> [String: Any] {
      var dictionary = configDictionary

      // Adding "Coffeeshop"

      // { "action": "random", ... } or {}
      var interfaceDictionary = dictionary[interface.hardMAC.formatted] as? [String: Any] ?? [:]
      // { "Existing SSID": "aa:aa:aa:aa:aa:aa" } or {}
      var ssidsDictionary = interfaceDictionary[Config.Key.ssids.rawValue] as? [String: String] ?? [:]
      // { "Existing SSID": "aa:aa:aa:aa:aa:aa", "Coffeeshop": "aa:aa:aa:aa:aa:aa" }
      ssidsDictionary[accessPointPolicy.ssid] = accessPointPolicy.softMAC.formatted
      // { "action": "random", "ssids": { "Existing SSID": "aa:aa:aa:aa:aa:aa", "Coffeeshop": "aa:aa:aa:aa:aa:aa" } }
      interfaceDictionary[Config.Key.ssids.rawValue] = ssidsDictionary
      // { "e1:e1:e1:e1:e1:e1": { "action": "random", "ssids": { ... } }
      dictionary[interface.hardMAC.formatted] = interfaceDictionary

      return dictionary
    }

    func removeInterfaceSsid(_ interface: Interface, ssid: String) -> [String: Any] {
      var dictionary = configDictionary

      // Removing "Coffeeshop".

      // { "action": "random", ... } or {}
      var interfaceDictionary = dictionary[interface.hardMAC.formatted] as? [String: Any] ?? [:]
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
      dictionary[interface.hardMAC.formatted] = interfaceDictionary

      // This compression stuff could be extracted using `compactMapValues`.
      // { "e1:e1:e1:e1:e1:e1": { } }
      if interfaceDictionary.isEmpty {
        // { }
        dictionary.removeValue(forKey: interface.hardMAC.formatted)
      }

      return dictionary
    }

    /// Convenience Wrapper if you don't have an ``Interface`` but you have a hardware MAC address.
    func removeInterfaceSsid(_ hardMAC: String, ssid: String) -> [String: Any] {
      let interface = Interface("e1:e1:e1:e1:e1:e1")
      return removeInterfaceSsid(interface, ssid: ssid)
    }

    // MARK: Private Instance Properties

    private var configDictionary: [String: Any]
  }
}
