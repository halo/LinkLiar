// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

struct MAC: Equatable {
  // MARK: Class Methods

  init?(_ address: String) {
    guard let validAddress = MACParser.normalized48(address) else { return nil }

    self.address = validAddress
  }

  init(address: String) {
    self.address = address
  }

  // MARK: Instance Properties

  func humanReadable(config: Config.Reader) -> String {
    guard config.general.isAnonymized else {
      return humanReadable
    }
    let address = config.general.anonymizationSeed
    let otherIntegers = address.integers
    let newIntegers = integers.enumerated().map { ($1 + otherIntegers[$0]) % 16 }
    let newAddress = newIntegers.map { String($0, radix: 16) }.joined()
    return Self(newAddress)?.address ?? "??:??:??:??:??:??"
  }

  var humanReadable: String {
    //    if Config.instance.settings.anonymizationSeed.isValid {
    //      return add(Config.instance.settings.anonymizationSeed).formatted
    //    } else {
    address
    //    }
  }

  var prefix: String {
    address.components(separatedBy: ":").prefix(3).joined(separator: ":")
  }

  var integers: [UInt8] {
    address.map { UInt8(String($0), radix: 16)! }
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
