import Foundation
import Cocoa

public struct RunningApplications {
  public static func isRunning(_ identifier: String) -> Bool {
    let notRunning = runningApps.filter { $0.bundleIdentifier == identifier }.isEmpty

    if notRunning {
      Log.debug("\(identifier) is not running")
      return false
    } else {
      Log.debug("\(identifier) is currently running")
      return true
    }
  }

  private static var runningApps: Array<NSRunningApplication> {
    return NSWorkspace.shared.runningApplications
  }
}
