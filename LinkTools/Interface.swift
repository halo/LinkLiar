import Foundation

class Interface {

  init(BSDName: String, displayName: String, hardMAC: String) {
    self.BSDName = BSDName
    self.displayName = displayName
    self.hardMAC = hardMAC
  }

  var BSDName: String
  var displayName: String
  var hardMAC: String

}
