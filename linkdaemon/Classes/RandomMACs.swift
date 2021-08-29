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
    let prefixes = Config.instance.prefixes.calculatedPrefixes

    guard let prefix = prefixes.sample() else {
      // The Array is never empty. But need to catch it still.
      Log.error("Could not pick random prefix, falling back to 00:00:00")
      return "00:00:00"
    }
    Log.debug("Chose random user-defined prefix \(prefix) among \(prefixes.count) prefixes")

    return prefix.prefix
  }

  private static func suffix() -> String {
    return String(format: "%06X", Int(arc4random_uniform(0xffffff)))
  }

}
