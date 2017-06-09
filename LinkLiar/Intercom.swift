import Foundation
import ServiceManagement

class Intercom: NSObject {

  private static var xpcConnection: NSXPCConnection?

  static func reset() {
    self.xpcConnection = nil
  }

  static func helperVersion(reply: @escaping (String?) -> Void) {
    let helper = self.connection()?.remoteObjectProxyWithErrorHandler({
      error in
      Log.debug("Oh no, no connection to helper")
      Log.debug(error.localizedDescription)
      reply(nil)
    }) as! HelperProtocol

    helper.version(reply: {
      installedVersion in
      Log.debug("Helper: Installed Version => \(installedVersion)")
      reply(installedVersion)
    })
  }

  static func createConfigDir(reply: @escaping (Bool) -> Void) {
    Log.debug("Asking Helper to create dir")
    let helper = self.connection()?.remoteObjectProxyWithErrorHandler({
      error in
      Log.debug("Oh no, no connection to helper")
      Log.debug(error.localizedDescription)
      reply(false)
    }) as! HelperProtocol

    Log.debug("helper is there")
    helper.createConfigDirectory(reply: {
      success in
      Log.debug("Helper worked on some directory I guess")
      reply(success)
    })
  }

  static func establishDaemon(reply: @escaping (Bool) -> Void) {
    Log.debug("Asking Helper to establish daemon")
    let helper = self.connection()?.remoteObjectProxyWithErrorHandler({
      error in
      Log.debug("Oh no, no connection to helper")
      Log.debug(error.localizedDescription)
      reply(false)
    }) as! HelperProtocol

    Log.debug("helper is there")
    helper.establishDaemon(reply: {
      success in
      Log.debug("Helper worked on the establishment of the daemon")
      reply(success)
    })
  }
  
  static func activateDaemon(reply: @escaping (Bool) -> Void) {
    Log.debug("Asking Helper to activate daemon")
    let helper = self.connection()?.remoteObjectProxyWithErrorHandler({
      error in
      Log.debug("Oh no, no connection to helper")
      Log.debug(error.localizedDescription)
      reply(false)
    }) as! HelperProtocol

    Log.debug("helper is there")
    helper.activateDaemon(reply: {
      success in
      Log.debug("Helper worked on the activation of the daemon")
      reply(success)
    })
  }

  static func deactivateDaemon(reply: @escaping (Bool) -> Void) {
    Log.debug("Asking Helper to deactivate daemon")
    let helper = self.connection()?.remoteObjectProxyWithErrorHandler({
      error in
      Log.debug("Oh no, no connection to helper")
      Log.debug(error.localizedDescription)
      reply(false)
    }) as! HelperProtocol

    Log.debug("helper is there")
    helper.deactivateDaemon(reply: {
      success in
      Log.debug("Helper worked on the deactivation of the daemon")
      reply(success)
    })
  }

  static func connection() -> NSXPCConnection? {
    if (self.xpcConnection != nil) { return self.xpcConnection }

    self.xpcConnection = NSXPCConnection(machServiceName: HelperConstants.machServiceName, options: NSXPCConnection.Options.privileged)
    self.xpcConnection!.exportedObject = self
    self.xpcConnection!.remoteObjectInterface = NSXPCInterface(with:HelperProtocol.self)

    self.xpcConnection!.interruptionHandler = {
      self.xpcConnection?.interruptionHandler = nil
      OperationQueue.main.addOperation(){
        self.xpcConnection = nil
        Log.debug("XPC Connection interrupted\n")
      }
    }

    self.xpcConnection!.invalidationHandler = {
      self.xpcConnection?.invalidationHandler = nil
      OperationQueue.main.addOperation(){
        self.xpcConnection = nil
        Log.debug("XPC Connection Invalidated\n")
      }
    }

    self.xpcConnection?.resume()
    return self.xpcConnection
  }

}
