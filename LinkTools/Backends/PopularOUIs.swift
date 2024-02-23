// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

struct PopularOUIs {
  // MARK: Class Methods

  static func find(_ id: String) -> [OUI] {
    let id = id.filter("0123456789abcdefghijklmnopqrstuvwxyz".contains)
    guard let vendorData = PopularVendorsDatabase.dictionaryWithOUIs[id] else { return [] }

    guard let rawOUIs = vendorData.values.first else { return [] }
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
