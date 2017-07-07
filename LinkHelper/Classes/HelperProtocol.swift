import Foundation

@objc(HelperProtocol)

protocol HelperProtocol {
  func version(reply: (String) -> Void)

  func install(pristineExecutableURL: URL, reply: (Bool) -> Void)
  func uninstall(reply: (Bool) -> Void)

  func createConfigDirectory(reply: (Bool) -> Void)
  func removeConfigDirectory(reply: (Bool) -> Void)

  func installDaemon(pristineExecutableURL: URL, reply: (Bool) -> Void)
  func activateDaemon(reply: (Bool) -> Void)
  func deactivateDaemon(reply: (Bool) -> Void)
  func uninstallDaemon(reply: (Bool) -> Void)

  func uninstallHelper(reply: (Bool) -> Void)
}
