// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

struct MACVendors {

  private static var dictionary: [String: String] = [:]

  static func load() {
    Log.debug("Loading MAC vendors asynchronously...")
    DispatchQueue.global(qos: .background).async(execute: { () -> Void in
      if dictionary = JSONReader(filePath: path).dictionary as [String: String] else {
        Log.debug("Could not parse MAC vendors.")
        return
      }
      Log.debug("MAC vendors loading completed. I got \(dictionary.count) prefixes.")
    })
  }

  static func name(address: MACAddress) -> String {
    Log.debug("Looking up vendor of MAC \(address.formatted)")
    guard let name = dictionary[address.prefix] else {
      return "No Vendor"
    }
    return name
  }

  private static var path = Bundle.main.url(forResource: "oui", withExtension: "json")!.path

  /*
    let bundle = Bundle(for: type(of: self))
    let filename = name.components(separatedBy: ".")

    return bundle .url(forResource: filename.first, withExtension: filename.last)!.path
  }()
*/

}
