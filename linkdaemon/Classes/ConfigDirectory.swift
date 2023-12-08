/*
 * Copyright (C) halo https://io.github.com/halo/LinkLiar
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
      Log.info("Could not create config directory \(Paths.configDirectory) does it already exist? \(error.localizedDescription)")
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
      try FileManager.default.setAttributes([.posixPermissions: 0o664, .groupOwnerAccountName: "staff"], ofItemAtPath: Paths.configFile)
      Log.debug("Did set file permissions")
    } catch let error {
      print("File Permissions error: ", error)
    }
  }

}
