// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

class Executor {

  /// <#Description#>
  func run() {
    Log.debug("Scheduling for synchronization...")

    // Any given synchronization run runs serially...
    //    let executorgroup = DispatchGroup()
    //    group.enter()

    executorQueue.sync {
      // ...because we don't want race-conditions when reading the configuration file
      // and comparing that with the currently attached hardware interfaces.
      reload()

      // However, per interface, we can parallelize the work.
      // To check if all interfaces have finished, we need a group.
      let group = DispatchGroup()
      Log.debug("Entering dispatch group for \(self.interfaces.count) Interfaces...")

      for interface in self.interfaces {
        group.enter()

        // Parallelization is especially needed if we're scanning for SSIDS,
        // which, serially, would take 3 seconds per Interface.
        interfaceQueue.async {

          Log.info("Synchronizing Interface \(interface.bsd.name)")
          let arbiter = self.config.arbiter(interface.hardMAC)
          Synchronization(interface: interface, arbiter: arbiter).run()

          // Inform the group, that this particular interface finished its synchronization.
          group.leave()
        }
      }

      Log.debug("Waiting for interfaces to finish synchronizing")
      let deadline = DispatchTime.now() + .seconds(15)
      if group.wait(timeout: deadline) == .success {
        Log.debug("Done synchronizing")
      } else {
        Log.error("Synchronization timed out!")
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
    //        Log.debug("Not re-randomizing \(interface.bsd.name) because it is not defined to be random.")
    //        return
    //      }
    //
    //      Log.debug("Taking the chance to re-randomize \(interface.bsd.name)")
    //      setMAC(BSDName: interface.bsd.name, address: RandomMACs.generate())
    //    }
  }

  // MARK: Private Instance Properties

  ///
  /// Per `DispatchQueue.init` this is a serial queue.
  /// We don't want to read the config and execute ifconfig parallelized.
  ///
  ///  private var queue = DispatchQueue(label: "\(Identifiers.daemon).Synchronizer", qos: .utility)
  private var config: Config.Reader = Config.Reader([:])
  private var interfaces: [Interface] = []
  private var synchronizations = [String: Synchronization]()
  private let executorQueue = DispatchQueue(label: "\(Identifiers.daemon).serialExecutorQueue")
  private let interfaceQueue = DispatchQueue(label: "\(Identifiers.daemon).parallelInterfaceQueue", attributes: .concurrent)

  // MARK: Private Instance Properties

  private func reload() {
    // Read configuration file afresh
    Log.debug("Reloading configuration...")
    let configDictionary = JSONReader(Paths.configFile).dictionary
    config = Config.Reader(configDictionary)

    // Query Interfaces afresh synchronously
    Log.debug("Reloading Interfaces...")
    interfaces = Interfaces.all(.sync).filter {
      config.policy($0.hardMAC).action != .hide
    }.filter {
      config.policy($0.hardMAC).action != .ignore
    }
  }

}
