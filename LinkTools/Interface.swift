import Foundation
import CoreWLAN

class Interface {

  enum Action: String {
    case ignore = "ignore"
    case random = "random"
    case specify = "specify"
    case original = "original"
  }

  // These attributes are known instantaneously
  var BSDName: String
  var displayName: String
  var kind: String

  // This is where we keep the hardware MAC address as a String. But we don't expose it.
  private var _hardMAC: String

  // Instead we expose the hardware MAC as an object.
  var hardMAC: MACAddress {
    return MACAddress(_hardMAC)
  }

  // This is where we keep the software MAC address as a String.
  // This variable is populated asynchronously by running ifconfig.
  var _softMAC: String

  // Whether the software MAC is already known or not, we expose it as an object.
  var softMAC: MACAddress {
    return MACAddress(_softMAC)
  }

  var hasOriginalMAC: Bool {
    return hardMAC == softMAC
  }

  var isSpoofable: Bool {
    // You can only change MAC addresses of Ethernet and Wi-Fi adapters
    if ((["Ethernet", "IEEE80211"].index(of: kind) ) == nil) { return false }
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
  // It is just simply from its name and interface identifier (e.g. "Wi-Fi ∙ en1")
  var title: String {
    return "\(displayName) · \(BSDName)"
  }

  // We cannot modify the MAC address of an Airport device that is turned off.
  // This method figures out whether this interface is just that.
  var isPoweredOffWifi: Bool {
    guard let wifi = CWWiFiClient.shared().interface(withName: BSDName) else { return false }
    return !wifi.powerOn()
  }

  // Upon initialization we assign what we already know
  init(BSDName: String, displayName: String, kind: String, hardMAC: String, async: Bool) {
    self.BSDName = BSDName
    self.displayName = displayName
    self.kind = kind
    self._hardMAC = hardMAC
    self._softMAC = ""
    let ifconfig = Ifconfig(BSDName: self.BSDName)
    if !isSpoofable { return }

    if async {
      ifconfig.softMAC(callback: { address in
        self._softMAC = address.formatted
        NotificationCenter.default.post(name: .softMacIdentified, object: self, userInfo: nil)
      })
    } else {
      self._softMAC = ifconfig.softMAC().formatted
    }
  }

}
