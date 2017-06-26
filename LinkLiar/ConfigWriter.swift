import Foundation
import os.log

struct ConfigWriter {

  static func reset() {
    var dictionary = [String: Any]()
    dictionary["version"] = Config.version()
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func ignoreInterface(_ interface: Interface) {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary[interface.hardMAC.formatted] = ["action": "ignore"]
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func ignoreDefaultInterface() {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary["default"] = ["action": "ignore"]
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func randomizeInterface(_ interface: Interface) {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary[interface.hardMAC.formatted] = ["action": "random"]
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func randomizeDefaultInterface() {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary["default"] = ["action": "random"]
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func specifyInterface(_ interface: Interface, softMAC: MACAddress) {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary[interface.hardMAC.formatted] = ["action": "specify", "address": softMAC.formatted]
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func originalizeInterface(_ interface: Interface) {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary[interface.hardMAC.formatted] = ["action": "original"]
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func forgetInterface(_ interface: Interface) {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary[interface.hardMAC.formatted] = nil
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  private static func dictionaryWithCurrentVersion() -> [String: Any] {
    var dictionary = Config.instance.dictionary
    dictionary["version"] = Config.version()
    return dictionary
  }

}
