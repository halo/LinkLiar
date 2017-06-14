import Foundation

class Ifconfig {

  private var BSDName: String
  private lazy var outputPipe: Pipe = Pipe()

  private lazy var process: Process = {
    let task = Process()
    task.launchPath = "/sbin/ifconfig"
    task.arguments = [self.BSDName]
    // TODO: Catch STDERR
    return task
  }()

  init(BSDName: String) {
    self.BSDName = BSDName
  }

  func launchSync() -> String {
    process.standardOutput = outputPipe
    process.launch()
    process.waitUntilExit()
    let status = process.terminationStatus
    if (status == 0) {
      Log.debug("Synchronous ifconfig succeeded.")
    } else {
      Log.debug("Synchronous ifconfig failed.")
    }
    return "aa:bb:cc:dd:ee:ff"
  }

  func launchAsync(interface: Interface) {
    process.standardOutput = outputPipe
    registerCallback(interface: interface)
    process.launch()
  }

  private func registerCallback(interface: Interface) {
    let outHandle = outputPipe.fileHandleForReading
    outHandle.waitForDataInBackgroundAndNotify()

    NotificationCenter.default.addObserver(forName: Process.didTerminateNotification, object: process, queue: nil) { notification in
      let outdata = self.outputPipe.fileHandleForReading.availableData

      guard let stdout = String(data: outdata, encoding: .utf8) else {
        Log.error("I ran `ifconfig \(self.BSDName)` and expected STDOUT but there was none.")
        return
      }

      guard let ether = stdout.components(separatedBy: "ether ").last else {
        Log.error("Failed to parse STDOUT of `ifconfig \(self.BSDName)` when looking for `ether `")
        return
      }

      guard let softMAC = ether.components(separatedBy: " ").first else {
        Log.error("Failed to parse STDOUT of `ifconfig \(self.BSDName)` when looking for MAC address.")
        return
      }

      guard softMAC != "" else {
        Log.debug("Interface \(self.BSDName) has no MAC address.")
        return
      }

      interface._softMAC = softMAC
      NotificationCenter.default.post(name: .softMacIdentified, object: interface, userInfo: nil)
    }
  }

}
