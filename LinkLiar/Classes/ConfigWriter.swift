import Foundation
import os.log

struct ConfigWriter {

  static func reset() {
    var dictionary = [String: String]()
    dictionary["version"] = AppDelegate.version.formatted
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
