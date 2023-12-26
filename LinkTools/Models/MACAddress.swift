// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

struct MACAddress: Equatable {
  // MARK: Class Methods

  static func initIfValid(_ address: String) -> Self? {
    let macAddress = self.init(address)
    if !macAddress.isValid { return nil }
    return macAddress
  }

  init(_ address: String) {
    self.raw = address
  }

  // MARK: Instance Methods

//  func add(_ address: MACAddress) -> MACAddress {
//  }

  // MARK: Instance Properties

  func humanReadable(config: Config.Reader) -> String {
    guard isValid else { return "??:??:??:??:??:??" }

    guard config.general.isAnonymized else {
      return humanReadable
    }
    let address = config.general.anonymizationSeed
    let otherIntegers = address.integers
    let newIntegers = integers.enumerated().map { ($1 + otherIntegers[$0]) % 16 }
    let newAddress = newIntegers.map { String($0, radix: 16) }.joined()
    return Self(newAddress).formatted
  }

  var humanReadable: String {
    guard isValid else { return "??:??:??:??:??:??" }

//    if Config.instance.settings.anonymizationSeed.isValid {
//      return add(Config.instance.settings.anonymizationSeed).formatted
//    } else {
      return formatted
//    }
  }

  var formatted: String {
    String(sanitized.enumerated().map {
      $0.offset % 2 == 1 ? [$0.element] : [":", $0.element]
    }.joined().dropFirst())
  }

  var prefix: String {
    formatted.components(separatedBy: ":").prefix(3).joined(separator: ":")
  }

  var isValid: Bool {
    formatted.count == 17
  }

  var isInvalid: Bool {
    !isValid
  }

  var integers: [UInt8] {
    sanitized.map { UInt8(String($0), radix: 16)! }
  }

  // MARK: Private Instance Properties

  private var sanitized: String {
    let nonHexCharacters = CharacterSet(charactersIn: "0123456789abcdef").inverted
    return raw.lowercased().components(separatedBy: nonHexCharacters).joined()
  }

  private var raw: String
}

extension MACAddress: Comparable {
  static func == (lhs: MACAddress, rhs: MACAddress) -> Bool {
    lhs.formatted == rhs.formatted
  }

  static func < (lhs: MACAddress, rhs: MACAddress) -> Bool {
    lhs.formatted < rhs.formatted
  }
}
