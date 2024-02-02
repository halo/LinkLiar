// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import CoreWLAN
import Foundation

struct Airport {
  /// Runs the external exectuable `airport` to determine which
  /// Access Points are reachable through the internal Wi-Fi interface.
  ///
  class Scanner {
    // MARK: - Instance Properties

    // For testing purposes only
    var stubOutput: String?

    // MARK: - Instance Methods

    /// Attempts to scan for access points.
    /// We try 3 times, waiting in between each attempt.
    ///
    func accessPoints() -> [AccessPoint] {
      if let cache = recall() {
        Log.debug("Re-used cached access points.")
        return cache
      }

      for attempt in (1...3) {
        if let foundAccessPoints = scan() {
          remember(foundAccessPoints)
          return foundAccessPoints
        }
        sleep(1)
        Log.debug("Retry \(attempt).")
      }

      return []
    }
    // MARK: - Private Class Properties

    /// Global variable to remember the result of recent scans.
    /// Useful if multiple scans are triggered in quick succession by network condition changes.
    private static var cachedAccessPoints = [AccessPoint]()

    /// Initially, the cache is considered infinitely old.
    private static var cachedAt: Date = Date(timeIntervalSinceNow: -999)

    // MARK: - Private Instance Methods

    /// Caches access points.
    ///
    private func remember(_ accessPoints: [AccessPoint]) {
      Log.debug("Caching access points...")
      Self.cachedAt = Date.now
      Self.cachedAccessPoints = accessPoints
    }

    /// Recalls cached access points if the cache is relatively young.
    ///
    private func recall() -> [AccessPoint]? {
      guard !Self.cachedAccessPoints.isEmpty else {
        Log.debug("Cache is empty.")
        return nil
      }

      // Ensure the cache is younger than 1 minute ago.
      guard Self.cachedAt > Date(timeIntervalSinceNow: -60) else {
        Log.debug("Cache too old to recall.")
        return nil
      }

      return Self.cachedAccessPoints
    }

    /// Parses the output of the shell command.
    ///
    /// - returns: All found ``AccessPoint`` as an Array. 
    ///            Returns ``nil`` in case of an error.
    ///
    private func scan() -> [AccessPoint]? {
      do {
        let infoPlistData = Data(commandOutput().utf8)

        guard !infoPlistData.isEmpty else {
          Log.debug("`airport --scan` returned empty STDOUT")
          return nil
        }

        let plistDecoder = PropertyListDecoder()
        let codableAccessPoints = try plistDecoder.decode([CodableAccessPoint].self, from: infoPlistData)
        let accessPoints = codableAccessPoints.compactMap(\.toAccessPoint)

        Log.debug("Scan revealed \(accessPoints.count) access points.")
        return accessPoints

      } catch {
        Log.error(error.localizedDescription)
        return nil
      }
    }

    /// Runs the `airport` CLI scanning for networks.
    ///
    /// > Important: The `airport` CLI occasionally returns no output at all, though the exit code is `0`.
    /// If it does, it fortunately happens without any delay.
    ///
    /// > Testing: The test suite may stub the command output by setting the ``stubOutput`` property.
    ///
    /// - returns: STDOUT of the command as String.
    ///
    private func commandOutput() -> String {
      if let output = stubOutput { return output }

      Log.debug("Looking for access points...")
      let command = Command.init(Paths.airportCLI, arguments: ["--scan", "--xml"])
      return command.run()
    }
  }
}

extension Airport {
  /// Model for parsing the XML that the `airport` CLI produces.
  ///
  struct CodableAccessPoint: Decodable {
    var bssid: String = ""
    var ssid: String = ""

    var toAccessPoint: AccessPoint? {
      AccessPoint.init(ssid: ssid, bssid: bssid)
    }

    // swiftlint:disable nesting
    private enum CodingKeys: String, CodingKey {
      case bssid = "BSSID"
      case ssid = "SSID_STR"
    }
    // swiftlint:enable nesting
  }
}
