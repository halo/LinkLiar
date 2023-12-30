// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

extension Config {
  /// An immutable wrapper for querying settings of one interface.
  ///
  /// It looks like this in JSON:
  ///
  ///     // Root of the configuration file
  ///     {
  ///       // Hardware MAC of an interface
  ///       // as key for a dictionary:
  ///       "e1:b3:3c:4d:e6:f7": {
  ///         // Various options for this interface
  ///       }
  ///     }
  ///
  struct Policy {
    // MARK: Class Methods

    init(_ hardMAC: String, dictionary: [String: Any]) {
      self.dictionary = dictionary
      self.hardMAC = hardMAC
    }

    // MARK: Instance Properties

    /// Looks up which action has been defined.
    ///
    /// Returns `nil` if no (valid) action was defined.
    ///
    /// - returns: An ``Interface.Action`` or `nil`.
    ///
    var action: Interface.Action? {
      guard let interfaceDictionary = dictionary[hardMAC] as? [String: Any] else { return nil }
      guard let actionName = interfaceDictionary[Config.Key.action.rawValue] as? String else { return nil }

      return Interface.Action(rawValue: actionName)
    }

    /// Looks up which MAC address has been defined.
    /// This is useful if the action is "specify".
    ///
    /// - returns: A valid ``MACAddress`` or `nil` if no valid address was specified.
    ///
    var address: MACAddress? {
      guard let interfaceDictionary = dictionary[hardMAC] as? [String: Any] else { return nil }
      guard let rawAddress = interfaceDictionary[Config.Key.address.rawValue] as? String else { return nil }

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
    var exceptionAddress: MACAddress? {
      guard let interfaceDictionary = dictionary[hardMAC] as? [String: Any] else { return nil }
      guard let rawAddress = interfaceDictionary[Config.Key.except.rawValue] as? String else { return nil }

      let address = MACAddress(rawAddress)
      return address.isValid ? address : nil
    }

    /// Queries the Hotspot definitions for this Interface.
    ///
    /// It looks like this in JSON:
    ///
    ///     // Root of the configuration file.
    ///     {
    ///       // Definitions for the Interface
    ///       // with a particular hardware MAC.
    ///       "ssids:00:2a:a5:75:da:32" : {
    ///         "Some Wifi Name" : "aa:bb:cc:dd:ee:ff",
    ///         "Another SSID" : "11:22:33:44:55:66"
    ///       },
    ///       // Definitions for another Interface.
    ///       "ssids:00:2a:a5:11:3f:8b" : {
    ///         "University SSID" : "55:55:55:55:55:55",
    ///       },
    ///     }
    ///
    var accessPoints: [AccessPointPolicy] {
      guard let interfaceDictionary = dictionary[hardMAC] as? [String: Any] else { return [] }
      guard let ssidsDictionary = interfaceDictionary[Config.Key.ssids.rawValue] as? [String: String] else { return [] }

      return ssidsDictionary.compactMap({ ssid, rawAddress in
        AccessPointPolicy.initIfValid(ssid: ssid, softMAC: rawAddress)
      }).sorted()
    }

    // MARK: Private Instance Properties

    /// The root of the configuration file.
    private var dictionary: [String: Any]

    /// The MAC address of the ``Interface`` we're interested in.
    private var hardMAC: String
  }
}
