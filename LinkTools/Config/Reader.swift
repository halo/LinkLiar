// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

enum Config {}

///
/// An immutable wrapper for querying the content of the configuration file.
///
extension Config {
  struct Reader {
    // MARK: Class Methods

    init(_ dictionary: [String: Any]) {
      self.dictionary = dictionary
    }

    // MARK: Public Instance Properties

    ///
    /// Gives (readonly) access to the underlying Dictionary of this configuration.
    /// This is basically the JSON content of the configuration file as Dictionary.
    ///
    var dictionary: [String: Any]

    ///
    /// Queries the version with which the configuration was created.
    ///
    lazy var version: String? = {
      dictionary[Config.Key.version.rawValue] as? String
    }()

    ///
    /// Queries universal LinkLiar settings.
    ///
    var general: General {
      General(dictionary: dictionary)
    }

    ///
    /// Queries the list of Vendors.
    ///
    var vendors: Vendors {
      Vendors(dictionary: dictionary)
    }

    ///
    /// Queries the list of Vendor MAC prefixes.
    ///
    var ouis: OUIs {
      OUIs(dictionary: dictionary)
    }

    ///
    /// Queries settings of one Interface.
    ///
    func policy(_ hardMAC: MAC) -> Policy {
      Policy(hardMAC.address, dictionary: dictionary)
    }

    ///
    /// Queries settings of the "default" Interface.
    ///
    var fallbackPolicy: Policy {
      Policy(Config.Key.theDefault.rawValue, dictionary: dictionary)
    }

    ///
    /// Determines final values by comparing
    /// specific Interfaces and fallback defaults.
    ///
    func arbiter(_ hardMAC: MAC) -> Config.Arbiter {
      Config.Arbiter(config: self, hardMAC: hardMAC)
    }

    var isRecommended: Bool {
      let interfaces = Interfaces.all(.async)

      // If any Interface is random (or otherwise specified),
      // then LinkLiar is doing what it's supposed to do (i.e. recommended usage).
      if interfaces.contains(where: { arbiter($0.hardMAC).action == .random }) { return true }
      if interfaces.contains(where: { arbiter($0.hardMAC).action == .specify }) { return true }
      if interfaces.contains(where: { arbiter($0.hardMAC).action == .original }) { return true }

      return false
    }
  }
}

extension Config {
  enum Key: String {
    case action
    case apple
    case address
    case anonymize
    case theDefault = "default"
    case except
    case denyScan = "deny_scan"
    case rerandomize
    case ssids
    case vendors
    case version
    case recommendation
    case restrictDaemon = "restrict_daemon"
  }
}
