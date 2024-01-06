// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import CoreWLAN
import Foundation

class WifiState {
  // MARK: Class Methods

  init(_ BSDName: String) {
    self.BSDName = BSDName
  }

  // MARK: Instance Properties

  /// The BSD Name of a network interface. This property is read-only.
  /// For example `en0` or `en1`.
  private(set) var BSDName: String

  // MARK: Instance Methods

  func prepare() {
    // If this is not a Wi-Fi interface, do nothing.
    guard let interface = getInterface else { return }

    // When a MacBook Wi-Fi is connected to an iPhone hotspot,
    // there is no SSID. So we check the signal strength, to
    // determine whether the Wi-Fi is currently associated.
    guard interface.rssiValue() != 0 else {
      Log.info("\(BSDName) is not connected to any Wi-Fi network")
      return
    }

    // If we are associated, and the access point SSID is known,
    // then we might as well remember it and reconnect to it later.

    // This doesn't work:
    // associatedSsid = interface.ssid()

    associatedSsid = Airport().ssid()

    Log.info("Disassociating Wi-Fi \(BSDName) connection...")

    // Cannot be connected to an access point while changing MAC address.
    // Technically, it would be fine, but ifconfig won't change the MAC
    // address if it sees that the Wi-Fi is currently connected.
    interface.disassociate()
  }

  func restore() {
    // Can only restore Wi-Fi interfaces.
    if getInterface == nil { return }

    // If we don't know the previous SSID, we can't do much.
    // Because, even if we knew the BSSID, we have no way of connecting to it.
    guard let ssid = associatedSsid else {
      Log.debug("You were not associated to an SSID earlier.")
      return
    }

    // Giving the Interface some time before attempting a re-connect to the same network.
    Log.info("Waiting for prior changes to take effect...")
    sleep(3)

    Log.info("Reconnecting to SSID <\(ssid)>")
    let process = Process()
    process.launchPath = "/usr/sbin/networksetup"
    process.arguments = ["-setairportnetwork", BSDName, ssid]
    process.launch()
    process.waitUntilExit()
    Log.info("Am I reconnected?")
    // FIXME: At this very point, the daemon re-randomized the (non-associated) Wi-Fi.
  }

  // MARK: Private Instance Properties

  private var associatedSsid: String?

  lazy private var getInterface: CWInterface? = {
    CWWiFiClient.shared().interface(withName: BSDName)
  }()
}
