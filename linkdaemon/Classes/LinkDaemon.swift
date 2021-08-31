/*
 * Copyright (C) 2012-2021 halo https://io.github.com/halo/LinkLiar
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

    NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(willPowerOff), name: NSWorkspace.willPowerOffNotification, object: nil)
    NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(willSleep(_:)), name: NSWorkspace.willSleepNotification, object: nil)
    NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(didWake(_:)), name: NSWorkspace.didWakeNotification, object: nil)
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
    // It's safe to randomize here, loosing Wi-Fi is not tragic while
    // closing the lid of your MacBook.
    Synchronizer.mayReRandomize()
  }

  @objc func didWake(_ _: Notification) {
    Log.debug("Woke up...")
    // Cannot re-randomize here because it's too late.
    // Wi-Fi will loose connection when opening the lid of your MacBook.
  }

  static var version: Version = {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      return Version(version)
    }
    return Version("?.?.?")
  }()

}
