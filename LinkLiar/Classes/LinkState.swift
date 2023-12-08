// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

@Observable

class LinkState {
  // GUI
  var wantsToQuit = false
  var version: Version = {
    Version(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?.?.?")
  }()

  // Daemon
  var daemonRegistration = DaemonRegistrations.unknown
  var xpcStatus = XpcStatuses.unknown
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
  enum DaemonRegistrations: String {
    case unknown = "unknown"
    case notRegistered = "not registered"
    case enabled = "enabled"
    case requiresApproval = "requires approval"
    case notFound = "not found"
    case novel = "novel" // Didn't exist yet in `SMAppService.Status` in this release.
  }

  enum XpcStatuses: String {
    case unknown
    case initialized
    case connected
    case invalidated
    case interrupted
  }
}
