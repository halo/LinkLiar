/*
 * Copyright (C)  halo https://io.github.com/halo/LinkLiar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
 * persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import SwiftUI

@Observable

class LinkState {
  // GUI
  var wantsToQuit = false
  var version: Version = {
    Version(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
  }()

  // Daemon
  var daemonRegistration = daemonRegistrations.unknown
  var xpcStatus = xpcStatuses.unknown
  var daemonVersion = Version("0.0.0")

  // Network
  var allInterfaces = [Interface]()
  var nonHiddenInterfaces: [Interface] {
    self.allInterfaces.filter {
      config.policy($0.hardMAC).action != .hide
    }
  }

  // Settings

  /// Holds the raw configuration file as Dictionary.
  var configDictionary: [String: Any] = [:]

//  var settingsEditingInterface: Interface?

  // Derived
  var warnAboutLeakage: Bool {
    self.nonHiddenInterfaces.contains(where: { interface in
      interface.hasOriginalMAC && config.policy(interface.hardMAC).action != .ignore
    })
  }

  /// Convenience wrapper for reading the configuration.
  var config: Configuration {
    Configuration(dictionary: configDictionary)
  }

}

extension LinkState {
  // Analogous to `SMAppService.Status`.
  enum daemonRegistrations: String {
    case unknown = "unknown"
    case notRegistered = "not registered"
    case enabled = "enabled"
    case requiresApproval = "requires approval"
    case notFound = "not found"
    case novel = "novel" // Didn't exist yet in `SMAppService.Status` in this release.
  }

  enum xpcStatuses: String {
    case unknown = "unknown"
    case initialized = "initialized"
    case connected = "connected"
    case invalidated = "invalidated"
    case interrupted = "interrupted"
  }
}
