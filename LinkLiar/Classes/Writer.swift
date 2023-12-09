// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation
// import os.log

extension Configuration {
  struct Writer {

    // MARK: Class Methods

    init(_ state: LinkState) {
      self.state = state
    }

    func addInterfaceSsid(interface: Interface, ssid: String, address: String) {
      guard let accessPointPolicy = Configuration.AccessPointPolicy
        .initIfValid(ssid: ssid, softMAC: address) else { return }

      var newDictionary = Configuration.Builder(state.configDictionary).addInterfaceSsid(
        interface,
        accessPointPolicy: accessPointPolicy)

      newDictionary["version"] = state.version.formatted
      if JSONWriter(filePath: Paths.configFile).write(newDictionary) {
        state.configDictionary = newDictionary
      }
    }

    func removeInterfaceSsid(interface: Interface, ssid: String) {
      var newDictionary = Configuration.Builder(state.configDictionary).removeInterfaceSsid(
        interface,
        ssid: ssid)

      newDictionary["version"] = state.version.formatted
      if JSONWriter(filePath: Paths.configFile).write(newDictionary) {
        state.configDictionary = newDictionary
      }
    }

    // MARK: TODO

    func setInterfaceActionHiddenness(interface: Interface, isHidden: Bool) {
      let newAction = isHidden ? Interface.Action.hide : Interface.Action.ignore
      setInterfaceAction(interface: interface, action: newAction)
    }

    func setInterfaceActionIgnoredness(interface: Interface, isIgnored: Bool) {
      let newAction = isIgnored ? Interface.Action.ignore : nil
      setInterfaceAction(interface: interface, action: newAction)
    }

    func TESTremoveInterfaceSsid(interface: Interface, ssid: String) {
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

    // MARK: Private Class Methods

    func setInterfaceAction(interface: Interface, action: Interface.Action?) {
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

    func setInterfaceAddress(interface: Interface, address: MACAddress) {
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

    func setFallbackInterfaceAction(action: Interface.Action?) {
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

    // MARK: Private Instance Properties

    private var state: LinkState

  }
}
