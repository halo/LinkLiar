import Foundation

struct Vendor: Equatable {

  init(name: String, prefixes: [MACPrefix]) {
    self.rawName = name
    self.prefixes = prefixes
  }

  var name: String {
    return rawName
  }

  var prefixes: [MACPrefix]

  private var rawName: String
}

func ==(lhs: Vendor, rhs: Vendor) -> Bool {
  return lhs.name == rhs.name
}
