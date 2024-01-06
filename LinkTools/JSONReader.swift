// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation
import os.log

class JSONReader {
  // MARK: Class Methods

  init(_ filePath: String) {
    self.path = filePath
  }

  // MARK: Instance Properties

  var success: Bool {
    data != nil
  }

  var failure: Bool {
    !success
  }

  lazy var data: Data? = {
    do {
      Log.debug("Reading \(path)")
      let result = try Data(contentsOf: url)
      Log.debug("Content: \(result)")
      Log.debug("Successfuly read it")
      return result
    } catch let error as NSError {
      Log.debug(error.localizedDescription)
      return nil
    }
  }()

  lazy var dictionary: [String: Any] = {
    guard let jsonData = data else {
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

  // MARK: Private Instance Properties

  private var path: String

  private var url: URL {
    URL(fileURLWithPath: path)
  }
}
