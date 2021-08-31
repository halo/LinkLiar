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
  private lazy var outputPipe = Pipe()
  private lazy var errorPipe = Pipe()

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

    Log.debug("Interface \(self.BSDName) has the soft MAC address \(MACAddress(address).humanReadable)")

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
