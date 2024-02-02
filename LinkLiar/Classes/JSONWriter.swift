// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation
import os.log

class JSONWriter {
  // MARK: Class Methods

  init(_ filePath: String) {
    self.path = filePath
  }

  // MARK: Instance Methods

  /// Persists a `Dictionary` in a file using `JSON` format.
  ///
  func write(_ dictionary: [String: Any]) -> Bool {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: dictionary,
                                                options: [.sortedKeys, .prettyPrinted]) as Data
      let json = String(data: jsonData, encoding: .utf8)!

      do {
        // We don't have write-permissions to the entire directory.
        // So we cannot create a temporary auxiliary file and "atomically" replace config.json,
        // Instead we modify the existing file in-place, since we're only allowed to do that.
        try json.write(toFile: path, atomically: false, encoding: .utf8)
        return true
      } catch {
        Log.error("Could not write: \(error)")
        return false
      }
    } catch {
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
