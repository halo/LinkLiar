import Cocoa

class LinkDaemon {

  var observer: FileObserver?

  func run() {
    Log.debug("daemon says hello")

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

}
