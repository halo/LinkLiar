// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

/// Runs `ifconfig` to dermine the current MAC address of an Interface.
class Ifconfig {

  // MARK: Class Methods

  /// Creates an `Ifconfig` instance for one particular Interface.
  ///
  /// - parameter BSDName: The BSD name of the interface, e.g. `en0` or `en1`.
  ///
  /// ## Example:
  ///
  /// ```swift
  /// let ifconfig = Ifconig(BSDName: "en2")
  /// ```
  init(BSDName: String) {
    self.BSDName = BSDName
  }

  // MARK: Instance Properties

  /// The BSD Name of a network interface. This property is read-only.
  /// For example `en0` or `en1`.
  private(set) public var BSDName: String

  // MARK: Instance Methods

  /// Synchronously queries software-assigned MAC address of the Interface.
  func softMAC() -> MACAddress {
    process.launch()
    process.waitUntilExit() // Block until ifconfig exited.
    return MACAddress(_softMAC)
  }

  /// Asynchronously queries software-assigned MAC address of the Interface.
  func softMAC(callback: @escaping (MACAddress) -> Void) {
    self.outputHandle.waitForDataInBackgroundAndNotify()

    NotificationCenter.default.addObserver(forName: Process.didTerminateNotification,
                                           object: process,
                                           queue: nil) { _ in
      callback(MACAddress(self._softMAC))
    }

    // Run ifconfig.
    process.launch()
  }

  // MARK: Private Instance Properties

  /// The `Process` instance that will execute the command.
  private lazy var process: Process = {
    let task = Process()
    task.launchPath = "/sbin/ifconfig"
    task.arguments = [self.BSDName, "ether"]
    task.standardOutput = self.outputPipe
    task.standardError = self.errorPipe
    return task
  }()

  /// This pipe will capture STDOUT of the ifconfig process.
  private lazy var outputPipe = Pipe()

  /// This pipe will capture STDERR of the ifconfig process.
  private lazy var errorPipe = Pipe()

  /// Converting the STDOUT pipe to an IO.
  private lazy var outputHandle: FileHandle = {
    return self.outputPipe.fileHandleForReading
  }()

  /// Reading the STDOUT IO as Data.
  private lazy var outputData: Data = {
    return self.outputHandle.availableData
  }()

  /// Converting the STDOUT Data to a String.
  private lazy var outputString: String = {
    guard let stdout = String(data: self.outputData, encoding: .utf8) else {
      Log.error("Ran `ifconfig \(self.BSDName)` and expected STDOUT but there was none.")
      return ""
    }
    return stdout
  }()

  /// Parses the STDOUT String to determine the current MAC address of the Interface.
  private lazy var _softMAC: String = {
    guard let ether = self.outputString.components(separatedBy: "ether ").last else {
      Log.error("Failed to parse STDOUT of `ifconfig \(self.BSDName)` when looking for `ether `. Got: \(self.outputString)")
      return ""
    }

    guard let address = ether.components(separatedBy: " ").first else {
      Log.error("Failed to parse STDOUT of `ifconfig \(self.BSDName)` when looking for MAC address. Got: \(ether)")
      return ""
    }

    guard address != "" else {
      Log.debug("Interface \(self.BSDName) has no MAC address.")
      return ""
    }

    Log.debug("Interface \(self.BSDName) has soft MAC address \(MACAddress(address).humanReadable)")

    return address
  }()

}
