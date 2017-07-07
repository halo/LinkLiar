import Foundation

class LinkHelper: NSObject {

  static var version: Version = {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      return Version(version)
    }
    return Version("?.?.?")
  }()

  // MARK Private Properties

  lazy var listener: NSXPCListener = {
    let listener = NSXPCListener(machServiceName:Identifiers.helper.rawValue)
    listener.delegate = self
    return listener
  }()

  var shouldQuit = false

  // MARK Instance Methods

  func listen(){
    Log.debug("Helper \(LinkHelper.version.formatted) says hello")
    listener.resume() // Tell the XPC listener to start processing requests.

    while !shouldQuit {
      RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 1))
    }
    Log.debug("Helper shutting down now.")
  }

}

// MARK: - HelperProtocol
extension LinkHelper: HelperProtocol {

  func version(reply: (String) -> Void) {
    reply(LinkHelper.version.formatted)
  }

  func install(pristineExecutableURL: URL, reply: (Bool) -> Void) {
    ConfigDirectory.create()
    UninstallDaemon.perform()
    InstallDaemon.perform(pristineExecutableURL: pristineExecutableURL)
    reply(BootDaemon.bootstrap())
  }

  func uninstall(reply: (Bool) -> Void) {
    let _ = BootDaemon.bootout()
    UninstallDaemon.perform()
    ConfigDirectory.remove()
    UninstallHelper.perform()
    reply(true) // <- Famous last words
  }

  func createConfigDirectory(reply: (Bool) -> Void) {
    ConfigDirectory.create()
    reply(true)
  }

  func removeConfigDirectory(reply: (Bool) -> Void) {
    ConfigDirectory.remove()
    reply(true)
  }

  func installDaemon(pristineExecutableURL: URL, reply: (Bool) -> Void) {
    UninstallDaemon.perform()
    InstallDaemon.perform(pristineExecutableURL: pristineExecutableURL)
    reply(BootDaemon.bootstrap())
  }

  func activateDaemon(reply: (Bool) -> Void) {
    reply(BootDaemon.bootstrap())
  }

  func deactivateDaemon(reply: (Bool) -> Void) {
    reply(BootDaemon.bootout())
  }

  func uninstallDaemon(reply: (Bool) -> Void) {
    UninstallDaemon.perform()
    reply(BootDaemon.bootout())
  }

  func uninstallHelper(reply: (Bool) -> Void) {
    UninstallHelper.perform()
    reply(true)
  }

}

// MARK: - NSXPCListenerDelegate
extension LinkHelper: NSXPCListenerDelegate {

  func listener(_ listener:NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
    newConnection.exportedInterface = NSXPCInterface(with: HelperProtocol.self)
    newConnection.exportedObject = self;
    newConnection.invalidationHandler = (() -> Void)? {
      Log.debug("Helper lost connection, queuing up for shutdown...")
      self.shouldQuit = true
    }
    newConnection.resume()
    return true
  }

}
