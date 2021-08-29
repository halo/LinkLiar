
extension Configuration {
  struct UnknownInterface {

    // MARK: Initialization

    init(dictionary: [String:Any]) {
      self.dictionary = dictionary
    }

    // MARK: Public Instance Properties

    var dictionary: [String:Any]

    /**
     * Looks up which action has been defined.
     *
     * If no valid action was defined, it returns `Interface.Action.ignore` as fallback.
     *
     * - returns: An `Interface.Action`.
     */
    var action: Interface.Action {
      guard let defaultDictionary = dictionary["default"] as? [String: String] else { return defaultAction }
      guard let actionName = defaultDictionary["action"] else { return defaultAction }

      return Interface.Action(rawValue: actionName) ?? defaultAction
    }

    var defaultAction: Interface.Action {
      return .ignore
    }

    /**
     * Looks up which MAC address has been defined.
     * This is only useful if the action is "specify".
     *
     * - returns: A valid `MACAddress` or `nil` if no valid address was specified.
     */
    var address: MACAddress? {
      guard let defaultDictionary = dictionary["default"] as? [String: String] else { return nil }
      guard let rawAddress = defaultDictionary["address"] else { return nil }

      let address = MACAddress(rawAddress)
      return address.isValid ? address : nil
    }

  }
}
