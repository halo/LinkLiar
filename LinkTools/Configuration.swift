/*
 * Copyright (C) 2012-2018 halo https://io.github.com/halo/LinkLiar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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

  var anonymizationSeed: MACAddress {
    guard let seed = self.dictionary["anonymous"] as? String else {
      return MACAddress("")
    }

    return MACAddress(seed)
  }

  var isAnonymized: Bool {
    return anonymizationSeed.isValid
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

  func action() -> Action {
    return Configuration.Action(dictionary: dictionary)
  }

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
   * Queries whether user-defined prefixes should be used for an Interface.
   *
   * - parameter hardMAC: The hardware MAC address of an Interface.
   */
  func usePrefixesForInterface(_ hardMAC: MACAddress) -> Bool? {
    return dictionary[hardMAC.formatted] as? Bool ?? false
  }

  /**
   * Queries whether user-defined prefixes should be used by default.
   *
   * - parameter hardMAC: The hardware MAC address of an Interface.
   */
  func usePrefixesForDefault() -> Bool {
    return dictionary["default"] as? Bool ?? false
  }

  func calculatedUsePrefixesForInterface(_ hardMAC: MACAddress) -> Bool {
    return usePrefixesForInterface(hardMAC) || usePrefixesForDefault()
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

  /**
   * Looks up which prefixes are specified for an Interface.
   *
   * - parameter hardMAC: The hardware MAC address of an Interface.
   *
   * - returns: An Array of valid `MACAddress` or `nil` if there are none.
   */
  func prefixesForInterface(_ hardMAC: MACAddress) -> [MACPrefix]? {
    guard let interfaceDictionary = dictionary[hardMAC.formatted] as? [String: String] else { return nil }
    guard let rawAddressesString = interfaceDictionary["prefixes"] else { return nil }
    let rawAddresses = rawAddressesString.split(separator: ",")

    let addresses = rawAddresses.compactMap { string -> MACPrefix? in
      let address = MACPrefix(String(string))
      return address.isValid ? address : nil
    }

    return addresses.isEmpty ? nil : addresses
  } 

  /**
   * Looks up which prefixes are specified as default.
   *
   * - returns: An Array of valid `MACAddress` or `nil` if there are none.
   */
  func prefixesForDefaultInterface() -> [MACPrefix]? {
    guard let interfaceDictionary = dictionary["default"] as? [String: String] else { return nil }
    guard let rawAddressesString = interfaceDictionary["prefixes"] else { return nil }
    let rawAddresses = rawAddressesString.split(separator: ",")

    let addresses = rawAddresses.compactMap { string -> MACPrefix? in
      let address = MACPrefix(String(string))
      return address.isValid ? address : nil
    }

    return addresses.isEmpty ? nil : addresses
  }

  /**
   * Looks up the defined prefixes for an Interface.
   * If no valid address has been defined, use the default one.
   * If the default is no valid address either, returns nil.
   *
   * - parameter hardMAC: The hardware MAC address of an Interface.
   *
   * - returns: An Array of valid `MACAddress` (falling back to the default)
   *            or `nil` if there are none.
   */
  func calculatedPrefixesForInterface(_ hardMAC: MACAddress) -> [MACPrefix]? {
    return prefixesForInterface(hardMAC) ?? prefixesForDefaultInterface()
  }
}
