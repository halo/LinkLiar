// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

enum Airport {}

extension Airport {
  ///
  /// Runs the external exectuable `airport` to determine the
  /// currently connected SSID and BSSID of the internal Wi-Fi Interface.
  ///
  struct Connection {
    // MARK: - Class Methods

    init(stubOutput: String? = nil) {
      self.stubOutput = stubOutput
    }

    // MARK: - Instance Properties

    lazy var ssid: String? = {
      guard !output.contains("BSSID: 0:0:0:0:0:0") else {
        Log.debug("Wi-Fi is not connected to a base station")
        return nil
      }

      let ssidAndMore = output.components(separatedBy: " SSID: ").dropFirst().joined(separator: " SSID: ")

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

    lazy var bssid: String? = {
      guard !output.contains("BSSID: 0:0:0:0:0:0") else {
        Log.debug("Wi-Fi is not connected to a base station")
        return nil
      }

      let bssidAndMore = output.components(separatedBy: " BSSID: ").dropFirst().joined(separator: " BSSID: ")

      guard let bssid = bssidAndMore.components(separatedBy: "\n").first else {
        Log.error("Failed to parse STDOUT of airport when looking for end of BSSID. Got: \(bssidAndMore)")
        return nil
      }

      guard bssid != "" else {
        Log.debug("Interface has an unexpected empty BSSID.")
        return nil
      }

      Log.debug("Interface connected to BSSID: \(bssid)")

      return bssid
    }()

    // MARK: - Private Instance Properties

    var stubOutput: String?

    private lazy var output: String = {
      stubOutput ?? command.run()
    }()

    private lazy var command = {
      Command.init(Paths.airportCLI, arguments: ["--getinfo"])
    }()
  }
}
