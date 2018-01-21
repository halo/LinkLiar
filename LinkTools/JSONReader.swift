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
import os.log

class JSONReader {

  private var path: String
  
  private var url: URL {
    return URL(fileURLWithPath: path)
  }

  var success: Bool {
    return data != nil
  }

  var failure: Bool {
    return !success
  }

  init(filePath: String) {
    self.path = filePath
  }

  lazy var data: Data? = {
    do {
      Log.debug("Reading \(self.path)")
      let result = try Data(contentsOf: self.url)
      Log.debug("Content: \(result)")
      Log.debug("Successfuly read it")
      return result
    } catch let error as NSError {
      Log.debug(error.localizedDescription)
      return nil
    }
  }()

  lazy var dictionary: [String: Any] = {
    guard let jsonData = self.data else {
      Log.error("Missing JSON data to parse.")
      return [String: Any]()
    }

    do {
      let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
      if let object = json as? [String: Any] {
        return object
      } else {
        Log.debug("JSON is not a Key-Value object")
      }
    } catch let error as NSError {
      Log.error(error.localizedDescription)
    }
    return [String: Any]()
  }()

}
