// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

enum Config {}

/**
 * An immutable wrapper for querying the content of the configuration file.
 */
extension Config {
  struct Reader {
    // MARK: Class Methods

    init(_ dictionary: [String: Any]) {
      self.dictionary = dictionary
    }

    // MARK: Public Instance Properties

    ///
    /// Gives (readonly) access to the underlying dictionary of this configuration.
    ///
    var dictionary: [String: Any]

    ///
    /// Queries the version with which the configuration was created.
    ///
    lazy var version: String? = {
      dictionary["version"] as? String
    }()

    ///
    /// Queries universal settings.
    ///
    var general: General {
      General(dictionary: dictionary)
    }

    ///
    /// Queries the global list of Vendor MAC prefixes.
    ///
    var vendors: Vendors {
      Vendors(dictionary: dictionary)
    }

    ///
    /// Queries settings of one Interface.
    ///
    func policy(_ hardMAC: MACAddress) -> Policy {
      Policy(hardMAC.formatted, dictionary: dictionary)
    }

    ///
    /// Queries settings of the "default" Interface.
    ///
    var fallbackPolicy: Policy {
      Policy("default", dictionary: dictionary)
    }

    ///
    /// Determines final values by comparing
    /// specific Interfaces and fallback defaults.
    ///
    func arbiter(_ hardMAC: MACAddress) -> Config.Arbiter {
      Config.Arbiter(config: self, hardMAC: hardMAC)
    }
  }
}

extension Config {
  enum Key: String {
    case action
    case ssids
  }
}
