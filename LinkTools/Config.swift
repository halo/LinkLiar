struct Config {

  // I'm pretty sure this is atomic.
  // So there will always be exactly one observer.
  /*
  static var observer: FileObserver = {
    Log.debug("Setting up listener for \(Paths.configFile)")

    return FileObserver(path: Paths.configFile, block: {
      Log.debug("Resetting cached configuration.")
      reload()
    })
  }()
 **/

  static var observer: FileObserver = {
    Log.debug("Setting up listener for \(Paths.configFile)")
    return FileObserver(path: Paths.configFile, callback: {
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
    Log.debug("Reloading Configuration singleton")
    let dictionary = JSONReader(filePath: Paths.configFile).dictionary
    _instance = Configuration(dictionary: dictionary)
  }

}
