/*
 * Copyright (C) halo https://io.github.com/halo/LinkLiar
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

class Radio {

  static func version(state: LinkState, reply: @escaping (Version?) -> Void) {
    transceive(state: state, block: { listener in
      listener.version(reply: { rawVersion in
        Log.debug("The helper responded with its version \(rawVersion)")
        let version = Version(rawVersion)
        state.daemonVersion = version
        state.xpcStatus = .connected
        reply(version)
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
  
  static func install(state: LinkState, reply: @escaping (Bool) -> Void) {
    transceive(state: state, block: { helper in
      helper.createConfigDirectory(reply: { success in
        Log.debug("Helper worked on installation")
        state.xpcStatus = .connected
        reply(success)
      })
    })
  }

  static func uninstall(state: LinkState, reply: @escaping (Bool) -> Void) {
    transceive(state: state, block: { helper in
      helper.removeConfigDirectory(reply: { success in
        Log.debug("Helper worked on uninstallation")
        state.xpcStatus = .connected
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

  
  // MARK: Private Properties

  private static var xpcConnection: NSXPCConnection?

  // MARK: Private Functions

  private static func transceive(state: LinkState, block: @escaping (ListenerProtocol) -> Void) {
    let helper = connection(state: state)?.remoteObjectProxyWithErrorHandler({ error in
      Log.debug("Oh no, no connection to helper: \(error.localizedDescription)")
      state.connectedToDaemon = false
    }) as! ListenerProtocol
    block(helper)
  }
  
  private static func connection(state: LinkState) -> NSXPCConnection? {
    if (xpcConnection != nil) {
      return xpcConnection
    }
    
    Log.debug(Identifiers.daemon.rawValue)
    xpcConnection = NSXPCConnection(machServiceName: Identifiers.daemon.rawValue, options: NSXPCConnection.Options.privileged)
    Log.debug("xpcConnection: \(xpcConnection!.description)")
    xpcConnection!.exportedObject = self
    xpcConnection!.remoteObjectInterface = NSXPCInterface(with: ListenerProtocol.self)

    xpcConnection!.interruptionHandler = {
      xpcConnection?.interruptionHandler = nil
      OperationQueue.main.addOperation(){
        xpcConnection = nil
        Log.debug("XPC Connection interrupted - the Helper probably crashed.")
        Log.debug("You mght find a crash report at /Library/Logs/DiagnosticReports")
        state.xpcStatus = .interrupted
      }
    }
    
    xpcConnection!.invalidationHandler = {
      xpcConnection?.invalidationHandler = nil
      
      OperationQueue.main.addOperation(){
        xpcConnection = nil
        Log.debug("XPC Connection Invalidated")
        state.xpcStatus = .invalidated
      }
    }

    xpcConnection?.resume()
    return xpcConnection
  }

}
