
extension Configuration {
  struct Action {

    // MARK: Public Instance Properties

    var dictionary: [String: Any]

    // MARK: Initialization

    init(dictionary: [String: Any]) {
      self.dictionary = dictionary
    }

    // MARK: Public Instance Methods

    /**
     * Looks up the defined action for an Interface.
     *
     * - parameter hardMAC: The hardware MAC address of an Interface.
     *
     * - returns: An `Interface.Action` or `nil` if no valid action could be found
     *            for this particular interface.
     */
    func forInterface(_ hardMAC: MACAddress) -> Interface.Action? {
      guard let interfaceDictionary = dictionary[hardMAC.formatted] as? [String: String] else { return nil }
      guard let actionName = interfaceDictionary["action"] else { return nil }

      return Interface.Action(rawValue: actionName) ?? nil
    }


  }
}
