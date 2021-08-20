import Foundation

struct Vendors {

  static func find(_ name: String) -> Vendor? {
    guard let rawPrefixes = MACPrefixes.dictionary[name] else { return nil }
    let prefixes = rawPrefixes.map { rawPrefix in
      MACPrefix.init(String(format:"%06X", rawPrefix))
    }

    return Vendor.init(name: name, prefixes: prefixes)
  }

}
