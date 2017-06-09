import Cocoa

class LinkDaemon {

  func run(){
    Log.debug("daemon says hello")

    signal(SIGTERM) {
      s in
      Log.debug("Received SIGTERM, shutting down immediately")
      exit(0)
    }

    RunLoop.main.run()
  }

}
