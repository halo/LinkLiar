// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

enum Ifconfig {}

extension Ifconfig {
  /// Runs the external exectuable `ifconfig` to dermine the current MAC address of an Interface.
  ///
  class Reader {
    // MARK: Class Methods

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
    init(_ BSDName: String, stubOutput: String? = nil) {
      self.BSDName = BSDName
      self.stubOutput = stubOutput
    }

    // MARK: Instance Properties

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
    func softMAC() -> MAC? {
      setOutput(command.run())
      return parse(output)
    }

    /// Asynchronously queries software-assigned MAC address of the Interface.
    ///
    /// Provide a callback to receive the MAC address once it was resolved.
    ///
    func softMAC(callback: @escaping (MAC?) -> Void) {
      if let stubbedOutput = stubOutput {
        callback(parse(stubbedOutput))
        return
      }

      command.run { output in
        callback(self.parse(output))
      }
    }

    // MARK: - Private Instance Methods

    /// Parses the STDOUT String to determine the current MAC address of the Interface.
    private func parse(_ stdout: String) -> MAC? {
      guard let ether = stdout.components(separatedBy: "ether ").last else {
        Log.error("Failed to parse STDOUT of `ifconfig \(BSDName)` when looking for `ether `. Got: \(output)")
        return nil
      }

      guard let address = ether.components(separatedBy: " ").first else {
        Log.error("Failed to parse STDOUT of `ifconfig \(BSDName)` when looking for MAC address. Got: \(ether)")
        return nil
      }

      guard address != "" else {
        Log.debug("Interface \(BSDName) has no MAC address.")
        return nil
      }

      return MAC(address)
    }

    private func setOutput(_ stdout: String) {
      _output = stdout
    }

    // MARK: - Private Instance Properties

    private var stubOutput: String?

    private lazy var output: String = {
      stubOutput ?? _output
    }()

    private var _output = ""

    private lazy var command = {
      Command.init(Paths.ifconfigCLI, arguments: [BSDName, "ether"])
    }()
  }
}
