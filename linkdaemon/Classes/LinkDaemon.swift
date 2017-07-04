import Cocoa

class LinkDaemon {

  var observer: FileObserver?

  func run() {
    Log.debug("Daemon \(LinkDaemon.version.formatted) says hello")

    signal(SIGTERM) { code in
      Log.debug("Received SIGTERM, shutting down immediately")
      exit(0)
    }

    subscribe()
    Config.observe()
    RunLoop.main.run()
  }

  func subscribe() {
    NotificationCenter.default.addObserver(forName: .configChanged, object: nil, queue: nil, using: configChanged)
    NSWorkspace.shared().notificationCenter.addObserver(self, selector:#selector(willPowerOff(_:)), name: .NSWorkspaceWillPowerOff, object: nil)
    NSWorkspace.shared().notificationCenter.addObserver(self, selector:#selector(willSleep(_:)), name: .NSWorkspaceWillSleep, object: nil)
    NSWorkspace.shared().notificationCenter.addObserver(self, selector:#selector(didWake(_:)), name: .NSWorkspaceDidWake, object: nil)
  }

  func configChanged(_ notification: Notification) {
    Synchronizer.run()
  }

  @objc func willPowerOff(_ notification: Notification) {
    Log.debug("Logging out...")
    Synchronizer.mayReRandomize()
  }

  @objc func willSleep(_ notification: Notification) {
    Log.debug("Going to sleep...")
    Synchronizer.mayReRandomize()
  }

  @objc func didWake(_ notification: Notification) {
    Log.debug("Woke up...")
    // Cannot re-randomize here because it's too late.
    // Wi-Fi will loose connection.
  }

  static var version: Version = {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      return Version(version)
    }
    return Version("?.?.?")
  }()

}
