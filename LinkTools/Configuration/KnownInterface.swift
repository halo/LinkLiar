
extension Configuration {
  struct KnownInterface {

    // MARK: Initialization

    init(dictionary: [String:Any]) {
      self.dictionary = dictionary
    }

    // MARK: Public Instance Properties

    var dictionary: [String:Any]

    /**
     * Looks up which action has been defined.
     *
     * If no valid action was defined, it returns `Interface.Action.default` as fallback.
     *
     * - returns: An `Interface.Action`.
     */
    func action(_ hardMAC: MACAddress) -> Interface.Action {
      guard let interfaceDictionary = dictionary[hardMAC.formatted] as? [String: String] else { return defaultAction }
      guard let actionName = interfaceDictionary["action"] else { return defaultAction }

      return Interface.Action(rawValue: actionName) ?? defaultAction
    }

    var defaultAction: Interface.Action {
      return .default
    }

    /**
     * Looks up which MAC address has been defined.
     * This is only useful if the action is "specify".
     *
     * - returns: A valid `MACAddress` or `nil` if no valid address was specified.
     */
    var address: MACAddress? {
      guard let defaultDictionary = dictionary[hardMAC.formatted] as? [String: String] else { return nil }
      guard let rawAddress = defaultDictionary["address"] else { return nil }

      let address = MACAddress(rawAddress)
      return address.isValid ? address : nil
    }

    /**
     * Looks up which vendors are specified.
     * If there are absolutely no prefixes defined (neither vendors nor custom)
     * then the default is returned.
     *
     * - returns: An Array of valid `Vendor`s or the default vendor Array.
     */
    var vendors: [Vendor] {
      guard let defaultDictionary = dictionary[hardMAC.formatted] as? [String: String] else { return defaultVendors }
      guard let vendorIDsList = defaultDictionary["vendors"] else { return defaultVendors }
      let vendorIDs = vendorIDsList.split(separator: ",")

      let vendors = vendorIDs.compactMap { string -> Vendor? in
        return Vendors.find(String(string))
      }

      // If there are vendors defined directly, return them.
      guard vendors.isEmpty else { return vendors }

      // If there are custom prefixes, we can rely on them
      // and don't need to fall back here to anything.
      guard prefixes.isEmpty else { return [] }

      // Fall back to whatever `UnknownInterface#vendors` would return.
      guard let defaultDictionary = dictionary["default"] as? [String: String] else { return defaultVendors }
      guard let fallbackVendorIDsList = defaultDictionary["vendors"] else { return defaultVendors }
      let fallbackVendorIDs = fallbackVendorIDsList.split(separator: ",")

      let fallbackVendors = fallbackVendorIDs.compactMap { string -> Vendor? in
        return Vendors.find(String(string))
      }

      // If there are "default" vendors defined directly, return them.
      guard fallbackVendors.isEmpty else { return vendors }

      // If the entire configuration file has no prefixes defined,
      // either via vendors or custom prefixes, fall back.
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

  }
}
