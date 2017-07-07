import Foundation

struct ConfigDirectory {

  // Readable and writable so that the GUI may persist config.
  private static let directoryPermissions: [FileAttributeKey: Any] = [.posixPermissions: 0o775]

  private static let manager = FileManager.default

  static func create() {
    ensureDirectory()
    ensureDirectoryPermissions()
  }

  static func remove() {
    do {
      try manager.removeItem(atPath: Paths.configDirectory)
      Log.debug("Deleted config directory \(Paths.configDirectory)")
    } catch {
      Log.info("Could not delete config directory \(Paths.configDirectory) \(error.localizedDescription)")
    }
  }

  private static func ensureDirectory() {
    do {
      try manager.createDirectory(atPath: Paths.configDirectory, withIntermediateDirectories: false)
      Log.debug("Created config directory \(Paths.configDirectory)")
    } catch {
      Log.info("Could not create config directory \(Paths.configDirectory) does it already exist? \(error.localizedDescription)")
    }
  }

  private static func ensureDirectoryPermissions() {
    do {
      try manager.setAttributes(directoryPermissions, ofItemAtPath: Paths.configDirectory)
      Log.debug("Set permissions of config directory at \(Paths.configDirectory) to \(directoryPermissions)")
    } catch {
      Log.info("Could not set permissions for config directory \(error.localizedDescription)")
    }
  }

}
