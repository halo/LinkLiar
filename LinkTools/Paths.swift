// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

extension String {
  func appendPath(_ string: String) -> String {
    URL(fileURLWithPath: self).appendingPathComponent(string).path
  }
}

class Paths {

  static let configDirectory = "/Library/Application Support/\(Identifiers.gui.rawValue)"
  static let configDirectoryURL = URL(fileURLWithPath: configDirectory)

  static let configFile = configDirectory.appendPath("config.json")
  static let configFileURL = URL(fileURLWithPath: configFile)

//  static let debugLogFile = configDirectory.appendPath("linkliar.log")
  static let debugLogFile = "/tmp/linkliar.log"
  static let debugLogFileURL = URL(fileURLWithPath: debugLogFile)

  static let githubApiReleases = "https://api.github.com/repos/halo/LinkLiar/releases/latest"
  static let githubApiReleasesURL = URL(string: githubApiReleases)!

}
