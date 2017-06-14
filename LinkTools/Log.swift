import os.log

public struct Log {
  private static let log = OSLog(subsystem: "io.github.halo.LinkLiar", category: "logger")

  public static func debug(_ message:String) {
    os_log("%{public}@", log: log, type: .debug, message)
  }

  public static func info(_ message:String) {
    os_log("%{public}@", log: log, type: .info, message)
  }

  public static func error(_ message:String) {
    os_log("%{public}@", log: log, type: .error, message)
  }
}
