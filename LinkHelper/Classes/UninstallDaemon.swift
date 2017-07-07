import Foundation

struct UninstallDaemon {

  static func perform() {
    removePlist()
    removeDirectory()
  }

  private static func removePlist() {
    do {
      try FileManager.default.removeItem(atPath: Paths.daemonPlistFile)
    } catch {
      Log.error("Could not delete Daemon plist at \(Paths.daemonPlistFile) is it there? \(error.localizedDescription)")
    }
  }

  private static func removeDirectory() {
    do {
      try FileManager.default.removeItem(atPath: Paths.daemonDirectory)
    } catch {
      Log.info("Could not delete Daemon directory at \(Paths.daemonDirectory) is it there? \(error.localizedDescription)")
    }
  }

}
