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
    guard let stdout = String(data: outdata, encoding: .utf8) else {
      Log.debug("Could not read stdout")
      reply(task.terminationStatus == 0)
      return
    }

    reply(!stdout.contains("not running"))


    // This could be improved by checking the PID
    // But since we have the daemon on KeepAlive, if its there, it's running.
    //reply(task.terminationStatus == 0)
  }

}
