
extension Configuration {
  struct KnownInterface {

    // MARK: Initialization

    init(dictionary: [String:Any]) {
      self.dictionary = dictionary
    }

    // MARK: Public Instance Properties

    var dictionary: [String:Any]

    var defaultAction: Interface.Action {
      return Config.instance.unknownInterface.action
    }

    // MARK: Public Instance Methods

    /**
     * Looks up which action has been defined.
     *
     * Returns `nil` if no valid action was defined.
     *
     * - returns: An `Interface.Action`.
     */
    func action(_ hardMAC: MACAddress) -> Interface.Action? {
      guard let interfaceDictionary = dictionary[hardMAC.formatted] as? [String: String] else { return nil }
      guard let actionName = interfaceDictionary["action"] else { return nil }

      return Interface.Action(rawValue: actionName) ?? nil
    }

    /**
     * Looks up which action has been defined.
     *
     * If no valid action was defined, it returns `Interface.Action.default` as fallback.
     *
     * - returns: An `Interface.Action`.
     */
    func calculatedAction(_ hardMAC: MACAddress) -> Interface.Action {
      guard let interfaceDictionary = dictionary[hardMAC.formatted] as? [String: String] else { return defaultAction }
      guard let actionName = interfaceDictionary["action"] else { return defaultAction }

      return Interface.Action(rawValue: actionName) ?? defaultAction
    }

    /**
     * Looks up which MAC address has been defined.
     * This is only useful if the action is "specify".
     *
     * - returns: A valid `MACAddress` or `nil` if no valid address was specified.
     */
    func address(_ hardMAC: MACAddress) -> MACAddress? {
      guard let defaultDictionary = dictionary[hardMAC.formatted] as? [String: String] else { return nil }
      guard let rawAddress = defaultDictionary["address"] else { return nil }

      let address = MACAddress(rawAddress)
      return address.isValid ? address : nil
    }

    /**
     * Looks up the defined exceptioning MAC address for an Interface.
     * This is useful to enforce re-randomization. Because the deamon
     * would usually not re-randomize and already random Interface.
     *
     * - parameter hardMAC: The hardware MAC address of an Interface.
     *
     * - returns: A valid `MACAddress` or `nil` if no valid address was specified.
     */
    func exceptionAddress(_ hardMAC: MACAddress) -> MACAddress? {
      guard let interfaceDictionary = dictionary[hardMAC.formatted] as? [String: String] else { return nil }
      guard let rawAddress = interfaceDictionary["except"] else { return nil }

      let address = MACAddress(rawAddress)
      return address.isValid ? address : nil
    }

  }
}
