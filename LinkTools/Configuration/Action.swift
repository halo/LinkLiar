
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
     * Looks up which action has been defined as default for unknown Interfaces.
     *
     * If no valid action was defined, it returns `Interface.Action.ignore` as fallback.
     *
     * - returns: An `Interface.Action`.
     */
    var calculatedForDefaultInterface: Interface.Action {
      guard let interfaceDictionary = dictionary["default"] as? [String: String] else { return .ignore }
      guard let actionName = interfaceDictionary["action"] else { return .ignore }

      return Interface.Action(rawValue: actionName) ?? .ignore
    }

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

    /**
     * Looks up the defined action for an Interface.
     * If no valid action has been defined, use the default one.
     *
     * - parameter hardMAC: The hardware MAC address of an Interface.
     *
     * - returns: An `Interface.Action` falling back to the default in a best-effort.
     */
    func calculatedForInterface(_ hardMAC: MACAddress) -> Interface.Action {
      return forInterface(hardMAC) ?? calculatedForDefaultInterface
    }

  }
}
