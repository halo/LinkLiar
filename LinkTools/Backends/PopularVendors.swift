/*
 * Copyright (C) 2012-2021 halo https://io.github.com/halo/LinkLiar
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

struct PopularVendors {
  // MARK: Class Properties

  ///
  /// Looks up a Vendor by its ID.
  /// If no vendor was found, returns nil.
  ///
  /// The ID is really just a nickname as String, nothing official.
  /// It is used as a convenience shortcut in the LinkLiar config file.
  ///
  /// - parameter id: The ID of the vendor (e.g. "ibm").
  ///
  /// - returns: A ``Vendor`` if found and `nil` if missing.
  ///
  static func find(_ id: String) -> Vendor? {
    let id = id.filter("0123456789abcdefghijklmnopqrstuvwxyz".contains)
    guard let vendorData = PopularVendorsDatabase.dictionary[id] else { return nil }

    guard let rawPrefixes = vendorData.values.first else { return nil }
    guard let name = vendorData.keys.first else { return nil }

    let prefixes = rawPrefixes.map { rawPrefix in
      MACPrefix(String(format: "%06X", rawPrefix))
    }

    return Vendor(id: id, name: name, prefixes: prefixes)
  }

  // MARK: Private Class Properties

  static var all: [Vendor] {
    PopularVendorsDatabase.dictionary.keys.reversed().compactMap {
      find($0)
    }.sorted()
  }
}
