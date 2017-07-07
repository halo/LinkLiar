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

import Foundation

struct LaunchCtl {

  static func isDaemonRunning(reply: @escaping (Bool) -> Void) {
    let task = Process()
    task.launchPath = "/bin/launchctl"
    task.arguments = ["blame", "system/\(Identifiers.daemon.rawValue)"]

    let outputPipe = Pipe()
    task.standardOutput = outputPipe

    Log.debug("Querying launchctl for daemon...")
    task.launch()
    task.waitUntilExit()

    let outdata = outputPipe.fileHandleForReading.availableData
    let stdout = String(data: outdata, encoding: .utf8) ?? ""

    let missing = stdout.contains("not find")
    let dead = stdout.contains("not running")

    if missing || dead {
      reply(!stdout.contains("not running"))
    } else {
      reply(task.terminationStatus == 0)
    }
  }

}
