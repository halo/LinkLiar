/*
 * Copyright (C) 2012-2021 halo https://io.github.com/halo/LinkLiar
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

struct MACVendors {

  private static var dictionary: [String: String] = [:]

  static func load() {
    Log.debug("Loading MAC vendors asynchronously...")
    DispatchQueue.global(qos: .background).async(execute: { () -> Void in
      dictionary = JSONReader(filePath: path).dictionary as! [String : String]
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
