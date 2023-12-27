// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import CoreWLAN
import Foundation

// Because the soft-MAC is queried asynchronously.
// We need SwiftUI to know that the Interface instance
// may change its properties at some point in the future.
@Observable

class Interface: Identifiable {
  // MARK: Class Methods

  init(_ hardMAC: String) {
    self._hardMAC = hardMAC
  }

  /// Upon initialization we assign what we already know.
  init(BSDName: String, displayName: String, kind: String, hardMAC: String, async: Bool) {
    self.BSDName = BSDName

    // Not sure why, but some Ethernet interfaces have this reduntantly in their name
    self.displayName = displayName
      .replacingOccurrences(of: "(en0)", with: "")
      .replacingOccurrences(of: "(en1)", with: "")
      .replacingOccurrences(of: "(en2)", with: "")
      .replacingOccurrences(of: "(en3)", with: "")
      .replacingOccurrences(of: "(en4)", with: "")
      .replacingOccurrences(of: "(en5)", with: "")
      .replacingOccurrences(of: "(en6)", with: "")
      .trimmingCharacters(in: .whitespaces)
    self.kind = kind
    self._hardMAC = hardMAC
    self._softMAC = ""

    // No need to lookup a soft MAC if it cannot be modified.
    if !isSpoofable { return }
    querySoftMAC(async: async)
  }

  // MARK: Instance Properties

  /// Conforming to `Identifiable`.
  /// The only truly long-term unique identifier is the hardware MAC of an Interface.
  /// In the unlikely case that it's unavailable, fall back to something like `en0`.
  var id: String { hardMAC.isValid ? hardMAC.formatted : BSDName }

  // These attributes are known instantaneously when querying the operating system.
  var BSDName = ""
  var displayName = ""
  var kind = ""

  /// Exposes the hardware MAC as an object.
  var hardMAC: MACAddress {
    MACAddress(_hardMAC)
  }

  /// Exposes the software MAC as an object.
  /// Whether it is already known or not.
  var softMAC: MACAddress {
    MACAddress(_softMAC)
  }

  var softPrefix: MACPrefix {
    MACPrefix(softMAC.prefix)
  }

  // MARK: Instance Methods

  /// Asks ``Ifconfig`` to fetch the soft MAC of this Interface.
  /// The answer is stored in the softMAC property.
  /// This can be done synchronously or asynchronously.
  func querySoftMAC(async: Bool) {
    let reader = Ifconfig.Reader(self.BSDName)

    if async {
      reader.softMAC(callback: { address in
        DispatchQueue.main.async {
          self._softMAC = address.formatted
        }
      })
    } else {
      self._softMAC = reader.softMAC().formatted
    }
  }

  // MARK: Instance Properties

  var hasOriginalMAC: Bool {
    hardMAC == softMAC
  }

  var isSpoofable: Bool {
    // You can only change MAC addresses of Ethernet and Wi-Fi adapters
    if (["Ethernet", "IEEE80211"].firstIndex(of: kind) ) == nil { return false }

    // If there is no internal MAC this is to be ignored
    if hardMAC.isInvalid { return false }

    // Bluetooth can also be filtered out
    if displayName.contains("tooth") { return false }

    // iPhones etc. are not spoofable either
    if displayName.contains("iPhone") { return false }
    if displayName.contains("iPad") { return false }
    if displayName.contains("iPod") { return false }

    // Internal Thunderbolt interfaces cannot be spoofed either
    if displayName.contains("Thunderbolt 1") { return false }
    if displayName.contains("Thunderbolt 2") { return false }
    if displayName.contains("Thunderbolt 3") { return false }
    if displayName.contains("Thunderbolt 4") { return false }
    if displayName.contains("Thunderbolt 5") { return false }

    return true
  }

  // This is a human readable representation of the Interface.
  // It's simply its name and interface identifier (e.g. "Wi-Fi ∙ en1")
  //  var title: String {
  //    return "\(displayName) · \(BSDName)"
  //  }

  /// We cannot modify the MAC address of an Airport device that is turned off.
  /// This method figures out whether this interface is turned off.
  var isPoweredOffWifi: Bool {
    guard let wifi = CWWiFiClient.shared().interface(withName: BSDName) else { return false }
    return !wifi.powerOn()
  }

  var isWifi: Bool {
    guard CWWiFiClient.shared().interface(withName: BSDName) != nil else { return false }
    return true
  }
  var iconName: String {
    if kind == "IEEE80211" { return "wifi" }

    return "cable.connector.horizontal"
  }

  // MARK: Instance Methods

  func setSoftMac(_ address: String) {
    _softMAC = address
  }

  // MARK: Private Instance Properties

  /// This is where we keep the hardware MAC address as a String. But we don't expose it.
  private var _hardMAC: String

  /// This is where we keep the software MAC address as a String.
  /// This variable is populated asynchronously using ``Ifconfig``.
  private var _softMAC = ""
}

extension Interface: Comparable {
  static func == (lhs: Interface, rhs: Interface) -> Bool {
    lhs.BSDName == rhs.BSDName
  }

  static func < (lhs: Interface, rhs: Interface) -> Bool {
    lhs.BSDName < rhs.BSDName
  }
}

extension Interface {
  enum Action: String {
    case hide
    case ignore
    case random
    case specify
    case original
  }
}
