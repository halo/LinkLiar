struct Config {

  // I'm pretty sure this is atomic.
  // So there will always be exactly one observer.
  private static var observer: FileObserver = {
    Log.debug("Setting up listener for \(Paths.configFile)")

    return FileObserver(path: Paths.configFile, block: {
      Log.debug("Resetting cached configuration.")
      reload()
    })
  }()

  private static var _instance: Configuration?

  static var instance: Configuration {
    get {
      if (_instance == nil) { reload() }
      return _instance!
    }
  }

  static func reload() {
    // This is just to initialize the static variable holding the observer.
    Config.observer.noop()
    let dictionary = JSONReader(filePath: Paths.configFile).dictionary
    _instance = Configuration(dictionary: dictionary)
  }

}
