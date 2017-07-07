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
      Log.error("Could not delete Helper plist at \(Paths.helperPlistFile) is it there? \(error.localizedDescription)")
    }
  }

  private static func removeExecutable() {
    do {
      try FileManager.default.removeItem(atPath: Paths.helperExecutable)
    } catch {
      Log.info("Could not delete Helper executable at \(Paths.helperExecutable) is it there? \(error.localizedDescription)")
    }
  }

  private static func bootout() {
    let task = Process()
    task.launchPath = "/usr/bin/sudo"
    task.arguments = ["/bin/launchctl", "bootout", "system/\(Identifiers.helper.rawValue)"]
    Log.info("Booting out Privileged Helper...")
    task.launch()
  }

}
