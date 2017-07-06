/**
 * An immutable wrapper for querying the content of the configuration file.
 */
struct Configuration {

  // MARK: Instance Properties

  /**
   * Gives access to the underlying dictionary of this configuration.
   */
  var dictionary: [String: Any]

  /**
   * Queries the version with whith the configuration was created.
   */
  lazy var version: String? = {
    return self.dictionary["version"] as? String
  }()

  /**
   * Queries whether the deamon os to be restricted to the lifetime of the GUI.
   */
  var isRestrictedDaemon: Bool {
    guard let restriction = self.dictionary["restrict_daemon"] as? Bool else {
      return false
    }

    return restriction != false
  }

  /**
   * Queries whether interfaces set to random may be rerandomized at best-effort.
   */
  var isForbiddenToRerandomize: Bool {
    guard let restriction = self.dictionary["skip_rerandom"] as? Bool else {
      return false
    }

    return restriction != false
  }

  // MARK: Initialization

  init(dictionary: [String: Any]) {
    self.dictionary = dictionary
  }

  // MARK: Instance Methods

  /**
   * Looks up the defined action for an Interface.
   * If no valid action has been defined, use the default one.
   *
   * - parameter hardMAC: The hardware MAC address of an Interface.
   *
   * - returns: An `Interface.Action` falling back to the default in a best-effort.
   */
  func calculatedActionForInterface(_ hardMAC: MACAddress) -> Interface.Action {
    return actionForInterface(hardMAC) ?? calculatedActionForDefaultInterface()
  }

  /**
   * Looks up the defined action for an Interface.
   * 
   * - parameter hardMAC: The hardware MAC address of an Interface.
   *
   * - returns: An `Interface.Action` or `nil` if no valid action could be found
   *            for this particular interface.
   */
  func actionForInterface(_ hardMAC: MACAddress) -> Interface.Action? {
    guard let interfaceDictionary = dictionary[hardMAC.formatted] as? [String: String] else { return nil }
    guard let actionName = interfaceDictionary["action"] else { return nil }

    return Interface.Action(rawValue: actionName) ?? nil
  }

  /**
   * Looks up which action has been defined as default for unknown Interfaces.
   *
   * If no valid action was defined, it returns `Interface.Action.ignore` as fallback.
   *
   * - parameter hardMAC: The hardware MAC address of an Interface.
   *
   * - returns: An `Interface.Action`.
   */
  func calculatedActionForDefaultInterface() -> Interface.Action {
    guard let interfaceDictionary = dictionary["default"] as? [String: String] else { return .ignore }
    guard let actionName = interfaceDictionary["action"] else { return .ignore }

    return Interface.Action(rawValue: actionName) ?? .ignore
  }

  /**
   * Looks up the defined exceptioning MAC address for an Interface.
   * This is useful to enforce re-randomization.
   *
   * - parameter hardMAC: The hardware MAC address of an Interface.
   *
   * - returns: A valid `MACAddress` or `nil` if no valid address was specified.
   */
  func exceptionAddressForInterface(_ hardMAC: MACAddress) -> MACAddress? {
    guard let interfaceDictionary = dictionary[hardMAC.formatted] as? [String: String] else { return nil }
    guard let rawAddress = interfaceDictionary["except"] else { return nil }

    let address = MACAddress(rawAddress)
    return address.isValid ? address : nil
  }

  /**
   * Looks up the defined address for an Interface.
   * If no valid address has been defined, use the default one.
   * If the default is no valid address either, returns nil.
   *
   * - parameter hardMAC: The hardware MAC address of an Interface.
   *
   * - returns: A valid `MACAddress` (falling back to the default) 
   *            or `nil` if no valid address was found.
   */
  func calculatedAddressForInterface(_ hardMAC: MACAddress) -> MACAddress? {
    return addressForInterface(hardMAC) ?? addressForDefaultInterface()
  }

  /**
   * Looks up the defined MAC address for an Interface.
   *
   * - parameter hardMAC: The hardware MAC address of an Interface.
   *
   * - returns: A valid `MACAddress` or `nil` if no valid address was specified
   *            for this particular interface.
   */
  func addressForInterface(_ hardMAC: MACAddress) -> MACAddress? {
    guard let interfaceDictionary = dictionary[hardMAC.formatted] as? [String: String] else { return nil }
    guard let rawAddress = interfaceDictionary["address"] else { return nil }

    let address = MACAddress(rawAddress)
    return address.isValid ? address : nil
  }

  /**
   * Looks up which address has been defined as default MAC address.
   *
   * - returns: A valid `MACAddress` or `nil` if no valid address was specified
   *            as general default.
   */
  func addressForDefaultInterface() -> MACAddress? {
    guard let interfaceDictionary = dictionary["default"] as? [String: String] else { return nil }
    guard let rawAddress = interfaceDictionary["address"] else { return nil }

    let address = MACAddress(rawAddress)
    return address.isValid ? address : nil
  }

}
