// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Cocoa

class LinkDaemon {
  // MARK: Class Methods

  init() {
    Log.debug("Daemon \(version.formatted) says hello")

    // Start observing the config file.
    configFileObserver = FileObserver(path: Paths.configFile, callback: configFileChanged)

    // Load config file once.
    configFileChanged()

    intervalTimer = IntervalTimer(callback: intervalElaped)

    // Start observing changes of ethernet interfaces
    networkObserver = NetworkObserver(callback: networkConditionsChanged)

    NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(willPowerOff), name: NSWorkspace.willPowerOffNotification, object: nil)
    NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(willSleep(_:)), name: NSWorkspace.willSleepNotification, object: nil)
    NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(didWake(_:)), name: NSWorkspace.didWakeNotification, object: nil)

    RunLoop.main.run()
  }

  // MARK: Private Instance Properties

  private var configFileObserver: FileObserver?
  private var networkObserver: NetworkObserver?
  private var intervalTimer: IntervalTimer?

  /// Holds the raw configuration file as Dictionary.
  var configDictionary: [String: Any] = [:]

  // MARK: Private Instance Methods

  private func intervalElaped() {
    Log.debug("Interval elaped, acting upon it")
    Synchronizer.run()
  }

  private func configFileChanged() {
    DispatchQueue.main.async {
      Log.debug("Config file change detected, acting upon it")
      self.configDictionary = JSONReader(filePath: Paths.configFile).dictionary
    }
  }

  private func networkConditionsChanged() {
    DispatchQueue.main.async {
      Log.debug("Network change detected, acting upon it")
      Synchronizer.run()
    }
  }

  @objc func willPowerOff(_ _: Notification) {
    Log.debug("Logging out...")
    Synchronizer.mayReRandomize()
  }

  @objc func willSleep(_ _: Notification) {
    Log.debug("Going to sleep...")
    // It's safe to randomize here, loosing Wi-Fi is not tragic while
    // closing the lid of your MacBook.
    Synchronizer.mayReRandomize()
  }

  @objc func didWake(_ _: Notification) {
    Log.debug("Woke up...")
    // Cannot re-randomize here because it's too late.
    // Wi-Fi will loose connection when opening the lid of your MacBook.
  }

  var version: Version = {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      return Version(version)
    }
    return Version("?.?.?")
  }()
}
