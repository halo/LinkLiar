// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

/// A Wi-Fi access point, usually a router.
///
struct AccessPoint: Identifiable {
  // MARK: - Class Methods

  init?(ssid: String, bssid: String) {
    guard let validSSID = SSID(ssid) else { return nil }
    guard let validBSSID = MACAddress(bssid) else { return nil }

    self.ssid = validSSID
    self.bssid = validBSSID
  }

  init(ssid: SSID, bssid: MACAddress) {
    self.ssid = ssid
    self.bssid = bssid
  }

  // MARK: - Instance Properties

  let ssid: SSID
  let bssid: MACAddress

  /// Conforming to `Identifiable`.
  var id: String { bssid.address }
}

extension AccessPoint: Comparable {
  static func == (lhs: AccessPoint, rhs: AccessPoint) -> Bool {
    lhs.ssid == rhs.ssid
  }

  static func < (lhs: AccessPoint, rhs: AccessPoint) -> Bool {
    lhs.ssid < rhs.ssid
  }
}
