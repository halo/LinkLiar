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

  static var helperDirectory = "/Library/PrivilegedHelperTools"
  static var helperDirectoryURL = URL(fileURLWithPath: helperDirectory)

  static var helperExecutable = helperDirectory.appendPath(Identifiers.helper.rawValue)
  static var helperExecutableURL = URL(fileURLWithPath: helperExecutable)

}
