import Cocoa

class LinkDaemon {

  var observer: FileObserver?

  func run() {
    Log.debug("Daemon \(LinkDaemon.version.formatted) says hello")

    signal(SIGTERM) { code in
      Log.debug("Received SIGTERM, shutting down immediately")
      exit(0)
    }
    observer = FileObserver(path: Paths.configFile, callback: {
      Log.debug("file changed!")
      Synchronizer.run()
    })

    RunLoop.main.run()
  }

  static var version: Version = {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      return Version(version)
    }
    return Version("?.?.?")
  }()


}
