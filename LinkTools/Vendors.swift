import Foundation

struct Vendors {

  /**
   * Looks up a Vendor by its ID.
   * If no vendor was found, returns nil.
   *
   * - parameter id: The ID of the vendor (e.g. "ibm").
   *
   * - returns: A `Vendor` if found and `nil` if missing.
   */
  static func find(_ id: String) -> Vendor? {
    let id = id.filter("0123456789abcdefghijklmnopqrstuvwxyz".contains)
    guard let vendorData = MACPrefixes.dictionary[id] else { return nil }
    guard let rawPrefixes = vendorData.values.first else { return nil }
    guard let name = vendorData.keys.first else { return nil }

    let prefixes = rawPrefixes.map { rawPrefix in
      MACPrefix.init(String(format:"%06X", rawPrefix))
    }

    return Vendor.init(id: id, name: name, prefixes: prefixes)
  }

  static var available: [Vendor] {
    all.filter { !Config.instance.prefixes.vendors.contains($0) }
  }

  private static var all: [Vendor] {
    MACPrefixes.dictionary.keys.compactMap {
      return find($0)
    }
  }
}
