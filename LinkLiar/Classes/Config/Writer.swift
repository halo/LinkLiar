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

      newDictionary[Config.Key.version.rawValue] = state.version.formatted
      if JSONWriter(Paths.configFile).write(newDictionary) {
        state.configDictionary = newDictionary
      }
    }

    func removeInterfaceSsid(interface: Interface, ssid: String) {
      var newDictionary = Config.Builder(state.configDictionary).removeInterfaceSsid(
        interface,
        ssid: ssid)

      newDictionary[Config.Key.version.rawValue] = state.version.formatted
      if JSONWriter(Paths.configFile).write(newDictionary) {
        state.configDictionary = newDictionary
      }
    }

    func resetExceptionAddress(interface: Interface) {
      var newDictionary = Config.Builder(state.configDictionary).resetExceptionAddress(interface)

      newDictionary[Config.Key.version.rawValue] = state.version.formatted
      if JSONWriter(Paths.configFile).write(newDictionary) {
        state.configDictionary = newDictionary
      }

      // This is one of the rare occasions where the background daemon changes a MAC address
      // while the GUI is open and showing that address. The GUI has no way of knowing that
      // the address was changed (it doesn't trigger a network condition change or config file change).
      // So we resort to polling, to give the user visual feedback about the successful change.
      // Less than a second should be enough to have detected the change.
      for millisecond in [100, 300, 500, 700] {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(millisecond)) {
          NotificationCenter.default.post(name: .manualTrigger, object: nil)
        }
      }
    }

//    func setVendors(vendors: [Vendor]) {
//      var newDictionary = Config.Builder(state.configDictionary).setVendors(vendors: vendors)
//
//      newDictionary[Config.Key.version.rawValue] = state.version.formatted
//      if JSONWriter(Paths.configFile).write(newDictionary) {
//        state.configDictionary = newDictionary
//      }
//    }

    func addVendor(_ vendor: Vendor) {
      var newDictionary = Config.Builder(state.configDictionary).addVendor(vendor)

      newDictionary[Config.Key.version.rawValue] = state.version.formatted
      if JSONWriter(Paths.configFile).write(newDictionary) {
        state.configDictionary = newDictionary
      }
    }

    func removeVendor(_ vendor: Vendor) {
      var newDictionary = Config.Builder(state.configDictionary).removeVendor(vendor)

      newDictionary[Config.Key.version.rawValue] = state.version.formatted
      if JSONWriter(Paths.configFile).write(newDictionary) {
        state.configDictionary = newDictionary
      }
    }

    func setInterfaceActionHiddenness(interface: Interface, isHidden: Bool) {
      let newAction = isHidden ? Interface.Action.hide : Interface.Action.ignore
      setInterfaceAction(interface: interface, action: newAction)
    }

    func setInterfaceActionIgnoredness(interface: Interface, isIgnored: Bool) {
      let newAction = isIgnored ? Interface.Action.ignore : nil
      setInterfaceAction(interface: interface, action: newAction)
    }

    func setInterfaceAction(interface: Interface, action: Interface.Action?) {
      var newDictionary = Config.Builder(state.configDictionary).setInterfaceAction(
        interface,
        action: action)

      newDictionary[Config.Key.version.rawValue] = state.version.formatted
      if JSONWriter(Paths.configFile).write(newDictionary) {
        state.configDictionary = newDictionary
      }
    }

    func setInterfaceAddress(interface: Interface, address: MACAddress) {
      var newDictionary = Config.Builder(state.configDictionary).setInterfaceAddress(
        interface,
        address: address)

      newDictionary[Config.Key.version.rawValue] = state.version.formatted
      if JSONWriter(Paths.configFile).write(newDictionary) {
        state.configDictionary = newDictionary
      }
    }

    func setFallbackInterfaceAction(_ action: Interface.Action?) {
      var newDictionary = Config.Builder(state.configDictionary).setFallbackInterfaceAction(action)

      newDictionary[Config.Key.version.rawValue] = state.version.formatted
      if JSONWriter(Paths.configFile).write(newDictionary) {
        state.configDictionary = newDictionary
      }
    }

    // MARK: Private Instance Properties

    private var state: LinkState
  }
}
