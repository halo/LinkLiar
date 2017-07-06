import Foundation

struct LaunchCtl {

  static func isDaemonRunning(reply: @escaping (Bool) -> Void) {
    let task = Process()
    task.launchPath = "/bin/launchctl"
    task.arguments = ["blame", "system/\(Identifiers.daemon.rawValue)"]

    Log.debug("Querying launchctl for daemon...")
    task.launch()
    task.waitUntilExit()

    // This could be improved by checking the PID
    // But since we have the daemon on KeepAlive, if its there, it's running.
    reply(task.terminationStatus == 0)
  }

}
