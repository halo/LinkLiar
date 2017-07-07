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
    Log.debug("Preparing activation of daemon...")
    let task = Process()

    // Set the task parameters
    task.launchPath = "/usr/bin/sudo"
    task.arguments = ["/bin/launchctl", subcommand.rawValue, "system", Paths.daemonPlistFile]

    let outputPipe = Pipe()
    let errorPipe = Pipe()
    task.standardOutput = outputPipe
    task.standardError = errorPipe

    // Launch the task
    Log.debug("Activating daemon now")
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
