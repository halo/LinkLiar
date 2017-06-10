import Foundation

extension String {

  func appendPath(_ string: String) -> String {
    return URL(fileURLWithPath: self).appendingPathComponent(string).path
  }

}

class Paths {

  static var configDirectory = "/Library/Application Support/LinkLiar"
  static var configDirectoryURL = URL(fileURLWithPath: configDirectory)

  static var configFile = configDirectory.appendPath("config.json")
  static var configFileURL = URL(fileURLWithPath: configFile)

}
