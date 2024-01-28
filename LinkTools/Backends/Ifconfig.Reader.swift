// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

enum Ifconfig {}

extension Ifconfig {
  ///
  /// Runs the external exectuable `ifconfig` to dermine the current MAC address of an Interface.
  ///
  class Reader {
    // MARK: Class Methods

    ///
    /// Creates an ``Ifconfig.Reader`` instance for one particular Interface.
    ///
    /// - parameter BSDName: The BSD name of the interface, e.g. `en0` or `en1`.
    ///
    /// ## Example:
    ///
    /// ```swift
    /// let myifconfig = Ifconig("en2")
    /// ```
    ///
    init(_ BSDName: String) {
      self.BSDName = BSDName
    }

    // MARK: Instance Properties

    ///
    /// The BSD Name of a network interface. For example `en0` or `en1`.
    ///
    /// This property is read-only.
    ///
    private(set) var BSDName: String

    // MARK: Instance Methods

    ///
    /// Synchronously queries software-assigned MAC address of the Interface.
    ///
    /// This is a function, rather than a computed property, to indicate that
    /// this method always shells out to get the up-to-date value without caching it.
    ///
    /// ## Example:
    ///
    /// ```swift
    /// Ifconig("en2").softMAC()
    /// ```
    ///
    func softMAC() -> MAC {
      process.launch()
      process.waitUntilExit() // Block until ifconfig exited.
      return MAC(address: _softMAC)
    }

    ///
    /// Asynchronously queries software-assigned MAC address of the Interface.
    ///
    /// Provide a callback to receive the MAC address once it was resolved.
    ///
    func softMAC(callback: @escaping (MAC) -> Void) {
      self.outputHandle.waitForDataInBackgroundAndNotify()

      NotificationCenter.default.addObserver(forName: Process.didTerminateNotification,
                                             object: process,
                                             queue: nil) { _ in
        callback(MAC(address: self._softMAC))
      }

      // Run ifconfig (now that the observer is in place).
      process.launch()
    }

    // MARK: Private Instance Properties

    /// The `Process` instance that will execute the command.
    private lazy var process: Process = {
      let task = Process()
      task.launchPath = "/sbin/ifconfig"
      task.arguments = [BSDName, "ether"]
      task.standardOutput = outputPipe
      task.standardError = errorPipe
      return task
    }()

    /// This pipe will capture STDOUT of the ifconfig process.
    private lazy var outputPipe = Pipe()

    /// This pipe will capture STDERR of the ifconfig process.
    private lazy var errorPipe = Pipe()

    /// Converting the STDOUT pipe to an IO.
    private lazy var outputHandle: FileHandle = {
      outputPipe.fileHandleForReading
    }()

    /// Reading the STDOUT IO as Data.
    private lazy var outputData: Data = {
      outputHandle.availableData
    }()

    /// Converting the STDOUT Data to a String.
    private lazy var outputString: String = {
      guard let stdout = String(data: outputData, encoding: .utf8) else {
        Log.error("Ran `ifconfig \(BSDName)` and expected STDOUT but there was none.")
        return ""
      }
      return stdout
    }()

    /// Parses the STDOUT String to determine the current MAC address of the Interface.
    private lazy var _softMAC: String = {
      guard let ether = outputString.components(separatedBy: "ether ").last else {
        Log.error("Failed to parse STDOUT of `ifconfig \(BSDName)` when looking for `ether `. Got: \(outputString)")
        return ""
      }

      guard let address = ether.components(separatedBy: " ").first else {
        Log.error("Failed to parse STDOUT of `ifconfig \(BSDName)` when looking for MAC address. Got: \(ether)")
        return ""
      }

      guard address != "" else {
        Log.debug("Interface \(BSDName) has no MAC address.")
        return ""
      }

//      Log.debug("Interface \(BSDName) has soft MAC address \(MACAddress(address).humanReadable)")

      return address
    }()
  }
}
