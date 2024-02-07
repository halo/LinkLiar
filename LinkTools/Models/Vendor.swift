// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

@Observable

class Vendor: Identifiable, Hashable {
  // MARK: Class Methods

  init(id: String, name: String, prefixes: [OUI] = [], prefixCount: Int = 0) {
    self.id = id
    self.name = name
    self.prefixes = prefixes
    // This is just a cache, in case the actual prefixes are absent.
    self.prefixCount = prefixCount == 0 ? prefixes.count : prefixCount
  }

  // MARK: Instance Properties

  var name: String
  var id: String
  var prefixes: [OUI]
  var prefixCount = 0

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
