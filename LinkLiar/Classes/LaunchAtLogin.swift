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

import Foundation
import Cocoa
import ServiceManagement

struct LaunchAtLogin {
  static var isEnabled: Bool {
    get {
      // You may live with this compiler warning, for now.
      // See https://stackoverflow.com/a/44610931
      guard let jobDictionaries = SMCopyAllJobDictionaries( kSMDomainUserLaunchd ).takeRetainedValue() as? [[String:Any]] else { return false }
      let job = jobDictionaries.first { $0["Label"] as! String == Identifiers.launcher.rawValue }
      return job?["OnDemand"] as? Bool ?? false
    }

    /**
     * If true: adds LinkLauncher to the Operating System Login Items and kills the launcher.
     * If false: Removes the Login Item.
     */
    set {
      Log.debug("Setting Login Item to \(newValue)")
      let result = SMLoginItemSetEnabled(Identifiers.launcher.rawValue as CFString, newValue)
      guard result else { return Log.error("Could not disable Login item") }
      
      if newValue {
        Log.debug("Successfully enabled Login Item")
      } else {
        Log.debug("Successfully removed Login Item")
      }
    }
  }

  static func toggle() {
    isEnabled = !isEnabled
  }
}
