// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import CoreWLAN
import Foundation

class Advisor {
  // MARK: Class Methods

  init(interface: Interface, arbiter: Config.Arbiter) {
    self.interface = interface
    self.arbiter = arbiter
  }

  var addressForStandard: MACAddress? {
    switch arbiter.action {
    case .original: return originalize
    case .specify: return specify
    case .random: return randomize
    default:
      Log.debug("Skipping Interface \(interface.BSDName) having action \(arbiter.action)")
      return nil
    }
  }

  var addressForSsid: MACAddress? {
    guard arbiter.action == .original || arbiter.action == .specify || arbiter.action == .random else {
      // An SSID-MAC binding can for example not affect ignored or hidden interfaces.
      Log.debug("\(interface.BSDName) with action \(arbiter.action) not applicable for SSID-MAC binding")
      return nil
    }

    return nil

//    guard let ssid = Airport.Connection.ssid else {
//      Log.debug("\(interface.BSDName) not associated to an SSID")
//      return nil
//    }
//
//    guard let newMAC = arbiter.addressForSsid(ssid) else {
//      Log.debug("\(interface.BSDName) has no SSID-MAC binding")
//      return nil
//    }
//
//    Log.info("\(interface.BSDName) associated to \(ssid) wants MAC \(newMAC.formatted)")
//    return newMAC
  }

  // MARK: Private Instance Properties

  private var interface: Interface
  private var arbiter: Config.Arbiter

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
      return arbiter.randomAddress()
    }

    if !arbiter.prefixes.contains(interface.softPrefix) {
      Log.debug("Interface \(interface.BSDName) has an unallowed prefix \(interface.softPrefix.formatted) randomizing.")
      return arbiter.randomAddress()
    }
//    else {
//      Log.debug("The Interface \(interface.BSDName) has the sanctioned prefix \(interface.softPrefix.formatted).")
//    }

    guard let undesiredAddress = arbiter.exceptionAddress else {
      Log.debug("\(interface.BSDName) is already random and no undesired address was specified.")
      return nil
    }

    if interface.softMAC == undesiredAddress {
      Log.debug("Randomizing \(interface.BSDName) because it has undesired address \(undesiredAddress.humanReadable).")
      return arbiter.randomAddress()
    }

    Log.debug("\(interface.BSDName) is already random but not undesired address \(undesiredAddress.humanReadable).")

    return nil
  }
}
