// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

/// Checks a potential MAC address for validity and normalizes it.
///
struct MACAnonymizer {
  // MARK: - Class Methods

  static func anonymize(_ input: MAC) -> String {
    let interfaces = Interfaces.all(.none)

    if let interface = interfaces.first(where: { $0.hardMAC == input }) {
      return String(String(repeating: "e\(interface.bsd.number):", count: 6).dropLast())
    }

    return input.address
  }
}
