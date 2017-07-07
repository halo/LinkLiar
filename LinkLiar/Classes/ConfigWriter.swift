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
import os.log

struct ConfigWriter {

  static func reset() {
    var dictionary = [String: String]()
    dictionary["version"] = AppDelegate.version.formatted
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func restrictDaemon() {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary["restrict_daemon"] = true
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func freeDaemon() {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary["restrict_daemon"] = nil
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func allowRerandom() {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary["skip_rerandom"] = nil
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func forbidRerandom() {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary["skip_rerandom"] = true
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func ignoreInterface(_ interface: Interface) {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary[interface.hardMAC.formatted] = ["action": "ignore"]
    Log.debug("Changing config to ignore Interface \(interface.BSDName)")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func ignoreDefaultInterface() {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary["default"] = ["action": "ignore"]
    Log.debug("Changing config to ignore default Interfaces")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func randomizeInterface(_ interface: Interface) {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary[interface.hardMAC.formatted] = ["action": "random", "except": interface.softMAC.formatted]
    Log.debug("Changing config to randomize Interface \(interface.BSDName) excluding its current address \(interface.softMAC.formatted)")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func randomizeDefaultInterface() {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary["default"] = ["action": "random"]
    Log.debug("Changing config to randomize default Interfaces")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func specifyInterface(_ interface: Interface, softMAC: MACAddress) {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary[interface.hardMAC.formatted] = ["action": "specify", "address": softMAC.formatted]
    Log.debug("Changing config to specific soft MAC \(softMAC.formatted) for hard MAC \(interface.hardMAC.formatted)...")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func specifyDefaultInterface(softMAC: MACAddress) {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary["default"] = ["action": "specify", "address": softMAC.formatted]
    Log.debug("Changing config to specific soft MAC \(softMAC.formatted) for default Interfaces...")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func originalizeInterface(_ interface: Interface) {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary[interface.hardMAC.formatted] = ["action": "original"]
    Log.debug("Changing config to originalize Interface \(interface.BSDName)")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func originalizeDefaultInterface() {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary["default"] = ["action": "original"]
    Log.debug("Changing config to originalize default Interfaces...")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func forgetInterface(_ interface: Interface) {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary[interface.hardMAC.formatted] = nil
    Log.debug("Changing config by removing Interface \(interface.BSDName)")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  private static func dictionaryWithCurrentVersion() -> [String: Any] {
    var dictionary = Config.instance.dictionary
    dictionary["version"] = AppDelegate.version.formatted
    return dictionary
  }

}
