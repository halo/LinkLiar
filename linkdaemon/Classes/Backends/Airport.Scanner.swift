// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

class Hotspot: Decodable {
  var bssid: String = ""
  var ssid: String = ""

  private enum CodingKeys: String, CodingKey {
    case bssid = "BSSID"
    case ssid = "SSID_STR"
  }
}

extension Airport {
  ///
  /// Runs the external exectuable `airport` to determine which
  /// Access Points are reachable through the internal Wi-Fi interface.
  ///
  struct Scanner {
    // MARK: - Class Methods

    init(stubOutput: String? = nil) {
      self.stubOutput = stubOutput
    }

    // MARK: - Instance Properties

    lazy var accessPoints: [Hotspot]? = {

      do {
        let infoPlistData = Data(output.utf8)  // command.runData()
        guard !infoPlistData.isEmpty else {
          Log.debug("`airport --scan` returned empty STDOUT")
          return nil
        }

        let plistDecoder = PropertyListDecoder()
        return try plistDecoder.decode([Hotspot].self, from: infoPlistData)

      } catch {
        print(error)
      }
      return nil
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
