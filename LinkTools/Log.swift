/*
 * Copyright (C) 2017 halo https://io.github.com/halo/LinkLiar
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

import os.log
import Foundation

public struct Log {
  private static let log = OSLog(subsystem: Identifiers.gui.rawValue, category: "logger")

  public static func debug(_ message: String, callerPath: String = #file) {
    write(message: message, level: .debug, callerPath: callerPath)
  }

  public static func info(_ message: String, callerPath: String = #file) {
    write(message: message, level: .info, callerPath: callerPath)
  }

  public static func error(_ message: String, callerPath: String = #file) {
    write(message: message, level: .error, callerPath: callerPath)
  }

  private static func write(message: String, level: OSLogType, callerPath: String) {
    let filename = URL(fileURLWithPath: callerPath).deletingPathExtension().lastPathComponent
    os_log("%{public}@ - %{public}@", log: log, type: .debug, filename, message)
    appendToLogfile(message, prefix: "")
  }

  private static func appendToLogfile(_ message: String, prefix: String) {
    let data = "\(prefix) \(message)\n".data(using: .utf8)!

    if let fileHandle = FileHandle(forWritingAtPath: Paths.debugLogFile) {
      defer {
        fileHandle.closeFile()
      }
      fileHandle.seekToEndOfFile()
      fileHandle.write(data)
    } else {
      /*
      #if DEBUG
        do {
          try data.write(to: Paths.debugLogFileURL)
        } catch {}
        // There is no logfile, which means the end-user does not want file logging
      #endif
      */
    }
  }

}
