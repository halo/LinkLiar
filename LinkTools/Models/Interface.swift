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
    self._softMAC = MAC(address: "")
  }

  /// Upon initialization we assign what we already know.
  init(BSDName: String, displayName: String, kind: String, hardMAC: String, async: Bool?) {
    self.BSDName = BSDName
    self.rawDisplayName = displayName
    self.kind = kind
    self._hardMAC = hardMAC
    self._softMAC = MAC(address: "")

    // No need to lookup a soft MAC if it cannot be modified.
    if !isSpoofable { return }
    querySoftMAC(async: async)
  }

  // MARK: Instance Properties

  /// Conforming to `Identifiable`.
  /// The only truly long-term unique identifier is the hardware MAC of an Interface.
  /// In the unlikely case that it's unavailable, fall back to something like `en0`.
  var id: String { hardMAC.address }

  // These attributes are known instantaneously when querying the operating system.
  // So we can set them to an empty String, knowing they will be populated at once.
  var BSDName = ""
  var kind = ""

  // Not sure why, but some Ethernet interfaces have this reduntantly in their name
  var displayName: String {
    rawDisplayName
      .replacingOccurrences(of: "(en0)", with: "")
      .replacingOccurrences(of: "(en1)", with: "")
      .replacingOccurrences(of: "(en2)", with: "")
      .replacingOccurrences(of: "(en3)", with: "")
      .replacingOccurrences(of: "(en4)", with: "")
      .replacingOccurrences(of: "(en5)", with: "")
      .replacingOccurrences(of: "(en6)", with: "")
      .trimmingCharacters(in: .whitespaces)
  }

  /// Exposes the hardware MAC as an object.
  var hardMAC: MAC {
    MAC(address: _hardMAC)
  }

  /// Exposes the software MAC as an object.
  /// Whether it is already known or not.
  var softMAC: MAC? {
    if let override = overrideSoftMacInTests { return override }

    return  _softMAC
  }

  var softPrefix: MACPrefix {
    MACPrefix(softMAC!.prefix)
  }

  // MARK: Instance Methods

  /// Asks ``Ifconfig`` to fetch the soft MAC of this Interface.
  /// The answer is stored in the softMAC property.
  /// This can be done synchronously or asynchronously.
  func querySoftMAC(async: Bool?) {
    guard let isAsync = async else { return }

    let reader = Ifconfig.Reader(self.BSDName)

    if isAsync {
      reader.softMAC(callback: { potentialAddress in
        guard let address = potentialAddress else { return }

        DispatchQueue.main.async {
          Log.debug("Setting softMAC to \(address.address)")
          self._softMAC = address
        }
      })
    } else {
      guard let address = reader.softMAC() else { return }
      self._softMAC = address
    }
  }

  // MARK: Instance Properties

  var hasOriginalMAC: Bool {
    hardMAC == softMAC
  }

  var isSpoofable: Bool {
    // You can only change MAC addresses of Ethernet and Wi-Fi adapters
    if (["Ethernet", "IEEE80211"].firstIndex(of: kind) ) == nil { return false }

//    // If there is no internal MAC this is to be ignored
//    if hardMAC == nil { return false }

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

  var isWifi: Bool {
   CWWiFiClient.shared().interface(withName: BSDName) != nil
  }

  var associatedSsid: String? {
    CWWiFiClient.shared().interface(withName: BSDName)?.ssid()
  }

  var iconName: String {
    if kind == "IEEE80211" { return "wifi" }

    return "cable.connector.horizontal"
  }

  var overrideSoftMacInTests: MAC?

  // MARK: Instance Methods

//  func setSoftMac(_ address: String) {
//    _softMAC = MAC(address)
//  }

  // MARK: Private Instance Properties

  /// This is where we keep the hardware MAC address as a String. But we don't expose it.
  private var _hardMAC: String

  /// This is where we keep the software MAC address as a String.
  /// This variable is populated asynchronously using ``Ifconfig``.
  private var _softMAC: MAC

  private var rawDisplayName = ""
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
