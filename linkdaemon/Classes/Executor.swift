// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

class Executor {
  func run() {
    Log.debug("Scheduling for synchronization...")

    queued {
      // Per interface, we can parallelize the work.
      // To check if all interfaces have finished, we need a group.
      Log.debug("Entering dispatch group for \(self.interfaces.count) Interfaces...")
      let group = DispatchGroup()

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
    guard self.config.general.isRerandomize else {
      Log.debug("This was a good chance to re-randomize, but it is disabled.")
      return
    }

    queued {

      Log.debug("Entering dispatch group for \(self.interfaces.count) Interfaces...")
      let group = DispatchGroup()

      for interface in self.interfaces {
        group.enter()

        Log.info("Checking rerandomization for Interface \(interface.bsd.name)")
        let arbiter = self.config.arbiter(interface.hardMAC)

        if arbiter.action == .random {
          Log.debug("Taking the chance to re-randomize \(interface.bsd.name)")
          Ifconfig.Setter(interface.bsd.name).setSoftMAC(arbiter.randomAddress())
        } else {
          Log.debug("Not re-randomizing \(interface.bsd.name) because it is not defined to be random.")
        }
        group.leave()
      }

      Log.debug("Waiting for interfaces to finish rerandomizing")
      let deadline = DispatchTime.now() + .seconds(3)

      if group.wait(timeout: deadline) == .success {
        Log.debug("Done rerandomizing")
      } else {
        Log.error("Rerandomization timed out!")
      }
    }
  }

  // MARK: Private Instance Properties

  private var config: Config.Reader = Config.Reader([:])
  private var interfaces: [Interface] = []
  private var synchronizations = [String: Synchronization]()
  private let executorQueue = DispatchQueue(label: "\(Identifiers.daemon).serialExecutorQueue")
  private let interfaceQueue = DispatchQueue(label: "\(Identifiers.daemon).parallelInterfaceQueue", attributes: .concurrent)

  // MARK: Private Instance Properties

  private func queued(_ block: () -> Void) {
    // ...because we don't want race-conditions when reading the configuration file
    // and comparing that with the currently attached hardware interfaces.
    executorQueue.sync {
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

      block()
    }
  }

}
