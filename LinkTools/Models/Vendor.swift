// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

@Observable

class Vendor: Identifiable, Hashable {
  // MARK: Class Methods

  init(id: String, name: String, prefixes: [OUI]) {
    self.id = id
    self.name = name
    self.prefixes = prefixes
  }

  // MARK: Instance Properties

  var name: String
  var id: String
  var prefixes: [OUI]

  var isChosen: Bool = false

  var title: String {
    [name, " ・ ", String(prefixes.count)].joined()
  }

  // MARK: Instance Methods

  func hash(into hasher: inout Hasher) {
      hasher.combine(id)
  }
}

extension Vendor: Comparable {
  static func == (lhs: Vendor, rhs: Vendor) -> Bool {
    lhs.name == rhs.name
  }

  static func < (lhs: Vendor, rhs: Vendor) -> Bool {
    lhs.name < rhs.name
  }
}
