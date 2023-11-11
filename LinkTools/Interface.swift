/*
 * Copyright (C) halo https://io.github.com/halo/LinkLiar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation
import CoreWLAN

// Because the soft-MAC is queried asynchronously.
// We need SwiftUI to know that the Interface instance
// may change its properties at some point in the future.
@Observable

class Interface: Identifiable {
  
  // MARK: Class Methods
  
  /// Upon initialization we assign what we already know.
  init(BSDName: String, displayName: String, kind: String, hardMAC: String, async: Bool) {
    self.BSDName = BSDName
    self.displayName = displayName
      .replacingOccurrences(of: "(en0)", with: "") // Not sure why, but some Ethernet interfaces have this reduntantly in their name
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
  var BSDName: String
  var displayName: String
  var kind: String
  
  /// Exposes the hardware MAC as an object.
  var hardMAC: MACAddress {
    return MACAddress(_hardMAC)
  }
  
  /// Exposes the software MAC as an object.
  /// Whether it is already known or not.
  var softMAC: MACAddress {
    return MACAddress(_softMAC)
  }
  
  // MARK: Instance Methods

  /// Asks ``Ifconfig`` to fetch the soft MAC of this Interface.
  /// The answer is stored in the softMAC property.
  /// This can be done synchronously or asynchronously.
  func querySoftMAC(async: Bool) {
    let ifconfig = Ifconfig(BSDName: self.BSDName)
    
    if async {
      ifconfig.softMAC(callback: { address in
        DispatchQueue.main.async {
          self._softMAC = address.formatted
        }
      })
    } else {
      self._softMAC = ifconfig.softMAC().formatted
    }
  }
  
  // MARK: Private Instance Properties

  /// This is where we keep the hardware MAC address as a String. But we don't expose it.
  private var _hardMAC: String
  
  /// This is where we keep the software MAC address as a String.
  /// This variable is populated asynchronously using ``Ifconfig``.
  var _softMAC: String
  
  //  var softPrefix: MACPrefix {
  //    return MACPrefix(softMAC.prefix)
  //  }
  
  var hasOriginalMAC: Bool {
    return hardMAC == softMAC
  }
  
  var isSpoofable: Bool {
    // You can only change MAC addresses of Ethernet and Wi-Fi adapters
    if ((["Ethernet", "IEEE80211"].firstIndex(of: kind) ) == nil) { return false }
    
    // If there is no internal MAC this is to be ignored
    if (hardMAC.isInvalid) { return false }
    
    // Bluetooth can also be filtered out
    if (displayName.contains("tooth")) { return false }
    
    // iPhones etc. are not spoofable either
    if (displayName.contains("iPhone")) { return false }
    if (displayName.contains("iPad")) { return false }
    if (displayName.contains("iPod")) { return false }
    
    // Internal Thunderbolt interfaces cannot be spoofed either
    if (displayName.contains("Thunderbolt 1")) { return false }
    if (displayName.contains("Thunderbolt 2")) { return false }
    if (displayName.contains("Thunderbolt 3")) { return false }
    if (displayName.contains("Thunderbolt 4")) { return false }
    if (displayName.contains("Thunderbolt 5")) { return false }
    
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
  
}

extension Interface: Comparable {
  static func ==(lhs: Interface, rhs: Interface) -> Bool {
    return lhs.BSDName == rhs.BSDName
  }
  
  static func <(lhs: Interface, rhs: Interface) -> Bool {
    return lhs.BSDName < rhs.BSDName
  }
}

extension Interface {
  enum Action: String {
    case ignore = "ignore"
    case random = "random"
    case specify = "specify"
    case original = "original"
  }
}
