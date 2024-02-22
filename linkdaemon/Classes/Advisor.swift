// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import CoreWLAN
import Foundation

struct Advisor {
  // MARK: Class Methods

  init(interface: Interface, arbiter: Config.Arbiter) {
    self.interface = interface
    self.arbiter = arbiter
  }

  var address: MAC? {
    if let override = addressForSsid() { return override }

    switch arbiter.action {
    case .original: return originalize
    case .specify: return specify
    case .random: return randomize
    default:
      Log.debug("Skipping Interface \(interface.bsd.name) having action \(arbiter.action)")
      return nil
    }
  }

  private func addressForSsid() -> MAC? {
    // No need to scan for networks, if this interface doesn't care.
    guard let accessPointPolicies = arbiter.accessPointPolicies else { return nil }
    guard arbiter.mayScan else {
      Log.debug("Won't scan for networks..")
      return nil
    }

    // This takes several seconds.
    Log.debug("Attempting to scan for networks...")

    let accessPoints = Airport.Scanner().accessPoints()
    guard !accessPoints.isEmpty else {
      Log.debug("There are no access points in the air.")
      return nil
    }

    Log.debug("Found \(accessPoints.count) access points in the air.")

    // I think that there usually are more access points in the air,
    // than there are defined policies in the configuration file.

    // That's why we look at each policy and compare it with all access points.
    // There would likely be more work to look at each access point
    // and compare it with all policies.

    // Let's see if one of the user-defined policies matches a found network.
    for accessPointPolicy in accessPointPolicies {
      Log.debug("Comparing policy \(accessPointPolicy.ssid) with \(accessPoints.count) access points.")
      guard accessPoints.contains(where: { $0.ssid == accessPointPolicy.ssid }) else { continue }
      Log.debug("There was a match on \(accessPointPolicy.ssid)")

      return accessPointPolicy.softMAC
    }

    return nil
  }

  // MARK: Private Instance Properties

  private var interface: Interface
  private var arbiter: Config.Arbiter

  private var originalize: MAC? {
    guard interface.hasOriginalMAC else {
      Log.debug("Skipping Interface \(interface.bsd.name), because it currently has its original MAC address.")
      return nil
    }

    Log.debug("Giving Interface \(interface.bsd.name) back its original hardware MAC.")
    return interface.hardMAC
  }

  private var specify: MAC? {
    guard let address = arbiter.address else {
      Log.debug("No address was provided for \(interface.bsd.name)")
      return nil
    }

    if interface.softMAC == address {
      Log.debug("Interface \(interface.bsd.name) is already set to softMAC \(address.address) - skipping")
      return nil
    }

    return address
  }

  private var randomize: MAC? {
    if interface.hasOriginalMAC {
      Log.debug("Randomizing Interface \(interface.bsd.name) because it currently has its original MAC address.")
      return arbiter.randomAddress()
    }

    if !arbiter.prefixes.contains(interface.softOUI) {
      Log.debug("Interface \(interface.bsd.name) has an unallowed prefix \(interface.softOUI.address) randomizing.")
      return arbiter.randomAddress()
    }
//    else {
//      Log.debug("The Interface \(interface.bsd.name) has the sanctioned prefix \(interface.softPrefix.formatted).")
//    }

    guard let undesiredAddress = arbiter.exceptionAddress else {
      Log.debug("\(interface.bsd.name) is already random and no undesired address was specified.")
      return nil
    }

    if interface.softMAC == undesiredAddress {
      Log.debug("Randomizing \(interface.bsd.name) because it has undesired address \(undesiredAddress.address).")
      return arbiter.randomAddress()
    }

    Log.debug("\(interface.bsd.name) is already random but not undesired address \(undesiredAddress.address).")

    return nil
  }
}
