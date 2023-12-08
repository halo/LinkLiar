// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation
import os.log

class ConfigWriter {

  // MARK: Class Methods

  static func setInterfaceActionHiddenness(interface: Interface, isHidden: Bool, state: LinkState) {
    let newAction = isHidden ? Interface.Action.hide : Interface.Action.ignore
    setInterfaceAction(interface: interface, action: newAction, state: state)
  }

  static func setInterfaceActionIgnoredness(interface: Interface, isIgnored: Bool, state: LinkState) {
    let newAction = isIgnored ? Interface.Action.ignore : nil
    setInterfaceAction(interface: interface, action: newAction, state: state)
  }

  static func removeInterfaceSsid(interface: Interface, ssid: String, state: LinkState) {
    var dictionary = state.configDictionary
    dictionary["version"] = state.version.formatted

    var ssidDictionary: [String: String] = [:]
    let key = "ssids:\(interface.hardMAC.humanReadable)"

    ssidDictionary = dictionary[key] as? [String: String] ?? [:]
    ssidDictionary.removeValue(forKey: ssid)
    dictionary[key] = ssidDictionary

    if ssidDictionary.isEmpty {
      Log.debug("Removing unused SSID policy \(key)")
      dictionary.removeValue(forKey: key)
    }

    Log.debug("Writing \(dictionary)")
    print(dictionary)
    if JSONWriter(filePath: Paths.configFile).write(dictionary) {
      state.configDictionary = dictionary
    }
  }

  static func addInterfaceSsid(interface: Interface, ssid: String, address: String, state: LinkState) {
    guard !ssid.isEmpty else { return }
    guard let macAddress = MACAddress.initIfValid(address) else { return }

    var dictionary = state.configDictionary
    dictionary["version"] = state.version.formatted
    let key = "ssids:\(interface.hardMAC.humanReadable)"

    let defaultSsidDictionary = [ssid: macAddress.formatted]
    var ssidsDictionary = dictionary[key] as? [String: String] ?? defaultSsidDictionary
    ssidsDictionary.updateValue(macAddress.formatted, forKey: ssid)
    dictionary[key] = ssidsDictionary

    if JSONWriter(filePath: Paths.configFile).write(dictionary) {
      state.configDictionary = dictionary
    }
  }

  // MARK: Private Class Methods

  static func setInterfaceAction(interface: Interface, action: Interface.Action?, state: LinkState) {
    var dictionary = state.configDictionary
    dictionary["version"] = state.version.formatted

    var interfaceDictionary: [String: String] = [:]

    if action == nil {
      interfaceDictionary = dictionary[interface.hardMAC.formatted] as? [String: String] ?? [:]
      interfaceDictionary.removeValue(forKey: "action")
      Log.debug("Removing action of Interface \(interface.hardMAC.formatted)")
    } else {
      if let newAction = action?.rawValue {
        Log.debug("Changing action of Interface \(interface.hardMAC.formatted) to \(newAction)")
        interfaceDictionary = dictionary[interface.hardMAC.formatted] as? [String: String] ?? ["action": newAction]
        interfaceDictionary.updateValue(newAction, forKey: "action")
      }
    }

    if interfaceDictionary.isEmpty {
      Log.debug("Removing unused Interface policy \(interface.hardMAC.formatted)")
      dictionary.removeValue(forKey: interface.hardMAC.formatted)
    } else {
      dictionary[interface.hardMAC.formatted] = interfaceDictionary
    }

    if JSONWriter(filePath: Paths.configFile).write(dictionary) {
      state.configDictionary = dictionary
    }
  }

  static func setInterfaceAddress(interface: Interface, address: MACAddress, state: LinkState) {
    guard address.isValid else {
      return
    }

    var dictionary = state.configDictionary
    dictionary["version"] = state.version.formatted

    var interfaceDictionary: [String: String] = [:]

    let newAddress = address.formatted

    Log.debug("Changing address of Interface \(interface.hardMAC.formatted) to \(newAddress)")
    interfaceDictionary = dictionary[interface.hardMAC.formatted] as? [String: String] ?? ["address": newAddress]
    interfaceDictionary.updateValue(newAddress, forKey: "address")

    if interfaceDictionary.isEmpty {
      Log.debug("Removing unused Interface policy \(interface.hardMAC.formatted)")
      dictionary.removeValue(forKey: interface.hardMAC.formatted)
    } else {
      dictionary[interface.hardMAC.formatted] = interfaceDictionary
    }

    if JSONWriter(filePath: Paths.configFile).write(dictionary) {
      state.configDictionary = dictionary
    }
  }

  static func setFallbackInterfaceAction(action: Interface.Action?, state: LinkState) {
    var dictionary = state.configDictionary
    dictionary["version"] = state.version.formatted

    var interfaceDictionary: [String: String] = [:]

    if action == nil {
      interfaceDictionary = dictionary["default"] as? [String: String] ?? [:]
      interfaceDictionary.removeValue(forKey: "action")
      Log.debug("Removing action of fallback Interface")
    } else {
      if let newAction = action?.rawValue {
        Log.debug("Changing fallback action to \(newAction)")
        interfaceDictionary = dictionary["default"] as? [String: String] ?? ["action": newAction]
        interfaceDictionary.updateValue(newAction, forKey: "action")
      }
    }

    if interfaceDictionary.isEmpty {
      Log.debug("Removing unused fallback policy")
      dictionary.removeValue(forKey: "default")
    } else {
      dictionary["default"] = interfaceDictionary
    }

    if JSONWriter(filePath: Paths.configFile).write(dictionary) {
      state.configDictionary = dictionary
    }
  }
}
