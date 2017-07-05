import Foundation

/// Runs `ifconfig` to dermine the current MAC address of an Interface.
class Ifconfig {

  // MARK: Initializers

  /**
   * Creates an `Ifconfig` instance for one particular Interface.
   *
   * - parameter BSDName: The BSD name of the interface, e.g. `en0` or `en1`.
   *
   * ## Example:
   *
   * ```swift
   * let ifconfig = Ifconig(BSDName: "en2")
   * ```
   */
  init(BSDName: String) {
    self.BSDName = BSDName
  }

  // MARK: Instance Properties

  /**
   * The BSD Name of a network interface. This property is read-only.
   * For example `en0` or `en1`.
  */
  private(set) public var BSDName: String

  // MARK: Instance Properties

  /**
   The `Process` instance that will execute the command.
   Formerly known as NSTask.
  */
  private lazy var process: Process = {
    let task = Process()
    task.launchPath = "/sbin/ifconfig"
    task.arguments = [self.BSDName, "ether"]
    task.standardOutput = self.outputPipe
    task.standardError = self.errorPipe
    return task
  }()

  // These pipes will capture STDOUT and STDERR of the ifconfig process.
  private lazy var outputPipe: Pipe = Pipe()
  private lazy var errorPipe: Pipe = Pipe()

  private lazy var outputHandle: FileHandle = {
    return self.outputPipe.fileHandleForReading
  }()

  private lazy var outputData: Data = {
    return self.outputHandle.availableData
  }()

  private lazy var outputString: String = {
    guard let stdout = String(data: self.outputData, encoding: .utf8) else {
      Log.error("I ran `ifconfig \(self.BSDName)` and expected STDOUT but there was none at all.")
      return ""
    }

    return stdout
  }()

  private lazy var _softMAC: String = {
    guard let ether = self.outputString.components(separatedBy: "ether ").last else {
      Log.error("Failed to parse STDOUT of `ifconfig \(self.BSDName)` when looking for `ether `")
      return ""
    }

    guard let address = ether.components(separatedBy: " ").first else {
      Log.error("Failed to parse STDOUT of `ifconfig \(self.BSDName)` when looking for MAC address.")
      return ""
    }

    guard address != "" else {
      Log.debug("Interface \(self.BSDName) has no MAC address.")
      return ""
    }
    return address
  }()

  // MARK: Instance Methods

  func softMAC() -> MACAddress {
    process.launch()
    process.waitUntilExit()
    return MACAddress(_softMAC)
  }

  func softMAC(callback: @escaping (MACAddress) -> Void) {
    self.outputHandle.waitForDataInBackgroundAndNotify()

    NotificationCenter.default.addObserver(forName: Process.didTerminateNotification, object: process, queue: nil) { notification in
      callback(MACAddress(self._softMAC))
    }
    process.launch()
  }

}
