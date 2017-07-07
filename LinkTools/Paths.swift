import Foundation

extension String {
  func appendPath(_ string: String) -> String {
    return URL(fileURLWithPath: self).appendingPathComponent(string).path
  }
}

class Paths {

  static let debugLogFile = "/tmp/linkliar.log"
  static let debugLogFileURL = URL(fileURLWithPath: debugLogFile)

  static let configDirectory = "/Library/Application Support/LinkLiar"
  static let configDirectoryURL = URL(fileURLWithPath: configDirectory)

  static let configFile = configDirectory.appendPath("config.json")
  static let configFileURL = URL(fileURLWithPath: configFile)

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

  static var daemonPristineExecutable: String {
    guard let url = Bundle.main.url(forResource: "linkdaemon", withExtension: nil) else {
      Log.error("Missing linkdaemon executable in LinkLiar.app Bundle at \(Bundle.main.resourcePath ?? "?")")
      return "/dev/null"
    }
    return url.path
  }
  static var daemonPristineExecutableURL = URL(fileURLWithPath: daemonPristineExecutable)

  static let daemonDirectory = "/Library/Application Support/LinkDaemon"
  static let daemonDirectoryURL = URL(fileURLWithPath: daemonDirectory)

  static let daemonExecutable = daemonDirectory.appendPath("linkdaemon")
  static let daemonExecutableURL = URL(fileURLWithPath: daemonExecutable)

}
