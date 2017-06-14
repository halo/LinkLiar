import Foundation
import CoreWLAN

class Interface {

  // These attributes are known instantaneously
  var BSDName: String
  var displayName: String
  var kind: String

  // This is where we keep the hardware MAC address as a String. But we don't expose it.
  private var _hardMAC: String

  // Instead we expose the hardware MAC as an object.
  var hardMAC: MACAddress {
    get {
      return MACAddress(_hardMAC)
    }
  }

  // This is where we keep the software MAC address as a String.
  // This variable is populated asynchronously by running ifconfig.
  var _softMAC: String

  // Whether the software MAC is already known or not, we expose it as an object.
  var softMAC: MACAddress {
    get {
      return MACAddress(_softMAC)
    }
  }

  // This is a human readable representation of the Interface.
  // It is just simply from its name and interface identifier (e.g. "Wi-Fi ∙ en1")
  var title: String {
    get {
      return "\(displayName) ∙ \(BSDName)"
    }
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
    if (async) {
      Ifconfig(BSDName: BSDName).launchAsync(interface: self)
    } else {
      self._softMAC = Ifconfig(BSDName: BSDName).launchSync()
    }
  }

}
