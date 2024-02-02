// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

extension Config {
  struct Vendors {

    // MARK: Public Instance Properties

    var dictionary: [String: Any]

    var popularMarked: [Vendor] {
      let allVendors = PopularVendors.all

      if let chosenVendorIDs = dictionary[Config.Key.vendors.rawValue] as? [String] {
        for vendor in allVendors {
          vendor.isChosen = (chosenVendorIDs.first { $0 == vendor.id } != nil)
        }
      }

      return allVendors
    }

    var chosenIDs: [String] {
      guard let vendorIDs = dictionary[Config.Key.vendors.rawValue] as? [String] else { return [] }
      return vendorIDs
    }

    var chosenPopular: [Vendor] {
      guard let vendorIDs = dictionary[Config.Key.vendors.rawValue] as? [String] else { return [] }

      let vendors = Set(vendorIDs).compactMap { string -> Vendor? in
        PopularVendors.find(string)
      }

      return Array(vendors).sorted()
    }
  }
}
