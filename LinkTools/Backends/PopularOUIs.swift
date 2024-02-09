// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

struct PopularOUIs {
  // MARK: Class Methods

  ///
  /// Looks up a Vendor by its ID.
  /// If no vendor was found, or it has no valid prefixes, returns nil.
  ///
  /// The ID is really just a nickname as String, nothing official.
  /// It is used as a convenience shortcut in the LinkLiar config file.
  ///
  /// - parameter id: The ID of the vendor (e.g. "ibm").
  ///
  /// - returns: A ``Vendor`` if found and `nil` if missing.
  ///
  static func find(_ id: String) -> [OUI] {
    let id = id.filter("0123456789abcdefghijklmnopqrstuvwxyz".contains)
    guard let vendorData = PopularVendorsDatabase.dictionaryWithOUIs[id] else { return [] }

    guard let rawOUIs = vendorData.values.first else { return [] }
    guard let name = vendorData.keys.first else { return [] }
    return rawOUIs.compactMap { OUI(String(format: "%06X", $0)) }
  }

  static func find(_ ids: [String]) -> [OUI] {
    ids.flatMap { find($0) }.compactMap { $0 }.sorted()
  }

  // MARK: Class Properties

  static var all: [OUI] {
    PopularVendorsDatabase.dictionaryWithCounts.keys.reversed().flatMap {
      find($0)
    }.compactMap { $0 }.sorted()
  }
}
