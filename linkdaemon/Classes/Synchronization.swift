// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import CoreWLAN
import Foundation

class Synchronization {
  // MARK: Class Methods

  init(interface: Interface, arbiter: Config.Arbiter) {
    self.interface = interface
    self.arbiter = arbiter
    self.advisor = Advisor(interface: interface, arbiter: arbiter)
  }

  func update(interface: Interface, arbiter: Config.Arbiter) {
    self.interface = interface
    self.arbiter = arbiter
    self.advisor = Advisor(interface: interface, arbiter: arbiter)
  }

  // Ensured to not run in parallel.
  // The ``Executor`` runs single-threadedly.
  func execute() {
    if gracetime > Date.now {
      Log.debug("\(BSDName) idle")
      return
    }

    if let address = advisor.addressForSsid {
      executeSsidBinding(address)
    } else if let address = advisor.addressForStandard {
      executeStandard(address)
    }
  }

  // This is idempodent, no limits on calling this.
  private func executeStandard(_ address: MAC) {
    Log.debug("Standard synchronization of \(interface.bsd.name)")
    Ifconfig.Setter(BSDName).setSoftMAC(address)
  }

  // This is NOT idempodent. Needs to limit itself.
  private func executeSsidBinding(_ address: MAC) {
    Log.debug("SSID synchronization of \(interface.bsd.name)")

//    if gracetime > Date.now {
//      Log.debug("\(BSDName) idle")
//      return
//    } else {
//      Log.debug("\(BSDName) ready")
//    }

    self.gracetime = Date(timeIntervalSinceNow: 4)
    Ifconfig.Setter(BSDName).setSoftMAC(address)
  }

  var hardMAC: MAC { interface.hardMAC }
  var BSDName: String { interface.bsd.name }
  var advisor: Advisor
  private var gracetime = Date(timeIntervalSinceReferenceDate: 0)

  // MARK: Private Instance Properties

  private var interface: Interface
  private var arbiter: Config.Arbiter
}
