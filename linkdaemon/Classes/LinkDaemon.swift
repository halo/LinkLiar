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
    NetworkObserver.observe()
    IntervalTimer.run()
    Config.observe()
    RunLoop.main.run()
  }

  func subscribe() {
    NotificationCenter.default.addObserver(forName: .configChanged, object: nil, queue: nil, using: configChanged)
    NotificationCenter.default.addObserver(forName: .intervalElapsed, object: nil, queue: nil, using: periodicRefresh)
    NotificationCenter.default.addObserver(forName: .interfacesChanged, object: nil, queue: nil, using: interfacesChanged)

    NSWorkspace.shared().notificationCenter.addObserver(self, selector: #selector(willPowerOff), name: .NSWorkspaceWillPowerOff, object: nil)
    NSWorkspace.shared().notificationCenter.addObserver(self, selector: #selector(willSleep(_:)), name: .NSWorkspaceWillSleep, object: nil)
    NSWorkspace.shared().notificationCenter.addObserver(self, selector: #selector(didWake(_:)), name: .NSWorkspaceDidWake, object: nil)
  }

  func periodicRefresh(_ _: Notification) {
    Log.debug("Time for periodic activity...")
    Synchronizer.run()
  }

  func configChanged(_ _: Notification) {
    Log.debug("Running Synchronizer because config changed...")
    Synchronizer.run()
  }

  func interfacesChanged(_ _: Notification) {
    Log.debug("Running Synchronizer because network conditions changed...")
    Synchronizer.run()
  }

  @objc func willPowerOff(_ _: Notification) {
    Log.debug("Logging out...")
    Synchronizer.mayReRandomize()
  }

  @objc func willSleep(_ _: Notification) {
    Log.debug("Going to sleep...")
    Synchronizer.mayReRandomize()
  }

  @objc func didWake(_ _: Notification) {
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
