// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

extension Config {
  struct OUIs {

    // MARK: Public Instance Properties

    var dictionary: [String: Any]

    // Proxy them, so that the state is observed.
    var popular: [OUI] {
      PopularOUIs.all
    }

    var chosenPopular: [OUI] {
      guard let vendorIDs = dictionary[Config.Key.vendors.rawValue] as? [String] else { return [] }

      let vendors = Set(vendorIDs).flatMap { PopularOUIs.find($0) }.compactMap { $0 }

      return Array(vendors).sorted()
    }
  }
}
