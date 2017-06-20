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
    get {
      if (_instance.version == nil) { reload() }
      return _instance
    }
  }

  static func reload() {
    // This is just to initialize the static variable holding the observer.
    Log.debug("Reloading Configuration singleton from file")
    let dictionary = JSONReader(filePath: Paths.configFile).dictionary
    _instance = Configuration(dictionary: dictionary)
  }

  static func version() -> String {
    if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
      return version
    }
    return "?.?.?"
  }

}
