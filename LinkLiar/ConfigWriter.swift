import Foundation
import os.log

struct ConfigWriter {

  static func reset() {
    var dictionary = [String: Any]()
    dictionary["version"] = Config.version()
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func forgetInterface(_ hardMAC: String) {
    var dictionary = dictionaryWithCurrentVersion()

    guard var interfacesDictionary = dictionary["interfaces"] as? [String: [String: String]] else {
      Log.error("Cannot interpret interfaces section of config file.")
      dictionary["interfaces"] = [String: [String: Any]]()
    }

    guard var interfaceDictionary = interfacesDictionary[hardMAC] else {
      Log.error("Cannot interpret section of interface \(hardMAC) in config file.")
      return
    }

    interfaceDictionary["action"] = "ignore"
    dictionary["interfaces"] = interfacesDictionary

    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  private static func dictionaryWithCurrentVersion() -> [String: Any] {
    var dictionary = Config.instance.dictionary
    dictionary["version"] = Config.version()
    return dictionary
  }

}
