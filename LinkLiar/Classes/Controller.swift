// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Cocoa
import Foundation
import ServiceManagement

class Controller {

  // MARK: Class Methods

  static func queryInterfaces(state: LinkState) {
    state.allInterfaces = Interfaces.all(asyncSoftMac: true)
  }

  static func registerDaemon(state: LinkState) {
//    queryDaemonRegistration(state: state)
    let service = SMAppService.daemon(plistName: "\(Identifiers.daemon.rawValue).plist")

    DispatchQueue.global().async {
      do {
        try service.register()
        queryDaemonRegistration(state: state)
        Log.debug("Successfully registered \(service)")
      } catch {
        Log.debug("Unable to register \(error)")
        queryDaemonRegistration(state: state)
      }
    }
  }

  static func unregisterDaemon(state: LinkState) {
//    queryDaemonRegistration(state: state)
    let service = SMAppService.daemon(plistName: "\(Identifiers.daemon.rawValue).plist")

    DispatchQueue.global().async {
      do {
        try service.unregister()
        queryDaemonRegistration(state: state)

        Log.debug("Successfully unregistered \(service)")
        print("\(service) has then status \(service.status)")
      } catch {
        Log.debug("Unable to unregister \(error)")
        queryDaemonRegistration(state: state)
      }
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
    state.allInterfaces.forEach { $0.querySoftMAC(async: true) }
  }

//
//  static func install(state: LinkState) {
//    Radio.install(state: state, reply: { success in
//      if (success) {
//        Log.debug("Installation complete")
//      } else {
//        Log.debug("Could not complete installation")
//      }
//    })
//  }
//
//
//
//  static func uninstall(state: LinkState) {
//    Radio.uninstall(state: state, reply: { success in
//      if (success) {
//        Log.debug("umInstallation complete")
//      } else {
//        Log.debug("Could not complete uninstallation")
//      }
//    })
//  }

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
    // in order for it's status to be updated
    queryDaemonVersion(state: state)
  }

}
