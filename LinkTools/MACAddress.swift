/*
 * Copyright (C) 2017 halo https://io.github.com/halo/LinkLiar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

struct MACAddress: Equatable {

  var humanReadable: String {
    guard isValid else { return "??:??:??:??:??:??" }

    if Config.instance.isAnonymized {
      return add(Config.instance.anonymizationSeed).formatted
    } else {
      return formatted
    }
  }

  var formatted: String {
    return String(sanitized.characters.enumerated().map() {
      $0.offset % 2 == 1 ? [$0.element] : [":", $0.element]
    }.joined().dropFirst())
  }

  var prefix: String {
    return formatted.components(separatedBy: ":").prefix(3).joined(separator: ":")
  }

  var isValid: Bool {
    return formatted.characters.count == 17
  }

  var isInvalid: Bool {
    return !isValid
  }

  private var sanitized: String {
    let nonHexCharacters = CharacterSet(charactersIn: "0123456789abcdef").inverted
    return raw.lowercased().components(separatedBy: nonHexCharacters).joined()
  }

  private var raw: String

  private var integers : [UInt8] {
    return sanitized.characters.map { UInt8(String($0), radix: 16)! }
  }

  init(_ raw: String) {
    self.raw = raw
  }

  func add(_ address: MACAddress) -> MACAddress {
    let otherIntegers = address.integers
    let newIntegers = integers.enumerated().map { ($1 + otherIntegers[$0]) % 16 }
    let newAddress = newIntegers.map { String($0, radix: 16) }.joined()
    return MACAddress(newAddress)
  }

}

func ==(lhs: MACAddress, rhs: MACAddress) -> Bool {
  return lhs.formatted == rhs.formatted
}
