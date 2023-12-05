/*
 * Copyright (C) halo https://io.github.com/halo/LinkLiar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Cocoa

class LinkDaemon {

  // MARK: Class Methods
  
  init() {
    Log.debug("Daemon \(version.formatted) says hello")
  }
  
  func run() {
    // Start observing the config file.
    configFileObserver = FileObserver.init(path: Paths.configFile, callback: configFileChanged)

    // Load config file once.
    configFileChanged()

    intervalTimer = IntervalTimer.init(callback: intervalElaped)

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
      self.configDictionary = JSONReader.init(filePath: Paths.configFile).dictionary
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
