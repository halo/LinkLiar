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
import ServiceManagement

class Intercom {

  private static var xpcConnection: NSXPCConnection?

  static func reset() {
    self.xpcConnection = nil
  }

//  static func helperIsCompatible(reply: @escaping (Bool) -> Void) {
//    let helper = self.connection()?.remoteObjectProxyWithErrorHandler({ _ in
//      return reply(false)
//    }) as! HelperProtocol
//
//    helper.version(reply: { rawVersion in
//      Log.debug("The helper responded with its version")
//      reply(Version(rawVersion).isCompatible(with: AppDelegate.version))
//    })
  
//
//  static func helperVersion(reply: @escaping (Version?) -> Void) {
//    let helper = self.connection()?.remoteObjectProxyWithErrorHandler({ _ in
//      return reply(nil)
//    }) as! HelperProtocol
//
//    helper.version(reply: { rawVersion in
//      Log.debug("The helper responded with its version")
//      reply(Version(rawVersion))
//    })
//  }

  
  //  static func uninstallDaemon(reply: @escaping (Bool) -> Void) {
  //    usingHelper(block: { helper in
  //      helper.uninstallDaemon(reply: { success in
  //        Log.debug("Helper worked on daemon uninstallation")
  //        reply(success)
  //      })
  //    })
  //  }
  
  static func install(reply: @escaping (Bool) -> Void) {
    usingHelper(block: { helper in
      helper.createConfigDirectory(reply: { success in
        Log.debug("Helper worked on installation")
        reply(success)
      })
    })
  }

  static func uninstall(reply: @escaping (Bool) -> Void) {
    usingHelper(block: { helper in
      helper.removeConfigDirectory(reply: { success in
        Log.debug("Helper worked on uninstallation")
        reply(success)
      })
    })
  }

//  static func uninstallDaemon(reply: @escaping (Bool) -> Void) {
//    usingHelper(block: { helper in
//      helper.uninstallDaemon(reply: { success in
//        Log.debug("Helper worked on daemon uninstallation")
//        reply(success)
//      })
//    })
//  }
//
//  static func createConfigDir(reply: @escaping (Bool) -> Void) {
//    usingHelper(block: { helper in
//      helper.createConfigDirectory(reply: { success in
//        Log.debug("Helper worked on config dir creation")
//        reply(success)
//      })
//    })
//  }
//
//  static func removeConfigDir(reply: @escaping (Bool) -> Void) {
//    usingHelper(block: { helper in
//      helper.removeConfigDirectory(reply: { success in
//        Log.debug("Helper worked on config dir deletion")
//        reply(success)
//      })
//    })
//  }
//
//  static func installDaemon(reply: @escaping (Bool) -> Void) {
//    Log.debug("Asking Helper to install daemon")
//    usingHelper(block: { helper in
//      helper.installDaemon(pristineDaemonExecutablePath: Paths.daemonPristineExecutablePath, reply: { success in
//        Log.debug("Helper worked on the establishment of the daemon")
//        reply(success)
//      })
//    })
//  }
//  
//  static func activateDaemon(reply: @escaping (Bool) -> Void) {
//    Log.debug("Asking Helper to activate daemon")
//    usingHelper(block: { helper in
//      helper.activateDaemon(reply: { success in
//        Log.debug("Helper worked on the activation of the daemon")
//        reply(success)
//      })
//    })
//  }
//
//  static func deactivateDaemon(reply: @escaping (Bool) -> Void) {
//    Log.debug("Asking Helper to deactivate daemon")
//    usingHelper(block: { helper in
//      helper.deactivateDaemon(reply: { success in
//        Log.debug("Helper worked on the deactivation of the daemon")
//        reply(success)
//      })
//    })
//  }
//
//  static func uninstallHelper(reply: @escaping (Bool) -> Void) {
//    usingHelper(block: { helper in
//      helper.uninstallHelper(reply: { success in
//        Log.debug("Helper worked on the imploding")
//        reply(success)
//      })
//    })
//  }

  static func usingHelper(block: @escaping (HelperProtocol) -> Void) {
    let helper = self.connection()?.remoteObjectProxyWithErrorHandler({ error in
      Log.debug("Oh no, no connection to helper: \(error.localizedDescription)")
    }) as! HelperProtocol
    block(helper)
  }

  static func connection() -> NSXPCConnection? {
    if (self.xpcConnection != nil) { return self.xpcConnection }
    
    Log.debug(Identifiers.daemon.rawValue)
    self.xpcConnection = NSXPCConnection(machServiceName: Identifiers.daemon.rawValue, options: NSXPCConnection.Options.privileged)
    Log.debug("xpcConnection: \(self.xpcConnection!.description)")
    self.xpcConnection!.exportedObject = self
    self.xpcConnection!.remoteObjectInterface = NSXPCInterface(with:HelperProtocol.self)

    self.xpcConnection!.interruptionHandler = {
      self.xpcConnection?.interruptionHandler = nil
      OperationQueue.main.addOperation(){
        self.xpcConnection = nil
        Log.debug("XPC Connection interrupted - the Helper probably crashed.")
        Log.debug("You mght find a crash report at /Library/Logs/DiagnosticReports")
      }
    }
    
    self.xpcConnection!.invalidationHandler = {
      self.xpcConnection?.invalidationHandler = nil
      
      OperationQueue.main.addOperation(){
        self.xpcConnection = nil
        Log.debug("XPC Connection Invalidated")
      }
    }

    self.xpcConnection?.resume()
    return self.xpcConnection
  }

}
