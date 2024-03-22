// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Cocoa
import Foundation
import ServiceManagement

class Controller {
  // MARK: Class Methods

  static func queryInterfaces(state: LinkState) {
    Log.debug("Reloading Interfaces...")
    state.allInterfaces = Interfaces.all(.async)
  }

  static func registerDaemon(state: LinkState) {
    let service = SMAppService.daemon(plistName: "\(Identifiers.daemon.rawValue).plist")

    DispatchQueue.global().async {
      do {
        try service.register()
        Log.debug("Successfully registered \(service)")
      } catch {
        Log.debug("Unable to register \(error)")
      }
      queryDaemonRegistration(state: state)
    }
  }

  static func unregisterDaemon(state: LinkState) {
    let service = SMAppService.daemon(plistName: "\(Identifiers.daemon.rawValue).plist")

    DispatchQueue.global().async {
      do {
        try service.unregister()
        Log.debug("Successfully unregistered \(service)")
      } catch {
        Log.debug("Unable to unregister \(error)")
      }
      queryDaemonRegistration(state: state)
    }
  }

  static func queryDaemonVersion(state: LinkState) {
    Radio.version(state: state, reply: { version in
      if version == nil {
        Log.debug("No Version")
        state.daemonVersion = Version("0.0.0")
      } else {
        Log.debug("Received Version")
        state.daemonVersion = version!
      }
    })
  }

  static func wantsToQuit(_ state: LinkState) {
    guard !state.wantsToQuit else {
      state.wantsToQuit = false
      return
    }

    if state.daemonRegistration == .enabled {
      state.wantsToQuit = true
    } else {
      quitForReal()
    }
  }

  static func wantsToStay(_ state: LinkState) {
    state.wantsToQuit = false
  }

  static func quitForReal() {
    NSApplication.shared.terminate(nil)
  }

  static func queryAllSoftMACs(_ state: LinkState) {
    state.allInterfaces.forEach { $0.querySoftMAC() }
  }

  static func troubleshoot(state: LinkState) {
    queryInterfaces(state: state)
    queryDaemonRegistration(state: state)
  }

  // MARK: Private Functions

  static func queryDaemonRegistration(state: LinkState) {
    let service = SMAppService.daemon(plistName: "\(Identifiers.daemon.rawValue).plist")

    switch service.status {
    case .notRegistered:
      state.daemonRegistration = .notRegistered

    case .enabled:
      state.daemonRegistration = .enabled

    case .requiresApproval:
      state.daemonRegistration = .requiresApproval

    case .notFound:
      state.daemonRegistration = .notFound

    default:
      state.daemonRegistration = .novel
    }

    // For some reason we also need to attempt to talk to the daemon
    // in order for it's status to be updated.
    queryDaemonVersion(state: state)
  }
}
