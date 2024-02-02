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
//    guard interface.rssiValue() != 0 else {
//      Log.info("\(BSDName) is not connected to any Wi-Fi network")
//      return
//    }

    // If we are associated, and the access point SSID is known,
    // then we might as well remember it and reconnect to it later.

    // This doesn't work:
    // associatedSsid = interface.ssid()

//    associatedSsid = AirportUtility().ssid()

    Log.info("Disassociating Wi-Fi \(BSDName) connection...")

    // Cannot be connected to an access point while changing MAC address.
    // Technically, it would be fine, but ifconfig won't change the MAC
    // address if it sees that the Wi-Fi is currently connected.
    interface.disassociate()
  }

  func restore() {
    // Can only restore Wi-Fi interfaces.
//    if getInterface == nil { return }
//    return

  }

  // MARK: Private Instance Properties

  private var associatedSsid: String?

  lazy private var getInterface: CWInterface? = {
    CWWiFiClient.shared().interface(withName: BSDName)
  }()

  // This only works for passwordless access points.
  private func connectToPublicWifi(_ ssid: String) {
//    Log.info("Attempt to connect to passwordless SSID <\(ssid)>")
//    let process = Process()
//    process.launchPath = "/usr/sbin/networksetup"
//    process.arguments = ["-setairportnetwork", BSDName, ssid]
//    process.run()
//    process.waitUntilExit()
  }

  private func turnWifiOffAndOn() {
////    Log.info("Turning off Wi-Fi")
//    let offProcess = Process()
//    offProcess.launchPath = "/usr/sbin/networksetup"
//    offProcess.arguments = ["-setairportpower", BSDName, "off"]
//    offProcess.run()
//    offProcess.waitUntilExit()
//
////    Log.info("Turning on Wi-Fi")
//    let onProcess = Process()
//    onProcess.launchPath = "/usr/sbin/networksetup"
//    onProcess.arguments = ["-setairportpower", BSDName, "on"]
//    onProcess.run()
//    onProcess.waitUntilExit()
  }
}
