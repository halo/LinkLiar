/*
 * Copyright (C) 2012-2018 halo https://io.github.com/halo/LinkLiar
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

extension String {
  func appendPath(_ string: String) -> String {
    return URL(fileURLWithPath: self).appendingPathComponent(string).path
  }
}

class Paths {

  static let configDirectory = "/Library/Application Support/LinkLiar"
  static let configDirectoryURL = URL(fileURLWithPath: configDirectory)

  static let configFile = configDirectory.appendPath("config.json")
  static let configFileURL = URL(fileURLWithPath: configFile)

  static let debugLogFile = configDirectory.appendPath("linkliar.log")
  static let debugLogFileURL = URL(fileURLWithPath: debugLogFile)

  static let helperDirectory = "/Library/PrivilegedHelperTools"
  static let helperDirectoryURL = URL(fileURLWithPath: helperDirectory)

  static let helperExecutable = helperDirectory.appendPath(Identifiers.helper.rawValue)
  static let helperExecutableURL = URL(fileURLWithPath: helperExecutable)

  static let daemonsPlistDirectory = "/Library/LaunchDaemons"
  static let daemonsPlistDirectoryURL = URL(fileURLWithPath: daemonsPlistDirectory)

  static let daemonPlistFile = daemonsPlistDirectory.appendPath(Identifiers.daemon.rawValue + ".plist")
  static let daemonPlistFileURL = URL(fileURLWithPath: daemonPlistFile)

  static let helperPlistFile = daemonsPlistDirectory.appendPath(Identifiers.helper.rawValue + ".plist")
  static let helperPlistFileURL = URL(fileURLWithPath: helperPlistFile)

  static var daemonPristineExecutablePath: String {
    guard let url = Bundle.main.url(forResource: "linkdaemon", withExtension: nil) else {
      Log.error("Missing linkdaemon executable in LinkLiar.app Bundle at \(Bundle.main.resourcePath ?? "?")")
      return "/dev/null"
    }
    return url.path
  }
  static var daemonPristineExecutableURL = URL(fileURLWithPath: daemonPristineExecutablePath)

  static let daemonDirectory = "/Library/Application Support/LinkDaemon"
  static let daemonDirectoryURL = URL(fileURLWithPath: daemonDirectory)

  static let daemonExecutable = daemonDirectory.appendPath("linkdaemon")
  static let daemonExecutableURL = URL(fileURLWithPath: daemonExecutable)

}
