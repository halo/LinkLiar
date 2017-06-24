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

  static var daemonsPlistDirectory = "/Library/LaunchDaemons"
  static var daemonsPlistDirectoryURL = URL(fileURLWithPath: daemonsPlistDirectory)

  static var daemonPlistFile = daemonsPlistDirectory.appendPath(Identifiers.daemon.rawValue + ".plist")
  static var daemonPlistFileURL = URL(fileURLWithPath: daemonPlistFile)

  static var helperPlistFile = daemonsPlistDirectory.appendPath(Identifiers.helper.rawValue + ".plist")
  static var helperPlistFileURL = URL(fileURLWithPath: helperPlistFile)

  #if DEBUG
    static var daemonExecutable = "/Users/orange/Code/LinkLiar/LinkLiar/build/DerivedData/LinkLiar/Build/Products/Debug/LinkLiar.app/Contents/Resources/linkdaemon"
  #else
    // Must not be writable to everyone
    static var daemonExecutable = "/Applications/LinkLiar.app/Contents/Resources/linkdaemon"
  #endif
  static var daemonExecutableURL = URL(fileURLWithPath: daemonExecutable)

}
