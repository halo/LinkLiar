
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
     * Looks up which custom prefixes are specified as default.
     *
     * - returns: An Array of valid `MACPrefix` or an empty Array if there are none.
     */
    var prefixesForDefaultInterface: [MACPrefix] {
      return prefixesForKey("default")
    }

    /**
     * Looks up which vendors are specified as default.
     *
     * - returns: An Array of valid `Vendor` or an empty Array if there are none.
     */
    var vendorsForDefaultInterface: [MACPrefix] {
      return prefixesForKey("default")
    }

    /**
     * Looks up which prefixes are specified for an Interface.
     *
     * - parameter hardMAC: The hardware MAC address of an Interface.
     *
     * - returns: An Array of valid `MACPrefix` or an empty Array if there are none.
     */
    func prefixesForInterface(_ hardMAC: MACAddress) -> [MACPrefix] {
      return prefixesForKey(hardMAC.formatted)
    }

    /**
     * Looks up the defined prefixes for an Interface.
     * If no valid address has been defined, use the default one.
     * If the default has no valid address either, returns an empty Array.
     *
     * - parameter hardMAC: The hardware MAC address of an Interface.
     *
     * - returns: An Array of valid `MACPrefix` (falling back to the default)
     *            or an empty Array if there are none.
     */
    func calculatedPrefixesForInterface(_ hardMAC: MACAddress) -> [MACPrefix] {
      let candidates = prefixesForInterface(hardMAC)
      return candidates.isEmpty ? prefixesForDefaultInterface : candidates
    }

    private func prefixesForKey(_ key: String) -> [MACPrefix] {
      guard let interfaceDictionary = dictionary[key] as? [String: String] else { return [] }
      guard let rawAddressesString = interfaceDictionary["prefixes"] else { return [] }
      let rawAddresses = rawAddressesString.split(separator: ",")

      let addresses = rawAddresses.compactMap { string -> MACPrefix? in
        let address = MACPrefix(String(string))
        return address.isValid ? address : nil
      }

      return addresses.isEmpty ? [] : addresses
    }
  }
}
