import Cocoa

class LinkDaemon {

  func run(){
    Log.debug("daemon says hello")

    signal(SIGINT) {
      s in
      print("Received SIGTERM, shutting down immediately")
      exit(0)
    }

    RunLoop.main.run()
  }

}
