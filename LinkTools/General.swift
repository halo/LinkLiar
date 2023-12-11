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

    /**
     * Queries whether interfaces set to random may be rerandomized at best-effort.
     * This is yes by default. You can turn it off by adding the key.
     */
    var isForbiddenToRerandomize: Bool {
      guard let restriction = self.dictionary["skip_rerandom"] as? Bool else {
        return false
      }

      return restriction != false
    }

//    /**
//     * Queries whether MAC addresses should be anonymized in GUI and logs.
//     */
    var isAnonymized: Bool {
      anonymizationSeed.isValid
    }

    /**
     * Queries a seed used for anonymizing MAC addresses shown in GUI and logs.
     */
    var anonymizationSeed: MACAddress {
      guard let seed = self.dictionary["anonymous"] as? String else {
        return MACAddress("")
      }

      return MACAddress(seed)
    }
  }
}
