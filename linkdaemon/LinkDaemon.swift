// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Cocoa

class LinkDaemon {
  // MARK: Class Methods

  init() {
    Log.debug("Daemon \(version.formatted) says hello")
    subscribe()
    RunLoop.main.run()
  }

  // MARK: Private Instance Properties

  private var configFileObserver: FileObserver?
  private var networkObserver: NetworkObserver?
  private var intervalTimer: IntervalTimer?

  /// Holds the raw configuration file as Dictionary.
  var configDictionary: [String: Any] = [:]

  // MARK: Private Instance Methods

  private func subscribe() {
    // Start observing the config file.
    configFileObserver = FileObserver(path: Paths.configFile, callback: configFileChanged)

    // Load config file once.
    configFileChanged()

    intervalTimer = IntervalTimer(callback: intervalElapsed)

    // Start observing changes of ethernet interfaces
    networkObserver = NetworkObserver(callback: networkConditionsChanged)

    NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(willPowerOff),
                                                      name: NSWorkspace.willPowerOffNotification, object: nil)
    NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(willSleep(_:)),
                                                      name: NSWorkspace.willSleepNotification, object: nil)
    NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(didWake(_:)),
                                                      name: NSWorkspace.didWakeNotification, object: nil)
  }

  private func intervalElapsed() {
    Log.debug("Interval elapsed, acting upon it")
    synchronizer.run()
  }

  private func configFileChanged() {
    Log.debug("Config file change detected, acting upon it")
    synchronizer.run()
  }

  private func networkConditionsChanged() {
    Log.debug("Network change detected, acting upon it")
    synchronizer.run()
  }

  @objc func willPowerOff(_ _: Notification) {
    Log.debug("Logging out...")
    synchronizer.mayReRandomize()
  }

  @objc func willSleep(_ _: Notification) {
    Log.debug("Going to sleep...")
    // It's safe to randomize here, loosing Wi-Fi is not tragic while
    // closing the lid of your MacBook.
    synchronizer.mayReRandomize()
  }

  @objc func didWake(_ _: Notification) {
    Log.debug("Woke up...")
    // Cannot re-randomize here because it's too late.
    // Wi-Fi will loose connection when opening the lid of your MacBook.
  }

  // MARK: Instance Properties

  lazy var version: Version = {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      return Version(version)
    }
    return Version("?.?.?")
  }()

  // MARK: Private Instance Properties

  lazy var synchronizer: Executor = {
    Executor()
  }()
}
