
extension Configuration {
  struct Prefixes {

    // MARK: Public Instance Properties

    var dictionary: [String: Any]

    // MARK: Initialization

    init(dictionary: [String: Any]) {
      self.dictionary = dictionary
    }

    // MARK: Public Instance Methods

    /**
     * Looks up which vendors are specified.
     * If there are absolutely no prefixes defined (neither vendors nor custom)
     * then the fallback Vendor (Apple) is returned.
     *
     * Because we need always some prefix to use for randomization.
     * Also, this makes upgrading LinkLiar simpler (i.e. no vendors and no prefixes
     * defined in settings file means use some default and persist that as new setting)
     *
     * - returns: An Array of valid `Vendor`s or an empty Array if there are none.
     */
    var vendors: [Vendor] {
      guard let defaultDictionary = dictionary["default"] as? [String: String] else { return defaultVendors }
      guard let vendorIDsList = defaultDictionary["vendors"] else { return defaultVendors }
      let vendorIDs = vendorIDsList.split(separator: ",")

      let vendors = vendorIDs.compactMap { string -> Vendor? in
        return Vendors.find(String(string))
      }

      // If there are vendors defined directly, return them.
      guard vendors.isEmpty else { return vendors }

      // We always need *some* prefix. If there are custom prefixes,
      // we can rely on them and don't need to fall back here to anything.
      guard prefixes.isEmpty else { return [] }

      return defaultVendors
    }

    private var defaultVendors: [Vendor] {
      // We assume that this vendor is always defined. It's a sensible default.
      return [Vendors.find("apple")!]
    }

    /**
     * Looks up which custom prefixes are specified.
     *
     * - returns: An Array of valid `MACPrefix`es or an empty Array if there are none.
     */
    var prefixes: [MACPrefix] {
      guard let baseDictionary = dictionary["default"] as? [String: String] else { return [] }
      guard let rawAddressesString = baseDictionary["prefixes"] else { return [] }
      let rawAddresses = rawAddressesString.split(separator: ",")

      let addresses = rawAddresses.compactMap { string -> MACPrefix? in
        let address = MACPrefix(String(string))
        return address.isValid ? address : nil
      }

      return addresses
    }

    /**
     * Gathers all default prefixes that can be used for randomization.
     *
     * - parameter hardMAC: The hardware MAC address of an Interface.
     *
     * - returns: An Array of valid `MacPrefix`es that is never empty.
     */
    var calculatedPrefixes: [MACPrefix] {
      let customPrefixes = prefixes
      let vendorPrefixes = vendors.flatMap { $0.prefixes }

      return customPrefixes + vendorPrefixes
    }

  }
}
