// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

class Listener: NSObject {
//
//  static var version: Version = {
//    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
//      return Version(version)
//    }
//    return Version("?.?.?")
//  }()

  // MARK: Private Properties

  lazy var listener: NSXPCListener = {
    Log.debug("Instantiating new listener...")
    Log.debug(Identifiers.daemon.rawValue)
    let listener = NSXPCListener(machServiceName: Identifiers.daemon.rawValue)
    Log.debug(listener.description)
    listener.delegate = self
    return listener
  }()

  var shouldQuit = false
  var versionOnStartUp = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?.?.?"

  // MARK: Instance Methods

  func listen() {
    Log.debug("Helper says hello")
    listener.resume() // Tell the XPC listener to start processing requests.

    while !shouldQuit {
      RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
    }
    Log.debug("Helper shutting down now.")
  }
}

// MARK: - HelperProtocol
extension Listener: ListenerProtocol {
//
  func version(reply: (String) -> Void) {
    Log.debug("I was asked for my version")

    guard let bundleDictionary = Bundle.main.infoDictionary else {
      Log.debug("Cannot find my bundle")
      return reply("missing bundle")
    }

    guard let versionString = bundleDictionary["CFBundleShortVersionString"] as? String else {
      Log.debug("Cannot find my version in the bundle dictionary")
      return reply("missing version string")
    }

    Log.debug("It is \(versionString)")
    reply(versionString)
  }
//
//  func install(pristineDaemonExecutablePath: String, reply: (Bool) -> Void) {
//    ConfigDirectory.create()
//    UninstallDaemon.perform()
//    InstallDaemon.perform(pristineExecutablePath: pristineDaemonExecutablePath)
//    reply(BootDaemon.bootstrap())
//  }
//
//  func uninstall(reply: (Bool) -> Void) {
//    let _ = BootDaemon.bootout()
//    UninstallDaemon.perform()
//    ConfigDirectory.remove()
//    UninstallHelper.perform()
//    reply(true) // <- Famous last words
//  }

  func createConfigDirectory(reply: (Bool) -> Void) {
//    Log.debug("\(Bundle.main.bundlePath)")
//    Log.debug("\(Bundle.main.infoDictionary)")
//    let infoPath = "\(Bundle.main.bundlePath)/Contents/Info.plist"
//    Log.debug(infoPath)
////
//    let uncachedBundle = Bundle.init(path: Bundle.main.bundlePath)!
////   Log.debug(uncachedBundle.infoDictionary!.description)
//
////    Log.debug(versionOnStartUp)
//    Log.debug(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
//    Log.debug("now!")
//    Log.debug(uncachedBundle.infoDictionary?["CFBundleShortVersionString"]! as! String)

    ConfigDirectory.ensure()
    reply(true)
  }

  func removeConfigDirectory(reply: (Bool) -> Void) {
//    ConfigDirectory.remove()
    reply(true)
  }

//  func installDaemon(pristineDaemonExecutablePath: String, reply: (Bool) -> Void) {
//    Log.debug("Going to prophylactically uninstall and then install daemon...")
//    UninstallDaemon.perform()
//    InstallDaemon.perform(pristineExecutablePath: pristineDaemonExecutablePath)
//    reply(BootDaemon.bootstrap())
//  }
//
//  func activateDaemon(reply: (Bool) -> Void) {
//    reply(BootDaemon.bootstrap())
//  }
//
//  func deactivateDaemon(reply: (Bool) -> Void) {
//    reply(BootDaemon.bootout())
//  }
//
//  func uninstallDaemon(reply: (Bool) -> Void) {
//    let success = BootDaemon.bootout()
//    UninstallDaemon.perform()
//    reply(success)
//  }
//
//  func uninstallHelper(reply: (Bool) -> Void) {
//    UninstallHelper.perform()
//    reply(true)
//  }

}

// MARK: - NSXPCListenerDelegate

extension Listener: NSXPCListenerDelegate {
  func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
    Log.debug("New connection!")
    newConnection.exportedInterface = NSXPCInterface(with: ListenerProtocol.self)
    newConnection.exportedObject = self
    newConnection.invalidationHandler = (() -> Void)? {
      Log.debug("Daemon lost connection to GUI...")
      // This means the GUI was closed and the helper can be closed.
      // But now we're using a daemon, that one should not quit.
//      self.shouldQuit = true
    }
    Log.debug("Resuming connection...")
    newConnection.resume() // Ready to receive connections
    return true // Accept the incoming connection
  }
}
