/*
 * Copyright (C) halo https://io.github.com/halo/LinkLiar
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
    return URL(fileURLWithPath: path)
  }

}
