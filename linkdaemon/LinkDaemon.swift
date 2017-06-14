import Cocoa

public class LinkDaemon {

  func run() {
    Log.debug("daemon says hello")

    signal(SIGTERM) { code in
      Log.debug("Received SIGTERM, shutting down immediately")
      exit(0)
    }
    FileObserver(path: Paths.configFile, block: {
      Log.debug("file changed!")
    })


    RunLoop.main.run()
  }

}
