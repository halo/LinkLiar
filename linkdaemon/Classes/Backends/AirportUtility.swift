// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

///
/// Runs the external exectuable `airport` to dermine the current SSID and/or BSSID of an Interface.
///
class AirportUtility {
  // MARK: Instance Methods

  func ssid() -> String? {
    process.launch()
    process.waitUntilExit() // Block until airport exited.
    return _ssid
  }

  // MARK: Private Instance Properties

  /// The `Process` instance that will execute the command.
  private lazy var process: Process = {
    let task = Process()
    task.launchPath = "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
    task.arguments = ["--getinfo"]
    task.standardOutput = outputPipe
    task.standardError = errorPipe
    return task
  }()

  /// This pipe will capture STDOUT of the airport process.
  private lazy var outputPipe = Pipe()

  /// This pipe will capture STDERR of the airport process.
  private lazy var errorPipe = Pipe()

  /// Converting the STDOUT pipe to an IO.
  private lazy var outputHandle: FileHandle = {
    outputPipe.fileHandleForReading
  }()

  /// Reading the STDOUT IO as Data.
  private lazy var outputData: Data = {
    outputHandle.availableData
  }()

  /// Converting the STDOUT Data to a String.
  private lazy var outputString: String = {
    guard let stdout = String(data: outputData, encoding: .utf8) else {
      Log.error("Ran airport and expected STDOUT but there was none.")
      return ""
    }
    return stdout
  }()

  /// Parses the STDOUT String to determine the current MAC address of the Interface.
  private lazy var _ssid: String? = {
    guard !outputString.contains("BSSID: 0:0:0:0:0:0") else {
      Log.debug("Wi-Fi is not connected to a base station")
      return nil
    }

    // This is bullet proof as long as the term "SSID: " comes before any user-generated output.
    // If, e.g., a hotspot would be called "My SSID: is cool" then the split would trigger that.
    // But as far as I can tell, there is no user-generated ouput before the first "SSID: "
    guard let ssidAndMore = outputString.components(separatedBy: "SSID: ").last else {
      Log.error("Failed to parse STDOUT of airport when looking for `SSID: `. Got: \(outputString)")
      return nil
    }

    guard let ssid = ssidAndMore.components(separatedBy: "\n").first else {
      Log.error("Failed to parse STDOUT of airport when looking for end of SSID. Got: \(ssidAndMore)")
      return nil
    }

    guard ssid != "" else {
      Log.debug("Interface has an unexpected empty SSID.")
      return nil
    }

    Log.debug("Interface connected to SSID: \(ssid)")

    return ssid
  }()
}
