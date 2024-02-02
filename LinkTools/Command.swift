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

  /// Run synchronously
  ///
  func run() -> String {
//    Log.debug("Running synchronously \(path) \(arguments.joined(separator: " "))")
    do {
      try process.run()
    } catch {
      Log.debug("Command failed \(error)")
    }
//    Log.debug("Waiting for synchronous command to finish.")
//    Log.debug("Synchronous command finished.")
    return outputString
  }

  /// Run asynchronously
  ///
  func run(callback: @escaping (String) -> Void) {
    NotificationCenter.default.addObserver(forName: Process.didTerminateNotification,
                                           object: process,
                                           queue: nil) { _ in
//      Log.debug("Asynchronous command finished.")
      callback(self.outputString)
    }
//    Log.debug("Running asynchronously \(path) \(arguments.joined(separator: " "))")
    do {
      try process.run()
    } catch {
      Log.error("Command failed \(error)")
    }
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
    outputHandle.readDataToEndOfFile()
  }()

  /// Converting the STDOUT Data to a String.
  private lazy var outputString: String = {
    guard let stdout = String(data: outputData, encoding: .utf8) else {
      return ""
    }
    return stdout
  }()
}
