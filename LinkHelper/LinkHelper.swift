import Foundation

class LinkHelper: NSObject, HelperProtocol, NSXPCListenerDelegate{

  private var connections = [NSXPCConnection]()
  private var listener:NSXPCListener
  private var shouldQuit = false
  private var shouldQuitCheckInterval = 1.0

  override init(){
    self.listener = NSXPCListener(machServiceName:HelperConstants.machServiceName)
    super.init()
    self.listener.delegate = self
  }

  func run(){
    self.listener.resume()

    while !shouldQuit {
      RunLoop.current.run(until: Date.init(timeIntervalSinceNow: shouldQuitCheckInterval))
    }
  }

  /*
   Called when the application connects to the helper
   */
  func listener(_ listener:NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {

    // MARK: Here a check should be added to verify the application that is calling the helper
    // For example, checking that the codesigning is equal on the calling binary as this helper.

    //newConnection.remoteObjectInterface = NSXPCInterface(with: ProcessProtocol.self)
    newConnection.exportedInterface = NSXPCInterface(with:HelperProtocol.self)
    newConnection.exportedObject = self;
    newConnection.invalidationHandler = (() -> Void)? {
      if let indexValue = self.connections.index(of: newConnection) {
        self.connections.remove(at: indexValue)
      }

      if self.connections.count == 0 {
        self.shouldQuit = true
      }
    }
    self.connections.append(newConnection)
    newConnection.resume()
    return true
  }

  /*
   Return bundle version for this helper
   */
  func version(reply: (String) -> Void) {
    reply(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String)
  }

  func createConfigDirectory(reply: (Bool) -> Void) {
    let manager = FileManager.default

    let attributes = [FileAttributeKey.posixPermissions.rawValue: 0o775]
    do {
      try manager.createDirectory(atPath: Configuration.directory, withIntermediateDirectories: false, attributes: attributes)
      Log.debug("Created directory yo")
      reply(true)
    } catch let error as NSError {
      Log.debug("Could not create directory")
      Log.debug("Unable to create directory \(error.debugDescription)")
      reply(false)
    }
  }


  /*
   Functions to run from the main app
   */
  func runCommandLs(path: String, reply: @escaping (NSNumber) -> Void) {

    // For security reasons, all commands should be hardcoded in the helper
    let command = "/bin/ls"
    let arguments = [path]

    // Run the task
  }

  /*
   Not really used in this test app, but there might be reasons to support multiple simultaneous connections.
   */
  private func connection() -> NSXPCConnection
  {
    //
    return self.connections.last!
  }

}

