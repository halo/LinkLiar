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
  }
}

extension Config {
  enum Key: String {
    case action
    case ssids
  }
}
