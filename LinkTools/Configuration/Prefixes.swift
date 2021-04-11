
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
     * Queries whether user-defined prefixes should be used for an Interface.
     *
     * - parameter hardMAC: The hardware MAC address of an Interface.
     */
    func usePrefixesForInterface(_ hardMAC: MACAddress) -> Bool {
      return dictionary[hardMAC.formatted] as? Bool ?? false
    }

    /**
     * Queries whether user-defined prefixes should be used by default.
     */
    func usePrefixesForDefault() -> Bool {
      return dictionary["default"] as? Bool ?? false

    }

    func calculatedUsePrefixesForInterface(_ hardMAC: MACAddress) -> Bool {
      return usePrefixesForInterface(hardMAC) || usePrefixesForDefault()
    }
  }
}
