// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation
import os.log

public struct Log {
  // MARK: Class Methods

  static func debug(_ message: String, callerPath: String = #file) {
    write(message, level: .debug, callerPath: callerPath)
  }

  static func info(_ message: String, callerPath: String = #file) {
    write(message, level: .info, callerPath: callerPath)
  }

  static func error(_ message: String, callerPath: String = #file) {
    write(message, level: .error, callerPath: callerPath)
  }

  // MARK: Private Class Methods

  private static func write(_ message: String, level: OSLogType, callerPath: String) {
    guard let filename = callerPath.components(separatedBy: "/").last else {
      return write(message, level: level)
    }

    let classname = filename.components(separatedBy: ".").dropLast().joined(separator: ".")

    write("\(classname) - \(message)", level: level)
  }

  // MARK: Private Class Properties

  private static let logger = Logger(subsystem: Identifiers.gui.rawValue, category: "logger")

  // MARK: Private Class Methods

  private static func write(_ message: String, level: OSLogType) {
    logger.log(level: level, "\(message, privacy: .public)")
    appendToLogfile(message, level: level)
  }

  private static func appendToLogfile(_ message: String, level: OSLogType) {
    var prefix = "UNKNOWN"

    switch level {
    case .debug: prefix = "DEBUG"
    case .info:  prefix = "INFO "
    case .error: prefix = "ERROR"
    default:     prefix = "OTHER"
    }

    let data = "\(prefix) \(message)\n".data(using: .utf8)!

    if let fileHandle = FileHandle(forWritingAtPath: "/tmp/linkliar.log") {
      defer { fileHandle.closeFile() }
      fileHandle.seekToEndOfFile()
      fileHandle.write(data)
    } else {
      // There is no logfile, which means the end-user does not want file logging
      // You may also end up here if you turned on app sandboxing.
    }
  }
}
