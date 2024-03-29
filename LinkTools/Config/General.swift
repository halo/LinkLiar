// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

extension Config {
  struct General {
    // MARK: Initialization

    init(dictionary: [String: Any]) {
      self.dictionary = dictionary
    }

    // MARK: Public Instance Properties

    var dictionary: [String: Any]

    var isDismissingRecommendation: Bool {
      guard let _ = self.dictionary[Config.Key.recommendation.rawValue] as? Bool else {
        return false
      }

      return true
    }

    ///
    /// Queries whether interfaces set to random may be rerandomized at best-effort.
    /// This is yes by default. You can turn it off by adding the key.
    ///
    var isRerandomize: Bool {
      self.dictionary[Config.Key.rerandomize.rawValue] as? Bool ?? false
    }

    /// Queries whether MAC addresses should be anonymized in GUI and logs.
    /// This is no by default. You can turn it on by adding the key.
    ///
    var isAnonymized: Bool {
      self.dictionary[Config.Key.anonymize.rawValue] as? Bool ?? false
    }

    /// Whether or not to scan for SSIDS on daemon synchronization runs.
    ///
    var denyScan: Bool {
      self.dictionary[Config.Key.denyScan.rawValue] as? Bool ?? false
    }
  }
}
