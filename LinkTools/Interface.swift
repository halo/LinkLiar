import Foundation

class Interface {

  var BSDName: String
  var displayName: String
  var kind: String
  var cachedRawSoftMAC: String

  var hardMAC: MACAddress {
    get {
      return MACAddress(rawHardMAC)
    }
  }

  var softMAC: MACAddress {
    get {
      getSoftMAC()
      return MACAddress(cachedRawSoftMAC)
    }
  }

  var title: String {
    get {
      return "\(displayName) ∙ \(BSDName)"
    }
  }

  private var rawHardMAC: String

  init(BSDName: String, displayName: String, hardMAC: String, kind: String) {
    self.BSDName = BSDName
    self.displayName = displayName
    self.rawHardMAC = hardMAC
    self.kind = kind
    self.cachedRawSoftMAC = ""
  }

  func getSoftMAC() -> String {
    let task = Process()

    // Set the task parameters
    task.launchPath = "/sbin/ifconfig"
    task.arguments = [BSDName]

    let outputPipe = Pipe()
    let errorPipe = Pipe()
    task.standardOutput = outputPipe
    task.standardError = errorPipe

    let outHandle = outputPipe.fileHandleForReading
    outHandle.waitForDataInBackgroundAndNotify()




    NotificationCenter.default.addObserver(forName: Process.didTerminateNotification, object: task, queue: nil) { notification in
      //print(notification)
      let pro = notification.object as! Process
      //print(pro)

      let outdata = outputPipe.fileHandleForReading.availableData
      let stdout = String(data: outdata, encoding: .utf8)!
      //Log.debug(stdout)

      let rawMAC = stdout.components(separatedBy: "ether ").last!.components(separatedBy: " ").first!
      Log.debug(rawMAC)

      self.cachedRawSoftMAC = rawMAC
      NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)


    }



    // Launch the task
    Log.debug("Running ifconfig")
    task.launch()
    //task.waitUntilExit()
    //Log.debug("ifconfig finished")

    if (task.isRunning) { return "too early" }

    let status = task.terminationStatus


    if status == 0 {
      Log.debug("Task succeeded.")
      let outdata = outputPipe.fileHandleForReading.availableData
      guard let stdout = String(data: outdata, encoding: .utf8) else {
        Log.debug("Could not read stdout")
        return ""
      }
      //Log.debug(stdout)

      let errdata = errorPipe.fileHandleForReading.availableData
      guard let stderr = String(data: errdata, encoding: .utf8) else {
        Log.debug("Could not read stderr")
        return ""
      }
      //Log.debug(stderr)

      let rawMAC = stdout.components(separatedBy: "ether ").last!.components(separatedBy: " ").first!
      Log.debug(rawMAC)
      
      return rawMAC


    } else {
      Log.debug("Task failed.")

      return "no"
    }
  }

}
