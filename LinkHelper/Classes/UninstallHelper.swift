import Foundation

struct UninstallHelper {

  static func perform() {
    removePlist()
    removeExecutable()
    bootout()
  }

  private static func removePlist() {
    do {
      try FileManager.default.removeItem(atPath: Paths.helperPlistFile)
    } catch {
      Log.error("Could not delete helper plist \(error) is it there?")
    }
  }

  private static func removeExecutable() {
    do {
      try FileManager.default.removeItem(atPath: Paths.helperExecutable)
    } catch {
      Log.info("Could not delete helper executable \(error) is it there?")
    }
  }

  private static func bootout() {
    let task = Process()
    task.launchPath = "/usr/bin/sudo"
    task.arguments = ["/bin/launchctl", "bootout", "system/\(Identifiers.helper.rawValue)"]
    task.launch()
  }

}
