// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

/// Organizationally unique identifier.
/// Also known as MAC prefix.
///
struct OUI: Equatable {
  // MARK: Class Methods

  init?(_ address: String) {
    guard let validAddress = MACParser.normalized24(address) else { return nil }

    self.address = validAddress
  }

  // MARK: Instance Properties

  // MARK: Private Instance Properties

  let address: String
}

extension OUI: Comparable {
  static func == (lhs: OUI, rhs: OUI) -> Bool {
    lhs.address == rhs.address
  }

  static func < (lhs: OUI, rhs: OUI) -> Bool {
    lhs.address < rhs.address
  }
}
