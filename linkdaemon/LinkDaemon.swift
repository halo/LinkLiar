import Cocoa

class LinkDaemon {

  func run() {
    Log.debug("daemon says hello")

    signal(SIGTERM) { code in
      Log.debug("Received SIGTERM, shutting down immediately")
      exit(0)
    }
    let observer = FileObserver(path: Configuration().path, block: {
      Log.debug("file changed!")
    })


    RunLoop.main.run()
  }

}
