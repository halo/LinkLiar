import Foundation

class LinkHelper: NSObject, HelperProtocol, NSXPCListenerDelegate {

  // MARK Private Properties

  private lazy var listener: NSXPCListener = {
    let listener = NSXPCListener(machServiceName:Identifiers.helper.rawValue)
    listener.delegate = self
    return listener
  }()

  private var shouldQuit = false

  // MARK Instance Methods

  func listen(){
    listener.resume() // Tell the XPC listener to start processing requests.

    while !shouldQuit {
      RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 1))
    }
    Log.debug("Helper shutting down now.")
  }

  // MARK HelperProtocol Conformity

  func version(reply: (String) -> Void) {
    guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
      Log.error("Helper is missing CFBundleVersion")
      return
    }
    reply(version)
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
    let plist : [String: Any] = [
      "Label": Identifiers.daemon.rawValue,
      "ProgramArguments": [Paths.daemonExecutable],
      "KeepAlive": true
    ]
    let plistContent = NSDictionary(dictionary: plist)

    let path = Paths.daemonPlistFile

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

  func implode(reply: (Bool) -> Void) {
    Log.debug("Removing helper executable...")
    let remover = Process()
    remover.launchPath = "/usr/bin/sudo"
    remover.arguments = ["/bin/rm", Paths.helperExecutable]
    remover.launch()
    remover.waitUntilExit()

    if (remover.terminationStatus != 0) { reply(false) }

    Log.debug("Removing helper daemon...")
    let task = Process()
    task.launchPath = "/usr/bin/sudo"
    task.arguments = ["/bin/launchctl", "bootout", "system", Paths.helperPlistFile]
    task.launch()
    task.waitUntilExit()

    if (task.terminationStatus == 0) {
      reply(true)
    } else {
      reply(false)
    }
  }

  // MARK NSXPCListenerDelegate Conformity

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

  // MARK Private Instance Methods

  private func launchctl(activate: Bool, reply: (Bool) -> Void) {
    Log.debug("Preparing activation of daemon...")
    let task = Process()

    // Set the task parameters
    task.launchPath = "/usr/bin/sudo"
    let subcommand = activate ? "bootstrap" : "bootout"
    task.arguments = ["/bin/launchctl", subcommand, "system", Paths.daemonPlistFile]

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
        Log.debug("Could not read stderr")
        return
      }

      Log.debug("Reason: \(stdout) \(stderr)")
      
      reply(false)
    }
  }

}
