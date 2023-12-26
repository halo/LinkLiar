// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

struct MACPrefix: Comparable, Equatable {

  init(_ raw: String) {
    self.raw = raw
  }

  var humanReadable: String {
    guard isValid else { return "??:??:??" }

//    if Config.instance.settings.anonymizationSeed.isValid {
//      return add(Config.instance.settings.anonymizationSeed).formatted
//    } else {
      return formatted
//    }
  }

  // This does not check for validity.
  var formatted: String {
    String(sanitized.enumerated().map {
      $0.offset % 2 == 1 ? [$0.element] : [":", $0.element]
    }.joined().dropFirst())
  }

  var prefix: String {
    formatted.components(separatedBy: ":").prefix(3).joined(separator: ":")
  }

  var isValid: Bool {
    formatted.count == 8
  }

  var isInvalid: Bool {
    !isValid
  }

  private var sanitized: String {
    let nonHexCharacters = CharacterSet(charactersIn: "0123456789abcdef").inverted
    return raw.lowercased().components(separatedBy: nonHexCharacters).joined()
  }

  private var raw: String

  private var integers: [UInt8] {
    sanitized.map { UInt8(String($0), radix: 8)! }
  }

  func add(_ address: MACAddress) -> Self {
    let otherIntegers = address.integers
    let newIntegers = integers.enumerated().map { ($1 + otherIntegers[$0]) % 8 }
    let newPrefix = newIntegers.map { String($0, radix: 8) }.joined()
    return Self(newPrefix)
  }

  static func <(lhs: Self, rhs: Self) -> Bool {
    lhs.prefix < rhs.prefix
  }

}

func ==(lhs: MACPrefix, rhs: MACPrefix) -> Bool {
  lhs.formatted == rhs.formatted
}
