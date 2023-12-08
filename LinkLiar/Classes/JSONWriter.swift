// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation
import os.log

class JSONWriter {

  // MARK: Class Methods

  init(filePath: String) {
    self.path = filePath
  }

  // MARK: Instance Methods

  func write(_ dictionary: [String: Any]) -> Bool {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [.sortedKeys, .prettyPrinted]) as NSData
      let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String

      do {
        // We don't have write-permissions to the entire directory.
        // Instead of creating a temporary auxiliary file and atomically replacing config.json,
        // we modify the existing file in-place, since we're only allowed to do that.
        try jsonString.write(toFile: path, atomically: false, encoding: .utf8)
        return true
      } catch let error as NSError {
        Log.error("Could not write: \(error)")
        return false
      }

    } catch let error as NSError {
      Log.error("Could not serialize: \(error)")
      return false
    }
  }

  // MARK: Private Instance Properties

  private var path: String

  private var url: URL {
    URL(fileURLWithPath: path)
  }

}
