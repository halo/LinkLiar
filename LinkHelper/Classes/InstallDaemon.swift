import Foundation

struct InstallDaemon {

  // Only writable/executable by root, so nobody can replace our privileged executable after-the-fact.
  private static let directoryPermissions: [FileAttributeKey: Any] = [.posixPermissions: 0o755]
  private static let executablePermissions: [FileAttributeKey: Any]  = [.posixPermissions: 0o744, .ownerAccountID: 0]

  private static let manager = FileManager.default

  private static let plist : [String: Any] = [
    "Label": Identifiers.daemon.rawValue,
    "Program": Paths.daemonExecutable,
    "KeepAlive": true
  ]

  static func perform(pristineExecutableURL: URL) {
    createPlist()
    ensureDirectory()
    ensureDirectoryPermissions()
    copyPristineExecutable(pristineExecutableURL: pristineExecutableURL)
    ensureExecutablePermissions()
  }

  private static func createPlist() {
    let success = NSDictionary(dictionary: plist).write(toFile: Paths.daemonPlistFile, atomically: true)

    if success {
      Log.debug("Created daemon plist at \(Paths.daemonPlistFile)")
    } else {
      Log.debug("Could not create daemon plist at \(Paths.daemonPlistFile)")
    }
  }

  private static func ensureDirectory() {
    do {
      try manager.createDirectory(atPath: Paths.daemonDirectory, withIntermediateDirectories: false)
      Log.debug("Created daemon directory \(Paths.daemonDirectory)")
    } catch {
      Log.info("Could not create daemon directory \(Paths.daemonDirectory) does it already exist? \(error.localizedDescription)")
    }
  }

  private static func ensureDirectoryPermissions() {
    do {
      try manager.setAttributes(directoryPermissions, ofItemAtPath: Paths.daemonDirectory)
      Log.debug("Ensured permissions of daemon directory at \(Paths.daemonDirectory) to \(directoryPermissions)")
    } catch {
      Log.info("Could not set permissions for daemon directory \(error.localizedDescription)")
    }
  }

  private static func copyPristineExecutable(pristineExecutableURL: URL) {
    Log.debug("Copying daemon executable from \(pristineExecutableURL) to \(Paths.daemonExecutable)")
    do {
      try manager.copyItem(at: pristineExecutableURL, to: Paths.daemonExecutableURL)
      Log.debug("Copied daemon executable from \(pristineExecutableURL) to \(Paths.daemonExecutable)")
    } catch {
      Log.info("Could not copy daemon executable from \(pristineExecutableURL) to \(Paths.daemonExecutable) does it already exist? \(error.localizedDescription)")
    }
  }

  private static func ensureExecutablePermissions() {
    do {
      try manager.setAttributes(executablePermissions, ofItemAtPath: Paths.daemonExecutable)
      Log.debug("Set permissions of daemon executable at \(Paths.daemonExecutable) to \(executablePermissions)")
    } catch {
      Log.info("Could not set permissions for daemon executable \(error.localizedDescription)")
    }
  }

}
