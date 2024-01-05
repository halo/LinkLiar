// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

class Paths {
  static var configDirectory: String {
    guard let path = Stage.configPath else {
      return defaultConfigDirectory
    }

    guard !path.isEmpty else {
      return defaultConfigDirectory
    }

    return path
  }

  static let configDirectoryURL = URL(fileURLWithPath: configDirectory)

  static let configFile = configDirectory.appendPath("config.json")
  static let configFileURL = URL(fileURLWithPath: configFile)

//  static let debugLogFile = configDirectory.appendPath("linkliar.log")
  static let debugLogFile = "/tmp/linkliar.log"
  static let debugLogFileURL = URL(fileURLWithPath: debugLogFile)

  static let githubApiReleases = "https://api.github.com/repos/halo/LinkLiar/releases/latest"
  static let githubApiReleasesURL = URL(string: githubApiReleases)!

  private static let defaultConfigDirectory = "/Library/Application Support/\(Identifiers.gui.rawValue)"
}


extension String {
  func appendPath(_ string: String) -> String {
    URL(fileURLWithPath: self).appendingPathComponent(string).path
  }
}
