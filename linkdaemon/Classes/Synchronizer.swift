// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import CoreWLAN
import Foundation

class Synchronizer {
  func run() {
    Log.debug("Scheduling for synchronization...")

    // Run serially
    queue.sync {
      Log.debug("Synchronizing now...")
      reload()

      for interface in interfaces {
        let arbiter = config.arbiter(interface.hardMAC)
        let sync = Sync(interface: interface, arbiter: arbiter)

        if let newSoftMac = sync.newSoftMAC {
          Ifconfig.Setter(interface.BSDName).setSoftMAC(newSoftMac)
        }
      }
    }
  }

  func mayReRandomize() {
//    if Config.instance.settings.isForbiddenToRerandomize {
//      Log.debug("This was a good chance to re-randomize, but it is disabled.")
//      return
//    }
//
//    for interface in Interfaces.all(async: false) {
//      let action = Config.instance.knownInterface.action(interface.hardMAC)
//
//      guard action == .random else {
//        Log.debug("Not re-randomizing \(interface.BSDName) because it is not defined to be random.")
//        return
//      }
//
//      Log.debug("Taking the chance to re-randomize \(interface.BSDName)")
//      setMAC(BSDName: interface.BSDName, address: RandomMACs.generate())
//    }
  }

  // MARK: Private Instance Properties

  /// Per `DispatchQueue.init` this is a serial queue.
  /// We don't want to read the config and execute ifconfig parallelized.
  ///
  private var queue = DispatchQueue(label: "\(Identifiers.daemon).Synchronizer", qos: .utility)
  private var config: Config.Reader = Config.Reader([:])
  private var interfaces: [Interface] = []

  // MARK: Private Instance Properties

  private func reload() {
    // Read configuration file afresh
    let configDictionary = JSONReader(filePath: Paths.configFile).dictionary
    config = Config.Reader(configDictionary)

    // Query Interfaces afresh
    interfaces = Interfaces.all(asyncSoftMac: false).filter {
      config.policy($0.hardMAC).action != .hide
    }.filter {
      config.policy($0.hardMAC).action != .ignore
    }
  }

//
//  // Internal Methods
//
//  private static func specify(_ interface: Interface) {
//    guard let address = Config.instance.knownInterface.calculatedAddress(interface.hardMAC) else {
//      return
//    }
//    if interface.softMAC == address {
//      Log.debug("Interface \(interface.BSDName) with hardMAC \(interface.hardMAC.humanReadable) and 
//      softMAC \(interface.softMAC.humanReadable) is already set to softMAC \(address.humanReadable) - skipping")
//      return
//    }
//    setMAC(BSDName: interface.BSDName, address: address)
//  }
//
//  private static func originalize(_ interface: Interface) {
//    if interface.hasOriginalMAC {
//      Log.debug("Skipping Interface \(interface.BSDName), because it currently has its original MAC address.")
//      return
//    }
//    Log.debug("Giving Interface \(interface.BSDName) back its original hardware MAC.")
//    setMAC(BSDName: interface.BSDName, address: interface.hardMAC)
//  }
//
//  private static func randomize(_ interface: Interface) {
//    Log.debug("Interface \(interface.BSDName) is specified to be randomized.")
//
//    if interface.hasOriginalMAC {
//      Log.debug("Randomizing Interface \(interface.BSDName) because it currently has its original MAC address.")
//      setMAC(BSDName: interface.BSDName, address: RandomMACs.generate())
//    }
//
//    Log.debug("Checking among these prefixes: \(Config.instance.prefixes.calculatedPrefixes.map { $0.formatted }).")
//    if !Config.instance.prefixes.calculatedPrefixes.contains(interface.softPrefix) {
//      Log.debug("Interface \(interface.BSDName) has an unallowed prefix \(interface.softPrefix) so I'm rerandomizing it now.")
//      setMAC(BSDName: interface.BSDName, address: RandomMACs.generate())
//      return
//    } else {
//      Log.debug("The Interface \(interface.BSDName) has the sanctioned prefix \(interface.softMAC).")
//    }
//
//    guard let undesiredAddress = Config.instance.knownInterface.exceptionAddress(interface.hardMAC) else {
//      Log.debug("Skipping randomization of Interface \(interface.BSDName) because it is already random and no undesired address has been specified.")
//      return
//    }
//
//    if undesiredAddress.isInvalid {
//      Log.debug("Skipping randomization of Interface \(interface.BSDName) because it is already random and the undesired address is invalidly specified.")
//      return
//    }
//
//    if interface.softMAC == undesiredAddress {
//      Log.debug("Randomizing Interface \(interface.BSDName) because it currently has the undesired address \(undesiredAddress.humanReadable).")
//      setMAC(BSDName: interface.BSDName, address: RandomMACs.generate())
//    } else {
//      Log.debug("Skipping randomization of Interface \(interface.BSDName) because it is already random does not have the undesired address \(undesiredAddress.humanReadable).")
//      return
//    }
//  }
}
