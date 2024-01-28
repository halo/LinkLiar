// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

class Executor {

  func run() {
    Log.debug("Scheduling for synchronization...")

    // Run serially
    DispatchQueue.global(qos: .utility).sync {
      Log.info("Synchronizing Interfaces...")
      reload()

      for interface in interfaces {
        let arbiter = config.arbiter(interface.hardMAC)
        let synchronization = Synchronization(interface: interface, arbiter: arbiter)

        if synchronizations[synchronization.hardMAC.address] == nil {
          // Trusting you'll never physically attach so many interfaces as to run out of memory here.
          Log.debug("Adding \(synchronization.hardMAC.address) to queue")
          synchronizations[synchronization.hardMAC.address] = synchronization
        }

        if let synchronization = synchronizations[synchronization.hardMAC.address] {
          synchronization.update(interface: interface, arbiter: arbiter)
        }
      }

      for synchronization in synchronizations.values {
        Log.debug("Synchronizing \(synchronization.BSDName)")
        synchronization.execute()
      }
    }

    Log.debug("Done synchronizing")
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

  ///
  /// Per `DispatchQueue.init` this is a serial queue.
  /// We don't want to read the config and execute ifconfig parallelized.
  ///
//  private var queue = DispatchQueue(label: "\(Identifiers.daemon).Synchronizer", qos: .utility)
  private var config: Config.Reader = Config.Reader([:])
  private var interfaces: [Interface] = []
  private var synchronizations = [String: Synchronization]()

  // MARK: Private Instance Properties

  private func reload() {
    // Read configuration file afresh
    Log.debug("Reloading configuration...")
    let configDictionary = JSONReader(Paths.configFile).dictionary
    config = Config.Reader(configDictionary)

    // Query Interfaces afresh synchronously
    Log.debug("Reloading Interfaces...")
    interfaces = Interfaces.all(asyncSoftMac: false).filter {
      config.policy($0.hardMAC).action != .hide
    }.filter {
      config.policy($0.hardMAC).action != .ignore
    }
  }

}
