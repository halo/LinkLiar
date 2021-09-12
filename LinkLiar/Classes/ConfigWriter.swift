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
import os.log

struct ConfigWriter {

  static var isWritable: Bool {
    var isDirectory: ObjCBool = false
    if !FileManager.default.fileExists(atPath: Paths.configFile, isDirectory: &isDirectory) {
      reset()
    }

    return FileManager.default.isWritableFile(atPath: Paths.configFile)
  }

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
    Log.debug("Changing config to randomize Interface \(interface.BSDName) excluding its current address \(interface.softMAC.humanReadable)")
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
    Log.debug("Changing config to specific soft MAC \(softMAC.humanReadable) for hard MAC \(interface.hardMAC.humanReadable)...")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func specifyDefaultInterface(softMAC: MACAddress) {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary["default"] = ["action": "specify", "address": softMAC.formatted]
    Log.debug("Changing config to specific soft MAC \(softMAC.humanReadable) for default Interfaces...")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func addDefaultPrefix(prefix: MACPrefix) {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary["prefixes"] = Config.instance.prefixes.prefixes + [prefix]
    Log.debug("Changing config to add Prefix \(prefix.humanReadable)...")
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

  static func anonymize() {
    var dictionary = dictionaryWithCurrentVersion()
    let prefix = String(format: "%06X", Int(arc4random_uniform(0xffffff)))
    let suffix = String(format: "%06X", Int(arc4random_uniform(0xffffff)))
    dictionary["anonymous"] = MACAddress(prefix + suffix).formatted
    Log.debug("Changing config by adding anonymization seed...")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func deAnonymize() {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary["anonymous"] = nil
    Log.debug("Changing config by removing anonymization seed...")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func removeVendor(_ vendor: Vendor) {
    var dictionary = dictionaryWithCurrentVersion()
    let currentVendorIds = Config.instance.prefixes.vendors.map { $0.id }
    let newVendorIds = currentVendorIds.filter { $0 != vendor.id }
    dictionary["vendors"] = newVendorIds
    Log.debug("Changing config by removing Vendor with ID \"\(vendor.id)\"...")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func removePrefix(_ prefix: MACPrefix) {
    var dictionary = dictionaryWithCurrentVersion()
    let currentPrefixes = Config.instance.prefixes.prefixes.map { $0.formatted }
    let newPrefixes = currentPrefixes.filter { $0 != prefix.formatted }
    dictionary["prefixes"] = newPrefixes
    Log.debug("Changing config by removing Prefix \"\(prefix.formatted)\"...")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func addVendor(_ vendor: Vendor) {
    var dictionary = dictionaryWithCurrentVersion()
    let currentVendorIds = Config.instance.prefixes.vendors.map { $0.id }
    let newVendorIds = currentVendorIds + [vendor.id]
    dictionary["vendors"] = Array(Set(newVendorIds)).sorted() // Removes duplicates
    Log.debug("Changing config by adding Vendor with ID \"\(vendor.id)\"...")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func addPrefix(_ prefix: MACPrefix) {
    var dictionary = dictionaryWithCurrentVersion()
    let currentPrefixes = Config.instance.prefixes.prefixes.map { $0.formatted }
    let newPrefixes = currentPrefixes + [prefix.formatted]
    dictionary["prefixes"] = Array(Set(newPrefixes)).sorted() // Removes duplicates
    Log.debug("Changing config by adding Prefix \"\(prefix.formatted)\"...")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  private static func dictionaryWithCurrentVersion() -> [String: Any] {
    var dictionary = Config.instance.dictionary
    dictionary["version"] = AppDelegate.version.formatted
    return dictionary
  }

}
