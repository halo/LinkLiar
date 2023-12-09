// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

struct ConfigDirectory {
  // MARK: Class Methods

  static func create() {
    ensureDirectory()
    ensureDirectoryPermissions()
    ensureFile()
    ensureFilePermissions()
  }

  // MARK: Private Instance Properties

  private static let manager = FileManager.default

  // MARK: Private Instance Methods

  private static func ensureDirectory() {
    do {
      try manager.createDirectory(atPath: Paths.configDirectory, withIntermediateDirectories: false)
      Log.debug("Created config directory \(Paths.configDirectory)")
    } catch let error as NSError {
      Log.info("""
               Could not create config directory \(Paths.configDirectory)
               does it already exist? \(error.localizedDescription)
               """)
    }
  }

  private static func ensureDirectoryPermissions() {
    // Readable and executable directory, so that the GUI may access it at all.
    let directoryPermissions: [FileAttributeKey: Any] = [.posixPermissions: 0o775]

    do {
      try manager.setAttributes(directoryPermissions, ofItemAtPath: Paths.configDirectory)
      Log.debug("Did set permissions of config directory at \(Paths.configDirectory) to \(directoryPermissions)")
    } catch let error as NSError {
      Log.info("Could not set permissions for config directory \(error.localizedDescription)")
    }
  }

  private static func ensureFile() {
    var isDirectory: ObjCBool = false
    guard !FileManager.default.fileExists(atPath: Paths.configFile, isDirectory: &isDirectory) else {
      Log.debug("Config file already exists")
      return
    }

    do {
      try "{}".write(toFile: Paths.configFile, atomically: true, encoding: .utf8)
      Log.debug("Created empty config file")
    } catch let error as NSError {
      Log.error("Could not establish empty config file: \(error)")
    }
  }

  private static func ensureFilePermissions() {
    do {
      try FileManager.default.setAttributes([.posixPermissions: 0o664, .groupOwnerAccountName: "staff"],
                                            ofItemAtPath: Paths.configFile)
      Log.debug("Did set file permissions")
    } catch {
      print("File Permissions error: ", error)
    }
  }
}
