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

  static func popular() -> MACAddress {
    return MACAddress([prefix(), suffix()].joined())
  }

  private static func prefix() -> String {
    return String(format:"%06X", OuiPrefixes.popular.sample()!)
  }

  private static func suffix() -> String {
    return String(format: "%06X", Int(arc4random_uniform(0xffffff)))
  }

}
