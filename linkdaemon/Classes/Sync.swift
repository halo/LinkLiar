// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import CoreWLAN
import Foundation

class Sync {
  // MARK: Class Methods

  init(interface: Interface, arbiter: Config.Arbiter) {
    self.interface = interface
    self.arbiter = arbiter
  }

  // MARK: Public Instance Properties

  var newSoftMAC: MACAddress? {
    switch arbiter.action {
    case .original: return originalize
    case .specify: return specify
    case .random: return randomize
    default:
      Log.debug("Skipping Interface \(interface.BSDName) having calculated action \(arbiter.action)")
      return nil
    }
  }

  // MARK: Private Instance Properties

  private var interface: Interface
  private var arbiter: Config.Arbiter

  // MARK: Private Instance Methods

  private var originalize: MACAddress? {
    guard interface.hasOriginalMAC else {
      Log.debug("Skipping Interface \(interface.BSDName), because it currently has its original MAC address.")
      return nil
    }

    Log.debug("Giving Interface \(interface.BSDName) back its original hardware MAC.")
    return interface.hardMAC
  }

  private var specify: MACAddress? {
    guard let address = arbiter.address else {
      Log.debug("No address was provided for \(interface.BSDName)")
      return nil
    }

    if interface.softMAC == address {
      Log.debug("Interface \(interface.BSDName) is already set to softMAC \(address.humanReadable) - skipping")
      return nil
    }

    return address
  }

  private var randomize: MACAddress? {
    if interface.hasOriginalMAC {
      Log.debug("Randomizing Interface \(interface.BSDName) because it currently has its original MAC address.")
      return RandomMACs.generate()
    }

    return nil
  }

}