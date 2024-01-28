// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

extension Airport {
  ///
  /// Runs the external exectuable `airport` to determine which
  /// Access Points are reachable through the internal Wi-Fi interface.
  ///
  struct Scanner {
    struct Hotspot: Decodable {
      var bssid: String = ""
      var ssid: String = ""

      private enum CodingKeys: String, CodingKey {
        case bssid = "BSSID"
        case ssid = "SSID_STR"
      }
    }

    // MARK: - Class Methods

    init(stubOutput: String? = nil) {
      self.stubOutput = stubOutput
    }

    // MARK: - Instance Properties

    lazy var accessPoints: [AccessPoint] = {

      do {
        let infoPlistData = Data(output.utf8)  // command.runData()
        guard !infoPlistData.isEmpty else {
          Log.debug("`airport --scan` returned empty STDOUT")
          return []
        }

        let plistDecoder = PropertyListDecoder()
        let hotspots = try plistDecoder.decode([Hotspot].self, from: infoPlistData)

        return hotspots.compactMap {
          print($0.ssid)
          return AccessPoint.init(ssid: $0.ssid, bssid: $0.bssid)
        }

      } catch {
        print(error)
      }
      return []
    }()

    // MARK: - Private Instance Properties

    var stubOutput: String?

    private lazy var output: String = {
      stubOutput ?? command.run()
    }()

    private lazy var command = {
      Command.init(Paths.airportCLI, arguments: ["--scan", "--xml"])
    }()
  }
}
