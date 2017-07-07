/*
 * Copyright (C) 2017 halo https://io.github.com/halo/LinkLiar
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

  static func perform(pristineExecutablePath: String) {
    createPlist()
    ensureDirectory()
    ensureDirectoryPermissions()
    copyPristineExecutable(pristineExecutablePath: pristineExecutablePath)
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
    } catch let error as NSError {
      Log.info("Could not create daemon directory \(Paths.daemonDirectory) does it already exist? \(error.localizedDescription)")
    }
  }

  private static func ensureDirectoryPermissions() {
    do {
      try manager.setAttributes(directoryPermissions, ofItemAtPath: Paths.daemonDirectory)
      Log.debug("Ensured permissions of daemon directory at \(Paths.daemonDirectory) to \(directoryPermissions)")
    } catch let error as NSError {
      Log.info("Could not set permissions for daemon directory \(error.localizedDescription)")
    }
  }

  private static func copyPristineExecutable(pristineExecutablePath: String) {
    let pristineExecutableURL = URL(fileURLWithPath: pristineExecutablePath)
    Log.debug("Copying daemon executable from \(pristineExecutableURL) to \(Paths.daemonExecutable)")
    do {
      try manager.copyItem(at: pristineExecutableURL, to: Paths.daemonExecutableURL)
      Log.debug("Copied daemon executable from \(pristineExecutableURL) to \(Paths.daemonExecutable)")
    } catch let error as NSError {
      Log.info("Could not copy daemon executable from \(pristineExecutableURL) to \(Paths.daemonExecutable) does it already exist? \(error.localizedDescription)")
    }
  }

  private static func ensureExecutablePermissions() {
    do {
      try manager.setAttributes(executablePermissions, ofItemAtPath: Paths.daemonExecutable)
      Log.debug("Set permissions of daemon executable at \(Paths.daemonExecutable) to \(executablePermissions)")
    } catch let error as NSError {
      Log.info("Could not set permissions for daemon executable \(error.localizedDescription)")
    }
  }

}
