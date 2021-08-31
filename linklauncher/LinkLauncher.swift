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

class LinkLauncher: NSObject {
  /**
   * Looks up the version of the Application Bundle in Info.plist.
   *
   * - Returns: An instance of `Version`.
   */
  static var version: Version = {
    Version(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
  }()

  @objc func terminate() {
    Log.debug("Shutting down myself")
    NSApp.terminate(nil)
  }

  private func startGUI() {
    Log.debug("Starting GUI located at \(path)")
    NSWorkspace.shared.launchApplication(path)
  }

  private var path: String {
    let launcherPath = Bundle.main.bundlePath as NSString
    var components = launcherPath.pathComponents
    components.removeLast()
    components.removeLast()
    components.removeLast()
    components.append("MacOS")
    components.append("LinkLiar")
    return NSString.path(withComponents: components)
  }
}

extension LinkLauncher: NSApplicationDelegate {

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    Log.debug("LinkLauncher \(LinkLauncher.version.formatted) says hello")
    DistributedNotificationCenter.default().addObserver(self, selector: #selector(self.terminate), name: .killLauncher, object: Identifiers.gui.rawValue)

    if RunningApplications.isRunning(Identifiers.gui.rawValue) {
      Log.debug("LinkLiar is already running.")
    } else {
      startGUI()
    }
    self.terminate()
  }
}

