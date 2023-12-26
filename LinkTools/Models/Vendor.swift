// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

struct Vendor: Identifiable {
  // MARK: Class Methods

  init(id: String, name: String, prefixes: [MACPrefix]) {
    self.id = id
    self.name = name
    self.prefixes = prefixes
  }

  // MARK: Instance Properties

  var name: String
  var id: String
  var prefixes: [MACPrefix]

  var title: String {
    [name, " ・ ", String(prefixes.count)].joined()
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
