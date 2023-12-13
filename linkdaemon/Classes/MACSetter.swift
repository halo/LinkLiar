// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import CoreWLAN
import Foundation

class MACSetter {
  static func setMAC(BSDName: String, address: MACAddress) {
    guard address.isValid else {
      Log.info("Cannot apply MAC <\(address.humanReadable)> because it is not valid.")
      return
    }

    let associatedSsid = CWWiFiClient.shared().interface()?.ssid()

    if associatedSsid == nil {
      Log.info("You are not associated to any network.")
    } else {
      Log.info("Disassociating current Wi-Fi connection...")
      CWWiFiClient.shared().interface()?.disassociate()
    }

    Log.info("Setting MAC address <\(address.humanReadable)> for Interface \(BSDName)...")
    let task = Process()
    task.launchPath = "/sbin/ifconfig"
    task.arguments = [BSDName, "ether", address.formatted]
    task.launch()

    if let ssid = associatedSsid {
      // Giving the Interface some time before attempting a re-connect to the same network.
      Log.info("Waiting for changes to take effect...")
      sleep(1)
      Log.info("Reconnecting to SSID <\(ssid)>")

      let task = Process()
      task.launchPath = "/usr/sbin/networksetup"
      task.arguments = ["-setairportnetwork", BSDName, ssid]
      task.launch()
    }
  }
}
