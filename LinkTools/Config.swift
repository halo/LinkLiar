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
    // This is a silly no-op to initiate the observer variable.
    if observer as FileObserver? != nil {}
    reload()
  }

  static func reload() {
    // This is just to initialize the static variable holding the observer.
    Log.debug("Reloading Configuration singleton from file")
    let dictionary = JSONReader(filePath: Paths.configFile).dictionary
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
