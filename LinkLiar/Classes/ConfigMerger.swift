// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation
import os.log

class ConfigMerger {

  // MARK: Class Methods

  static func addInterfaceSsid(interface: Interface, accessPointPolicy: Configuration.AccessPointPolicy, state: LinkState) -> [String: Any] {
    var dictionary = state.configDictionary
    dictionary["version"] = state.version.formatted

    // { "action": "random", ... } or {}
    var interfaceDictionary = dictionary[interface.hardMAC.formatted] as? [String: Any] ?? [:]
    // { "Existing SSID": "aa:aa:aa:aa:aa:aa" } or {}
    let ssidsDictionary = interfaceDictionary[Configuration.Key.ssids.rawValue] as? [String: String] ?? [:]
    // { "Coffeeshop": "aa:aa:aa:aa:aa:aa" }
    let minimalSsidDictionary = [accessPointPolicy.ssid: accessPointPolicy.softMAC.formatted]
    // { "Existing SSID": "aa:aa:aa:aa:aa:aa", "Coffeeshop": "aa:aa:aa:aa:aa:aa" }
    let newSsidsDictionary = ssidsDictionary.merging(minimalSsidDictionary) { (_, new) in new }
    // { "action": "random", "ssids": { "Existing SSID": "aa:aa:aa:aa:aa:aa", "Coffeeshop": "aa:aa:aa:aa:aa:aa" } }
    interfaceDictionary.updateValue(newSsidsDictionary, forKey: Configuration.Key.ssids.rawValue)
    // { "e1:e1:e1:e1:e1:e1": { "action": "random", "ssids": { ... } }
    dictionary.updateValue(interfaceDictionary, forKey: interface.hardMAC.formatted)

    return dictionary
  }
}
