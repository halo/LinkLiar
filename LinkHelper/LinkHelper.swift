import Foundation

class LinkHelper: NSObject, HelperProtocol, NSXPCListenerDelegate {

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
      try manager.createDirectory(atPath: Paths.configDirectory, withIntermediateDirectories: false, attributes: attributes)
      Log.debug("Created directory yo")
      reply(true)
    } catch let error as NSError {
      Log.debug("Could not create configuration directory")
      Log.debug("Unable to create directory \(error.localizedDescription)")
      reply(false)
    }
  }

  func establishDaemon(reply: (Bool) -> Void) {
    let daemonpath = "/Users/orange/Code/LinkLiar/LinkLiar/build/DerivedData/LinkLiar/Build/Products/Debug/LinkLiar.app/Contents/Resources/linkdaemon"
    let plist : [String: Any] = ["Label": "io.github.halo.linkdaemon", "ProgramArguments": [daemonpath], "KeepAlive": true]
    let plistContent = NSDictionary(dictionary: plist)

    let path = "/Library/LaunchDaemons/io.github.halo.linkdaemon.plist"

    let success:Bool = plistContent.write(toFile: path, atomically: true)

    if success {
      Log.debug("file has been created!")
      reply(true)
    }else{
      Log.debug("unable to create the file")
      reply(false)
    }
  }

  func activateDaemon(reply: (Bool) -> Void) {
    launchctl(activate: true, reply: reply)
  }

  func deactivateDaemon(reply: (Bool) -> Void) {
    launchctl(activate: false, reply: reply)
  }

  private func launchctl(activate: Bool, reply: (Bool) -> Void) {
    Log.debug("Preparing activation of daemon...")
    let task = Process()

    // Set the task parameters
    task.launchPath = "/usr/bin/sudo"
    let subcommand = activate ? "bootstrap" : "bootout"
    task.arguments = ["/bin/launchctl", subcommand, "system", "/Library/LaunchDaemons/io.github.halo.linkdaemon.plist"]

    let outputPipe = Pipe()
    let errorPipe = Pipe()
    task.standardOutput = outputPipe
    task.standardError = errorPipe


    // Launch the task
    Log.debug("Activating daemon now")
    task.launch()
    task.waitUntilExit()

    let status = task.terminationStatus


    if status == 0 {
      Log.debug("Task succeeded.")
      reply(true)

    } else {
      Log.debug("Task failed \(task.terminationStatus)")

      let outdata = outputPipe.fileHandleForReading.availableData
      guard let stdout = String(data: outdata, encoding: .utf8) else {
        Log.debug("Could not read stdout")
        return
      }

      let errdata = errorPipe.fileHandleForReading.availableData
      guard let stderr = String(data: errdata, encoding: .utf8) else {
        Log.debug("Could not read stdout")
        return
      }

      Log.debug("Reason: \(stdout) \(stderr)")

      reply(false)
    }
  }
  

  /*
   Not really used in this test app, but there might be reasons to support multiple simultaneous connections.
   */
  private func connection() -> NSXPCConnection {
    return self.connections.last!
  }

}

