// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

/// A small wrapper around ``Process`` that returns the STDOUT of the command as string.
///
class Command {
  // MARK: Class Methods
  init(_ path: String, arguments: [String]) {
    self.path = path
    self.arguments = arguments
  }

  // MARK: Instance Methods

  func run() -> String {
    process.launch()
    process.waitUntilExit() // Block until airport exited.
    return outputString
  }

  func runData() -> Data {
    process.launch()
    process.waitUntilExit()
    return outputData
  }

  // MARK: Private Instance Properties

  private var path: String
  private var arguments: [String]

  /// The `Process` instance that will execute the command.
  private lazy var process: Process = {
    let task = Process()
    task.launchPath = path
    task.arguments = arguments
    task.standardOutput = outputPipe
    return task
  }()

  /// This pipe will capture STDOUT of the process.
  private lazy var outputPipe = Pipe()

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
      return ""
    }
    return stdout
  }()
}
