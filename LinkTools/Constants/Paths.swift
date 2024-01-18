// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

class Paths {
  // Class Properties

  static var configFile: String = {
    guard let path = Stage.configPath else {
      Log.debug("Using default config file path: \(defaultConfigFile)")
      return defaultConfigFile
    }

    guard !path.isEmpty else {
      Log.debug("Using config file path: \(defaultConfigFile)")
      return defaultConfigFile
    }

    Log.debug("Using custom config file path: \(path)")
    return path
  }()

  static let configDirectory = "/Library/Application Support/\(Identifiers.gui.rawValue)"
  static let configDirectoryURL = URL(fileURLWithPath: configDirectory)

  static let configFileURL = URL(fileURLWithPath: configFile)

//  static let debugLogFile = configDirectory.appendPath("linkliar.log")
  static let debugLogFile = "/tmp/linkliar.log"
  static let debugLogFileURL = URL(fileURLWithPath: debugLogFile)

  static let githubApiReleases = "https://api.github.com/repos/halo/LinkLiar/releases/latest"
  static let githubApiReleasesURL = URL(string: githubApiReleases)!

  static let airportCLI = "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

  // Private Class Properties

  private static let defaultConfigFile = configDirectory.appendPath("config.json")

}

extension String {
  func appendPath(_ string: String) -> String {
    URL(fileURLWithPath: self).appendingPathComponent(string).path
  }
}
