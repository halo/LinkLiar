// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

extension Config {
  struct Vendors {

    // MARK: Public Instance Properties

    var dictionary: [String: Any]

    var chosenPopular: [Vendor] {
      guard let vendorIDs = dictionary["vendors"] as? [String] else { return [] }

      let vendors = Set(vendorIDs).compactMap { string -> Vendor? in
        PopularVendors.find(string)
      }

      return Array(vendors).sorted()
    }
  }
}
