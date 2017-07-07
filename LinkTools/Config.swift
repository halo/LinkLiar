/*
 * Copyright (C) 2017 halo https://io.github.com/halo/LinkLiar
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

struct Config {

  static var observer: FileObserver = {
    Log.debug("Setting up listener for \(Paths.configFile)")
    return FileObserver(path: Paths.configFile, callback: {
      Log.debug("Initiating config singleton reset.")
      reload()
    })
  }()

  private static var _instance: Configuration = Configuration(dictionary: [String: Any]())

  static var instance: Configuration {
    if (_instance.version == nil) { reload() }
    return _instance
  }

  static func observe() {
    // This is a silly no-op to initiate the `observer` variable.
    if observer as FileObserver? != nil {}
    reload()
  }

  static func reload() {
    // This is just to initialize the static variable holding the observer.
    Log.debug("Reloading Configuration singleton from file")
    let reader = JSONReader(filePath: Paths.configFile)
    if reader.failure {
      return
    }
    let dictionary = reader.dictionary
    _instance = Configuration(dictionary: dictionary)
    NotificationCenter.default.post(name:.configChanged, object: nil, userInfo: nil)
  }

  /*
  static func interfaces() -> [String: [String: String]] {
    let dictionary = instance.dictionary
    guard let interfacesDictionary = dictionary["interfaces"] as? [String: [String: String]] else {
      Log.info("Cannot interpret interfaces section of config file. Ignoring it.")
      return [String: [String: String]]()
    }
     return interfacesDictionary
  }
 */

}
