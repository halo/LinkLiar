// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

struct MACVendors {
  private static var dictionary: [String: String] = [:]

  static func load(_ callback: @escaping ([String: String]) -> Void) {
    Log.debug("Loading MAC vendors asynchronously...")
    DispatchQueue.global(qos: .background).async(execute: { () -> Void in
      guard let parsed = JSONReader(path).dictionary as? [String: String] else {
        Log.debug("Could not parse MAC vendors.")
        return
      }
      self.dictionary = parsed
      Log.debug("MAC vendors loading completed. I got \(parsed.count) prefixes.")
      callback(parsed)
    })
  }

  static func name(_ oui: OUI) -> String {
    Log.debug("Looking up vendor of MAC \(oui.address)")
    guard let name = dictionary[oui.address] else {
      return "No Vendor"
    }
    return name
  }

  private static var path = Bundle.main.url(forResource: "oui", withExtension: "json")!.path
}
