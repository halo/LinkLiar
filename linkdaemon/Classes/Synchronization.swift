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

  func run() {
    if let address = advisor.address {
      Ifconfig.Setter(BSDName).setSoftMAC(address)
    } else {
      Log.debug("Nothing to do for \(interface.hardMAC)")
    }
  }

  var hardMAC: MAC { interface.hardMAC }
  var BSDName: String { interface.bsd.name }
  var advisor: Advisor

  // MARK: Private Instance Properties

  private var interface: Interface
  private var arbiter: Config.Arbiter
}
