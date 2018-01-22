/*
 * Copyright (C) 2012-2018 halo https://io.github.com/halo/LinkLiar
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

/**
 * The LinkLiar GUI Application.
 */
class AppDelegate: NSObject {

  // MARK: Instance Properties

  /**
   * Holds the Menu Bar instance that manages the menu tree.
   *
   * - Returns: An instance of `Bar`.
   */
  lazy var bar: Bar = Bar()

  // MARK: Type Properties

  /**
   * Looks up the version of the Application Bundle in Info.plist.
   *
   * - Returns: An instance of `Version`.
   */
  static var version: Version = {
    Version(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
  }()

  fileprivate func checkDaemon() {
    // If the daemon is self-sustained, no need to do anything
    if !Config.instance.isRestrictedDaemon {
      Log.debug("The daemon is not restricted.")
      return
    }

    // If the daemon is coupled to the GUI, activate it if necessary
    // If there is no Helper, the `reply` callback will never be triggered.
    LaunchCtl.isDaemonRunning(reply: { isRunning in
      if isRunning {
        Log.debug("Daemon is already running, no need to activate it.")
      } else {
        Log.debug("Daemon is not running, try to activate it.")
        Controller.activateDaemon(self)
      }
    })
  }

}

// MARK: - NSXPCListenerDelegate
extension AppDelegate: NSApplicationDelegate {

  // MARK: Instance Methods

  /**
   * Loads the status bar, auxiliary data and observers.
   */
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    Log.debug("LinkLiar GUI \(AppDelegate.version.formatted) launched.")

    if RunningApplications.isRunning(Identifiers.launcher.rawValue) {
      Log.debug("Sending notification to running Launcher to quit.")
      DistributedNotificationCenter.default().post(name: .killLauncher, object: Bundle.main.bundleIdentifier!)
    }

    Config.observe()
    checkDaemon()
    bar.load()
    NetworkObserver.observe()
    IntervalTimer.run()
    MACVendors.load()
  }

}
