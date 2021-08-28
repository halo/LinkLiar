import Foundation

struct Vendor: Equatable {

  init(id: String, name: String, prefixes: [MACPrefix]) {
    self.id = id
    self.name = name
    self.prefixes = prefixes
  }

  var name: String
  var id: String
  var prefixes: [MACPrefix]
}

func ==(lhs: Vendor, rhs: Vendor) -> Bool {
  return lhs.name == rhs.name
}
