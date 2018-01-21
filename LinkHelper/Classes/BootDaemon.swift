/*
 * Copyright (C) 2012-2018 halo https://io.github.com/halo/LinkLiar
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

struct BootDaemon {

  enum SubCommand: String {
    case bootstrap = "bootstrap"
    case bootout = "bootout"
  }

  static func bootstrap() -> Bool {
    if bootout() {
      Log.debug("Deactivated daemon so I can now go ahead and safely (re-)activate it...")
    } else {
      Log.debug("Just-In-Case-Deactivation failed, but that's fine, let me activate it")
    }
    return launchctl(.bootstrap)
  }

  static func bootout() -> Bool {
    return launchctl(.bootout)
  }

  // MARK Private Instance Methods

  private static func launchctl(_ subcommand: SubCommand) -> Bool {
    Log.debug("Preparing \(subcommand.rawValue) of daemon...")
    let task = Process()

    // Set the task parameters
    task.launchPath = "/usr/bin/sudo"
    task.arguments = ["/bin/launchctl", subcommand.rawValue, "system", Paths.daemonPlistFile]

    let outputPipe = Pipe()
    let errorPipe = Pipe()
    task.standardOutput = outputPipe
    task.standardError = errorPipe

    // Launch the task
    task.launch()
    task.waitUntilExit()

    let status = task.terminationStatus

    if status == 0 {
      Log.debug("Task succeeded.")
      return(true)

    } else {
      Log.debug("Task failed \(task.terminationStatus)")

      let outdata = outputPipe.fileHandleForReading.availableData
      guard let stdout = String(data: outdata, encoding: .utf8) else {
        Log.debug("Could not read stdout")
        return false
      }

      let errdata = errorPipe.fileHandleForReading.availableData
      guard let stderr = String(data: errdata, encoding: .utf8) else {
        Log.debug("Could not read stderr")
        return false
      }

      Log.debug("Reason: \(stdout) \(stderr)")
      
      return(false)
    }
  }

}
