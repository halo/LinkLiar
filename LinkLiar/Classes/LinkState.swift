// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

@Observable

class LinkState {
  // Convenience initializer
  init(_ configDictionary: [String: Any]? = nil) {
    self.configDictionary = configDictionary ?? [:]
  }

  // GUI
  var wantsToQuit = false
  var version: Version = {
    Version(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0")
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

  /// Convenience wrapper for reading the configuration.
  var config: Config.Reader {
    Config.Reader(configDictionary)
  }

  // Derived
  var warnAboutLeakage: Bool {
    self.nonHiddenInterfaces.contains(where: { interface in
      interface.hasOriginalMAC && config.policy(interface.hardMAC).action != .ignore
    })
  }
}

extension LinkState {
  // Analogous to `SMAppService.Status`.
  enum DaemonRegistrations: String {
    case unknown
    case notRegistered
    case enabled
    case requiresApproval
    case notFound
    // I.e. didn't exist yet in `SMAppService.Status` at the time of this release.
    case novel
  }

  enum XpcStatuses: String {
    case unknown
    case initialized
    case connected
    case invalidated
    case interrupted
  }
}
