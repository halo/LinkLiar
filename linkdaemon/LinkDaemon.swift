import Cocoa

class LinkDaemon {

  var observer: FileObserver?

  func run() {
    Log.debug("Daemon \(LinkDaemon.version.formatted) says hello")

    signal(SIGTERM) { code in
      Log.debug("Received SIGTERM, shutting down immediately")
      exit(0)
    }

    NotificationCenter.default.addObserver(forName: .configChanged, object: nil, queue: nil, using: configChanged)
    Config.observe()
    RunLoop.main.run()
  }

  func configChanged(_ notification: Notification) {
    Synchronizer.run()
  }

  static var version: Version = {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      return Version(version)
    }
    return Version("?.?.?")
  }()

}
