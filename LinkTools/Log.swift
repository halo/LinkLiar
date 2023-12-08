// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import os.log
import Foundation

public struct Log {
  private static let log = OSLog(subsystem: Identifiers.gui.rawValue, category: "logger")

  public static func debug(_ message: String, callerPath: String = #file) {
    write(message, level: .debug, callerPath: callerPath)
  }

  public static func info(_ message: String, callerPath: String = #file) {
    write(message, level: .info, callerPath: callerPath)
  }

  public static func error(_ message: String, callerPath: String = #file) {
    write(message, level: .error, callerPath: callerPath)
  }

  private static func write(_ message: String, level: OSLogType, callerPath: String) {
    guard let filename = callerPath.components(separatedBy: "/").last else {
      return write(message, level: level)
    }

    guard let classname = filename.components(separatedBy: ".").first else {
      return write(message, level: level)
    }

    write("\(classname) - \(message)", level: level)
  }

  private static func write(_ message: String, level: OSLogType) {
    os_log("%{public}@", log: log, type: level, message)
    appendToLogfile(message, level: level)
  }

  private static func appendToLogfile(_ message: String, level: OSLogType) {
    var prefix = "UNKNOWN"

    switch level {
    case OSLogType.debug: prefix = "DEBUG"
    case OSLogType.info: prefix = "INFO"
    case OSLogType.error: prefix = "ERROR"
    default: prefix = "DEFAULT"
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
