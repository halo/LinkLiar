// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

/// Checks a potential MAC address for validity and normalizes it.
///
struct MACParser {
  // MARK: - Class Methods

  static func normalized24(_ input: String) -> String? {
    self.init(input).normalized24
  }

  static func normalized48(_ input: String) -> String? {
    self.init(input).normalized48
  }

  // MARK: - PrivateClass Methods

  private init(_ input: String) {
    self.input = input
  }

  // MARK: - Instance Properties

  /// OUI prefix size, that is, 24 bits.
  ///
  var normalized24: String? {
    formatted.count == 8 ? formatted : nil
  }

  /// Standard MAC address with 48 bits
  ///
  var normalized48: String? {
    formatted.count == 17 ? formatted : nil
  }

  // MARK: - Private Instance Properties

  private var input: String

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
    let nonHexCharacters = CharacterSet(charactersIn: "0123456789abcdef").inverted

    return expanded.lowercased()
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
