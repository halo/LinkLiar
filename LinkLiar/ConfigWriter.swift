import Foundation
import os.log

struct ConfigWriter {

  static func reset() {
    var dictionary = [String: Any]()
    dictionary["version"] = Config.version()
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func ignoreInterface(_ hardMAC: String) {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary[hardMAC] = ["action": "ignore"]
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func randomizeInterface(_ hardMAC: String) {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary[hardMAC] = ["action": "random"]
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  private static func dictionaryWithCurrentVersion() -> [String: Any] {
    var dictionary = Config.instance.dictionary
    dictionary["version"] = Config.version()
    return dictionary
  }

}
