// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

struct MAC: Equatable {
  // MARK: Class Methods

  init?(_ address: String) {
    guard let validAddress = Parser.init(address).normalized else { return nil }

    self.address = validAddress
  }

  init(address: String) {
    self.address = address
  }

  // MARK: Instance Properties

  // TODO: Remove this alias
  let isValid = true

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

// MARK: Private Helpers

extension MAC {
  /// Checks a potential MAC address for validity and normalizes it.
  ///
  private struct Parser {
    init(_ input: String) {
      self.input = input
    }

    var normalized: String? {
      formatted.count == 17 ? formatted : nil
    }

    private var input: String
    private let nonHexCharacters = CharacterSet(charactersIn: "0123456789abcdef").inverted

    /// Firstly, convert "aa:b::ff" to "aa:0b:00:ff"
    ///
    private var expanded: String {
      input.split(separator: ":", omittingEmptySubsequences: false).map { substring in
        if substring.count > 1 { return substring }
        if substring.count == 1 { return "0\(substring)" }
        return "00"
      }.joined()
    }

    /// Secondly, remove potential non-valid characters.
    ///
    private var stripped: String {
      expanded.lowercased()
              .components(separatedBy: nonHexCharacters)
              .joined()
    }

    /// Thirdly, insert ":" for proper formatting.
    ///
    private var formatted: String {
      String(stripped.enumerated().map {
        $0.offset % 2 == 1 ? [$0.element] : [":", $0.element]
      }.joined().dropFirst())
    }
  }
}

extension MAC: Comparable {
  static func == (lhs: MAC, rhs: MAC) -> Bool {
    lhs.address == rhs.address
  }

  static func < (lhs: MAC, rhs: MAC) -> Bool {
    lhs.address < rhs.address
  }
}
