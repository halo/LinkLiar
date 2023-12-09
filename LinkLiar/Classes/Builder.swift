// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation
import os.log

extension Configuration {
  struct Builder {

    // MARK: Class Methods

    init(_ dictionary: [String: Any]) {
      self.configDictionary = dictionary
    }

    // MARK: Instance Methods

    func addInterfaceSsid(_ interface: Interface, accessPointPolicy: AccessPointPolicy) -> [String: Any] {
      var dictionary = configDictionary

      // Adding "Coffeeshop"

      // { "action": "random", ... } or {}
      var interfaceDictionary = dictionary[interface.hardMAC.formatted] as? [String: Any] ?? [:]
      // { "Existing SSID": "aa:aa:aa:aa:aa:aa" } or {}
      var ssidsDictionary = interfaceDictionary[Configuration.Key.ssids.rawValue] as? [String: String] ?? [:]
      // { "Existing SSID": "aa:aa:aa:aa:aa:aa", "Coffeeshop": "aa:aa:aa:aa:aa:aa" }
      ssidsDictionary[accessPointPolicy.ssid] = accessPointPolicy.softMAC.formatted
      // { "action": "random", "ssids": { "Existing SSID": "aa:aa:aa:aa:aa:aa", "Coffeeshop": "aa:aa:aa:aa:aa:aa" } }
      interfaceDictionary[Configuration.Key.ssids.rawValue] = ssidsDictionary
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
      var ssidsDictionary = interfaceDictionary[Configuration.Key.ssids.rawValue] as? [String: String] ?? [:]
      // { "Existing SSID": "aa:aa:aa:aa:aa:aa" } or {}
      ssidsDictionary.removeValue(forKey: ssid)

      // { "action": "random", "ssids": { "Existing SSID": "aa:aa:aa:aa:aa:aa" } }
      interfaceDictionary[Configuration.Key.ssids.rawValue] = ssidsDictionary

      // { "e1:e1:e1:e1:e1:e1": { "action": "random", ssids: {} } }
      if ssidsDictionary.isEmpty {
        // { "e1:e1:e1:e1:e1:e1": { "action": "random" } }
        interfaceDictionary.removeValue(forKey: Configuration.Key.ssids.rawValue)
      }

      // { "e1:e1:e1:e1:e1:e1": { "action": "random", "ssids": { ... } }
      dictionary[interface.hardMAC.formatted] = interfaceDictionary

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
