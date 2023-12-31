// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation
// import os.log

extension Config {
  struct Writer {
    // MARK: Class Methods

    init(_ state: LinkState) {
      self.state = state
    }

    func addInterfaceSsid(interface: Interface, ssid: String, address: String) {
      guard let accessPointPolicy = Config.AccessPointPolicy
        .initIfValid(ssid: ssid, softMAC: address) else { return }

      var newDictionary = Config.Builder(state.configDictionary).addInterfaceSsid(
        interface,
        accessPointPolicy: accessPointPolicy)

      newDictionary["version"] = state.version.formatted
      if JSONWriter(Paths.configFile).write(newDictionary) {
        state.configDictionary = newDictionary
      }
    }

    func removeInterfaceSsid(interface: Interface, ssid: String) {
      var newDictionary = Config.Builder(state.configDictionary).removeInterfaceSsid(
        interface,
        ssid: ssid)

      newDictionary["version"] = state.version.formatted
      if JSONWriter(Paths.configFile).write(newDictionary) {
        state.configDictionary = newDictionary
      }
    }

    func resetExceptionAddress(interface: Interface) {
      var newDictionary = Config.Builder(state.configDictionary).resetExceptionAddress(interface)

      newDictionary["version"] = state.version.formatted
      if JSONWriter(Paths.configFile).write(newDictionary) {
        state.configDictionary = newDictionary
      }
    }

    func setVendors(vendors: [Vendor]) {
      var newDictionary = Config.Builder(state.configDictionary).setVendors(vendors: vendors)

      newDictionary["version"] = state.version.formatted
      if JSONWriter(Paths.configFile).write(newDictionary) {
        state.configDictionary = newDictionary
      }
    }

    // MARK: TODO below this line

    func setInterfaceActionHiddenness(interface: Interface, isHidden: Bool) {
      let newAction = isHidden ? Interface.Action.hide : Interface.Action.ignore
      setInterfaceAction(interface: interface, action: newAction)
    }

    func setInterfaceActionIgnoredness(interface: Interface, isIgnored: Bool) {
      let newAction = isIgnored ? Interface.Action.ignore : nil
      setInterfaceAction(interface: interface, action: newAction)
    }

    // MARK: Private Class Methods

    func setInterfaceAction(interface: Interface, action: Interface.Action?) {
      var newDictionary = Config.Builder(state.configDictionary).setInterfaceAction(
        interface,
        action: action)

      newDictionary["version"] = state.version.formatted
      if JSONWriter(Paths.configFile).write(newDictionary) {
        state.configDictionary = newDictionary
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

      if JSONWriter(Paths.configFile).write(dictionary) {
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

      if JSONWriter(Paths.configFile).write(dictionary) {
        state.configDictionary = dictionary
      }
    }

    // MARK: Private Instance Properties

    private var state: LinkState
  }
}
