// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

struct MAC: Equatable {
  // MARK: Class Methods

  init?(_ address: String) {
    guard let validAddress = MACParser.normalized48(address) else { return nil }

    self.address = validAddress
  }

  private init(address: String) {
    self.address = address
  }

  // MARK: Instance Properties

  var prefix: String {
    address.components(separatedBy: ":").prefix(3).joined(separator: ":")
  }

  var integers: [UInt8] {
    address.split(separator: ":")
           .joined()
           .map { UInt8(String($0), radix: 16)! }
  }

  // MARK: Instance Methods

  func anonymous(_ anonymize: Bool) -> String {
    if anonymize {
      return MACAnonymizer.anonymize(self)
    } else {
      return address
    }
  }

  // MARK: Private Instance Properties

  let address: String
}

extension MAC: Comparable {
  static func == (lhs: MAC, rhs: MAC) -> Bool {
    lhs.address == rhs.address
  }

  static func < (lhs: MAC, rhs: MAC) -> Bool {
    lhs.address < rhs.address
  }
}
