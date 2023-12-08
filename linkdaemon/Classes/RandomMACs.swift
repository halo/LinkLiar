// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

extension Collection where Index == Int {

  /**
   Picks a random element of the collection.

   - returns: A random element of the collection.
   */
  func sample() -> Iterator.Element? {
    return isEmpty ? nil : self[Int(arc4random_uniform(UInt32(endIndex)))]
  }

}

struct RandomMACs {

  // Internal Methods

  static func generate() -> MACAddress {
    return MACAddress([prefix(), suffix()].joined())
  }

  private static func prefix() -> String {
    return "aa:aa:aa"
//    let prefixes = [String] // Config.instance.prefixes.calculatedPrefixes
//
//    guard let prefix = prefixes.sample() else {
//      // The Array is never empty. But need to catch it still.
//      Log.error("Could not pick random prefix, falling back to 00:00:00")
//      return "00:00:00"
//    }
//    Log.debug("Chose random user-defined prefix \(prefix.formatted) among \(prefixes.count) prefixes")
//
//    return prefix.prefix
  }

  private static func suffix() -> String {
    return String(format: "%06X", Int(arc4random_uniform(0xffffff)))
  }

}
