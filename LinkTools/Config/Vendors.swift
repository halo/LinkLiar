// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

extension Config {
  struct Vendors {

    // MARK: Public Instance Properties

    var dictionary: [String: Any]

    var popular: [Vendor] {
//      if let chosenVendorIDs = dictionary[Config.Key.vendors.rawValue] as? [String] {
//        for vendor in allVendors {
//          vendor.isChosen = (chosenVendorIDs.first { $0 == vendor.id } != nil)
//        }
//      }

      PopularVendors.all
    }

    func isChosen(_ vendor: Vendor) -> Bool {
      guard let chosenIDs = dictionary[Config.Key.vendors.rawValue] as? [String] else { return false }
      return chosenIDs.contains(where: { $0 == vendor.id })
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
