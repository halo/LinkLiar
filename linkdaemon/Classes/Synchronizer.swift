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
}
